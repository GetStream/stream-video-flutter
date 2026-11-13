package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.NotificationManager
import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.os.Build
import androidx.test.core.app.ApplicationProvider
import coil.target.Target
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationManager
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import io.mockk.mockk
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Pins that two calls ringing at once keep their own notifications and avatars, with the avatar
 * loads captured instead of run.
 */
@RunWith(RobolectricTestRunner::class)
class IncomingCallNotificationManagerTest {

    private val context: Context get() = ApplicationProvider.getApplicationContext()
    private val notifications: NotificationManager
        get() = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    /** The pending avatar loads, by URL. */
    private val loads = mutableMapOf<String, Target>()

    private val manager by lazy {
        IncomingCallNotificationManager(
            context,
            ringtone = mockk(relaxed = true),
            incomingBuilder = IncomingCallNotificationBuilder(
                context,
                Build.VERSION_CODES.UPSIDE_DOWN_CAKE,
            ),
            loadCircleImage = { _, url, _, target -> loads[url] = target },
        )
    }

    private fun call(id: String) =
        RingingCall(id = id, callerName = id, avatar = "https://x.io/$id.png")

    private fun posted(id: String) =
        notifications.activeNotifications.single { it.id == id.hashCode() }.notification

    private val bitmap: Bitmap = Bitmap.createBitmap(4, 4, Bitmap.Config.ARGB_8888)

    @Test
    fun `two calls get their own notifications and avatars`() {
        manager.showIncomingNotification(CallPayloadMapper.toBundle(call("a")))
        manager.showIncomingNotification(CallPayloadMapper.toBundle(call("b")))

        assertEquals(
            setOf("a".hashCode(), "b".hashCode()),
            notifications.activeNotifications.map { it.id }.toSet(),
        )
        assertEquals("b".hashCode(), manager.currentIncomingNotification?.id)

        loads.getValue("https://x.io/a.png").onSuccess(BitmapDrawable(context.resources, bitmap))

        assertNotNull(posted("a").getLargeIcon())
        assertNull(posted("b").getLargeIcon())
    }

    @Test
    fun `an avatar that loads after its call was cleared changes nothing`() {
        manager.showIncomingNotification(CallPayloadMapper.toBundle(call("a")))
        manager.showIncomingNotification(CallPayloadMapper.toBundle(call("b")))

        manager.clearIncomingNotification(CallPayloadMapper.toBundle(call("a")), false)
        loads.getValue("https://x.io/a.png").onSuccess(BitmapDrawable(context.resources, bitmap))

        assertEquals(listOf("b".hashCode()), notifications.activeNotifications.map { it.id })
        assertEquals("b".hashCode(), manager.currentIncomingNotification?.id)
    }
}
