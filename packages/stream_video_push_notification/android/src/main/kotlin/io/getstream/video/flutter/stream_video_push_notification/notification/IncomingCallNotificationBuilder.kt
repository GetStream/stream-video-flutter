package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.Notification
import android.content.Context
import android.graphics.Bitmap
import android.os.Build
import android.os.Bundle
import android.text.TextUtils
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.Person
import io.getstream.video.flutter.stream_video_push_notification.R
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper

/**
 * Builds the incoming call notification of one call: `CallStyle` from Android 14, custom
 * `RemoteViews` below. Keeps no state between calls.
 *
 * @param sdkInt the API level to build for.
 */
internal class IncomingCallNotificationBuilder(
    private val context: Context,
    private val sdkInt: Int = Build.VERSION.SDK_INT,
) {

    /**
     * Builds the notification for the call in [data], whose actions carry [data]. Stamps [data]
     * with [EXTRA_TIME_START_CALL] first.
     */
    fun build(data: Bundle): IncomingNotificationContent {
        data.putLong(EXTRA_TIME_START_CALL, System.currentTimeMillis())

        val id = NotificationIds.incoming(data)
        val call = CallPayloadMapper.fromBundle(data)

        NotificationChannels.ensureCreated(
            context,
            call.incomingCallNotificationChannelName,
            call.missedCallNotificationChannelName,
        )

        val builder = NotificationCompat.Builder(context, NotificationChannels.INCOMING_ID)
            .setChannelId(NotificationChannels.INCOMING_ID)
            .setDefaults(NotificationCompat.DEFAULT_VIBRATE)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setAutoCancel(false)
            .setWhen(System.currentTimeMillis())
            .setTimeoutAfter(call.duration)
            .setOnlyAlertOnce(true)
            .setSound(null)
            .setFullScreenIntent(NotificationIntents.fullScreen(context, id, data), true)
            .setContentIntent(NotificationIntents.fullScreen(context, id, data))
            .setSmallIcon(smallIcon(call.type))

        val avatarUrl = AvatarLoader.avatarUrl(call.avatar, call.defaultAvatar)

        if (sdkInt >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val person = Person.Builder()
                .setName(call.callerName)
                .setImportant(call.isImportant)
                .setBot(call.isBot)
                .build()
            builder.setStyle(
                NotificationCompat.CallStyle.forIncomingCall(
                    person,
                    NotificationIntents.decline(context, id, data),
                    NotificationIntents.accept(context, id, data),
                ).setIsVideo(call.type > 0),
            )
            if (call.showCallHandle) builder.setContentText(call.handle)

            return IncomingNotificationContent(id, avatarUrl, builder, emptyList(), callStyle = true)
        }

        val bigViews = RemoteViews(context.packageName, R.layout.layout_custom_notification)
        val smallLayout = if (
            Build.MANUFACTURER.equals("Samsung", ignoreCase = true) &&
            sdkInt >= Build.VERSION_CODES.S
        ) {
            R.layout.layout_custom_small_ex_notification
        } else {
            R.layout.layout_custom_small_notification
        }
        val smallViews = RemoteViews(context.packageName, smallLayout)
        listOf(bigViews, smallViews).forEach { views ->
            views.setTextViewText(R.id.tvCallerName, call.callerName)
            if (call.showCallHandle) views.setTextViewText(R.id.tvNumber, call.handle)
            views.setOnClickPendingIntent(
                R.id.llDecline,
                NotificationIntents.decline(context, id, data),
            )
            views.setTextViewText(
                R.id.tvDecline,
                textOr(call.textDecline, R.string.text_decline),
            )
            views.setOnClickPendingIntent(
                R.id.llAccept,
                NotificationIntents.accept(context, id, data),
            )
            views.setTextViewText(R.id.tvAccept, textOr(call.textAccept, R.string.text_accept))
        }
        builder.setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(smallViews)
            .setCustomBigContentView(bigViews)
            .setCustomHeadsUpContentView(smallViews)

        return IncomingNotificationContent(
            id,
            avatarUrl,
            builder,
            listOf(bigViews, smallViews),
            callStyle = false,
        )
    }

    private fun smallIcon(type: Int): Int {
        if (type > 0) return R.drawable.ic_video
        val appIcon = context.applicationInfo.icon
        return if (appIcon >= 0) R.drawable.ic_accept else appIcon
    }

    private fun textOr(text: String, fallback: Int): String =
        if (TextUtils.isEmpty(text)) context.getString(fallback) else text

    companion object {
        /** When the ring started, in milliseconds since the epoch. */
        const val EXTRA_TIME_START_CALL = "EXTRA_TIME_START_CALL"
    }
}

/**
 * The incoming notification of one call, with what it needs to be posted again once the caller's
 * avatar has loaded.
 */
internal class IncomingNotificationContent(
    val id: Int,
    /** The avatar to load, or null when the call has none. */
    val avatarUrl: String?,
    private val builder: NotificationCompat.Builder,
    private val views: List<RemoteViews>,
    private val callStyle: Boolean,
) {
    val notification: Notification = builder.build()

    /** The notification again, showing [bitmap] as the caller's avatar. */
    fun withAvatar(bitmap: Bitmap): Notification {
        views.forEach {
            it.setImageViewBitmap(R.id.ivAvatar, bitmap)
            it.setViewVisibility(R.id.ivAvatar, View.VISIBLE)
        }
        if (callStyle) builder.setLargeIcon(bitmap)
        return builder.build()
    }
}
