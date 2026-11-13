package io.getstream.video.flutter.stream_video_push_notification

import android.app.Application
import android.app.KeyguardManager
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
 * accept or a decline, in a process with no Flutter engine attached.
 */
@RunWith(RobolectricTestRunner::class)
class RingingActivitiesTest {

    private val context: Application get() = ApplicationProvider.getApplicationContext()
    private val call = RingingCall(id = CALL_ID, callerName = "Ada")

    @Before
    fun freshProcess() {
        resetPlugin()
        mockkObject(StreamTelecomManager)
        PrefsCallStore(context).removeAll()
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
    fun `accepting on the full-screen activity only opens the trampoline`() {
        // On the lock screen, where the accept also asks to dismiss the keyguard.
        shadowOf(context.getSystemService(KeyguardManager::class.java)).setKeyguardLocked(true)
        val activity = fullScreen().get()

        activity.findViewById<ImageView>(R.id.ivAcceptCall).performClick()

        val next = shadowOf(context).nextStartedActivity
        assertEquals(TransparentActivity::class.java.name, next.component?.className)
        assertEquals(IncomingCallConstants.ACTION_CALL_ACCEPT, next.action)
        assertNull(shadowOf(context).nextStartedService)
    }

    @Test
    fun `declining on the full-screen activity runs the decline`() {
        PrefsCallStore(context).add(call)
        val activity = fullScreen().get()

        activity.findViewById<ImageView>(R.id.ivDeclineCall).performClick()
        shadowOf(Looper.getMainLooper()).idle()

        assertEquals(emptyList<RingingCall>(), PrefsCallStore(context).all())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.REJECTED) }
    }

    @Test
    fun `the trampoline runs the accept and opens the app`() {
        val activity = Robolectric.buildActivity(
            TransparentActivity::class.java,
            TransparentActivity.getIntent(
                context,
                IncomingCallConstants.ACTION_CALL_ACCEPT,
                CallPayloadMapper.toBundle(call),
            ),
        ).setup().get()

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
