package io.getstream.video.flutter.stream_video_push_notification

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat

class IncomingCallNotificationService : Service() {

    companion object {

        private const val TAG = "IncomingCallService"

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

        /**
         * Runs this service in the foreground for the incoming call ringing window, and rings from
         * there once the service is actually in the foreground.
         *
         * Android 17 mutes background audio unless the app has a visible activity or is running a
         * foreground service that is not of type `SHORT_SERVICE`, so the ringtone of a push
         * delivered incoming call is silently dropped without one. Below Android 17 nothing
         * changes: this returns false and the caller keeps ringing the way it always has.
         *
         * @return true when the caller must not play the ringtone itself because this service took
         * it over, false when it still has to.
         */
        fun startRinging(context: Context, data: Bundle): Boolean {
            if (Build.VERSION.SDK_INT < IncomingCallConstants.SDK_INT_CINNAMON_BUN) return false

            val intent = Intent(context, IncomingCallNotificationService::class.java).apply {
                action = IncomingCallConstants.ACTION_CALL_RINGING
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
            }
            return try {
                ContextCompat.startForegroundService(context, intent)
                true
            } catch (error: Exception) {
                // Background start can be refused, e.g. when the push was downgraded from high
                // priority. Ringing without a foreground service is better than not ringing.
                Log.e(TAG, "Could not start the ringing foreground service", error)
                false
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
        if (intent?.action == IncomingCallConstants.ACTION_CALL_RINGING) {
            val data = intent.getBundleExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
            if (data == null) {
                stopSelf()
                return START_NOT_STICKY
            }
            // Ring either way: when the foreground service could not be started the playback may
            // still be muted by the system, but that is no worse than not attempting it at all.
            val inForeground = startRingingForeground()
            incomingCallNotificationManager?.playIncomingCallSound(data)
            if (!inForeground) stopSelf()
            return START_NOT_STICKY
        }
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

    /**
     * Adopts the already posted incoming call notification as the foreground service notification.
     *
     * `phoneCall` is used because Android 17 only requires the type not to be `SHORT_SERVICE`, and
     * its prerequisites (`FOREGROUND_SERVICE_PHONE_CALL` and `MANAGE_OWN_CALLS`) are declared by
     * this package.
     *
     * Note this does not give the service while-in-use capabilities, which apps targeting API 37
     * additionally need: those are granted by how a service is started, not by its type, and a
     * service started from an incoming push is started neither while visible nor from a user
     * interaction. Covering that case needs Telecom system delegation (`CallsManager.addCall`).
     */
    private fun startRingingForeground(): Boolean {
        val notification = incomingCallNotificationManager?.currentIncomingNotification
        if (notification == null) {
            Log.w(TAG, "No incoming call notification to run the ringing service with")
            return false
        }
        return try {
            ServiceCompat.startForeground(
                this,
                notification.id,
                notification.notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_PHONE_CALL,
            )
            true
        } catch (error: Exception) {
            Log.e(TAG, "Could not move the ringing service to the foreground", error)
            false
        }
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
