package io.getstream.video.flutter.stream_video_push_notification.channel

import android.app.Activity
import android.content.Context
import android.os.Bundle
import androidx.test.core.app.ApplicationProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationManager
import io.getstream.video.flutter.stream_video_push_notification.core.CallStore
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import io.getstream.video.flutter.stream_video_push_notification.core.RingingController
import io.getstream.video.flutter.stream_video_push_notification.notification.RingtonePlayer
import io.getstream.video.flutter.stream_video_push_notification.permissions.FullScreenIntentPermission
import io.getstream.video.flutter.stream_video_push_notification.permissions.NotificationPermissionFlow
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkObject
import io.mockk.slot
import io.mockk.unmockkObject
import io.mockk.verify
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/** Pins how each method's arguments reach the controller, the store and the other parts. */
@RunWith(RobolectricTestRunner::class)
class PushMethodCallHandlerTest {

    private val context: Context get() = ApplicationProvider.getApplicationContext()

    private val controller = mockk<RingingController>(relaxed = true)
    private val store = mockk<CallStore>(relaxed = true)
    private val notifications = mockk<IncomingCallNotificationManager>(relaxed = true)
    private val ringtone = mockk<RingtonePlayer>(relaxed = true)
    private val events = mockk<RingingEventDispatcher>(relaxed = true)
    private val notificationPermission = mockk<NotificationPermissionFlow>(relaxed = true)
    private val fullScreenIntent = mockk<FullScreenIntentPermission>(relaxed = true)
    private val result = mockk<MethodChannel.Result>(relaxed = true)

    private lateinit var handler: PushMethodCallHandler

    @Before
    fun createHandler() {
        mockkObject(StreamTelecomManager)
        handler = PushMethodCallHandler(
            context,
            controller,
            store,
            notifications,
            ringtone,
            events,
            notificationPermission,
            fullScreenIntent,
        )
    }

    @After
    fun releaseTelecom() {
        unmockkObject(StreamTelecomManager)
        IncomingCallBroadcastReceiver.silenceEvents = false
    }

    private fun call(method: String, arguments: Any? = null) =
        handler.onMethodCall(MethodCall(method, arguments), result)

    @Test
    fun `endCall, callConnected and endAllCalls go to the controller by call id`() {
        call("endCall", mapOf("id" to "call-1"))
        call("callConnected", mapOf("id" to "call-2"))
        call("endAllCalls")

        verify { controller.endCall("call-1") }
        verify { controller.callConnected("call-2") }
        verify { controller.endAllCalls() }
        verify(exactly = 3) { result.success(true) }
    }

    @Test
    fun `dismissRingingCall passes the call cid, or null without one`() {
        call("dismissRingingCall", mapOf("id" to "default:abc"))
        call("dismissRingingCall")

        verify { controller.dismissRingingCall("default:abc") }
        verify { controller.dismissRingingCall(null) }
    }

    @Test
    fun `muteCall and holdCall report the arguments, and holdCall holds in Telecom`() {
        call("muteCall", mapOf("id" to "call-1", "isMuted" to true))
        call("holdCall", mapOf("id" to "call-1", "isOnHold" to false))

        verify {
            events.send(
                IncomingCallConstants.ACTION_CALL_TOGGLE_MUTE,
                mapOf("id" to "call-1", "isMuted" to true),
            )
        }
        verify {
            events.send(
                IncomingCallConstants.ACTION_CALL_TOGGLE_HOLD,
                mapOf("id" to "call-1", "isOnHold" to false),
            )
        }
        verify { StreamTelecomManager.setOnHold(any(), "call-1", false) }
    }

    @Test
    fun `activeCalls answers the stored calls in their stored form`() {
        every { store.all() } returns listOf(RingingCall(id = "call-1", isAccepted = true))
        val answer = slot<Any>()
        every { result.success(capture(answer)) } returns Unit

        call("activeCalls")

        @Suppress("UNCHECKED_CAST")
        val calls = answer.captured as List<Map<String, Any?>>
        assertEquals("call-1", calls.single()["id"])
        assertEquals(true, calls.single()["isAccepted"])
    }

    @Test
    fun `showMissCallNotification clears the ring and shows the missed call for the same call`() {
        call("showMissCallNotification", mapOf("id" to "call-1"))

        val cleared = slot<Bundle>()
        val shown = slot<Bundle>()
        verify { notifications.clearIncomingNotification(capture(cleared), false) }
        verify { notifications.showMissCallNotification(capture(shown)) }
        assertEquals("call-1", shown.captured.getString(IncomingCallConstants.EXTRA_CALL_ID))
        assertEquals(
            "notification",
            shown.captured.getString(IncomingCallConstants.EXTRA_CALL_ACTION_FROM),
        )
    }

    @Test
    fun `hideIncomingCall stops the ringtone and clears the ring`() {
        call("hideIncomingCall", mapOf("id" to "call-1"))

        verify { ringtone.stop() }
        verify { notifications.clearIncomingNotification(any(), false) }
    }

    @Test
    fun `silenceEvents sets the flag`() {
        call("silenceEvents", true)
        assertTrue(IncomingCallBroadcastReceiver.silenceEvents)

        call("silenceEvents", false)
        assertFalse(IncomingCallBroadcastReceiver.silenceEvents)
    }

    @Test
    fun `the permission methods use the attached activity`() {
        val activity = mockk<Activity>()
        handler.activity = activity
        every { fullScreenIntent.canUse() } returns false

        call("requestNotificationPermission", mapOf("title" to "Notifications"))
        call("ensureFullScreenIntentPermission")
        call("canUseFullScreenIntent")

        verify { notificationPermission.request(activity, mapOf("title" to "Notifications")) }
        verify { fullScreenIntent.request(activity) }
        verify { result.success(false) }
    }

    @Test
    fun `a permission result is handled only for the plugin's own request code`() {
        val grants = intArrayOf(0)

        assertTrue(
            handler.onRequestPermissionsResult(NotificationPermissionFlow.REQUEST_CODE, grants),
        )
        assertFalse(handler.onRequestPermissionsResult(1234, grants))

        verify(exactly = 1) {
            notificationPermission.onRequestPermissionsResult(any(), any(), any())
        }
    }

    @Test
    fun `an unknown method is not implemented and a failing one answers an error`() {
        every { controller.endAllCalls() } throws IllegalStateException("boom")

        call("noSuchMethod")
        call("endAllCalls")

        verify { result.notImplemented() }
        verify { result.error("error", "boom", "") }
    }
}
