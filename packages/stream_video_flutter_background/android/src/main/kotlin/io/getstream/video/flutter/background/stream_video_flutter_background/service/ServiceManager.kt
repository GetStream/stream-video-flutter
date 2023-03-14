package io.getstream.video.flutter.background.stream_video_flutter_background.service

import android.content.Context
import android.content.Intent
import android.os.Build
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationOptions

interface ServiceManager {
    fun start(options: NotificationOptions): Boolean
    fun update(options: NotificationOptions): Boolean
    fun stop(): Boolean
}

class ServiceManagerImpl(
    private val appContext: Context
): ServiceManager {

    private val logger by taggedLogger(tag = "StreamServiceManager")

    /**
     * Start the foreground service.
     */
    override fun start(options: NotificationOptions): Boolean {
        logger.d { "[start] options: $options" }
        StreamCallService.notificationOptions = options
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

    override fun update(options: NotificationOptions): Boolean {
        logger.d { "[update] options: $options" }
        StreamCallService.notificationOptions = options
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