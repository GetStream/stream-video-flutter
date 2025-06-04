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

// Data class to hold information about each active call managed by the service
private data class ActiveCallData(
    val callCid: String,
    var notificationPayload: NotificationPayload,
    val notificationId: Int
)

open class StreamCallService : Service() {

    private val logger by taggedLogger("StreamCallService")
    private val scope = CoroutineScope(Dispatchers.Default)
    private val notificationManager: NotificationManager by lazy { application.notificationManager }
    private lateinit var notificationBuilder: StreamNotificationBuilder

    // Map to store active calls: Key = callCid, Value = ActiveCallData
    private val activeCalls = mutableMapOf<String, ActiveCallData>()

    private fun generateNotificationId(callCid: String): Int {
        // Generate a unique notification ID. Ensure it's positive.
        val id = callCid.hashCode()
        return if (id == Int.MIN_VALUE) Int.MAX_VALUE else kotlin.math.abs(id) 
    }
    
    protected open fun createNotificationBuilder(context: Context): StreamNotificationBuilder =
        StreamNotificationBuilderImpl(context, scope, ServiceType.call, { callCid -> generateNotificationId(callCid) }) {
            logger.i { "[onNotificationUpdated by Builder] notification: $it. This callback might be redundant if service manages all notify calls." }
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
            
            if (callCidFromIntent == null && L_INTENT.action != ACTION_UPDATE && L_INTENT.action != ACTION_STOP_SPECIFIC_CALL) {
                 logger.e { "[onStartCommand] callCid is null in intent for a new call. Invalid state."}
                 return START_NOT_STICKY
            }

            when (L_INTENT.action) {
                ACTION_STOP_SPECIFIC_CALL -> {
                    if (callCidFromIntent != null) {
                        stopCall(callCidFromIntent, startId)
                    } else {
                        logger.w { "[onStartCommand] ACTION_STOP_SPECIFIC_CALL received without callCid. Cannot stop." }
                    }
                }
                ACTION_UPDATE -> {
                    val payload = getPayloadFromIntent(L_INTENT)
                    if (payload != null && payload.callCid.isNotBlank()) {
                        updateCallNotification(payload.callCid, payload)
                    } else {
                        logger.w { "[onStartCommand] ACTION_UPDATE: callCid from payload is blank or payload is null. Cannot update. Payload: $payload" }
                        if(callCidFromIntent != null && payload != null) {
                             updateCallNotification(callCidFromIntent, payload.copy(callCid = callCidFromIntent))
                             logger.i {"[onStartCommand] ACTION_UPDATE: Used callCidFromIntent as fallback."}
                        } else {
                             logger.e { "[onStartCommand] ACTION_UPDATE: Cannot proceed with update due to missing callCid/payload."}
                        }
                    }
                }
                else -> { // New call or service restart
                    val payload = getPayloadFromIntent(L_INTENT)
                    val callCid = callCidFromIntent ?: payload?.callCid
                    
                    if (callCid != null && callCid.isNotBlank() && payload != null) {
                        startNewCall(callCid, payload, startId)
                    } else {
                        logger.e { "[onStartCommand] New call: callCid or payload is missing/invalid. Cannot start. CID from Intent: $callCidFromIntent, Payload: $payload" }
                    }
                }
            }
        } ?: run {
            logger.w { "[onStartCommand] Intent is null. Service may be restarting. If activeCalls is not empty, try to revive notifications." }
            if (activeCalls.isEmpty()) {
                stopSelfResult(startId)
            }
        }
        
        return START_STICKY
    }
    
    private fun getPayloadFromIntent(intent: Intent): NotificationPayload? {
        @Suppress("DEPRECATION")
        val payload = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra("notificationPayload", NotificationPayload::class.java)
        } else {
            intent.getParcelableExtra("notificationPayload")
        }
        
        return payload
    }

    private fun startNewCall(callCid: String, payload: NotificationPayload, startId: Int) {
        logger.i { "[startNewCall] callCid: $callCid, existing active calls: ${activeCalls.size}" }
        
        if (activeCalls.containsKey(callCid)) {
            logger.w { "[startNewCall] Call with cid: $callCid already active. Updating instead." }
            updateCallNotification(callCid, payload)
            return
        }

        val notificationId = generateNotificationId(callCid)
        val callData = ActiveCallData(callCid, payload, notificationId)

        activeCalls[callCid] = callData

        val (builtNotificationIdFromBuilder, notification) = notificationBuilder.build(payload)

        if (activeCalls.size == 1) {
            try {
                super.startForeground(notificationId, notification)
                logger.i { "[startNewCall] Service started in foreground for callCid: $callCid, notificationId: $notificationId" }
            } catch (e: Exception) {
                logger.e(e) { "[startNewCall] Exception starting foreground for $callCid. Error: ${e.message}" }
                activeCalls.remove(callCid)
            }
        } else {
            notificationManager.notify(notificationId, notification)
            logger.i { "[startNewCall] Additional call notification shown for callCid: $callCid, notificationId: $notificationId" }
        }
    }

    private fun updateCallNotification(callCid: String, newPayload: NotificationPayload) {
        activeCalls[callCid]?.let {
            logger.i { "[updateCallNotification] Updating callCid: $callCid" }
            it.notificationPayload = newPayload

            val (builtNotificationId, notification) = notificationBuilder.build(newPayload)
            notificationManager.notify(it.notificationId, notification)
        } ?: run {
            logger.w { "[updateCallNotification] No active call found for cid: $callCid to update." }
        }
    }

    private fun stopCall(callCid: String, startId: Int) {
        logger.i { "[stopCall] Attempting to stop callCid: $callCid. Active calls before stop: ${activeCalls.size}" }
        val callData = activeCalls.remove(callCid)
        if (callData != null) {
            notificationManager.cancel(callData.notificationId)
            logger.i { "[stopCall] Cancelled notification and removed callCid: $callCid. Remaining calls: ${activeCalls.size}" }
        } else {
            logger.w { "[stopCall] No active call found for cid: $callCid to stop." }
        }

        if (activeCalls.isEmpty()) {
            logger.i { "[stopCall] No active calls remaining. Stopping service (stopSelfResult for startId: $startId)." }
            stopSelfResult(startId)
        } else {
             logger.i { "[stopCall] Active calls remaining: ${activeCalls.size}. Service continues running." }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        logger.i { "[onDestroy] Service destroying. Clearing ${activeCalls.size} active calls and their notifications." }

        activeCalls.values.forEach { callData ->
            notificationManager.cancel(callData.notificationId)
            println("=== StreamCallService.onDestroy === Cancelled notification ID: ${callData.notificationId}")
        }
        activeCalls.clear()
        scope.cancel()
    }
    
    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        logger.i { "[onTaskRemoved] Task removed. Stopping all calls and self." }
        val currentCallCids = activeCalls.keys.toList()
        currentCallCids.forEach { cid ->
             val callData = activeCalls.remove(cid)
             if (callData != null) {
                notificationManager.cancel(callData.notificationId)
             }
        }
        if (activeCalls.isEmpty()) {
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


