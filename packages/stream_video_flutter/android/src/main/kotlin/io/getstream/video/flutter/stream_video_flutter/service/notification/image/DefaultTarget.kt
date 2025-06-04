package io.getstream.video.flutter.stream_video_flutter.service.notification.image

import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import androidx.core.app.NotificationCompat
import com.squareup.picasso.Picasso
import com.squareup.picasso.Target
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.stream_video_flutter.service.notification.IdentifiedNotification

class DefaultTarget(
    private val notificationId: Int,
    private val onUpdate: (IdentifiedNotification) -> Unit,
) : Target, Function1<NotificationCompat.Builder, DefaultTarget> {

    private val logger by taggedLogger("StreamPicassoTD")

    private var builder: NotificationCompat.Builder? = null

    override fun onBitmapLoaded(bitmap: Bitmap?, from: Picasso.LoadedFrom?) {
        logger.v { "[onBitmapLoaded] bitmap.byteCount: ${bitmap?.byteCount}" }
        val builder = builder ?: return
        val icon = bitmap ?: return
        builder.setLargeIcon(icon)
        val notification = IdentifiedNotification(notificationId, builder.build())
        logger.v { "[onBitmapLoaded] notification: $notification" }
        onUpdate(notification)
    }

    override fun onBitmapFailed(e: Exception?, errorDrawable: Drawable?) {
        logger.e { "[onBitmapFailed] error: $e" }
    }

    override fun onPrepareLoad(placeHolderDrawable: Drawable?) {
        logger.d { "[onPrepareLoad] placeHolderDrawable: $placeHolderDrawable" }
    }

    override fun invoke(builder: NotificationCompat.Builder): DefaultTarget {
        this.builder = builder
        return this
    }
}