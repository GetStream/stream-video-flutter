package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.content.Context
import android.net.Uri
import android.telecom.DisconnectCause
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.core.PrefsCallStore
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Pins what [TelecomIntegration] asks Telecom for and what it reports back, against a fake
 * repository, with registrations and callbacks run on the calling thread.
 */
@RunWith(RobolectricTestRunner::class)
class TelecomIntegrationTest {

    private val context: Context get() = ApplicationProvider.getApplicationContext()

    private val repository = FakeTelecomCallRepository()
    private val reported = mutableListOf<String>()
    private val events = mutableListOf<Pair<String, Map<String, Any?>>>()

    private val listener = object : TelecomIntegration.Listener {
        override fun onIncomingCallRegistered() {
            reported += "incoming registered"
        }

        override fun onAnsweredBySystem(call: RingingCall) {
            reported += "answered ${call.id}"
        }

        override fun onDisconnectedBySystem(call: RingingCall, wasConnected: Boolean) {
            reported += "disconnected ${call.id} connected=$wasConnected"
        }

        override fun onEvent(event: String, body: Map<String, Any?>) {
            events += event to body
        }
    }

    private fun integration(canUseTelecom: Boolean = true) = TelecomIntegration(
        context,
        repositoryFactory = { repository },
        permissions = object : TelecomPermissions() {
            override fun canUseTelecom(context: Context) = canUseTelecom
        },
        scope = CoroutineScope(Dispatchers.Unconfined),
        mainThread = { it.run() },
    ).also { it.listener = listener }

    private fun enabled(schema: String? = null) = mapOf(
        "android" to mapOf("telecom" to mapOf("enabled" to true, "schema" to schema)),
    )

    private val call = RingingCall(
        id = CALL_ID,
        callerName = "Ada",
        type = 1,
        extra = mapOf("callCid" to "default:abc"),
    )

    @Before
    @After
    fun clearPersistedConfig() {
        context.getSharedPreferences(PrefsCallStore.PREFERENCES_FILE_NAME, Context.MODE_PRIVATE)
            .edit().clear().commit()
        IncomingCallBroadcastReceiver.silenceEvents = false
    }

    // Registration.

    @Test
    fun `a call is registered with its name, cid address and type`() {
        val telecom = integration().apply { init(enabled(schema = "myapp")) }

        telecom.registerIncomingCall(call)

        assertEquals(
            FakeTelecomCallRepository.Registration(
                CALL_ID,
                "Ada",
                Uri.parse("myapp:default:abc"),
                isIncoming = true,
                isVideo = true,
            ),
            repository.registrations.single(),
        )
    }

    @Test
    fun `an outgoing call is activated once it is registered`() {
        val telecom = integration().apply { init(enabled()) }

        telecom.registerOutgoingCall(call)
        repository.completeRegistration(CALL_ID)

        assertEquals(listOf(TelecomCallAction.Activate), repository.actions(CALL_ID))
    }

    @Test
    fun `nothing is registered while Telecom is turned off or unusable`() {
        val off = mapOf("android" to mapOf("telecom" to mapOf("enabled" to false)))
        integration().apply { init(off) }.registerIncomingCall(call)
        integration(canUseTelecom = false).apply { init(enabled()) }.registerIncomingCall(call)

        assertEquals(emptyList<Any>(), repository.registrations)
    }

    // Actions while registering.

