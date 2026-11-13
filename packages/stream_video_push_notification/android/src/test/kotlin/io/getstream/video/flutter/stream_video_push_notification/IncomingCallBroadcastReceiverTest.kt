package io.getstream.video.flutter.stream_video_push_notification

import android.app.Application
import android.app.Notification
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Looper
import android.telecom.DisconnectCause
import androidx.test.core.app.ApplicationProvider
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.PrefsCallStore
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager
import io.mockk.mockkObject
import io.mockk.unmockkObject
import io.mockk.verify
import java.io.File
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.android.controller.ServiceController

/**
 * Pins what the broadcast receiver does for each call action: the notification it shows or
 * clears, the event Dart receives, the active-calls list Dart reads back, the ringing service it
 * starts or stops, and the Telecom call it registers or ends.
 *
 * Everything Dart sees is observed through the plugin's real method and event channels, with a
 * fake engine on the other end. The receiver is driven with the intents the plugin and the
 * notifications send it.
 */
@RunWith(RobolectricTestRunner::class)
class IncomingCallBroadcastReceiverTest {

    private val context: Application get() = ApplicationProvider.getApplicationContext()
    private val notifications: NotificationManager
        get() = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    private lateinit var dart: FakeDartSide
    private var ringingService: ServiceController<IncomingCallNotificationService>? = null

    @Before
    fun attachPlugin() {
        resetPlugin()
        IncomingCallBroadcastReceiver.silenceEvents = false
        dart = FakeDartSide(context)
        // A spy: the real Telecom code runs, and is off at this SDK level.
        mockkObject(StreamTelecomManager)
    }

    @After
    fun detachPlugin() {
        ringingService?.destroy()
        ringingService = null
        unmockkObject(StreamTelecomManager)
        IncomingCallBroadcastReceiver.silenceEvents = false
        resetPlugin()
    }

    private fun data(vararg extraTopLevel: Pair<String, Any?>) = CallPayloadMapper.fromArgs(
        mapOf(
            "id" to CALL_ID,
            "callerName" to "Ada",
            "handle" to "ada",
            "type" to 1,
            "duration" to 15000,
            "extra" to hashMapOf<String, Any?>("callCid" to "default:ada"),
            "android" to hashMapOf<String, Any?>(
                "ringtonePath" to "ring.mp3",
                "defaultAvatar" to "avatar.png",
                "avatar" to "ada.png",
                "isImportant" to true,
                "missedCallNotification" to mapOf("id" to MISSED_ID, "subtitle" to "Missed"),
                "incomingCallNotification" to mapOf("textAccept" to "Pick up"),
            ),
            *extraTopLevel,
        ),
    )

    private fun RingingCall.toBundle() = CallPayloadMapper.toBundle(this)

    /** Delivers [intent] to a receiver created now, as the system creates one per broadcast. */
    private fun receive(intent: Intent) {
        IncomingCallBroadcastReceiver().onReceive(context, intent)
        shadowOf(Looper.getMainLooper()).idle()
    }

    private fun incoming(bundle: Bundle = data().toBundle()) =
        receive(IncomingCallBroadcastReceiver.getIntentIncoming(context, bundle))

    /** Creates the ringing service as the system would, so a stop request can be observed. */
    private fun runRingingService() {
        ringingService = Robolectric.buildService(IncomingCallNotificationService::class.java)
            .create()
    }

    private fun ringingServiceWasStopped() =
        shadowOf(context).nextStoppedService?.component?.className ==
            IncomingCallNotificationService::class.java.name

    private fun shownNotificationIds() = notifications.activeNotifications.map { it.id }

    private fun eventNames() = dart.receivedEvents().map { it["event"] }

    @Suppress("UNCHECKED_CAST")
    private fun lastEventBody() = dart.receivedEvents().last()["body"] as Map<String, Any?>

    @Suppress("UNCHECKED_CAST")
    private fun activeCalls() = dart.invoke("activeCalls") as List<Map<String, Any?>>

