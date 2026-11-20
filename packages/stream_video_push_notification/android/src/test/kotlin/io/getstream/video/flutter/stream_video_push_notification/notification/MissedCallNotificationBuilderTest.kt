package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.Notification
import android.content.Context
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.R
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/** Pins the missed-call notification's id, channel, texts and when it is not built. */
@RunWith(RobolectricTestRunner::class)
class MissedCallNotificationBuilderTest {

    private val context: Context get() = ApplicationProvider.getApplicationContext()

    private fun build(call: RingingCall) =
        MissedCallNotificationBuilder(context).build(CallPayloadMapper.toBundle(call))

    @Test
    fun `uses the missed-call id the call carries`() {
        val content = build(RingingCall(id = "call-1", missedNotificationId = 7))!!

        assertEquals(7, content.id)
    }

    @Test
    fun `derives the id from the call id when the call carries none`() {
        val content = build(RingingCall(id = "call-1"))!!

        assertEquals("missing_call-1".hashCode(), content.id)
    }

    @Test
    fun `is a missed-call notification in its own channel and group`() {
        val notification = build(
            RingingCall(id = "call-1", callerName = "Ada", missedNotificationSubtitle = "Missed!"),
        )!!.notification

        assertEquals(NotificationChannels.MISSED_ID, notification.channelId)
        assertEquals(Notification.CATEGORY_MISSED_CALL, notification.category)
        assertEquals(MissedCallNotificationBuilder.MISSED_GROUP_KEY, notification.group)
        assertEquals("Ada", notification.extras.getString(Notification.EXTRA_TITLE))
        assertEquals("Missed!", notification.extras.getString(Notification.EXTRA_TEXT))
        assertEquals(R.layout.layout_custom_miss_notification, notification.bigContentView.layoutId)
    }

    @Test
    fun `falls back to the default subtitle`() {
        val notification = build(RingingCall(id = "call-1"))!!.notification

        assertEquals(
            context.getString(R.string.text_missed_call),
            notification.extras.getString(Notification.EXTRA_TEXT),
        )
    }

    @Test
    fun `is not built when the call asks for no missed-call notification`() {
        assertNull(build(RingingCall(id = "call-1", showMissedCallNotification = false)))
    }
}
