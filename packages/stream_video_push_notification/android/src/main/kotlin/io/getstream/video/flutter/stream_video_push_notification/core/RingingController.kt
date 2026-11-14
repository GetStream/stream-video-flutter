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
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationService
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomIntegration

/**
 * Runs each step of a ringing call: shows or clears the notification and ringtone, reports the
 * step to Dart, keeps the call store current and mirrors the step into Telecom.
 *
 * The broadcast receiver, the notification trampoline and the full-screen activity call its steps
 * with the call as the Bundle [CallPayloadMapper.toBundle] writes; the method channel also calls
 * it by call id or cid, and the Telecom integration with what the system did to a call. A step
 * that fails is logged and the rest of it skipped.
 */
internal class RingingController(
    private val context: Context,
    private val store: CallStore,
    private val notifications: IncomingCallNotificationManager,
    private val telecom: TelecomIntegration,
    private val sendEvent: (String, Map<String, Any?>) -> Unit,
) : TelecomIntegration.Listener {

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
            telecom.registerIncomingCall(call)
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
        telecom.registerOutgoingCall(call)
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
        telecom.answer(call.id)
    }

    /** Clears the ring, reports it, forgets the call and disconnects it in Telecom as rejected. */
    fun onDecline(data: Bundle) = step {
        notifications.clearIncomingNotification(data, false)
        report(IncomingCallConstants.ACTION_CALL_DECLINE, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.remove(call.id)
        telecom.disconnect(call.id, DisconnectCause.REJECTED)
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
            telecom.disconnect(call.id, DisconnectCause.LOCAL)
        }
    }

    /** Clears the ring, reports it, forgets the call and disconnects it in Telecom as missed. */
    fun onTimeout(data: Bundle) = step {
        notifications.clearIncomingNotification(data, false)
        report(IncomingCallConstants.ACTION_CALL_TIMEOUT, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.remove(call.id)
        telecom.disconnect(call.id, DisconnectCause.MISSED)
    }

    /** Reports the call as connected and activates it in Telecom. */
    fun onConnected(data: Bundle) = step {
        report(IncomingCallConstants.ACTION_CALL_CONNECTED, data)
        telecom.activate(CallPayloadMapper.fromBundle(data).id)
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

    /**
     * Ends the stored call with [id]: as ended when it was accepted, as declined otherwise. Does
     * nothing for a call that is not stored.
     */
    fun endCall(id: String) {
        val call = store.byId(id) ?: return
        val data = CallPayloadMapper.toBundle(call)
        if (call.isAccepted) onEnded(data, keepSystemCall = false) else onDecline(data)
    }

    /**
     * Reports the stored call with [id] as connected. Does nothing for a call that is not stored.
     */
    fun callConnected(id: String) {
        val call = store.byId(id) ?: return
        onConnected(CallPayloadMapper.toBundle(call))
    }

    /**
     * Forgets every stored call, disconnects every call Telecom holds as ended locally, then runs
     * the end or decline step of each call that was stored, as [endCall] picks it.
     */
    fun endAllCalls() {
        val calls = store.all()
        store.removeAll()
        step { telecom.disconnectAll(DisconnectCause.LOCAL) }
        calls.forEach { call ->
            val data = CallPayloadMapper.toBundle(call)
            if (call.isAccepted) onEnded(data, keepSystemCall = false) else onDecline(data)
        }
    }

    /**
     * Ends the ring of the stored calls with [callCid], or of every stored call when [callCid] is
     * null or matches none, and keeps them in Telecom as answered calls.
     */
    fun dismissRingingCall(callCid: String?) {
        val calls = callCid
            ?.let { store.byCallCid(it) }
            ?.takeIf { it.isNotEmpty() }
            ?: store.all()

        calls.forEach { call ->
            // Answered whatever `isAccepted` says; answering an answered call does nothing.
            step { telecom.answer(call.id) }
            onEnded(CallPayloadMapper.toBundle(call), keepSystemCall = true)
        }
    }

    /**
     * Promotes the ringing foreground service again, so it is promoted with the call in the
     * Telecom stack.
     */
    override fun onIncomingCallRegistered() {
        IncomingCallNotificationService.repromoteRingingForeground()
    }

    /** Runs the accept step for a call the user answered outside the app. */
    override fun onAnsweredBySystem(call: RingingCall) {
        onAccept(CallPayloadMapper.toBundle(call))
    }

    /**
     * Runs the end step, reported to Dart as ended by the system, for a connected call the user
     * ended outside the app, and the decline step for a ringing one.
     */
    override fun onDisconnectedBySystem(call: RingingCall, wasConnected: Boolean) {
        val data = CallPayloadMapper.toBundle(call)
        if (wasConnected) {
            data.putBoolean(IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM, true)
            onEnded(data, keepSystemCall = false)
        } else {
            onDecline(data)
        }
    }

    override fun onEvent(event: String, body: Map<String, Any?>) = sendEvent(event, body)

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
