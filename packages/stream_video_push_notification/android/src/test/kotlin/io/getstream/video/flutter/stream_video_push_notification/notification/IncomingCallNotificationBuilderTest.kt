package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.Notification
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.R
import io.getstream.video.flutter.stream_video_push_notification.TransparentActivity
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf

/**
 * Pins the incoming call notification for API 34 and later (`CallStyle`) and for API 33 and
 * earlier (custom views), built for the API level the builder is given.
 */
@RunWith(RobolectricTestRunner::class)
class IncomingCallNotificationBuilderTest {

    private val context: Context get() = ApplicationProvider.getApplicationContext()

    private val call = RingingCall(
        id = "call-1",
        callerName = "Ada",
        handle = "ada",
        type = 1,
        duration = 45000L,
        showCallHandle = true,
        avatar = "ada.png",
    )

    private fun build(sdkInt: Int, ringingCall: RingingCall = call) =
        IncomingCallNotificationBuilder(context, sdkInt)
            .build(CallPayloadMapper.toBundle(ringingCall))

    private fun intentOf(pendingIntent: android.app.PendingIntent) =
        shadowOf(pendingIntent).savedIntent

    @Test
    fun `on API 34 it is a CallStyle call notification with decline and accept`() {
        val content = build(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
        val notification = content.notification

        assertEquals("call-1".hashCode(), content.id)
        assertEquals(NotificationChannels.INCOMING_ID, notification.channelId)
        assertEquals(Notification.CATEGORY_CALL, notification.category)
        assertEquals(45000L, notification.timeoutAfter)
        assertTrue(notification.flags and Notification.FLAG_ONGOING_EVENT != 0)
        assertEquals("ada", NotificationCompat.getContentText(notification))
        assertEquals(R.drawable.ic_video, notification.smallIcon.resId)

        val actionIntents = notification.actions.map { intentOf(it.actionIntent) }
        val decline = actionIntents.single {
            it.action?.endsWith(IncomingCallConstants.ACTION_CALL_DECLINE) == true
        }
        assertEquals(IncomingCallBroadcastReceiver::class.java.name, decline.component?.className)
        val accept = actionIntents.single { it.action == IncomingCallConstants.ACTION_CALL_ACCEPT }
        assertEquals(TransparentActivity::class.java.name, accept.component?.className)

        val fullScreen = intentOf(notification.fullScreenIntent)
        assertTrue(fullScreen.action!!.endsWith(IncomingCallConstants.ACTION_CALL_INCOMING))
        val carried = fullScreen.getBundleExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)!!
        assertEquals("call-1", carried.getString(IncomingCallConstants.EXTRA_CALL_ID))
        assertTrue(carried.containsKey(IncomingCallNotificationBuilder.EXTRA_TIME_START_CALL))
    }

    @Test
    fun `on API 33 it uses the custom views, with the actions in them`() {
        val content = build(Build.VERSION_CODES.TIRAMISU)
        val notification = content.notification

        assertEquals(NotificationChannels.INCOMING_ID, notification.channelId)
        assertEquals(R.layout.layout_custom_notification, notification.bigContentView.layoutId)
        assertEquals(R.layout.layout_custom_small_notification, notification.contentView.layoutId)
        assertEquals(0, notification.actions?.size ?: 0)
        assertNotNull(notification.fullScreenIntent)
    }

    @Test
    fun `the avatar falls back to the default avatar and resolves to a Flutter asset`() {
        val content = build(
            Build.VERSION_CODES.UPSIDE_DOWN_CAKE,
            call.copy(avatar = "", defaultAvatar = "assets/default.png"),
        )

        assertEquals("file:///android_asset/flutter_assets/assets/default.png", content.avatarUrl)
        assertNull(build(Build.VERSION_CODES.UPSIDE_DOWN_CAKE, call.copy(avatar = "")).avatarUrl)
    }

    @Test
    fun `an audio call uses the accept icon`() {
        val notification =
            build(Build.VERSION_CODES.UPSIDE_DOWN_CAKE, call.copy(type = 0)).notification

        assertEquals(R.drawable.ic_accept, notification.smallIcon.resId)
    }
}
