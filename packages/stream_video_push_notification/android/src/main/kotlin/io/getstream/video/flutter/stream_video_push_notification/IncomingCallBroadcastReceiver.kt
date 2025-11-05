
package io.getstream.video.flutter.stream_video_push_notification

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log

class IncomingCallBroadcastReceiver : BroadcastReceiver() {
    
    companion object {
        private const val TAG = "IncomingCallReceiver"
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

        fun getIntentEnded(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_ENDED}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
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

        fun getIntentHeldByCell(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_HELD}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }

        fun getIntentUnHeldByCell(context: Context, data: Bundle?) =
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_UNHELD}"
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
                    incomingCallNotificationManager?.showIncomingNotification(data)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_INCOMING, data)
                    addCall(context, Data.fromBundle(data))
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
                    addCall(context, Data.fromBundle(data), true)
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
                    addCall(context, Data.fromBundle(data), true)
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_DECLINE}" -> {
                try {
                    // clear notification
                    incomingCallNotificationManager?.clearIncomingNotification(data, false)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_DECLINE, data)
                    removeCall(context, Data.fromBundle(data))
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_ENDED}" -> {
                try {
                    // clear notification and stop service
                    incomingCallNotificationManager?.clearIncomingNotification(data, false)
                    IncomingCallNotificationService.stopService(context)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_ENDED, data)
                    removeCall(context, Data.fromBundle(data))
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_TIMEOUT}" -> {
                try {
                    incomingCallNotificationManager?.clearIncomingNotification(data, false)
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_TIMEOUT, data)
                    removeCall(context, Data.fromBundle(data))
                } catch (error: Exception) {
                    Log.e(TAG, null, error)
                }
            }

            "${context.packageName}.${IncomingCallConstants.ACTION_CALL_CONNECTED}" -> {
                try {
                    sendEventFlutter(IncomingCallConstants.ACTION_CALL_CONNECTED, data)
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

    private fun sendEventFlutter(event: String, data: Bundle) {
        if (silenceEvents) return

        val missedCallNotification = mapOf(
            "id" to data.getInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID),
            "showNotification" to data.getBoolean(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SHOW),
            "count" to data.getInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_COUNT),
            "subtitle" to data.getString(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SUBTITLE),
            "callbackText" to data.getString(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT),
            "showCallbackButton" to data.getBoolean(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW),
        )

        val incomingCallNotification = mapOf(
            "fullScreenShowLogo" to data.getBoolean(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_SHOW_LOGO, false),
            "fullScreenLogoUrl" to data.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_LOGO_URL, ""),
            "fullScreenBackgroundColor" to data.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_COLOR, ""),
            "fullScreenBackgroundUrl" to data.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_URL, ""),
            "fullScreenTextColor" to data.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_TEXT_COLOR, ""),
            "textAccept" to data.getString(IncomingCallConstants.EXTRA_CALL_TEXT_ACCEPT, ""),
            "textDecline" to data.getString(IncomingCallConstants.EXTRA_CALL_TEXT_DECLINE, ""),
        )

        val android = mapOf(
            "ringtonePath" to data.getString(IncomingCallConstants.EXTRA_CALL_RINGTONE_PATH, ""),
            "defaultAvatar" to data.getString(IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR, ""),
            "missedCallNotification" to missedCallNotification,
            "incomingCallNotification" to incomingCallNotification,
            "incomingCallNotificationChannelName" to data.getString(
                IncomingCallConstants.EXTRA_CALL_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME,
                ""
            ),
            "missedCallNotificationChannelName" to data.getString(
                IncomingCallConstants.EXTRA_CALL_MISSED_CALL_NOTIFICATION_CHANNEL_NAME,
                ""
            ),
            "isImportant" to data.getBoolean(IncomingCallConstants.EXTRA_CALL_IS_IMPORTANT, true),
            "isBot" to data.getBoolean(IncomingCallConstants.EXTRA_CALL_IS_BOT, false),
        )

        val forwardData = mapOf(
            "id" to data.getString(IncomingCallConstants.EXTRA_CALL_ID, ""),
            "callerName" to data.getString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, ""),
            "avatar" to data.getString(IncomingCallConstants.EXTRA_CALL_AVATAR, ""),
            "number" to data.getString(IncomingCallConstants.EXTRA_CALL_HANDLE, ""),
            "type" to data.getInt(IncomingCallConstants.EXTRA_CALL_TYPE, 0),
            "duration" to data.getLong(IncomingCallConstants.EXTRA_CALL_DURATION, 0L),
            "extra" to data.getSerializable(IncomingCallConstants.EXTRA_CALL_EXTRA),
            "android" to android
        )
        
        StreamVideoPushNotificationPlugin.sendEvent(event, forwardData)
    }
}