    @Test
    fun `a disconnect queued while registering wins over the answer queued before it`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)

        telecom.answer(CALL_ID)
        telecom.disconnect(CALL_ID, DisconnectCause.REJECTED)
        assertEquals(emptyList<TelecomCallAction>(), repository.actions(CALL_ID))

        repository.completeRegistration(CALL_ID)

        assertEquals(
            listOf(TelecomCallAction.Disconnect(DisconnectCause(DisconnectCause.REJECTED))),
            repository.actions(CALL_ID),
        )
    }

    @Test
    fun `actions queued while registering are replayed in order`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)

        telecom.answer(CALL_ID)
        telecom.setOnHold(CALL_ID, true)
        repository.completeRegistration(CALL_ID)

        assertEquals(
            listOf(TelecomCallAction.Answer, TelecomCallAction.Hold),
            repository.actions(CALL_ID),
        )
    }

    @Test
    fun `a call is answered once, and not at all when it is not registered`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.answer(CALL_ID)
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        telecom.answer(CALL_ID)
        telecom.answer(CALL_ID)

        assertEquals(listOf(TelecomCallAction.Answer), repository.actions(CALL_ID))
    }

    // Hold.

    private fun hold(isOnHold: Boolean) =
        IncomingCallConstants.ACTION_CALL_TOGGLE_HOLD to
            mapOf("id" to CALL_ID, "isOnHold" to isOnHold)

    @Test
    fun `a hold the app asked for is reported once Telecom has done it, and only then`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        telecom.setOnHold(CALL_ID, true)
        assertEquals(listOf(TelecomCallAction.Hold), repository.actions(CALL_ID))
        assertEquals(emptyList<Any>(), events)

        repository.inactive(CALL_ID)
        telecom.setOnHold(CALL_ID, false)
        repository.active(CALL_ID)

        assertEquals(listOf(hold(true), hold(false)), events)
    }

    @Test
    fun `a hold and a resume from the system are reported`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        repository.inactive(CALL_ID)
        repository.active(CALL_ID)

        assertEquals(listOf(hold(true), hold(false)), events)
    }

    @Test
    fun `a hold is reported once per transition, and an active call that was not held is not`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        repository.active(CALL_ID)
        repository.inactive(CALL_ID)
        repository.inactive(CALL_ID)

        assertEquals(listOf(hold(true)), events)
    }

    @Test
    fun `a hold Telecom refused is not reported`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        telecom.setOnHold(CALL_ID, true)
        repository.holdChangeFailed(CALL_ID, requestedOnHold = true)

        assertEquals(emptyList<Any>(), events)
    }

    @Test
    fun `no event is sent while events are silenced`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)
        IncomingCallBroadcastReceiver.silenceEvents = true

        repository.inactive(CALL_ID)

        assertEquals(emptyList<Any>(), events)
    }

    // The system answering and hanging up.

    @Test
    fun `an answer from the system is reported, the app's own is not`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        repository.answer(CALL_ID, TelecomEventSource.APP)
        repository.answer(CALL_ID, TelecomEventSource.SYS)

        assertEquals(listOf("incoming registered", "answered $CALL_ID"), reported)
    }

    @Test
    fun `a system hang-up of a ringing call is a decline, of a connected call an end`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)
        repository.disconnect(CALL_ID, TelecomEventSource.SYS)

        telecom.registerIncomingCall(call.copy(id = "connected"))
        repository.completeRegistration("connected")
        repository.answer("connected", TelecomEventSource.APP)
        repository.disconnect("connected", TelecomEventSource.SYS)

        telecom.registerOutgoingCall(call.copy(id = "outgoing"))
        repository.completeRegistration("outgoing")
        repository.disconnect("outgoing", TelecomEventSource.SYS)

        assertEquals(
            listOf(
                "disconnected $CALL_ID connected=false",
                "disconnected connected connected=true",
                "disconnected outgoing connected=true",
            ),
            reported.filter { it.startsWith("disconnected") },
        )
    }

    @Test
    fun `a disconnect the app asked for is not reported, and the call is forgotten`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        repository.disconnect(CALL_ID, TelecomEventSource.APP)
        telecom.releaseIfIdle()

        assertEquals(listOf("incoming registered"), reported)
        assertTrue(repository.released)
    }

    @Test
    fun `the accept that follows an answer from the system asks Telecom for nothing more`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        repository.answer(CALL_ID, TelecomEventSource.SYS)
        telecom.answer(CALL_ID)

        assertEquals(emptyList<TelecomCallAction>(), repository.actions(CALL_ID))
    }

    @Test
    fun `an incoming call is reported once it is registered, an outgoing one is not`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        telecom.registerOutgoingCall(call.copy(id = "outgoing"))
        assertEquals(emptyList<String>(), reported)

        repository.completeRegistration(CALL_ID)
        repository.completeRegistration("outgoing")

        assertEquals(listOf("incoming registered"), reported)
    }

    // Queries and teardown.

    @Test
    fun `isMuted answers what Telecom reports, and false for a call it does not hold`() {
        val telecom = integration()
        assertFalse(telecom.isMuted(CALL_ID))

        telecom.init(enabled())
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)
        repository.setMuted(CALL_ID, true)

        assertTrue(telecom.isMuted(CALL_ID))
        assertFalse(telecom.isMuted("other"))
    }

    @Test
    fun `disconnectAll disconnects registered and still registering calls`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)
        telecom.registerIncomingCall(call.copy(id = "registering"))

        telecom.disconnectAll(DisconnectCause.LOCAL)
        repository.completeRegistration("registering")

        val local = TelecomCallAction.Disconnect(DisconnectCause(DisconnectCause.LOCAL))
        assertEquals(listOf(local), repository.actions(CALL_ID))
        assertEquals(listOf(local), repository.actions("registering"))
    }

    @Test
    fun `releaseIfIdle keeps Telecom while a call is tracked and releases it after`() {
        val telecom = integration().apply { init(enabled()) }
        telecom.registerIncomingCall(call)
        repository.completeRegistration(CALL_ID)

        telecom.releaseIfIdle()
        assertFalse(repository.released)

        repository.disconnect(CALL_ID, TelecomEventSource.SYS)
        telecom.releaseIfIdle()
        assertTrue(repository.released)
    }

    // Configuration.

    @Test
    fun `a cold start uses the configuration persisted by the last init`() {
        integration().init(enabled(schema = "persisted"))

        integration().registerIncomingCall(call)

        assertEquals(Uri.parse("persisted:default:abc"), repository.registrations.single().address)
    }

    @Test
    fun `a cold start with nothing persisted uses the platform default, off below Android 17`() {
        integration().registerIncomingCall(call)

        assertEquals(emptyList<Any>(), repository.registrations)
    }

    private companion object {
        const val CALL_ID = "call-1"
    }
}
