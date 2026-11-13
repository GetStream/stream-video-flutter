package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.telecom.DisconnectCause
import kotlinx.coroutines.CompletableDeferred

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

    /**
     * Route the call's audio to the endpoint of [endpointType], a `CallEndpointCompat.TYPE_*`.
     *
     * [result] completes with true once Telecom routes the call there, or already did, and with
     * false when it does not: no such endpoint, a refused change, a newer request, or a call that
     * ended first.
     */
    class RequestEndpoint(val endpointType: Int) : TelecomCallAction {
        val result = CompletableDeferred<Boolean>()
    }
}

/** Answers a [TelecomCallAction.RequestEndpoint] that will not be carried out as false. */
internal fun TelecomCallAction.drop() {
    if (this is TelecomCallAction.RequestEndpoint) result.complete(false)
}
