package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.graphics.Color
import android.os.Build
import androidx.core.app.NotificationManagerCompat

/** The incoming-call and missed-call notification channels. */
internal object NotificationChannels {

    const val INCOMING_ID = "io.getstream.video_incoming_call_channel_id"
    const val MISSED_ID = "io.getstream.video_missed_call_channel_id"

    const val DEFAULT_INCOMING_NAME = "Incoming Call"
    const val DEFAULT_MISSED_NAME = "Missed Call"

    /**
     * Creates both channels on Android 8 and later, with the given names, high importance, no
     * sound on the incoming channel and public lock-screen visibility for it. A channel that
     * already exists keeps its settings; the system only takes a new name or description for it.
     */
    fun ensureCreated(context: Context, incomingName: String?, missedName: String?) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        NotificationManagerCompat.from(context).apply {
            var channelCall = getNotificationChannel(INCOMING_ID)
            if (channelCall != null) {
                channelCall.setSound(null, null)
            } else {
                channelCall = NotificationChannel(
                    INCOMING_ID,
                    incomingName ?: DEFAULT_INCOMING_NAME,
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply {
                    description = ""
                    vibrationPattern = longArrayOf(0, 1000, 500, 1000, 500)
                    lightColor = Color.RED
                    enableLights(true)
                    enableVibration(true)
                    setSound(null, null)
                }
            }
            channelCall.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            channelCall.importance = NotificationManager.IMPORTANCE_HIGH
            createNotificationChannel(channelCall)

            var channelMissedCall = getNotificationChannel(MISSED_ID)
            if (channelMissedCall == null) {
                channelMissedCall = NotificationChannel(
                    MISSED_ID,
                    missedName ?: DEFAULT_MISSED_NAME,
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply {
                    description = ""
                    vibrationPattern = longArrayOf(0, 1000)
                    lightColor = Color.RED
                    enableLights(true)
                    enableVibration(true)
                }
            }
            channelMissedCall.importance = NotificationManager.IMPORTANCE_HIGH
            createNotificationChannel(channelMissedCall)
        }
    }

    /**
     * Whether notifications are enabled for the app and, on Android 8 and later, the incoming
     * channel exists with an importance above none.
     */
    fun isIncomingEnabled(context: Context): Boolean = NotificationManagerCompat.from(context).run {
        if (!areNotificationsEnabled()) return false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = getNotificationChannel(INCOMING_ID)
            return channel != null && channel.importance > NotificationManagerCompat.IMPORTANCE_NONE
        }
        return true
    }
}