    @Test
    fun `an incoming call is shown, reported to Dart and stored`() {
        incoming()

        assertEquals(listOf(CALL_ID.hashCode()), shownNotificationIds())
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_INCOMING), eventNames())
        assertEquals(listOf(CALL_ID), activeCalls().map { it["id"] })
        assertEquals(false, activeCalls().single()["isAccepted"])
        verify { StreamTelecomManager.registerIncomingCall(any(), match { it.id == CALL_ID }) }
    }

    @Test
    fun `the event body is the shared Android payload`() {
        incoming()

        assertMatchesFixture(lastEventBody(), "android_call_event.json")
    }

    @Test
    fun `accepting clears the ring, reports it and marks the call accepted, starting no service`() {
        incoming()

        receive(IncomingCallBroadcastReceiver.getIntentAccept(context, data().toBundle()))

        assertNull(shadowOf(context).nextStartedService)
        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(fullScreenActivityWasToldToClose())
        assertEquals(IncomingCallConstants.ACTION_CALL_ACCEPT, eventNames().last())
        assertEquals(true, activeCalls().single()["isAccepted"])
        verify { StreamTelecomManager.answer(any(), CALL_ID) }
    }

    @Test
    fun `declining clears the ring, reports it and forgets the call`() {
        incoming()
        runRingingService()

        receive(IncomingCallBroadcastReceiver.getIntentDecline(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(ringingServiceWasStopped())
        assertTrue(fullScreenActivityWasToldToClose())
        assertEquals(IncomingCallConstants.ACTION_CALL_DECLINE, eventNames().last())
        assertEquals(emptyList<Any?>(), activeCalls())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.REJECTED) }
    }

    @Test
    fun `ending clears the ring, reports it and disconnects Telecom`() {
        incoming()
        runRingingService()

        receive(IncomingCallBroadcastReceiver.getIntentEnded(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(ringingServiceWasStopped())
        assertTrue(fullScreenActivityWasToldToClose())
        assertEquals(IncomingCallConstants.ACTION_CALL_ENDED, eventNames().last())
        assertEquals(emptyList<Any?>(), activeCalls())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.LOCAL) }
    }

    @Test
    fun `ending with keepSystemCall clears the ring but keeps the Telecom call`() {
        incoming()

        receive(
            IncomingCallBroadcastReceiver.getIntentEnded(
                context,
                data().toBundle(),
                keepSystemCall = true,
            ),
        )

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(IncomingCallConstants.ACTION_CALL_ENDED, eventNames().last())
        assertEquals(emptyList<Any?>(), activeCalls())
        verify(exactly = 0) { StreamTelecomManager.disconnect(any(), any(), any()) }
    }

    @Test
    fun `an end reported by the system reaches Dart as endedBySystem`() {
        incoming()
        val bundle = data().toBundle().apply {
            putBoolean(IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM, true)
        }

        receive(IncomingCallBroadcastReceiver.getIntentEnded(context, bundle))

        assertEquals(true, lastEventBody()["endedBySystem"])
    }

    @Test
    fun `a timeout clears the ring, reports it and disconnects Telecom as missed`() {
        incoming()
        runRingingService()

        receive(IncomingCallBroadcastReceiver.getIntentTimeout(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(ringingServiceWasStopped())
        assertEquals(IncomingCallConstants.ACTION_CALL_TIMEOUT, eventNames().last())
        assertEquals(emptyList<Any?>(), activeCalls())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.MISSED) }
    }

    @Test
    fun `clearing a call that no longer owns the ring leaves the ringing service running`() {
        incoming()
        incoming(data("id" to OTHER_CALL_ID).toBundle())
        runRingingService()

        receive(IncomingCallBroadcastReceiver.getIntentDecline(context, data().toBundle()))

        assertEquals(listOf(OTHER_CALL_ID.hashCode()), shownNotificationIds())
        assertFalse(ringingServiceWasStopped())

        receive(
            IncomingCallBroadcastReceiver.getIntentDecline(
                context,
                data("id" to OTHER_CALL_ID).toBundle(),
            ),
        )

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(ringingServiceWasStopped())
    }

    @Test
    fun `connected is reported and activates the Telecom call`() {
        receive(IncomingCallBroadcastReceiver.getIntentConnected(context, data().toBundle()))

        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_CONNECTED), eventNames())
        verify { StreamTelecomManager.activate(any(), CALL_ID) }
    }

    @Test
    fun `a call back clears the missed-call notification and is reported`() {
        notifications.notify(MISSED_ID, Notification())

        receive(IncomingCallBroadcastReceiver.getIntentCallback(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_CALLBACK), eventNames())
    }

    @Test
    fun `starting an outgoing call reports it and stores it accepted, starting no service`() {
        receive(IncomingCallBroadcastReceiver.getIntentStart(context, data().toBundle()))

        assertNull(shadowOf(context).nextStartedService)
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_START), eventNames())
        assertEquals(true, activeCalls().single()["isAccepted"])
        verify { StreamTelecomManager.registerOutgoingCall(any(), match { it.id == CALL_ID }) }
    }

    @Test
    fun `an intent without call data is ignored`() {
        receive(
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_INCOMING}"
            },
        )

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(emptyList<Any?>(), eventNames())
        assertEquals(emptyList<Any?>(), activeCalls())
    }

    @Test
    fun `while events are silenced nothing reaches Dart and the rest still happens`() {
        IncomingCallBroadcastReceiver.silenceEvents = true

        incoming()

        assertEquals(emptyList<Any?>(), eventNames())
        assertEquals(listOf(CALL_ID.hashCode()), shownNotificationIds())
        assertEquals(listOf(CALL_ID), activeCalls().map { it["id"] })
    }

    @Test
    fun `a decline in a new process with no Flutter engine clears the ring shown before`() {
        incoming()
        assertEquals(listOf(CALL_ID.hashCode()), shownNotificationIds())
        // The process dies; the notification stays. A new one starts for the decline action.
        resetPlugin()

        receive(IncomingCallBroadcastReceiver.getIntentDecline(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(fullScreenActivityWasToldToClose())
        assertEquals(emptyList<RingingCall>(), PrefsCallStore(context).all())
    }

    @Test
    fun `an incoming call is shown in a process with no Flutter engine`() {
        resetPlugin()

        incoming()

        assertEquals(listOf(CALL_ID.hashCode()), shownNotificationIds())
        assertEquals(listOf(CALL_ID), PrefsCallStore(context).all().map { it.id })
    }

    @Test
    fun `a bundle without the keys reaches Dart with the call defaults, not separate receiver ones`() {
        receive(IncomingCallBroadcastReceiver.getIntentDecline(context, Bundle()))

        val body = lastEventBody()
        assertEquals("", body["id"])
        assertEquals(0, body["type"])
        assertEquals(30000L, body["duration"])
        assertEquals(emptyMap<String, Any?>(), body["extra"])
        @Suppress("UNCHECKED_CAST")
        val android = body["android"] as Map<String, Any?>
        assertEquals(false, android["isImportant"])
        @Suppress("UNCHECKED_CAST")
        val missed = android["missedCallNotification"] as Map<String, Any?>
        assertEquals(0, missed["id"])
        assertEquals(true, missed["showNotification"])
        assertEquals(true, missed["showCallbackButton"])
        assertEquals(1, missed["count"])
    }

    private fun fullScreenActivityWasToldToClose() = shadowOf(context).broadcastIntents.any {
        it.action == "${context.packageName}.io.getstream.video.ACTION_ENDED_CALL_INCOMING"
    }

    /** Compares [body] with the fixture both sides of the channel test against. */
    private fun assertMatchesFixture(body: Map<String, Any?>, fixture: String) {
        val file = File(FIXTURES, fixture)
        assertTrue("no fixture at ${file.absolutePath}", file.exists())

        val mapper = ObjectMapper()
        val expected = mapper.readTree(file)
        val actual = mapper.valueToTree<JsonNode>(body)
        // The codec keeps Int and Long apart; JSON does not.
        val numbersByValue = Comparator<JsonNode> { a, b ->
            when {
                a.isNumber && b.isNumber -> a.decimalValue().compareTo(b.decimalValue())
                a == b -> 0
                else -> 1
            }
        }
        assertTrue(
            "the event body drifted from $fixture\nexpected: $expected\nactual:   $actual",
            expected.equals(numbersByValue, actual),
        )
    }

    private companion object {
        const val CALL_ID = "call-uuid"
        const val OTHER_CALL_ID = "other-call-uuid"
        const val MISSED_ID = 7

        /** Shared with the Dart tests, relative to the module directory the tests run in. */
        val FIXTURES = File("../test/fixtures/ringing_events")
    }
}
