package io.getstream.video.flutter.stream_video_push_notification

import android.annotation.SuppressLint
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import androidx.core.content.ContextCompat

class IncomingCallNotificationService : Service() {

    companion object {

        private val ActionForeground = listOf(
            IncomingCallConstants.ACTION_CALL_START,
            IncomingCallConstants.ACTION_CALL_ACCEPT
        )

        fun startServiceWithAction(context: Context, action: String, data: Bundle?) {
            val intent = Intent(context, IncomingCallNotificationService::class.java).apply {
                this.action = action
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && intent.action in ActionForeground) {
                data?.let {
                    context.startService(intent)
                }
            } else {
                context.startService(intent)
            }
        }

        fun stopService(context: Context) {
            val intent = Intent(context, IncomingCallNotificationService::class.java)
            context.stopService(intent)
        }

    }

    private val incomingCallNotificationManager: IncomingCallNotificationManager? =
        StreamVideoPushNotificationPlugin.getInstance()?.getIncomingCallNotificationManager()


    override fun onCreate() {
        super.onCreate()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == IncomingCallConstants.ACTION_CALL_START) {
            intent.getBundleExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
                ?.let {
                    stopSelf()
                }
        }
        if (intent?.action == IncomingCallConstants.ACTION_CALL_ACCEPT) {
            intent.getBundleExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
                ?.let {
                    incomingCallNotificationManager?.clearIncomingNotification(it, true)
                    stopSelf()
                }
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        incomingCallNotificationManager?.destroy()
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }


    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        }else {
            stopForeground(true)
        }
        stopSelf()
    }



}

