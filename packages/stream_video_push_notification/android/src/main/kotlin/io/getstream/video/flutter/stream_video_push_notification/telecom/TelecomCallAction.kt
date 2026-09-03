package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.telecom.DisconnectCause

/**
 * Actions that can be pushed into a registered Telecom call scope.
 */
internal sealed interface TelecomCallAction {
    /** Answer an incoming call. */
    object Answer : TelecomCallAction

    /** Disconnect the call with the given cause. */
    data class Disconnect(val cause: DisconnectCause) : TelecomCallAction

    /** Put the call on hold (Telecom "inactive"). */
    object Hold : TelecomCallAction

    /** Make the call active, used for outgoing calls once they are answered. */
    object Activate : TelecomCallAction
}


