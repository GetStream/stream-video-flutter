package io.getstream.video.flutter.stream_video_flutter.service

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.stream_video_flutter.R
import io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationPayload
import io.getstream.video.flutter.stream_video_flutter.service.notification.StreamNotificationBuilder
import io.getstream.video.flutter.stream_video_flutter.service.notification.StreamNotificationBuilderImpl
import io.getstream.video.flutter.stream_video_flutter.service.utils.notificationManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel

open class StreamCallService : Service() {

    private val logger by taggedLogger("StreamCallService")

    private val scope = CoroutineScope(Dispatchers.Default)

    private val notificationManager: NotificationManager by lazy { application.notificationManager }

    private val notificationBuilder: StreamNotificationBuilder by lazy {
        createNotificationBuilder(application)
    }

    private val payload: NotificationPayload
        get() {
            val payload = notificationPayload
            if (payload.callCid.isEmpty()) {
                error("[StreamCallService.callCid] NotificationPayload.callCid must not be empty")
            }
            return payload
        }

    private val getNotificationId = { R.id.stream_call_notification }

    protected open fun createNotificationBuilder(context: Context): StreamNotificationBuilder =
        StreamNotificationBuilderImpl(context, scope, getNotificationId) {
            logger.i { "[onNotificationUpdated] notification: $it" }
            notificationManager.notify(it.id, it.notification)
        }

    override fun onCreate() {
        super.onCreate()
        isRunning = true

        logger.i { "[onCreate] no args" }
        startForeground()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        logger.i { "[onStartCommand] startId: $startId, flags: $flags, action: ${intent?.action}, intent: $intent" }
        if (intent?.action == ACTION_UPDATE) {
            updateNotification()
        }
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        stopForeground(true)
        logger.i { "[onDestroy] no args" }
        scope.cancel()
        isRunning = false
        notificationPayload = NotificationPayload()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun startForeground() {
        logger.v { "[startForeground] notificationPayload: $payload" }
        val (notificationId, notification) = notificationBuilder.build(payload)
        startForeground(notificationId, notification)
    }

    private fun updateNotification() {
        logger.v { "[updateNotification] notificationPayload: $payload" }
        val (notificationId, notification) = notificationBuilder.build(payload)
        notificationManager.notify(notificationId, notification)
    }

    companion object {
        var isRunning = false

        var notificationPayload = NotificationPayload()

        internal const val ACTION_UPDATE = "UPDATE"
    }
}


