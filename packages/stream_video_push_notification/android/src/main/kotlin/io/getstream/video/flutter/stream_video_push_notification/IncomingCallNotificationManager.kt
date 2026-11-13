package io.getstream.video.flutter.stream_video_push_notification

import android.annotation.SuppressLint
import android.app.Notification
import android.content.Context
import android.graphics.Bitmap
import android.os.Bundle
import androidx.core.app.NotificationManagerCompat
import coil.target.Target
import io.getstream.video.flutter.stream_video_push_notification.notification.AvatarLoader
import io.getstream.video.flutter.stream_video_push_notification.notification.IncomingCallNotificationBuilder
import io.getstream.video.flutter.stream_video_push_notification.notification.MissedCallNotificationBuilder
import io.getstream.video.flutter.stream_video_push_notification.notification.NotificationChannels
import io.getstream.video.flutter.stream_video_push_notification.notification.NotificationIds
import io.getstream.video.flutter.stream_video_push_notification.notification.RingtonePlayer

/**
 * Posts and clears the incoming and missed-call notifications and owns the ringtone of the call
 * that currently rings. Each call's notification is built separately and keeps its own avatar
 * load, so two calls at once do not share either.
 */
internal class IncomingCallNotificationManager(
    private val context: Context,
    private val ringtone: RingtonePlayer,
    private val incomingBuilder: IncomingCallNotificationBuilder =
        IncomingCallNotificationBuilder(context),
    private val missedBuilder: MissedCallNotificationBuilder = MissedCallNotificationBuilder(context),
    private val loadCircleImage: (Context, String, Map<String, String>, Target) -> Unit =
        AvatarLoader::loadCircle,
) {

    /**
     * The incoming call notification currently on screen, so that
     * [IncomingCallNotificationService] can adopt it as its foreground service notification
     * instead of building and posting a second one.
     */
    internal var currentIncomingNotification: IncomingCallNotification? = null
        private set

    /** Pending avatar loads, by notification id. */
    private val incomingAvatarTargets = mutableMapOf<Int, SafeTarget>()
    private val missedAvatarTargets = mutableMapOf<Int, SafeTarget>()

    private val notificationManager get() = NotificationManagerCompat.from(context)

    /**
     * Posts the incoming notification for the call in [data], makes it the current one and rings:
     * from [IncomingCallNotificationService] where it can run in the foreground, here otherwise.
     * Nothing rings when notifications or the incoming channel are turned off.
     */
    @SuppressLint("MissingPermission")
    fun showIncomingNotification(data: Bundle) {
        val content = incomingBuilder.build(data)
        val notification = IncomingCallNotification(content.id, content.notification)
        currentIncomingNotification = notification
        notificationManager.notify(content.id, notification.notification)

        content.avatarUrl?.let { url ->
            loadAvatar(incomingAvatarTargets, content.id, url, data) { bitmap ->
                notificationManager.notify(content.id, content.withAvatar(bitmap))
            }
        }

        if (NotificationChannels.isIncomingEnabled(context)) {
            // The notification has to be posted first: the ringing service adopts it as its
            // foreground service notification and only then starts the ringtone.
            if (!IncomingCallNotificationService.startRinging(context, data)) {
                ringtone.play(data)
            }
        }
    }

    /**
     * Removes the incoming notification of the call in [data] and tells the full-screen activity
     * to close. The ringtone and the ringing service stop only when this call owns them.
     */
    fun clearIncomingNotification(data: Bundle, isAccepted: Boolean) {
        val notificationId = NotificationIds.incoming(data)

        // The ringtone and the ringing service are shared by every incoming call, so they may only
        // be torn down for the call that currently owns them. A second call arriving while the
        // first still rings takes them over, and clearing the first one then has to leave them be.
        val current = currentIncomingNotification
        if (current == null || current.id == notificationId) {
            ringtone.stop()
            currentIncomingNotification = null
            // Covers accept, decline, ended and timeout, so the ringing foreground service never
            // outlives the notification it was started for.
            IncomingCallNotificationService.stopService(context)
        }

        context.sendBroadcast(IncomingCallActivity.getIntentEnded(context, isAccepted))

        notificationManager.cancel(notificationId)
        incomingAvatarTargets.remove(notificationId)?.isCancelled = true
    }

    /** Posts the missed-call notification of the call in [data], unless the call asks for none. */
    @SuppressLint("MissingPermission")
    fun showMissCallNotification(data: Bundle) {
        val content = missedBuilder.build(data) ?: return
        notificationManager.notify(content.id, content.notification)

        content.avatarUrl?.let { url ->
            loadAvatar(missedAvatarTargets, content.id, url, data) { bitmap ->
                notificationManager.notify(content.id, content.withAvatar(bitmap))
            }
        }
    }

    fun clearMissCallNotification(data: Bundle) {
        val notificationId = NotificationIds.missed(data)
        notificationManager.cancel(notificationId)
        missedAvatarTargets.remove(notificationId)?.isCancelled = true
    }

    /** Rings from [IncomingCallNotificationService], once it is in the foreground. */
    internal fun playIncomingCallSound(data: Bundle) {
        ringtone.play(data)
    }

    /**
     * Stops the ringtone when the ringing notification goes away without passing through
     * [clearIncomingNotification], e.g. the ringing service being torn down with the task.
     */
    internal fun stopIncomingCallRinging() {
        ringtone.stop()
        currentIncomingNotification = null
    }

    /** Loads [url] for notification [id], replacing a load still pending for that id. */
    private fun loadAvatar(
        targets: MutableMap<Int, SafeTarget>,
        id: Int,
        url: String,
        data: Bundle,
        onLoaded: (Bitmap) -> Unit,
    ) {
        targets.remove(id)?.isCancelled = true
        val target = SafeTarget(id, onLoaded)
        targets[id] = target
        loadCircleImage(context, url, AvatarLoader.headers(data), target)
    }
}

internal data class IncomingCallNotification(val id: Int, val notification: Notification)
