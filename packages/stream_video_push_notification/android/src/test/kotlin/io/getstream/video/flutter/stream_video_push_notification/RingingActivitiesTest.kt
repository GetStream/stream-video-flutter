package io.getstream.video.flutter.stream_video_push_notification

import android.app.AlarmManager
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
import android.widget.TextView
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.PrefsCallStore
import io.getstream.video.flutter.stream_video_push_notification.core.RingingComponents
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomIntegration
import io.mockk.verify
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
import org.robolectric.annotation.Config
import org.robolectric.shadows.ShadowPowerManager
import java.time.Duration

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

    private lateinit var telecom: TelecomIntegration

    @Before
    fun ringThenNewProcess() {
        RingingComponents.reset()
        telecom = mockTelecom()
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
        PrefsCallStore(context).removeAll()
        RingingComponents.reset()
    }

    private fun fullScreen() = Robolectric.buildActivity(
        IncomingCallActivity::class.java,
        IncomingCallActivity.getIntent(context, CallPayloadMapper.toBundle(call)),
    ).setup()

    /** Sends the broadcast the notification manager sends when the ring of [callId] ends. */
    private fun ringEnded(callId: String, isAccepted: Boolean = false) {
        context.sendBroadcast(IncomingCallActivity.getIntentEnded(context, callId, isAccepted))
        shadowOf(Looper.getMainLooper()).idle()
    }

    @Test
    fun `the full-screen intent names the activity`() {
        val intent = IncomingCallActivity.getIntent(context, CallPayloadMapper.toBundle(call))

        assertEquals(IncomingCallActivity::class.java.name, intent.component?.className)
    }

    @Test
    fun `the full-screen activity closes when its call's ring ends`() {
        val activity = fullScreen().get()

        ringEnded(CALL_ID)

        assertTrue(activity.isFinishing)
    }

    @Test
    @Config(sdk = [31])
    fun `the full-screen activity closes when its call's ring ends below Android 13`() {
        // Below 13 the not-exported receiver rests on a signature permission core-ktx merges
        // into the app, which Robolectric does not grant by itself.
        shadowOf(context).grantPermissions(
            "${context.packageName}.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION",
        )
        val activity = fullScreen().get()

        ringEnded(CALL_ID)

        assertTrue(activity.isFinishing)
    }

    @Test
    fun `the full-screen activity stays up when another call's ring ends`() {
        val activity = fullScreen().get()

        ringEnded("another-call")

        assertFalse(activity.isFinishing)
    }

    @Test
    fun `the full-screen activity closes shortly after its call is accepted elsewhere`() {
        val activity = fullScreen().get()

        ringEnded(CALL_ID, isAccepted = true)
        assertFalse(activity.isFinishing)
        shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(1))

        assertTrue(activity.isFinishing)
    }

    @Test
    fun `the full-screen activity does not time the ring out itself`() {
        val activity = fullScreen().get()
        // Forgetting the call leaves the ring timer nothing to time out, so only a timeout of the
        // screen's own could close it.
        PrefsCallStore(context).removeAll()

        shadowOf(Looper.getMainLooper()).idleFor(Duration.ofMillis(call.duration + 1000))

        assertFalse(activity.isFinishing)
    }

    @Test
    fun `a second ring shows its call, which accept and decline then act on`() {
        val second = RingingCall(id = SECOND_CALL_ID, callerName = "Grace")
        IncomingCallBroadcastReceiver().onReceive(
            context,
            IncomingCallBroadcastReceiver.getIntentIncoming(
                context,
                CallPayloadMapper.toBundle(second),
            ),
        )
        shadowOf(Looper.getMainLooper()).idle()
        val controller = fullScreen()

        controller.newIntent(
            IncomingCallActivity.getIntent(context, CallPayloadMapper.toBundle(second)),
        )
        val activity = controller.get()

        assertEquals("Grace", activity.findViewById<TextView>(R.id.tvCallerName).text.toString())
        activity.findViewById<ImageView>(R.id.ivDeclineCall).performClick()
        shadowOf(Looper.getMainLooper()).idle()
        verify { telecom.disconnect(SECOND_CALL_ID, DisconnectCause.REJECTED) }
        // Not declined. Robolectric advances the clock while the screen animates, so the first
        // call's ring may time out meanwhile; that is the ring timer's doing, not the screen's.
        verify(exactly = 0) { telecom.disconnect(CALL_ID, DisconnectCause.REJECTED) }
    }

    @Test
    fun `after a second ring only the second call's end closes the full-screen activity`() {
        PrefsCallStore(context).add(RingingCall(id = SECOND_CALL_ID))
        val controller = fullScreen()
        controller.newIntent(
            IncomingCallActivity.getIntent(
                context,
                CallPayloadMapper.toBundle(RingingCall(id = SECOND_CALL_ID)),
            ),
        )
        val activity = controller.get()

        ringEnded(CALL_ID)
        assertFalse(activity.isFinishing)

        ringEnded(SECOND_CALL_ID)
        assertTrue(activity.isFinishing)
    }

    @Test
    fun `an accept elsewhere of the first call does not close the screen of the second`() {
        PrefsCallStore(context).add(RingingCall(id = SECOND_CALL_ID))
        val controller = fullScreen()

        ringEnded(CALL_ID, isAccepted = true)
        controller.newIntent(
            IncomingCallActivity.getIntent(
                context,
                CallPayloadMapper.toBundle(RingingCall(id = SECOND_CALL_ID)),
            ),
        )
        shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(2))

        assertFalse(controller.get().isFinishing)
    }

    @Test
    fun `the full-screen activity closes on coming up when its call's ring is already over`() {
        PrefsCallStore(context).removeAll()

        assertTrue(fullScreen().get().isFinishing)
    }

    @Test
    fun `the full-screen activity closes on coming back when its call was accepted meanwhile`() {
        val controller = fullScreen()
        controller.pause()
        PrefsCallStore(context).add(call.copy(isAccepted = true))

        controller.resume()

        assertTrue(controller.get().isFinishing)
    }

    @Test
    fun `a second ring whose ring is already over closes the full-screen activity`() {
        val controller = fullScreen()

        // Its ended broadcast came before the new intent, so only the store tells.
        controller.newIntent(
            IncomingCallActivity.getIntent(
                context,
                CallPayloadMapper.toBundle(RingingCall(id = SECOND_CALL_ID)),
            ),
        )

        assertTrue(controller.get().isFinishing)
    }

    @Test
    fun `a recreated full-screen activity keeps showing the second call`() {
        PrefsCallStore(context).add(RingingCall(id = SECOND_CALL_ID, callerName = "Grace"))
        val controller = fullScreen()
        controller.newIntent(
            IncomingCallActivity.getIntent(
                context,
                CallPayloadMapper.toBundle(RingingCall(id = SECOND_CALL_ID, callerName = "Grace")),
            ),
        )

        controller.recreate()
        val activity = controller.get()

        assertEquals("Grace", activity.findViewById<TextView>(R.id.tvCallerName).text.toString())
        ringEnded(CALL_ID)
        assertFalse(activity.isFinishing)
        ringEnded(SECOND_CALL_ID)
        assertTrue(activity.isFinishing)
    }

    @Test
    fun `a second ring puts back what only the first call set`() {
        // The first call is a video call with a text colour; the second sets neither.
        val first = call.copy(type = 1)
        val firstData = CallPayloadMapper.toBundle(first).apply {
            putString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_TEXT_COLOR, "#FF0000")
        }
        PrefsCallStore(context).add(RingingCall(id = SECOND_CALL_ID))
        val controller = Robolectric.buildActivity(
            IncomingCallActivity::class.java,
            IncomingCallActivity.getIntent(context, firstData),
        ).setup()
        fun name() = controller.get().findViewById<TextView>(R.id.tvCallerName)
        val layoutColor = context.getColor(R.color.incoming_call_text_primary)
        assertEquals(android.graphics.Color.RED, name().currentTextColor)
        val wakeLockOfFirst = ShadowPowerManager.getLatestWakeLock()

        controller.newIntent(
            IncomingCallActivity.getIntent(
                context,
                CallPayloadMapper.toBundle(RingingCall(id = SECOND_CALL_ID)),
            ),
        )

        assertEquals(layoutColor, name().currentTextColor)
        val accept = controller.get().findViewById<ImageView>(R.id.ivAcceptCall)
        assertEquals(R.drawable.ic_accept, shadowOf(accept.drawable).createdFromResId)
        assertFalse(wakeLockOfFirst.isHeld)
        assertTrue(ShadowPowerManager.getLatestWakeLock().isHeld)
    }

    @Test
    fun `the ringing components are not exported`() {
        val packageManager = context.packageManager
        val activity = packageManager.getActivityInfo(
            ComponentName(context, IncomingCallActivity::class.java),
            0,
        )
        val receiver = packageManager.getReceiverInfo(
            ComponentName(context, IncomingCallBroadcastReceiver::class.java),
            0,
        )
        val service = packageManager.getServiceInfo(
            ComponentName(context, IncomingCallNotificationService::class.java),
            0,
        )

        assertFalse(activity.exported)
        assertFalse(receiver.exported)
        assertFalse(service.exported)
    }

    @Test
    fun `accepting on the full-screen activity clears the ring and opens the trampoline only`() {
        // On the lock screen, where the accept also asks to dismiss the keyguard.
        shadowOf(context.getSystemService(KeyguardManager::class.java)).setKeyguardLocked(true)
        val activity = fullScreen().get()

        activity.findViewById<ImageView>(R.id.ivAcceptCall).performClick()

        // The ring and its timeout stop at once; the accept itself waits for the trampoline.
        assertEquals(emptyList<Int>(), shownNotificationIds())
        val alarms = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        assertNull(shadowOf(alarms).nextScheduledAlarm)
        assertEquals(listOf(call), PrefsCallStore(context).all())
        verify(exactly = 0) { telecom.answer(any()) }
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
        verify { telecom.disconnect(CALL_ID, DisconnectCause.REJECTED) }
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
        verify { telecom.answer(CALL_ID) }
        val next = shadowOf(activity).nextStartedActivity
        assertEquals(IncomingCallConstants.ACTION_CALL_ACCEPT, next.action)
        assertEquals(context.packageName, next.component?.packageName)
    }

    @Test
    fun `the full-screen activity without call data finishes before setting anything up`() {
        val controller = Robolectric.buildActivity(
            IncomingCallActivity::class.java,
            Intent(context, IncomingCallActivity::class.java),
        ).setup()

        assertTrue(controller.get().isFinishing)
        assertNull(ShadowPowerManager.getLatestWakeLock())
        assertTrue(
            shadowOf(context).registeredReceivers.none {
                it.intentFilter.actionsIterator().asSequence().any { action ->
                    action.endsWith("ACTION_ENDED_CALL_INCOMING")
                }
            },
        )
        controller.destroy()
    }

    private companion object {
        const val CALL_ID = "call-uuid"
        const val SECOND_CALL_ID = "second-call-uuid"
    }
}
