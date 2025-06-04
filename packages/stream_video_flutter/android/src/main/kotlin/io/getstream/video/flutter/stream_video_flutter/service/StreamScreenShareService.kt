package io.getstream.video.flutter.stream_video_flutter.service

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
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

/**
 * Screen-sharing in Android requires a ForegroundService (with type foregroundServiceType set to "mediaProjection").
 * The Stream SDK will start this [StreamScreenShareService] once screen-sharing is enabled and then
 * will stop it when screen-sharing it's either stopped by the user or we get a callback that the
 * screen-sharing was stopped by the system.
 *
 * This Service isn't doing any long-running operations. It's just an empty Service to meet the platform
 * requirement (https://developer.android.com/reference/android/media/projection/MediaProjectionManager).
 */

private data class ActiveScreenShareData(
    val callCid: String, 
    var notificationPayload: NotificationPayload,
    val notificationId: Int
)

internal class StreamScreenShareService : Service() {
    private val logger by taggedLogger("StreamScreenShareService")
    private val scope = CoroutineScope(Dispatchers.Default)
    private val notificationManager: NotificationManager by lazy { application.notificationManager }
    private lateinit var notificationBuilder: StreamNotificationBuilder

    // Map to store active screen shares: Key = callCid (of the associated call), Value = ActiveScreenShareData
    private val activeScreenShares = mutableMapOf<String, ActiveScreenShareData>()

    private fun generateNotificationId(callCid: String): Int {
        // Using a different salt for hash to avoid collision with StreamCallService
        val id = (callCid + "_screenshare").hashCode()
        return if (id == Int.MIN_VALUE) Int.MAX_VALUE else kotlin.math.abs(id)
    }

    private fun createNotificationBuilder(context: Context): StreamNotificationBuilder =
            StreamNotificationBuilderImpl(context, scope, ServiceType.screenSharing, { callCid -> generateNotificationId(callCid) }) {
                logger.i { "[onNotificationUpdated by Builder] notification: $it. This callback might be redundant." }
            }

    override fun onCreate() {
        super.onCreate()
        logger.i { "[onCreate] Service instance created." }
        notificationBuilder = createNotificationBuilder(applicationContext)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        logger.i { "[onStartCommand] startId: $startId, action: ${intent?.action}" }

        intent?.let { L_INTENT ->
            val callCidFromIntent = L_INTENT.getStringExtra("callCid")

            when (L_INTENT.action) {
                ACTION_STOP_SPECIFIC_CALL -> {
                    if (callCidFromIntent != null) {
                        stopScreenShare(callCidFromIntent, startId)
                    } else {
                        logger.w { "[onStartCommand] ACTION_STOP_SPECIFIC_CALL for screen share received without callCid." }
                    }
                }
                ACTION_UPDATE -> {
                    val payload = getPayloadFromIntent(L_INTENT)
                    if (payload != null && payload.callCid.isNotBlank()) {
                        updateScreenShareNotification(payload.callCid, payload)
                    } else {
                        logger.w { "[onStartCommand] ACTION_UPDATE for screen share: callCid from payload is blank or payload is null. Payload: $payload" }
                        if(callCidFromIntent != null && payload != null) { 
                             updateScreenShareNotification(callCidFromIntent, payload.copy(callCid = callCidFromIntent))
                             logger.i {"[onStartCommand] ACTION_UPDATE screen share: Used callCidFromIntent as fallback."}
                        } else {
                             logger.e { "[onStartCommand] ACTION_UPDATE screen share: Cannot proceed with update due to missing callCid/payload."}
                        }
                    }
                }
                else -> { 
                    val payload = getPayloadFromIntent(L_INTENT)
                    val callCid = callCidFromIntent ?: payload?.callCid

                    if (callCid != null && callCid.isNotBlank() && payload != null) {
                        startNewScreenShare(callCid, payload, startId)
                    } else {
                        logger.e { "[onStartCommand] New screen share: callCid or payload is missing/invalid. CID from Intent: $callCidFromIntent, Payload: $payload" }
                    }
                }
            }
        } ?: run {
            logger.w { "[onStartCommand] Intent is null for screen share service. System restart?" }
            if (activeScreenShares.isEmpty()) {
                stopSelfResult(startId)
            }
        }
        return START_STICKY
    }

