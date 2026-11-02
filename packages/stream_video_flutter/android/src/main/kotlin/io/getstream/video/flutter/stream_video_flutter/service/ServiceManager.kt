package io.getstream.video.flutter.stream_video_flutter.service

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationPayload

enum class ServiceType {
    call,
    screenSharing
}

/**
 * Which Android service hosts a call of [ServiceType.call], and so which foreground service
 * types it requests. Mirrors `AndroidCallServiceKind` on the Dart side.
 */
enum class CallServiceKind {
    /** A voice or video call, hosted by [StreamCallService]. */
    call,

    /** A livestream viewer, hosted by [StreamLivestreamViewerService]. */
    livestreamViewer,
}

interface ServiceManager {
    fun start(
        callCid: String,
        payload: NotificationPayload,
        type: ServiceType = ServiceType.call,
        kind: CallServiceKind = CallServiceKind.call,
    ): Boolean

    fun update(callCid: String, payload: NotificationPayload, type: ServiceType = ServiceType.call): Boolean
    fun stop(callCid: String?, type: ServiceType = ServiceType.call): Boolean
    fun isRunning(callCid: String?, type: ServiceType): Boolean
}

private data class ActiveService(val type: ServiceType, val kind: CallServiceKind)

class ServiceManagerImpl(
    private val appContext: Context
): ServiceManager {

    private val logger by taggedLogger(tag = "StreamServiceManager")

    // The service class a call was started in is remembered here, so an update or a stop
    // reaches the same one.
    private val activeServices = mutableMapOf<String, ActiveService>()

    /**
     * Forgets calls whose service ended them on its own, such as a `shortService` the system
     * timed out.
     *
     * Without this the call would read as running forever: updates would keep being sent, and
     * each would recreate a service that is not in the foreground. A call that was only just
     * started is not affected, since it is not recorded as ended until its service lets go of it.
     */
    private fun pruneEndedCalls() {
        StreamCallService.drainEndedCallCids().forEach { callCid ->
            if (activeServices.remove("$callCid-${ServiceType.call}") != null) {
                logger.w { "[pruneEndedCalls] The service for callCid: $callCid ended without being stopped. It no longer runs in the foreground." }
            }
        }
    }

    private fun serviceClass(type: ServiceType, kind: CallServiceKind): Class<out android.app.Service> =
        when (type) {
            ServiceType.call -> when (kind) {
                CallServiceKind.call -> StreamCallService::class.java
                CallServiceKind.livestreamViewer -> StreamLivestreamViewerService::class.java
            }
            ServiceType.screenSharing -> StreamScreenShareService::class.java
        }

    /**
     * Start the foreground service.
     */
    override fun start(
        callCid: String,
        payload: NotificationPayload,
        type: ServiceType,
        kind: CallServiceKind,
    ): Boolean {
        logger.d { "[start] callCid: $callCid, type: $type, kind: $kind, payload: $payload" }
        pruneEndedCalls()
        val serviceKey = "$callCid-$type"

        if (activeServices.containsKey(serviceKey)) {
            if (type == ServiceType.screenSharing && !StreamScreenShareService.isServiceRunning(callCid)) {
                logger.w { "[start] Service for callCid: $callCid was in activeServices but not in foreground mode. Retrying." }
                activeServices.remove(serviceKey)
            } else {
                logger.w { "[start] Service for callCid: $callCid, type: $type already running." }
                return true
            }
        }
        try {
            var startedKind = kind
            var component = startService(callCid, payload, type, kind)

            // An app without a viewer mode may remove the viewer service from its manifest, and
            // starting an undeclared service returns null rather than throwing. The call still
            // needs a foreground service, so it runs in the call service.
            if (component == null && type == ServiceType.call && kind == CallServiceKind.livestreamViewer) {
                logger.w { "[start] StreamLivestreamViewerService is not declared in the manifest. Starting callCid: $callCid in StreamCallService instead." }
                startedKind = CallServiceKind.call
                component = startService(callCid, payload, type, startedKind)
            }

            if (component == null) {
                logger.e { "[start] Service for callCid: $callCid, type: $type, kind: $startedKind is not declared in the manifest." }
                return false
            }

            activeServices[serviceKey] = ActiveService(type, startedKind)
        } catch (e: Exception) {
            logger.e(e) { "[start] Failed for callCid: $callCid, type: $type, kind: $kind" }
            return false
        }

        return true
    }

    /** Starts the service hosting the call, returning null when it is not in the manifest. */
    private fun startService(
        callCid: String,
        payload: NotificationPayload,
        type: ServiceType,
        kind: CallServiceKind,
    ): ComponentName? {
        val nIntent = Intent(appContext, serviceClass(type, kind)).apply {
            putExtra("callCid", callCid)
            putExtra("notificationPayload", payload)
        }

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            appContext.startForegroundService(nIntent)
        } else {
            appContext.startService(nIntent)
        }
    }

    override fun update(callCid: String, payload: NotificationPayload, type: ServiceType): Boolean {
        logger.d { "[update] callCid: $callCid, type: $type, payload: $payload" }
        pruneEndedCalls()

        val serviceKey = "$callCid-$type"
        val active = activeServices[serviceKey]
        if (active == null) {
            logger.w { "[update] Service for callCid: $callCid, type: $type not running. Cannot update." }
            return false
        }

        try {
            val intentAction = when(type) {
                ServiceType.call -> StreamCallService.ACTION_UPDATE
                ServiceType.screenSharing -> StreamScreenShareService.ACTION_UPDATE
            }
            val nIntent = Intent(appContext, serviceClass(type, active.kind)).apply {
                action = intentAction
                putExtra("callCid", callCid)
                if (type == ServiceType.call) putExtra("type", type.name)
                putExtra("notificationPayload", payload)
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
        pruneEndedCalls()

        val actualCallCid = if (callCid != null) {
            callCid
        } else {
            // Find services of the specified type
            val servicesOfType = activeServices.filter { it.value.type == type }
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
            val kind = wasActive?.kind ?: CallServiceKind.call
            val nIntent = Intent(appContext, serviceClass(type, kind)).apply {
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
        pruneEndedCalls()
        val actualCallCid = if (callCid != null) {
            callCid
        } else {
            // Find services of the specified type
            val servicesOfType = activeServices.filter { it.value.type == type }
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
        val inActiveServices = activeServices.containsKey(serviceKey)

        val running = if (type == ServiceType.screenSharing) {
            inActiveServices && StreamScreenShareService.isServiceRunning(actualCallCid)
        } else {
            inActiveServices
        }

        logger.d { "[isRunning] callCid: $actualCallCid, type: $type. Result: $running" }
        return running
    }
}
