package io.getstream.video.flutter.stream_video_push_notification

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
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

            // A new ring owes nothing yet. Without this the flag survives a ring whose service
            // never started — nothing clears it, since onDestroy only runs for a service that was
            // created — and the next ring double-promotes on its behalf.
            synchronized(foregroundLock) { repromotionOwed = false }

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
            if (runningInstance == null) return

            val intent = Intent(context, IncomingCallNotificationService::class.java)
            context.stopService(intent)
        }

        /**
         * The running service, so [repromoteRingingForeground] can reach it without binding.
         */
        @Volatile
        private var runningInstance: IncomingCallNotificationService? = null

        /**
         * Re-issues [startForeground] for a ringing service that is already in the foreground.
         *
         * While-in-use capabilities are granted by the circumstances a service is promoted under,
         * not by its type, so a service promoted from a push has none. Re-promoting once the call
         * exists in the Telecom stack gives the platform a second chance to grant them. 
         *
         * A no-op when no ringing service is in the foreground.
         */
        fun repromoteRingingForeground() {
            // The ringing service only ever runs on API 37+ (see startRinging), so below that
            // there is nothing to re-promote and no point leaving a flag set for nobody.
            if (Build.VERSION.SDK_INT < IncomingCallConstants.SDK_INT_CINNAMON_BUN) return

            val service = synchronized(foregroundLock) {
                val running = runningInstance
                if (running == null || !isRingingForeground) {
                    // Not in the foreground yet; leave the request for startRingingForeground.
                    repromotionOwed = true
                    null
                } else {
                    running
                }
            } ?: return

            Handler(Looper.getMainLooper()).post {
                val stillCurrent = synchronized(foregroundLock) {
                    runningInstance === service && isRingingForeground
                }
                if (stillCurrent) service.startRingingForeground()
            }
        }

        /**
         * Guards [repromotionOwed] and [isRingingForeground] together.
         */
        private val foregroundLock = Any()

        /** Set when a re-promotion was asked for before the service was foreground. */
        private var repromotionOwed: Boolean = false

        /** Whether the ringing service reached the foreground and can be re-promoted. */
        private var isRingingForeground: Boolean = false

    }

    private val incomingCallNotificationManager: IncomingCallNotificationManager? =
        StreamVideoPushNotificationPlugin.getInstance()?.getIncomingCallNotificationManager()


    override fun onCreate() {
        super.onCreate()
        runningInstance = this
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == IncomingCallConstants.ACTION_CALL_RINGING) {
            val data = intent.getBundleExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
            if (data == null) {
                stopSelf()
                return START_NOT_STICKY
            }
            // This start is delivered asynchronously, so the call may already have been
            // accepted, declined or cancelled by now. Ringing then would start a ringtone with no
            // notification and no service left to stop it.
            if (incomingCallNotificationManager?.currentIncomingNotification == null) {
                Log.w(TAG, "Incoming call notification is already gone, not ringing")
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
                    stopSelfUnlessRinging()
                }
        }
        if (intent?.action == IncomingCallConstants.ACTION_CALL_ACCEPT) {
            intent.getBundleExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
                ?.let {
                    incomingCallNotificationManager?.clearIncomingNotification(it, true)
                    stopSelfUnlessRinging()
                }
        }
        return START_NOT_STICKY
    }

    /**
     * Stops the service unless it is currently ringing for a call.
     *
     */
    private fun stopSelfUnlessRinging() {
        val isRinging = synchronized(foregroundLock) { isRingingForeground }
        if (isRinging) return
        stopSelf()
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
    internal fun startRingingForeground(): Boolean {
        val notification = incomingCallNotificationManager?.currentIncomingNotification
        if (notification == null) {
            Log.w(TAG, "No incoming call notification to run the ringing service with")
            return false
        }
        if (!promoteToForeground(notification)) return false

        val owed = synchronized(foregroundLock) {
            isRingingForeground = true
            repromotionOwed.also { repromotionOwed = false }
        }

        if (owed) {
            // Telecom registered the call before this promotion happened, so promote once more now
            // that both are in place. The flag was cleared above, so this cannot recurse.
            promoteToForeground(notification)
        }
        return true
    }

    private fun promoteToForeground(notification: IncomingCallNotification): Boolean = try {
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

    override fun onDestroy() {
        super.onDestroy()
        runningInstance = null
        synchronized(foregroundLock) {
            isRingingForeground = false
            repromotionOwed = false
        }
        // Do not destroy the notification manager here; it's a shared singleton.
        // Stopping it would silence the ringtone unintentionally. It is properly cleaned up elsewhere.
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }


    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        incomingCallNotificationManager?.stopIncomingCallRinging()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        }else {
            stopForeground(true)
        }
        stopSelf()
    }



}
