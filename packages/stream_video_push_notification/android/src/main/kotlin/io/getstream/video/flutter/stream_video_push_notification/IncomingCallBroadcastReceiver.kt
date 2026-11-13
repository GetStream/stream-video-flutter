
package io.getstream.video.flutter.stream_video_push_notification

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.telecom.DisconnectCause
import android.util.Log
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.CallStore
import io.getstream.video.flutter.stream_video_push_notification.core.PrefsCallStore
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager

class IncomingCallBroadcastReceiver : BroadcastReceiver() {
    
    companion object {
        private const val TAG = "IncomingCallReceiver"
        /**
         * Volatile: set from the method channel on the main thread, but read from the Telecom
         * listener callbacks, which run on a background dispatcher.
         */
        @Volatile
        var silenceEvents = false

        fun getIntent(context: Context, action: String, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                this.action = "${context.packageName}.${action}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }

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

    private val incomingCallNotificationManager: IncomingCallNotificationManager? = StreamVideoPushNotificationPlugin.getInstance()?.getIncomingCallNotificationManager()


    @SuppressLint("MissingPermission")
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val data = intent.extras?.getBundle(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA) ?: return
        when (action) {
            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_INCOMING}" -> {
                try {
                    val callData = CallPayloadMapper.fromBundle(data)
                    // Registered before the notification so the ringing foreground service is
                    // promoted with the call already in the Telecom stack; if this loses the race,
                    // StreamTelecomManager re-promotes once registration completes.
                    try {
                        StreamTelecomManager.registerIncomingCall(context, callData)
                    } catch (error: Exception) {
                        Log.e(TAG, "telecom registration failed; ringing continues without it", error)
                    }
                    incomingCallNotificationManager?.showIncomingNotification(data)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_INCOMING, data)
                    callStore(context).add(callData)
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_START}" -> {
                try {
                    // start service and show ongoing call when call is accepted
                    IncomingCallNotificationService.startServiceWithAction(
                        context,
                        IncomingCallConstants.ACTION_CALL_START,
                        data
                    )
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_START, data)
                    val callData = CallPayloadMapper.fromBundle(data)
                    callStore(context).add(callData.copy(isAccepted = true))
                    StreamTelecomManager.registerOutgoingCall(context, callData)
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_ACCEPT}" -> {
                try {
                    // start service and show ongoing call when call is accepted
                    IncomingCallNotificationService.startServiceWithAction(
                        context,
                        IncomingCallConstants.ACTION_CALL_ACCEPT,
                        data
                    )
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_ACCEPT, data)
                    val callData = CallPayloadMapper.fromBundle(data)
                    callStore(context).add(callData.copy(isAccepted = true))
                    StreamTelecomManager.answer(context, callData.id)
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_DECLINE}" -> {
                try {
                    // clear notification
                    incomingCallNotificationManager?.clearIncomingNotification(data, false)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_DECLINE, data)
                    val callData = CallPayloadMapper.fromBundle(data)
                    callStore(context).remove(callData.id)
                    StreamTelecomManager.disconnect(
                        context,
                        callData.id,
                        DisconnectCause.REJECTED
                    )
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_ENDED}" -> {
                try {
                    // clear notification and stop service
                    incomingCallNotificationManager?.clearIncomingNotification(data, false)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_ENDED, data)
                    val callData = CallPayloadMapper.fromBundle(data)
                    callStore(context).remove(callData.id)

                    // An ENDED right after an accept means "the ring is over", not "the call is
                    // over". Disconnecting Telecom here would end the registration seconds into a
                    // call the user is still in, taking watch/headset/car controls with it.
                    val keepSystemCall = intent.getBooleanExtra(
                        IncomingCallConstants.EXTRA_KEEP_SYSTEM_CALL,
                        false,
                    )
                    if (!keepSystemCall) {
                        StreamTelecomManager.disconnect(
                            context,
                            callData.id,
                            DisconnectCause.LOCAL
                        )
                    }
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_TIMEOUT}" -> {
                try {
                    incomingCallNotificationManager?.clearIncomingNotification(data, false)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_TIMEOUT, data)
                    val callData = CallPayloadMapper.fromBundle(data)
                    callStore(context).remove(callData.id)
                    StreamTelecomManager.disconnect(
                        context,
                        callData.id,
                        DisconnectCause.MISSED
                    )
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_CONNECTED}" -> {
                try {
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_CONNECTED, data)
                    StreamTelecomManager.activate(context, CallPayloadMapper.fromBundle(data).id)
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_CALLBACK}" -> {
                try {
                    incomingCallNotificationManager?.clearMissCallNotification(data)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_CALLBACK, data)
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                        val closeNotificationPanel = Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS)
                        context.sendBroadcast(closeNotificationPanel)
                    }
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }
        }
    }

    private fun callStore(context: Context): CallStore = PrefsCallStore(context)

    private fun sendEventFlutter(event: String, data: Bundle) {
        if (silenceEvents) return

        val body = CallPayloadMapper.toEventBody(
            CallPayloadMapper.fromBundle(data),
            endedBySystem = data.getBoolean(IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM, false),
        )
        StreamVideoPushNotificationPlugin.sendEvent(event, body)
    }
}