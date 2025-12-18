package io.getstream.video.flutter.stream_video_flutter.service.utils

import android.app.Notification
import android.app.NotificationManager
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.RECEIVER_NOT_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.os.Build
import android.util.Log
import androidx.core.app.ServiceCompat
import io.getstream.video.flutter.stream_video_flutter.service.StreamCallService.Companion.TRIGGER_INCOMING_CALL
import io.getstream.video.flutter.stream_video_flutter.service.StreamCallService.Companion.TRIGGER_ONGOING_CALL
import io.getstream.video.flutter.stream_video_flutter.service.StreamCallService.Companion.TRIGGER_OUTGOING_CALL
import io.getstream.video.flutter.stream_video_flutter.service.StreamScreenShareService.Companion.TRIGGER_SHARE_SCREEN
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.buffer
import kotlinx.coroutines.flow.callbackFlow

internal val Context.notificationManager: NotificationManager
    get() = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

internal val Context.applicationName: String
    get() {
        return try {
            val stringResId = applicationInfo.labelRes
            if (stringResId == 0) applicationInfo.nonLocalizedLabel.toString() else getString(
                stringResId
            )
        } catch (e: Throwable) {
            "Unknown"
        }
    }

@OptIn(ExperimentalCoroutinesApi::class)
internal fun Context.registerReceiverAsFlow(vararg actions: String): Flow<Intent> {
    return callbackFlow {
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                trySendBlocking(intent)
            }
        }

        val intentFilter = IntentFilter().apply {
            actions.forEach {
                addAction(it)
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(
                receiver,
                intentFilter,
                RECEIVER_NOT_EXPORTED
            )
        } else {
            registerReceiver(
                receiver,
                intentFilter
            )
        }

        awaitClose {
            unregisterReceiver(receiver)
        }
    }.buffer(capacity = Channel.UNLIMITED)
}


/**
 * Start a foreground service with a service type to meet requirements introduced in Android 14.
 *
 * @param notificationId The notification ID
 * @param notification The notification to show
 * @param trigger The trigger that started the service: [TRIGGER_ONGOING_CALL], [TRIGGER_OUTGOING_CALL], [TRIGGER_INCOMING_CALL], [TRIGGER_SHARE_SCREEN]
 */
internal fun Service.startForegroundWithServiceType(
    notificationId: Int,
    notification: Notification,
    trigger: String,
    foregroundServiceType: Int?,
) {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
        startForeground(notificationId, notification)
        Log.d(
            "AndroidUtils",
            "[startForegroundWithServiceType] 1 startForeground notificationId: $notificationId",
        )
    } else {
        val serviceType = foregroundServiceType ?: ServiceInfo.FOREGROUND_SERVICE_TYPE_PHONE_CALL
        ServiceCompat.startForeground(
            this,
            notificationId,
            notification,
            when (trigger) {
                TRIGGER_ONGOING_CALL -> serviceType
                TRIGGER_OUTGOING_CALL, TRIGGER_INCOMING_CALL -> serviceType
                TRIGGER_SHARE_SCREEN -> ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION
                else -> serviceType
            },
        )
        Log.d(
            "AndroidUtils",
            "[startForegroundWithServiceType] 2 startForeground notificationId: $notificationId",
        )
    }
}