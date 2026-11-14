package io.getstream.video.flutter.stream_video_push_notification.core

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.telecom.DisconnectCause
import android.util.Log
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationManager
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager

/**
 * Runs each step of a ringing call: shows or clears the notification and ringtone, reports the
 * step to Dart, keeps the call store current and mirrors the step into Telecom.
 *
 * Every entry point (the broadcast receiver, the notification trampoline, the full-screen
 * activity) calls it, with the call as the Bundle [CallPayloadMapper.toBundle] writes. A step
 * that fails is logged and the rest of it skipped.
 */
internal class RingingController(
    private val context: Context,
    private val store: CallStore,
    private val notifications: IncomingCallNotificationManager,
    private val sendEvent: (String, Map<String, Any?>) -> Unit,
) {

    /**
     * Runs the step for [action], one of the `IncomingCallConstants.ACTION_CALL_*` names without
     * the package prefix. An unknown action does nothing.
     */
    fun handle(action: String, data: Bundle, keepSystemCall: Boolean = false) {
        when (action) {
            IncomingCallConstants.ACTION_CALL_INCOMING -> onIncoming(data)
            IncomingCallConstants.ACTION_CALL_START -> onStart(data)
            IncomingCallConstants.ACTION_CALL_ACCEPT -> onAccept(data)
            IncomingCallConstants.ACTION_CALL_DECLINE -> onDecline(data)
            IncomingCallConstants.ACTION_CALL_ENDED -> onEnded(data, keepSystemCall)
            IncomingCallConstants.ACTION_CALL_TIMEOUT -> onTimeout(data)
            IncomingCallConstants.ACTION_CALL_CONNECTED -> onConnected(data)
            IncomingCallConstants.ACTION_CALL_CALLBACK -> onCallback(data)
        }
    }

    /**
     * Registers the call with Telecom, then shows the incoming notification, reports it and stores
     * it. A registration that throws is logged and the ring goes on without Telecom.
     */
    @SuppressLint("MissingPermission")
    fun onIncoming(data: Bundle) = step {
        val call = CallPayloadMapper.fromBundle(data)
        try {
            StreamTelecomManager.registerIncomingCall(context, call)
        } catch (error: Exception) {
            Log.e(TAG, "telecom registration failed; ringing continues without it", error)
        }
        notifications.showIncomingNotification(data)
        report(IncomingCallConstants.ACTION_CALL_INCOMING, data)
        store.add(call)
    }

    /** Reports an outgoing call, stores it as accepted and registers it with Telecom. */
    fun onStart(data: Bundle) = step {
        report(IncomingCallConstants.ACTION_CALL_START, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.add(call.copy(isAccepted = true))
        StreamTelecomManager.registerOutgoingCall(context, call)
    }

    /**
     * Clears the ring as accepted, reports it, stores the call as accepted and answers it in
     * Telecom.
     */
    fun onAccept(data: Bundle) = step {
        notifications.clearIncomingNotification(data, true)
        report(IncomingCallConstants.ACTION_CALL_ACCEPT, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.add(call.copy(isAccepted = true))
        StreamTelecomManager.answer(context, call.id)
    }

    /** Clears the ring, reports it, forgets the call and disconnects it in Telecom as rejected. */
    fun onDecline(data: Bundle) = step {
        notifications.clearIncomingNotification(data, false)
        report(IncomingCallConstants.ACTION_CALL_DECLINE, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.remove(call.id)
        StreamTelecomManager.disconnect(context, call.id, DisconnectCause.REJECTED)
    }

    /**
     * Clears the ring, reports it and forgets the call. Telecom is disconnected too unless
     * [keepSystemCall] is set, which marks the end of the ring of a call that is now live.
     */
    fun onEnded(data: Bundle, keepSystemCall: Boolean) = step {
        notifications.clearIncomingNotification(data, false)
        report(IncomingCallConstants.ACTION_CALL_ENDED, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.remove(call.id)
        if (!keepSystemCall) {
            StreamTelecomManager.disconnect(context, call.id, DisconnectCause.LOCAL)
        }
    }

    /** Clears the ring, reports it, forgets the call and disconnects it in Telecom as missed. */
    fun onTimeout(data: Bundle) = step {
        notifications.clearIncomingNotification(data, false)
        report(IncomingCallConstants.ACTION_CALL_TIMEOUT, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.remove(call.id)
        StreamTelecomManager.disconnect(context, call.id, DisconnectCause.MISSED)
    }

    /** Reports the call as connected and activates it in Telecom. */
    fun onConnected(data: Bundle) = step {
        report(IncomingCallConstants.ACTION_CALL_CONNECTED, data)
        StreamTelecomManager.activate(context, CallPayloadMapper.fromBundle(data).id)
    }

    /**
     * Clears the missed-call notification and reports the call back. Below Android 12 it also
     * closes the notification shade.
     */
    fun onCallback(data: Bundle) = step {
        notifications.clearMissCallNotification(data)
        report(IncomingCallConstants.ACTION_CALL_CALLBACK, data)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            @Suppress("DEPRECATION")
            context.sendBroadcast(Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS))
        }
    }

    private fun report(event: String, data: Bundle) {
        if (IncomingCallBroadcastReceiver.silenceEvents) return
        val body = CallPayloadMapper.toEventBody(
            CallPayloadMapper.fromBundle(data),
            endedBySystem = data.getBoolean(
                IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM,
                false,
            ),
        )
        sendEvent(event, body)
    }

    private inline fun step(block: () -> Unit) {
        try {
            block()
        } catch (error: Exception) {
            Log.e(TAG, null, error)
        }
    }

    private companion object {
        const val TAG = "RingingController"
    }
}
