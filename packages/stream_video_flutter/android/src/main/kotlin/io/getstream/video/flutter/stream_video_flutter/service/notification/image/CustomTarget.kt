package io.getstream.video.flutter.stream_video_flutter.service.notification.image

import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import coil.target.Target
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.stream_video_flutter.R
import io.getstream.video.flutter.stream_video_flutter.service.notification.IdentifiedNotification
import io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationLayout

class CustomTarget(
    private val notificationId: Int,
    private val onUpdate: (IdentifiedNotification) -> Unit,
) : Target, Function3<NotificationCompat.Builder, NotificationLayout, NotificationLayout, CustomTarget> {

    private val logger by taggedLogger("StreamCoilTC")

    private var builder: NotificationCompat.Builder? = null
    private var notificationSmallLayout: NotificationLayout? = null
    private var notificationLargeLayout: NotificationLayout? = null

    override fun onSuccess(result: Drawable) {
        logger.v { "[onSuccess] result: $result" }
        val builder = builder ?: return
        val bitmap = (result as? BitmapDrawable)?.bitmap ?: return
        logger.v { "[onSuccess] bitmap.byteCount: ${bitmap.byteCount}" }
        notificationLargeLayout?.setAvatar(bitmap)
        notificationSmallLayout?.setAvatar(bitmap)

        val notification = IdentifiedNotification(notificationId, builder.build())
        logger.v { "[onSuccess] notification: $notification" }
        onUpdate(notification)
    }

    override fun onError(error: Drawable?) {
        logger.e { "[onError] error: $error" }
    }

    override fun onStart(placeholder: Drawable?) {
        logger.d { "[onStart] placeholder: $placeholder" }
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