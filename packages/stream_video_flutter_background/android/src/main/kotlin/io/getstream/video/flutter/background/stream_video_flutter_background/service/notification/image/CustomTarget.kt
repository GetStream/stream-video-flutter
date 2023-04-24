package io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.image

import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import com.squareup.picasso.Picasso
import com.squareup.picasso.Target
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.R
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.IdentifiedNotification
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationLayout

class CustomTarget(
    private val getNotificationId: () -> Int,
    private val onUpdate: (IdentifiedNotification) -> Unit,
) : Target, Function3<NotificationCompat.Builder, NotificationLayout, NotificationLayout, CustomTarget> {

    private val logger by taggedLogger("StreamPicassoTC")

    private var builder: NotificationCompat.Builder? = null
    private var notificationSmallLayout: NotificationLayout? = null
    private var notificationLargeLayout: NotificationLayout? = null

    override fun onBitmapLoaded(bitmap: Bitmap?, from: Picasso.LoadedFrom?) {
        logger.v { "[onBitmapLoaded] bitmap.byteCount: ${bitmap?.byteCount}" }
        val builder = builder ?: return
        val icon = bitmap ?: return
        notificationLargeLayout?.setAvatar(icon)
        notificationSmallLayout?.setAvatar(icon)

        val notification = IdentifiedNotification(getNotificationId(), builder.build())
        logger.v { "[onBitmapLoaded] notification: $notification" }
        onUpdate(notification)
    }

    override fun onBitmapFailed(e: Exception?, errorDrawable: Drawable?) {
        logger.e { "[onBitmapFailed] error: $e" }
    }

    override fun onPrepareLoad(placeHolderDrawable: Drawable?) {
        logger.d { "[onPrepareLoad] placeHolderDrawable: $placeHolderDrawable" }
    }

    override fun invoke(
        builder: NotificationCompat.Builder,
        notificationLargeLayout: NotificationLayout,
        notificationSmallLayout: NotificationLayout,
    ): CustomTarget {
        this.builder = builder
        this.notificationLargeLayout = notificationLargeLayout
        this.notificationSmallLayout = notificationSmallLayout
        return this
    }
}