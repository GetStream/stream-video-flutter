package io.getstream.video.flutter.background.stream_video_flutter_background.service

import android.content.Context
import android.content.Intent
import android.os.Build
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationPayload

interface ServiceManager {
    fun start(payload: NotificationPayload): Boolean
    fun update(payload: NotificationPayload): Boolean
    fun stop(): Boolean
}

class ServiceManagerImpl(
    private val appContext: Context
): ServiceManager {

    private val logger by taggedLogger(tag = "StreamServiceManager")

    /**
     * Start the foreground service.
     */
    override fun start(payload: NotificationPayload): Boolean {
        logger.d { "[start] payload: $payload" }
        StreamCallService.notificationPayload = payload
        try {
            val nIntent = Intent(appContext, StreamCallService::class.java)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                appContext.startForegroundService(nIntent)
            } else {
                appContext.startService(nIntent)
            }
        } catch (e: Exception) {
            return false
        }

        return true
    }

    override fun update(payload: NotificationPayload): Boolean {
        logger.d { "[update] payload: $payload" }
        StreamCallService.notificationPayload = payload
        try {
            val nIntent = Intent(appContext, StreamCallService::class.java).apply {
                action = StreamCallService.ACTION_UPDATE
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                appContext.startForegroundService(nIntent)
            } else {
                appContext.startService(nIntent)
            }
        } catch (e: Exception) {
            return false
        }

        return true
    }

    /**
     * Start the foreground service.
     */
    override fun stop(): Boolean {
        logger.d { "[stop] no args" }
        try {
            val nIntent = Intent(appContext, StreamCallService::class.java)
            appContext.stopService(nIntent)
        } catch (e: Exception) {
            return false
        }

        return true
    }

}