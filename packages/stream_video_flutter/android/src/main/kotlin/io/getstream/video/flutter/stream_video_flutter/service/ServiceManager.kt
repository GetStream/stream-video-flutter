package io.getstream.video.flutter.stream_video_flutter.service

import android.content.Context
import android.content.Intent
import android.os.Build
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationPayload

enum class ServiceType {
    call,
    screenSharing
}

interface ServiceManager {
    fun start(payload: NotificationPayload, type: ServiceType = ServiceType.call): Boolean
    fun update(payload: NotificationPayload, type: ServiceType = ServiceType.call): Boolean
    fun stop(type: ServiceType = ServiceType.call): Boolean

}

class ServiceManagerImpl(
    private val appContext: Context
): ServiceManager {

    private val logger by taggedLogger(tag = "StreamServiceManager")

    /**
     * Start the foreground service.
     */
    override fun start(payload: NotificationPayload, type: ServiceType): Boolean {
        logger.d { "[start] type: $type, payload: $payload" }
        if(type == ServiceType.call) {
            StreamCallService.notificationPayload = payload
        } else {
            StreamScreenShareService.notificationPayload = payload
        }
        try {
            val nIntent = when(type){
                ServiceType.call -> Intent(appContext, StreamCallService::class.java)
                ServiceType.screenSharing -> Intent(appContext, StreamScreenShareService::class.java)
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

    override fun update(payload: NotificationPayload, type: ServiceType): Boolean {
        logger.d { "[update] type: $type, payload: $payload" }

        if(type == ServiceType.call) {
            StreamCallService.notificationPayload = payload
        } else {
            StreamScreenShareService.notificationPayload = payload
        }

        try {
            val nIntent = when(type){
                ServiceType.call -> Intent(appContext, StreamCallService::class.java).apply {
                    action = StreamCallService.ACTION_UPDATE
                }
                ServiceType.screenSharing -> Intent(appContext, StreamScreenShareService::class.java).apply {
                    action = StreamScreenShareService.ACTION_UPDATE
                }
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
     * Stop the foreground service.
     */
    override fun stop(type: ServiceType): Boolean {
        logger.d { "[stop] type: $type" }
        try {
            val nIntent = when(type){
                ServiceType.call -> Intent(appContext, StreamCallService::class.java)
                ServiceType.screenSharing -> Intent(appContext, StreamScreenShareService::class.java)
            }

            appContext.stopService(nIntent)
        } catch (e: Exception) {
            return false
        }

        return true
    }

}