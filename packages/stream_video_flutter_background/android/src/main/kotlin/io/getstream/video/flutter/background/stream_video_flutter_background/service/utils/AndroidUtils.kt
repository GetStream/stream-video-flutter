package io.getstream.video.flutter.background.stream_video_flutter_background.service.utils

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.Context.RECEIVER_NOT_EXPORTED
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

@RequiresApi(Build.VERSION_CODES.O)
@OptIn(ExperimentalCoroutinesApi::class)
internal fun Context.registerReceiverAsFlow(vararg actions: String): Flow<Intent> {
    return callbackFlow {
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                trySendBlocking(intent)
            }
        }
        registerReceiver(
            receiver,
            IntentFilter().apply {
                actions.forEach {
                    addAction(it)
                }
            },
            RECEIVER_NOT_EXPORTED
        )

        awaitClose {
            unregisterReceiver(receiver)
        }
    }.buffer(capacity = Channel.UNLIMITED)
}