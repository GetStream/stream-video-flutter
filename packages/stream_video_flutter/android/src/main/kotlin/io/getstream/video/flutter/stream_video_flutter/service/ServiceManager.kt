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
    fun start(callCid: String, payload: NotificationPayload, type: ServiceType = ServiceType.call): Boolean
    fun update(callCid: String, payload: NotificationPayload, type: ServiceType = ServiceType.call): Boolean
    fun stop(callCid: String, type: ServiceType = ServiceType.call): Boolean
    fun isRunning(callCid: String, type: ServiceType): Boolean
}

class ServiceManagerImpl(
    private val appContext: Context
): ServiceManager {

    private val logger by taggedLogger(tag = "StreamServiceManager")
    private val activeServices = mutableMapOf<String, ServiceType>() // Key: callCid, Value: ServiceType

    /**
     * Start the foreground service.
     */
    override fun start(callCid: String, payload: NotificationPayload, type: ServiceType): Boolean {
        logger.d { "[start] callCid: $callCid, type: $type, payload: $payload" }
        val serviceKey = "$callCid-$type"
        
        if (activeServices.containsKey(serviceKey)) {
            logger.w { "[start] Service for callCid: $callCid, type: $type already running." }
            return true
        }
        try {
            val nIntent = when(type){
                ServiceType.call -> Intent(appContext, StreamCallService::class.java)
                ServiceType.screenSharing -> Intent(appContext, StreamScreenShareService::class.java)
            }.apply {
                putExtra("callCid", callCid)
                putExtra("notificationPayload", payload)
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                appContext.startForegroundService(nIntent)
            } else {
                appContext.startService(nIntent)
            }

            activeServices[serviceKey] = type
        } catch (e: Exception) {
            logger.e(e) { "[start] Failed for callCid: $callCid, type: $type" }
            return false
        }

        return true
    }

    override fun update(callCid: String, payload: NotificationPayload, type: ServiceType): Boolean {
        logger.d { "[update] callCid: $callCid, type: $type, payload: $payload" }

        val serviceKey = "$callCid-$type"
        if (!activeServices.containsKey(serviceKey)) {
            logger.w { "[update] Service for callCid: $callCid, type: $type not running. Cannot update." }
            return false
        }

        try {
            val intentAction = when(type) {
                ServiceType.call -> StreamCallService.ACTION_UPDATE
                ServiceType.screenSharing -> StreamScreenShareService.ACTION_UPDATE
            }
            val nIntent = when(type){
                ServiceType.call -> Intent(appContext, StreamCallService::class.java).apply {
                    action = intentAction
                    putExtra("callCid", callCid)
                    putExtra("notificationPayload", payload)
                }
                ServiceType.screenSharing -> Intent(appContext, StreamScreenShareService::class.java).apply {
                    action = intentAction
                    putExtra("callCid", callCid)
                    putExtra("notificationPayload", payload)
                }
            }

            appContext.startService(nIntent)
        } catch (e: Exception) {
            logger.e(e) { "[update] Failed for callCid: $callCid, type: $type" }
            return false
        }

        return true
    }

    /**
     * Stop the foreground service.
     */
    override fun stop(callCid: String, type: ServiceType): Boolean {
        logger.d { "[stop] callCid: $callCid, type: $type" }
        val serviceKey = "$callCid-$type"

        val wasActive = activeServices.remove(serviceKey)
        if (wasActive == null) {
            logger.w { "[stop] Service for callCid: $callCid, type: $type was not in activeServices map. Still sending stop command." }
        }

        try {
            val intentAction = when(type) {
                ServiceType.call -> StreamCallService.ACTION_STOP_SPECIFIC_CALL
                ServiceType.screenSharing -> StreamScreenShareService.ACTION_STOP_SPECIFIC_CALL
            }
            val nIntent = when(type){
                ServiceType.call -> Intent(appContext, StreamCallService::class.java)
                ServiceType.screenSharing -> Intent(appContext, StreamScreenShareService::class.java)
            }.apply {
                action = intentAction
                putExtra("callCid", callCid)
            }

            appContext.startService(nIntent)

        } catch (e: Exception) {
            logger.e(e) { "[stop] Failed to send stop command for callCid: $callCid, type: $type. It was removed from activeServices map." }
            return false
        }
        return true
    }

    override fun isRunning(callCid: String, type: ServiceType): Boolean {
        val serviceKey = "$callCid-$type"
        val running = activeServices.containsKey(serviceKey)
        logger.d { "[isRunning] callCid: $callCid, type: $type. Result: $running" }
        return running
    }
}