    private fun getPayloadFromIntent(intent: Intent): NotificationPayload? {
        @Suppress("DEPRECATION")
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra("notificationPayload", NotificationPayload::class.java)
        } else {
            intent.getParcelableExtra("notificationPayload")
        }
    }

    private fun startNewScreenShare(callCid: String, payload: NotificationPayload, startId: Int) {
        logger.i { "[startNewScreenShare] for callCid: $callCid, existing shares: ${activeScreenShares.size}" }
        if (activeScreenShares.containsKey(callCid)) {
            logger.w { "[startNewScreenShare] Screen share for callCid: $callCid already active. Updating." }
            updateScreenShareNotification(callCid, payload)
            return
        }

        val notificationId = generateNotificationId(callCid)
        val screenShareData = ActiveScreenShareData(callCid, payload, notificationId)
        activeScreenShares[callCid] = screenShareData

        val (builtNotificationId, notification) = notificationBuilder.build(payload)

        if (activeScreenShares.size == 1) {
            try {
                super.startForeground(notificationId, notification)
                logger.i { "[startNewScreenShare] Service started in foreground for screen share (callCid: $callCid), notificationId: $notificationId" }
            } catch (e: Exception) {
                logger.e(e) { "[startNewScreenShare] Exception starting foreground for screen share $callCid. Error: ${e.message}" }
                activeScreenShares.remove(callCid)
            }
        } else {
            notificationManager.notify(notificationId, notification)
            logger.i { "[startNewScreenShare] Additional screen share notification for callCid: $callCid, notificationId: $notificationId" }
        }
    }

    private fun updateScreenShareNotification(callCid: String, newPayload: NotificationPayload) {
        activeScreenShares[callCid]?.let {
            logger.i { "[updateScreenShareNotification] Updating screen share for callCid: $callCid" }
            it.notificationPayload = newPayload
            val (builtNotificationId, notification) = notificationBuilder.build(newPayload)
            notificationManager.notify(it.notificationId, notification)
        } ?: logger.w { "[updateScreenShareNotification] No active screen share for cid: $callCid to update." }
    }

    private fun stopScreenShare(callCid: String, startId: Int) {
        logger.i { "[stopScreenShare] Attempting to stop screen share for callCid: $callCid. Active shares: ${activeScreenShares.size}" }
        val screenShareData = activeScreenShares.remove(callCid)
        if (screenShareData != null) {
            notificationManager.cancel(screenShareData.notificationId)
            logger.i { "[stopScreenShare] Cancelled notification and removed screen share for callCid: $callCid. Remaining: ${activeScreenShares.size}" }
        } else {
            logger.w { "[stopScreenShare] No active screen share for cid: $callCid to stop." }
        }

        if (activeScreenShares.isEmpty()) {
            logger.i { "[stopScreenShare] No active screen shares. Stopping service (stopSelfResult for startId: $startId)." }
            stopSelfResult(startId)
        } else {
            logger.i { "[stopScreenShare] Active screen shares remaining: ${activeScreenShares.size}. Service continues." }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        logger.i { "[onDestroy] Service destroying. Clearing ${activeScreenShares.size} screen shares and notifications." }
        activeScreenShares.values.forEach { data ->
            notificationManager.cancel(data.notificationId)
        }
        activeScreenShares.clear()
        scope.cancel()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        logger.i { "[onTaskRemoved] Task removed. Stopping all screen shares and self." }
        val currentScreenShareCids = activeScreenShares.keys.toList() 
        currentScreenShareCids.forEach { cid ->
             val data = activeScreenShares.remove(cid)
             if (data != null) {
                notificationManager.cancel(data.notificationId)
             }
        }
        if (activeScreenShares.isEmpty()) {
             stopForeground(STOP_FOREGROUND_REMOVE) 
             stopSelf()
        }
    }
    
    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        internal const val ACTION_UPDATE = "UPDATE"
        internal const val ACTION_STOP_SPECIFIC_CALL = "STOP_SPECIFIC_CALL" 
    }
}