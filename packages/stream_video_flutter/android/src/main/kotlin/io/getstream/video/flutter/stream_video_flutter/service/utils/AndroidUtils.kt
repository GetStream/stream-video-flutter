package io.getstream.video.flutter.stream_video_flutter.service.utils

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.RECEIVER_NOT_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import androidx.annotation.RequiresApi
import io.getstream.video.flutter.stream_video_flutter.service.notification.IdentifiedNotification
import io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationAction
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.buffer
import kotlinx.coroutines.flow.callbackFlow

internal val Context.notificationManager: NotificationManager
    get() = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

internal val Context.applicationName: String get() {
    return try {
        val stringResId = applicationInfo.labelRes
        if (stringResId == 0) applicationInfo.nonLocalizedLabel.toString() else getString(stringResId)
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

        val intentFilter =  IntentFilter().apply {
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