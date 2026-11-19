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

/** Callbacks for the calls tracked by [TelecomCallRepository]. */
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

    fun onCallAudioEndpointsChanged(
        callId: String,
        snapshot: Map<String, Any?>,
    ) {}
}
