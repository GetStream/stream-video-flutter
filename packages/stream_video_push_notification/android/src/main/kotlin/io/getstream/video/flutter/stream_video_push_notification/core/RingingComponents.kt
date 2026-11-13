package io.getstream.video.flutter.stream_video_push_notification.core

import android.annotation.SuppressLint
import android.content.Context
import androidx.annotation.VisibleForTesting
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationManager
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallSoundPlayerManager
import io.getstream.video.flutter.stream_video_push_notification.StreamVideoPushNotificationPlugin

/**
 * The ringing state the plugin shares across the process: the call store, the ringtone, the
 * notifications and the controller that drives them.
 *
 * Built from the application context on first use, so the broadcast receiver, the service and the
 * activities have it in a process no Flutter engine has attached to. The plugin uses the same
 * instance.
 */
internal class RingingComponents private constructor(context: Context) {

    val callStore: CallStore = PrefsCallStore(context)

    val soundPlayer = IncomingCallSoundPlayerManager(context)

    val notifications = IncomingCallNotificationManager(context, soundPlayer)

    val controller = RingingController(
        context = context,
        store = callStore,
        notifications = notifications,
        sendEvent = StreamVideoPushNotificationPlugin::sendEvent,
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
