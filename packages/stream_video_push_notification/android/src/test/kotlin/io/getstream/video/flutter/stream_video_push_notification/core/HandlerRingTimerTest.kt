package io.getstream.video.flutter.stream_video_push_notification.core

import android.app.AlarmManager
import android.app.Application
import android.content.Context
import android.os.Looper
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import java.time.Duration
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf

/** Pins when [HandlerRingTimer] times a ring out and the alarm it sets as a fallback. */
@RunWith(RobolectricTestRunner::class)
class HandlerRingTimerTest {

    private val context: Application get() = ApplicationProvider.getApplicationContext()
    private val alarms get() = shadowOf(context.getSystemService(Context.ALARM_SERVICE) as AlarmManager)

    private val timedOut = mutableListOf<String>()
    private val timer by lazy { HandlerRingTimer(context) { timedOut += it } }

    private val call = RingingCall(id = "call-1", duration = 30_000L)

    private fun advance(millis: Long) {
        shadowOf(Looper.getMainLooper()).idleFor(Duration.ofMillis(millis))
    }

    @Test
    fun `a ring times out once its duration has passed, and not before`() {
        timer.start(call)

        advance(29_999)
        assertEquals(emptyList<String>(), timedOut)

        advance(1)
        assertEquals(listOf("call-1"), timedOut)
        assertNull(alarms.nextScheduledAlarm)
    }

    @Test
    fun `a cancelled ring does not time out and its alarm is gone`() {
        timer.start(call)
        timer.cancel("call-1")

        advance(60_000)

        assertEquals(emptyList<String>(), timedOut)
        assertNull(alarms.nextScheduledAlarm)
    }

    @Test
    fun `starting again replaces the running timer`() {
        timer.start(call)
        advance(20_000)
        timer.start(call)

        advance(20_000)
        assertEquals(emptyList<String>(), timedOut)

        advance(10_000)
        assertEquals(listOf("call-1"), timedOut)
    }

    @Test
    fun `the fallback alarm sends the timeout broadcast for the call`() {
        timer.start(call)

        val alarm = alarms.nextScheduledAlarm!!
        assertEquals(AlarmManager.ELAPSED_REALTIME_WAKEUP, alarm.type)
        val intent = shadowOf(alarm.operation).savedIntent
        assertEquals(
            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_TIMEOUT}",
            intent.action,
        )
        assertEquals(
            "call-1",
            intent.getBundleExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
                ?.getString(IncomingCallConstants.EXTRA_CALL_ID),
        )
    }

    @Test
    fun `a ring without a duration is not timed`() {
        timer.start(call.copy(duration = 0))

        advance(60_000)

        assertEquals(emptyList<String>(), timedOut)
        assertNull(alarms.nextScheduledAlarm)
    }
}
