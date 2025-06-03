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
    fun stop(callCid: String?, type: ServiceType = ServiceType.call): Boolean
    fun isRunning(callCid: String?, type: ServiceType): Boolean
}

class ServiceManagerImpl(
    private val appContext: Context
): ServiceManager {

    private val logger by taggedLogger(tag = "StreamServiceManager")
    private val activeServices = mutableMapOf<String, ServiceType>()

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
                    putExtra("type", type.name)
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
    override fun stop(callCid: String?, type: ServiceType): Boolean {
        logger.d { "[stop] callCid: $callCid, type: $type" }
        
        val actualCallCid = if (callCid != null) {
            callCid
        } else {
            // Find services of the specified type
            val servicesOfType = activeServices.filter { it.value == type }
            when (servicesOfType.size) {
                0 -> {
                    logger.w { "[stop] No services of type $type are running. Cannot stop." }
                    return false
                }
                1 -> {
                    // Extract callCid from the service key (format: "callCid-type")
                    val serviceKey = servicesOfType.keys.first()
                    serviceKey.substringBeforeLast("-$type")
                }
                else -> {
                    throw IllegalStateException("Multiple services of type $type are running. CallCid is required to specify which one to stop.")
                }
            }
        }
        
        val serviceKey = "$actualCallCid-$type"

        val wasActive = activeServices.remove(serviceKey)
        if (wasActive == null) {
            logger.w { "[stop] Service for callCid: $actualCallCid, type: $type was not in activeServices map. Still sending stop command." }
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
                putExtra("callCid", actualCallCid)
            }

            appContext.startService(nIntent)

        } catch (e: Exception) {
            logger.e(e) { "[stop] Failed to send stop command for callCid: $actualCallCid, type: $type. It was removed from activeServices map." }
            return false
        }
        return true
    }

    override fun isRunning(callCid: String?, type: ServiceType): Boolean {
        val actualCallCid = if (callCid != null) {
            callCid
        } else {
            // Find services of the specified type
            val servicesOfType = activeServices.filter { it.value == type }
            when (servicesOfType.size) {
                0 -> {
                    logger.d { "[isRunning] No services of type $type are running. Result: false" }
                    return false
                }
                1 -> {
                    // Extract callCid from the service key (format: "callCid-type")
                    val serviceKey = servicesOfType.keys.first()
                    serviceKey.substringBeforeLast("-$type")
                }
                else -> {
                    throw IllegalStateException("Multiple services of type $type are running. CallCid is required to specify which one to check.")
                }
            }
        }
        
        val serviceKey = "$actualCallCid-$type"
        val running = activeServices.containsKey(serviceKey)
        logger.d { "[isRunning] callCid: $actualCallCid, type: $type. Result: $running" }
        return running
    }
}