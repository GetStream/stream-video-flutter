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
    private val ringTimer: RingTimer,
    private val sendEvent: (String, Map<String, Any?>) -> Unit,
) : TelecomIntegration.Listener {

    /**
     * Runs the step for [action], one of the `IncomingCallConstants.ACTION_CALL_*` names without
     * the package prefix. An unknown action does nothing.
     */
    fun handle(action: String, data: Bundle) {
        when (action) {
            IncomingCallConstants.ACTION_CALL_INCOMING -> onIncoming(data)
            IncomingCallConstants.ACTION_CALL_START -> onStart(data)
            IncomingCallConstants.ACTION_CALL_ACCEPT -> onAccept(data)
            IncomingCallConstants.ACTION_CALL_DECLINE -> onDecline(data)
            IncomingCallConstants.ACTION_CALL_ENDED -> onEnded(data)
            IncomingCallConstants.ACTION_CALL_TIMEOUT ->
                onRingTimedOut(CallPayloadMapper.fromBundle(data).id)
            IncomingCallConstants.ACTION_CALL_CONNECTED -> onConnected(data)
            IncomingCallConstants.ACTION_CALL_CALLBACK -> onCallback(data)
        }
    }

    /**
     * Registers the call with Telecom, then shows the incoming notification, reports it, stores it
     * and starts timing the ring out. A registration that throws is logged and the ring goes on
     * without Telecom.
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
        ringTimer.start(call)
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
        ringTimer.cancel(CallPayloadMapper.fromBundle(data).id)
        notifications.clearIncomingNotification(data, true)
        report(IncomingCallConstants.ACTION_CALL_ACCEPT, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.add(call.copy(isAccepted = true))
        telecom.answer(call.id)
    }

    /** Clears the ring, reports it, forgets the call and disconnects it in Telecom as rejected. */
    fun onDecline(data: Bundle) = step {
        ringTimer.cancel(CallPayloadMapper.fromBundle(data).id)
        notifications.clearIncomingNotification(data, false)
        report(IncomingCallConstants.ACTION_CALL_DECLINE, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.remove(call.id)
        telecom.disconnect(call.id, DisconnectCause.REJECTED)
    }

    /** Clears the ring, reports it, forgets the call and disconnects it in Telecom as local. */
    fun onEnded(data: Bundle) = step {
        ringTimer.cancel(CallPayloadMapper.fromBundle(data).id)
        notifications.clearIncomingNotification(data, false)
        report(IncomingCallConstants.ACTION_CALL_ENDED, data)
        val call = CallPayloadMapper.fromBundle(data)
        store.remove(call.id)
        telecom.disconnect(call.id, DisconnectCause.LOCAL)
    }

    /**
     * Runs the timeout step for the stored call with [callId] if it is still ringing: stored and
     * not accepted. Otherwise does nothing.
     */
    fun onRingTimedOut(callId: String) = step {
        val call = store.byId(callId) ?: return@step
        if (call.isAccepted) return@step
        onTimeout(CallPayloadMapper.toBundle(call))
    }

    /** Clears the ring, reports it, forgets the call and disconnects it in Telecom as missed. */
    private fun onTimeout(data: Bundle) = step {
        ringTimer.cancel(CallPayloadMapper.fromBundle(data).id)
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
        if (call.isAccepted) onEnded(data) else onDecline(data)
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
            if (call.isAccepted) onEnded(data) else onDecline(data)
        }
    }

    /**
     * Ends the ring of the stored calls with [callCid], or of every stored call when [callCid] is
     * null, for [reason]: clears it, reports it as dismissed with the reason and forgets the call.
     *
     * For [DismissReason.ACCEPTED] the call stays in Telecom, answered whatever `isAccepted` says.
     * For the other reasons Telecom disconnects it: as remote for a cancel and for an answer on
     * another device, as missed for a missed call.
     */
    fun dismissRingingCall(callCid: String?, reason: DismissReason) {
        val calls = callCid?.let { store.byCallCid(it) } ?: store.all()

        calls.forEach { call ->
            if (reason == DismissReason.ACCEPTED) step { telecom.answer(call.id) }
            dismiss(call, reason)
        }
    }

    private fun dismiss(call: RingingCall, reason: DismissReason) = step {
        ringTimer.cancel(call.id)
        val data = CallPayloadMapper.toBundle(call)
        notifications.clearIncomingNotification(data, false)
        report(IncomingCallConstants.ACTION_CALL_DISMISSED, data, "reason" to reason.wireName)
        store.remove(call.id)
        when (reason) {
            DismissReason.ACCEPTED -> Unit
            DismissReason.REMOTE_CANCELLED -> telecom.disconnect(call.id, DisconnectCause.REMOTE)
            DismissReason.ANSWERED_ELSEWHERE -> telecom.disconnect(call.id, DisconnectCause.REMOTE)
            DismissReason.MISSED -> telecom.disconnect(call.id, DisconnectCause.MISSED)
        }
    }

    /**
     * Shows the missed-call notification of the call in [data] and ends the rings of the stored
     * calls with its call cid that were not accepted: clears each, forgets it and disconnects it
     * in Telecom as missed. Without such a stored call, clears the ring of the id in [data].
     * Nothing is reported.
     */
    fun showMissedCall(data: Bundle) = step {
        val missed = CallPayloadMapper.fromBundle(data)
        val ringing = missed.callCid
            ?.let { store.byCallCid(it) }
            .orEmpty()
            .filter { !it.isAccepted }
            .ifEmpty { listOf(missed) }

        ringing.forEach { call ->
            ringTimer.cancel(call.id)
            notifications.clearIncomingNotification(CallPayloadMapper.toBundle(call), false)
            store.remove(call.id)
            telecom.disconnect(call.id, DisconnectCause.MISSED)
        }
        notifications.showMissCallNotification(data)
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
            onEnded(data)
        } else {
            onDecline(data)
        }
    }

    override fun onEvent(event: String, body: Map<String, Any?>) = sendEvent(event, body)

    private fun report(event: String, data: Bundle, vararg extra: Pair<String, Any?>) {
        if (IncomingCallBroadcastReceiver.silenceEvents) return
        val body = CallPayloadMapper.toEventBody(
            CallPayloadMapper.fromBundle(data),
            endedBySystem = data.getBoolean(
                IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM,
                false,
            ),
        )
        sendEvent(event, body + extra)
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
