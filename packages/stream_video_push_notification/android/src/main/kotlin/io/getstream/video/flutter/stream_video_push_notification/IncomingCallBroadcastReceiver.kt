
package io.getstream.video.flutter.stream_video_push_notification

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.getstream.video.flutter.stream_video_push_notification.core.RingingComponents

/**
 * Receives the call actions sent as broadcasts, from the plugin and the notifications, and hands
 * them to the [RingingComponents] controller.
 */
class IncomingCallBroadcastReceiver : BroadcastReceiver() {
    companion object {
        /**
         * Volatile: set from the method channel on the main thread, but read from the Telecom
         * listener callbacks, which run on a background dispatcher.
         */
        @Volatile
        var silenceEvents = false

        fun getIntentIncoming(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_INCOMING}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }

        fun getIntentStart(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_START}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }

        fun getIntentAccept(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_ACCEPT}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }

        fun getIntentDecline(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_DECLINE}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }

        fun getIntentEnded(
            context: Context,
            data: Bundle?,
            keepSystemCall: Boolean = false,
        ) = Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
            action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_ENDED}"
            putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            putExtra(IncomingCallConstants.EXTRA_KEEP_SYSTEM_CALL, keepSystemCall)
        }

        fun getIntentTimeout(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_TIMEOUT}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }

        fun getIntentCallback(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_CALLBACK}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }

        fun getIntentConnected(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_CONNECTED}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val data = intent.extras?.getBundle(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA) ?: return
        val prefix = "${context.packageName}."
        if (!action.startsWith(prefix)) return

        RingingComponents.get(context).controller.handle(
            action = action.removePrefix(prefix),
            data = data,
            keepSystemCall = intent.getBooleanExtra(
                IncomingCallConstants.EXTRA_KEEP_SYSTEM_CALL,
                false,
            ),
        )
    }
}
