package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.NotificationManager
import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.os.Build
import androidx.test.core.app.ApplicationProvider
import coil.target.Target
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
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
import org.robolectric.Shadows.shadowOf

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

    /** The call id the posted notification's full-screen intent carries. */
    private fun callIdOf(id: String) = shadowOf(posted(id).fullScreenIntent).savedIntent
        .getBundleExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
        ?.getString(IncomingCallConstants.EXTRA_CALL_ID)

    private fun loadAvatar(id: String) =
        loads.getValue("https://x.io/$id.png").onSuccess(BitmapDrawable(context.resources, bitmap))

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

        loadAvatar("a")

        assertNotNull(posted("a").getLargeIcon())
        assertEquals("a", callIdOf("a"))
        assertNull(posted("b").getLargeIcon())

        loadAvatar("b")

        assertNotNull(posted("b").getLargeIcon())
        assertEquals("b", callIdOf("b"))
        assertEquals("a", callIdOf("a"))
        // The ringing service adopts the current notification, which now shows the avatar.
        assertNotNull(manager.currentIncomingNotification?.notification?.getLargeIcon())
    }

    @Test
    fun `an avatar that loads after its call was cleared changes nothing`() {
        manager.showIncomingNotification(CallPayloadMapper.toBundle(call("a")))
        manager.showIncomingNotification(CallPayloadMapper.toBundle(call("b")))

        manager.clearIncomingNotification(CallPayloadMapper.toBundle(call("a")), false)
        loadAvatar("a")

        assertEquals(listOf("b".hashCode()), notifications.activeNotifications.map { it.id })
        assertEquals("b".hashCode(), manager.currentIncomingNotification?.id)

        // Clearing the first call leaves the second call's avatar load running.
        loadAvatar("b")
        assertNotNull(posted("b").getLargeIcon())
        assertEquals("b", callIdOf("b"))
    }
}
