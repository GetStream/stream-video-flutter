package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.Notification
import android.content.Context
import android.graphics.Bitmap
import android.media.RingtoneManager
import android.os.Build
import android.os.Bundle
import android.text.format.DateFormat
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import io.getstream.video.flutter.stream_video_push_notification.R
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import java.util.Date

/** Builds the missed-call notification of one call. Keeps no state between calls. */
internal class MissedCallNotificationBuilder(private val context: Context) {

    /**
     * Builds the notification for the call in [data], whose actions carry [data], or returns null
     * when the call asks for no missed-call notification.
     */
    fun build(data: Bundle): MissedNotificationContent? {
        val call = CallPayloadMapper.fromBundle(data)
        if (!call.showMissedCallNotification) return null

        val id = NotificationIds.missed(data)

        NotificationChannels.ensureCreated(
            context,
            call.incomingCallNotificationChannelName,
            call.missedCallNotificationChannelName,
        )

        val subtitle = textOr(call.missedNotificationSubtitle, R.string.text_missed_call)

        val bigViews = RemoteViews(context.packageName, R.layout.layout_custom_miss_notification)
        val smallViews =
            RemoteViews(context.packageName, R.layout.layout_custom_miss_small_notification)
        bigViews.setTextViewText(R.id.tvCallerName, call.callerName)
        smallViews.setTextViewText(R.id.tvCallerName, call.callerName)
        smallViews.setTextViewText(R.id.tvTime, DateFormat.getTimeFormat(context).format(Date()))
        if (call.showCallHandle) {
            bigViews.setTextViewText(R.id.tvNumber, call.handle)
            smallViews.setTextViewText(R.id.tvNumber, call.handle)
        }
        bigViews.setOnClickPendingIntent(
            R.id.llCallback,
            NotificationIntents.callback(context, id, data),
        )
        bigViews.setViewVisibility(
            R.id.llCallback,
            if (call.showCallbackButton) View.VISIBLE else View.GONE,
        )
        bigViews.setTextViewText(
            R.id.tvCallback,
            textOr(call.missedNotificationCallbackText, R.string.text_call_back),
        )

        val builder = NotificationCompat.Builder(context, NotificationChannels.MISSED_ID)
            .setChannelId(NotificationChannels.MISSED_ID)
            .setWhen(System.currentTimeMillis())
            .setSubText(subtitle)
            .setSmallIcon(smallIcon(call.type))
            .setOnlyAlertOnce(true)
            .setContentTitle(call.callerName)
            .setContentText(subtitle)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(smallViews)
            .setCustomBigContentView(bigViews)
            .setGroup(MISSED_GROUP_KEY)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
            .setContentIntent(NotificationIntents.app(context, id, data))
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            builder.setCategory(Notification.CATEGORY_MISSED_CALL)
        }

        return MissedNotificationContent(
            id,
            AvatarLoader.avatarUrl(call.avatar, call.defaultAvatar),
            builder,
            listOf(bigViews, smallViews),
        )
    }

    private fun smallIcon(type: Int): Int {
        if (type > 0) return R.drawable.ic_video_missed
        val appIcon = context.applicationInfo.icon
        return if (appIcon >= 0) R.drawable.ic_call_missed else appIcon
    }

    private fun textOr(text: String?, fallback: Int): String =
        if (text.isNullOrEmpty()) context.getString(fallback) else text

    companion object {
        const val MISSED_GROUP_KEY = "io.getstream.video.flutter.missed_calls"
    }
}

/**
 * The missed-call notification of one call, with what it needs to be posted again once the
 * caller's avatar has loaded.
 */
internal class MissedNotificationContent(
    val id: Int,
    /** The avatar to load, or null when the call has none. */
    val avatarUrl: String?,
    private val builder: NotificationCompat.Builder,
    private val views: List<RemoteViews>,
) {
    val notification: Notification = builder.build()

    /** The notification again, showing [bitmap] as the caller's avatar. */
    fun withAvatar(bitmap: Bitmap): Notification {
        views.forEach {
            it.setImageViewBitmap(R.id.ivAvatar, bitmap)
            it.setViewVisibility(R.id.ivAvatar, View.VISIBLE)
        }
        return builder.build()
    }
}
