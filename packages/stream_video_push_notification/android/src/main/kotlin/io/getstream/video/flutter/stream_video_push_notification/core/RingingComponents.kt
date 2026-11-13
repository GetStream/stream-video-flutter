package io.getstream.video.flutter.stream_video_push_notification.core

import android.annotation.SuppressLint
import android.content.Context
import androidx.annotation.VisibleForTesting
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationManager
import io.getstream.video.flutter.stream_video_push_notification.channel.RingingEventDispatcher
import io.getstream.video.flutter.stream_video_push_notification.notification.RingtonePlayer
import io.getstream.video.flutter.stream_video_push_notification.permissions.FullScreenIntentPermission
import io.getstream.video.flutter.stream_video_push_notification.permissions.NotificationPermissionFlow

/**
 * The ringing state the plugin shares across the process: the call store, the ringtone, the
 * notifications, the permission flows, the event dispatcher and the controller that drives them.
 *
 * One instance per process, built from the application context on first use, whether or not a
 * Flutter engine has attached. The plugin, the broadcast receiver, the service and the activities
 * all use it.
 */
internal class RingingComponents private constructor(context: Context) {

    val callStore: CallStore = PrefsCallStore(context)

    val ringtone = RingtonePlayer(context)

    val notifications = IncomingCallNotificationManager(context, ringtone)

    val notificationPermission = NotificationPermissionFlow()

    val fullScreenIntentPermission = FullScreenIntentPermission(context)

    val events = RingingEventDispatcher()

    val controller = RingingController(
        context = context,
        store = callStore,
        notifications = notifications,
        sendEvent = events::send,
    )

    companion object {
        @SuppressLint("StaticFieldLeak") // Holds the application context only.
        @Volatile
        private var instance: RingingComponents? = null

        fun get(context: Context): RingingComponents =
            instance ?: synchronized(this) {
                instance ?: RingingComponents(context.applicationContext).also { instance = it }
            }

        /** Forgets the instance, so the next [get] builds one for a new application context. */
        @VisibleForTesting
        fun reset() {
            synchronized(this) { instance = null }
        }
    }
}
