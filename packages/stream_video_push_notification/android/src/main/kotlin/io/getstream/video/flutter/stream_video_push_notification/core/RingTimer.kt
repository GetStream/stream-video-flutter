package io.getstream.video.flutter.stream_video_push_notification.core

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver

/** Times a ring out after its duration. */
internal interface RingTimer {

    /** Starts timing [call] out, replacing a timer already running for it. */
    fun start(call: RingingCall)

    /** Stops the timer of the call with [callId], if one runs. */
    fun cancel(callId: String)
}

/**
 * A [RingTimer] that calls [onTimeout] on the main thread when a ring's duration has passed.
 *
 * Also sets an inexact alarm for the same time, which sends the timeout broadcast to the receiver.
 * It ends the ring when the main-thread timer cannot, for example after the process died or while
 * the device slept; it can arrive late in Doze. The controller ignores a timeout for a call that
 * is no longer ringing.
 */
internal class HandlerRingTimer(
    private val context: Context,
    private val onTimeout: (callId: String) -> Unit,
) : RingTimer {

    private val handler = Handler(Looper.getMainLooper())
    private val pending = mutableMapOf<String, Runnable>()

    override fun start(call: RingingCall) {
        cancel(call.id)
        if (call.id.isEmpty() || call.duration <= 0) return

        val runnable = Runnable {
            pending.remove(call.id)
            cancelAlarm(call.id)
            onTimeout(call.id)
        }
        pending[call.id] = runnable
        handler.postDelayed(runnable, call.duration)

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
        val triggerAt = SystemClock.elapsedRealtime() + call.duration
        val operation = alarmIntent(call.id, CallPayloadMapper.toBundle(call))
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager?.setAndAllowWhileIdle(
                AlarmManager.ELAPSED_REALTIME_WAKEUP,
                triggerAt,
                operation,
            )
        } else {
            alarmManager?.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, triggerAt, operation)
        }
    }

    override fun cancel(callId: String) {
        pending.remove(callId)?.let(handler::removeCallbacks)
        cancelAlarm(callId)
    }

    private fun cancelAlarm(callId: String) {
        val intent = PendingIntent.getBroadcast(
            context,
            callId.hashCode(),
            IncomingCallBroadcastReceiver.getIntentTimeout(context, null),
            PendingIntent.FLAG_NO_CREATE or immutableFlag(),
        ) ?: return
        (context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager)?.cancel(intent)
        intent.cancel()
    }

    /** The alarm's PendingIntent for a call, identified by the call id's hash. */
    private fun alarmIntent(callId: String, data: Bundle): PendingIntent =
        PendingIntent.getBroadcast(
            context,
            callId.hashCode(),
            IncomingCallBroadcastReceiver.getIntentTimeout(context, data),
            PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag(),
        )

    private fun immutableFlag(): Int =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
}
