package io.getstream.video.flutter.stream_video_flutter.service.notification.image

import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.core.app.NotificationCompat
import coil.target.Target
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.stream_video_flutter.service.notification.IdentifiedNotification

class DefaultTarget(
    private val notificationId: Int,
    private val onUpdate: (IdentifiedNotification) -> Unit,
) : Target, Function1<NotificationCompat.Builder, DefaultTarget> {

    private val logger by taggedLogger("StreamCoilTD")

    private var builder: NotificationCompat.Builder? = null

    override fun onSuccess(result: Drawable) {
        logger.v { "[onSuccess] result: $result" }
        val builder = builder ?: return
        val bitmap = (result as? BitmapDrawable)?.bitmap ?: return
        logger.v { "[onSuccess] bitmap.byteCount: ${bitmap.byteCount}" }
        builder.setLargeIcon(bitmap)
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

    override fun invoke(builder: NotificationCompat.Builder): DefaultTarget {
        this.builder = builder
        return this
    }
}