package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.telecom.DisconnectCause

/**
 * Where a Telecom state transition originated.
 *
 * Used to tell an action the app requested apart from one the user performed somewhere else, such
 * as answering from a paired watch or hanging up from a car head unit. Without the distinction,
 * every action we send to Telecom would come straight back and be applied twice.
 */
internal enum class TelecomEventSource { APP, SYS }

/**
 * Callbacks for the calls tracked by [TelecomCallRepository].
 *
 * Kept out of the repository so implementors do not inherit its API-26 requirement.
 */
internal interface TelecomCallListener {
    fun onCallRegistered(callId: String, incoming: Boolean) {}
    fun onRegistrationFailed(callId: String, error: Throwable?) {}
    fun onIsCallAnswered(callId: String, source: TelecomEventSource) {}
    fun onIsCallDisconnected(
        callId: String,
        cause: DisconnectCause,
        source: TelecomEventSource,
    ) {}
    fun onIsCallActive(callId: String) {}
    fun onIsCallInactive(callId: String) {}
    fun onMuteCallChanged(callId: String, isMuted: Boolean) {}

    /**
     * A hold or unhold this app requested was refused by Telecom, so no transition will arrive.
     *
     * @param requestedOnHold the value that was asked for, so an implementor can tell a refused
     * hold apart from a refused unhold instead of clearing whatever it happens to be tracking.
     */
    fun onHoldChangeFailed(callId: String, requestedOnHold: Boolean) {}
    fun onCallAudioEndpointsChanged(
        callId: String,
        snapshot: Map<String, Any?>,
    ) {}
}
