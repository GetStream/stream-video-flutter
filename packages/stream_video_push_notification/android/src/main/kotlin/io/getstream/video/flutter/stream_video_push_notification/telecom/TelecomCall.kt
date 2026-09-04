package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.telecom.DisconnectCause
import androidx.core.telecom.CallAttributesCompat
import androidx.core.telecom.CallEndpointCompat
import kotlinx.coroutines.channels.Channel

/**
 * Local representation of a call known to the Android Telecom stack.
 */
internal sealed class TelecomCall {

    /** No call is currently tracked. */
    object None : TelecomCall()

    /** A call that was handed to Telecom via `CallsManager.addCall`. */
    data class Registered(
        val id: String,
        val callAttributes: CallAttributesCompat,
        val isActive: Boolean,
        val isOnHold: Boolean,
        /**
         * The platform's mute state, mirrored from `CallControlScope.isMuted`.
         *
         * Written only by that flow. Nothing else may write it: a second writer makes the next
         * platform emission look like a user-originated change and it gets reported as one.
         */
        val isMuted: Boolean,
        /**
         * True between the moment the call is added to the repository map and the moment the
         * Telecom call scope actually starts. Actions requested while pending are queued.
         */
        val isPending: Boolean,
        val errorCode: Int?,
        val currentCallEndpoint: CallEndpointCompat?,
        val availableCallEndpoints: List<CallEndpointCompat>,
        private val actionSource: Channel<TelecomCallAction>,
    ) : TelecomCall() {

        fun isIncoming() = callAttributes.direction == CallAttributesCompat.DIRECTION_INCOMING

        /**
         * Sends an action to the Telecom call scope.
         *
         * @return true when the action was accepted, false when the scope is already gone.
         */
        fun processAction(action: TelecomCallAction) = actionSource.trySend(action).isSuccess

        /**
         * Ends the action stream, which is what lets the Telecom call scope finish.
         */
        fun closeActionSource() {
            actionSource.close()
        }
    }

    /** A previously registered call that Telecom has disconnected. */
    data class Unregistered(
        val id: String,
        val callAttributes: CallAttributesCompat,
        val disconnectCause: DisconnectCause,
    ) : TelecomCall()
}
