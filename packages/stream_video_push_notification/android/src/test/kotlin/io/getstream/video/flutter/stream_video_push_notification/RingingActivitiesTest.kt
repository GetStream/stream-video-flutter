package io.getstream.video.flutter.stream_video_push_notification

import android.app.Application
import android.app.KeyguardManager
import android.app.NotificationManager
import android.content.Context
import android.content.ComponentName
import android.content.Intent
import android.content.IntentFilter
import android.os.Looper
import android.telecom.DisconnectCause
import android.widget.ImageView
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.PrefsCallStore
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager
import io.mockk.mockkObject
import io.mockk.unmockkObject
import io.mockk.verify
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf

/**
 * Pins what the full-screen incoming call activity and the notification trampoline do with an
 * accept or a decline. Each test shows the ring in a process with a Flutter engine, then acts in a
 * new process with none, as after the app was killed.
 */
@RunWith(RobolectricTestRunner::class)
class RingingActivitiesTest {

    private val context: Application get() = ApplicationProvider.getApplicationContext()
    private val call = RingingCall(id = CALL_ID, callerName = "Ada")

    private val notifications: NotificationManager
        get() = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    private fun shownNotificationIds() = notifications.activeNotifications.map { it.id }

    @Before
    fun ringThenNewProcess() {
        resetPlugin()
        mockkObject(StreamTelecomManager)
        PrefsCallStore(context).removeAll()
        FakeDartSide(context)
        IncomingCallBroadcastReceiver().onReceive(
            context,
            IncomingCallBroadcastReceiver.getIntentIncoming(
                context,
                CallPayloadMapper.toBundle(call),
            ),
        )
        shadowOf(Looper.getMainLooper()).idle()
        assertEquals(listOf(CALL_ID.hashCode()), shownNotificationIds())
        resetPlugin()
        // The trampoline brings the app forward through its launch intent.
        val launcher = ComponentName(context.packageName, "LauncherActivity")
        shadowOf(context.packageManager).apply {
            addActivityIfNotPresent(launcher)
            addIntentFilterForActivity(
                launcher,
                IntentFilter(Intent.ACTION_MAIN).apply { addCategory(Intent.CATEGORY_LAUNCHER) },
            )
        }
    }

    @After
    fun releaseTelecom() {
        unmockkObject(StreamTelecomManager)
        PrefsCallStore(context).removeAll()
        resetPlugin()
    }

    private fun fullScreen() = Robolectric.buildActivity(
        IncomingCallActivity::class.java,
        IncomingCallActivity.getIntent(context, CallPayloadMapper.toBundle(call))
            .setClass(context, IncomingCallActivity::class.java),
    ).setup()

    @Test
    fun `accepting on the full-screen activity clears the ring and opens the trampoline only`() {
        // On the lock screen, where the accept also asks to dismiss the keyguard.
        shadowOf(context.getSystemService(KeyguardManager::class.java)).setKeyguardLocked(true)
        val activity = fullScreen().get()

        activity.findViewById<ImageView>(R.id.ivAcceptCall).performClick()

        // The ring is cleared at once; the accept itself waits for the trampoline.
        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(listOf(call), PrefsCallStore(context).all())
        verify(exactly = 0) { StreamTelecomManager.answer(any(), any()) }
        val next = shadowOf(context).nextStartedActivity
        assertEquals(TransparentActivity::class.java.name, next.component?.className)
        assertEquals(IncomingCallConstants.ACTION_CALL_ACCEPT, next.action)
        assertNull(shadowOf(context).nextStartedService)
    }

    @Test
    fun `declining on the full-screen activity clears the ring and runs the decline`() {
        val activity = fullScreen().get()

        activity.findViewById<ImageView>(R.id.ivDeclineCall).performClick()
        shadowOf(Looper.getMainLooper()).idle()

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(emptyList<RingingCall>(), PrefsCallStore(context).all())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.REJECTED) }
    }

    @Test
    fun `the trampoline clears the ring, runs the accept and opens the app`() {
        val activity = Robolectric.buildActivity(
            TransparentActivity::class.java,
            TransparentActivity.getIntent(
                context,
                IncomingCallConstants.ACTION_CALL_ACCEPT,
                CallPayloadMapper.toBundle(call),
            ),
        ).setup().get()

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(listOf(call.copy(isAccepted = true)), PrefsCallStore(context).all())
        verify { StreamTelecomManager.answer(any(), CALL_ID) }
        val next = shadowOf(activity).nextStartedActivity
        assertEquals(IncomingCallConstants.ACTION_CALL_ACCEPT, next.action)
        assertEquals(context.packageName, next.component?.packageName)
    }

    private companion object {
        const val CALL_ID = "call-uuid"
    }
}
