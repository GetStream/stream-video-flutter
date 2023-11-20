package io.getstream.video.flutter.stream_video_flutter.service

import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
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
internal class StreamScreenShareService : Service() {
    private val logger by taggedLogger("StreamScreenShareService")

    private val scope = CoroutineScope(Dispatchers.Default)

    private val notificationManager: NotificationManager by lazy { application.notificationManager }

    private val notificationBuilder: StreamNotificationBuilder by lazy {
        createNotificationBuilder(application)
    }

    private val payload: NotificationPayload
        get() {
            val payload = notificationPayload
            if (payload.callCid.isEmpty()) {
                error("[StreamScreenShareService.callCid] NotificationPayload.callCid must not be empty")
            }
            return payload
        }

    private val getNotificationId = { R.id.stream_screen_share_notification }

    protected open fun createNotificationBuilder(context: Context): StreamNotificationBuilder =
            StreamNotificationBuilderImpl(context, scope, ServiceType.screenSharing, getNotificationId) {
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

//    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        val callId = intent?.getStringExtra(EXTRA_CALL_ID)!!
//        val cancelScreenShareIntent = Intent(
//            this,
//            StopScreenshareBroadcastReceiver::class.java,
//        ).apply {
//            action = BROADCAST_CANCEL_ACTION
//            putExtra(INTENT_EXTRA_CALL_ID, callId)
//        }
//        val cancelScreenSharePendingIntent: PendingIntent =
//            PendingIntent.getBroadcast(
//                this,
//                0,
//                cancelScreenShareIntent,
//                PendingIntent.FLAG_IMMUTABLE,
//            )
//
//        val builder = NotificationCompat.Builder(applicationContext, channelId).apply {
//            priority = NotificationCompat.PRIORITY_HIGH
//            setAutoCancel(false)
//            setOngoing(true)
//            setSmallIcon(R.drawable.stream_video_ic_screenshare)
//            setContentTitle(getString(R.string.stream_video_screen_sharing_notification_title))
//            setContentText(getString(R.string.stream_video_screen_sharing_notification_description))
//            setAllowSystemGeneratedContextualActions(false)
//            addAction(
//                R.drawable.stream_video_ic_cancel_screenshare,
//                getString(R.string.stream_video_screen_sharing_notification_action_stop),
//                cancelScreenSharePendingIntent,
//            )
//        }
//
//        NotificationManagerCompat.from(application).also {
//            it.createNotificationChannel(
//                NotificationChannelCompat
//                    .Builder(channelId, NotificationManager.IMPORTANCE_DEFAULT)
//                    .setName(
//                        getString(R.string.stream_video_screen_sharing_notification_channel_title),
//                    )
//                    .setDescription(
//                        getString(
//                            R.string.stream_video_screen_sharing_notification_channel_description,
//                        ),
//                    )
//                    .build(),
//            )
//        }
//
//        startForeground(NOTIFICATION_ID, builder.build())
//        return super.onStartCommand(intent, flags, startId)
//    }

//    companion object {
//        internal const val NOTIFICATION_ID = 43534
//        internal const val EXTRA_CALL_ID = "EXTRA_CALL_ID"
//        internal const val BROADCAST_CANCEL_ACTION = "io.getstream.video.android.action.CANCEL_SCREEN_SHARE"
//        internal const val INTENT_EXTRA_CALL_ID = "io.getstream.video.android.intent-extra.call_cid"
//
//        fun createIntent(context: Context, callId: String) =
//            Intent(context, StreamScreenShareService::class.java).apply {
//                putExtra(EXTRA_CALL_ID, callId)
//            }
//    }
}