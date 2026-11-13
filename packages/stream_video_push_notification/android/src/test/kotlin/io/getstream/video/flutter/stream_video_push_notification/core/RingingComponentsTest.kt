package io.getstream.video.flutter.stream_video_push_notification.core

import android.app.Application
import android.content.Context
import android.os.Looper
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.FakeDartSide
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.telecom.FakeTelecomCallRepository
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomEventSource
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomIntegration
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomPermissions
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf

/**
 * Pins that the components connect the Telecom integration to the controller: what the system does
 * to a call reaches Dart, through a real integration over a fake repository.
 */
@RunWith(RobolectricTestRunner::class)
class RingingComponentsTest {

    private val context: Application get() = ApplicationProvider.getApplicationContext()
    private val repository = FakeTelecomCallRepository()
    private lateinit var dart: FakeDartSide

    @Before
    fun connectTelecom() {
        RingingComponents.reset()
        context.getSharedPreferences(PrefsCallStore.PREFERENCES_FILE_NAME, Context.MODE_PRIVATE)
            .edit().clear().commit()
        RingingComponents.telecomFactory = { ctx ->
            TelecomIntegration(
                ctx,
                repositoryFactory = { repository },
                permissions = object : TelecomPermissions() {
                    override fun canUseTelecom(context: Context) = true
                },
                scope = CoroutineScope(Dispatchers.Unconfined),
                mainThread = { it.run() },
            )
        }
        dart = FakeDartSide(context)
        RingingComponents.get(context).telecom.init(
            mapOf("android" to mapOf("telecom" to mapOf("enabled" to true))),
        )
    }

    @After
    fun reset() {
        RingingComponents.reset()
    }

    private fun ring(id: String) {
        RingingComponents.get(context).controller.onIncoming(
            CallPayloadMapper.toBundle(RingingCall(id = id, callerName = "Ada")),
        )
        repository.completeRegistration(id)
    }

    private fun events(): List<Pair<Any?, Map<*, *>>> {
        shadowOf(Looper.getMainLooper()).idle()
        return dart.receivedEvents().map { it["event"] to it["body"] as Map<*, *> }
    }

    @Test
    fun `an answer and a hang-up from the system reach Dart as accept and ended by the system`() {
        ring("call-1")

        repository.answer("call-1", TelecomEventSource.SYS)
        repository.disconnect("call-1", TelecomEventSource.SYS)

        val received = events().drop(1)
        assertEquals(
            listOf(
                IncomingCallConstants.ACTION_CALL_ACCEPT,
                IncomingCallConstants.ACTION_CALL_ENDED,
            ),
            received.map { it.first },
        )
        assertEquals(true, received.last().second["endedBySystem"])
    }

    @Test
    fun `a hang-up from the system while ringing reaches Dart as a decline`() {
        ring("call-1")

        repository.disconnect("call-1", TelecomEventSource.SYS)

        assertEquals(IncomingCallConstants.ACTION_CALL_DECLINE, events().last().first)
    }

    @Test
    fun `a hold from the system reaches Dart`() {
        ring("call-1")

        repository.inactive("call-1")

        val (event, body) = events().last()
        assertEquals(IncomingCallConstants.ACTION_CALL_TOGGLE_HOLD, event)
        assertEquals(mapOf("id" to "call-1", "isOnHold" to true), body)
    }
}
