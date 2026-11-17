package io.getstream.video.flutter.stream_video_push_notification.notification

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.widget.ImageView
import coil.ImageLoader
import coil.request.ImageRequest
import coil.target.Target
import io.getstream.video.flutter.stream_video_push_notification.CircleTransform
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import okhttp3.OkHttpClient

/**
 * Turns the images a call shows into requests and loads them: the caller's avatar, the
 * full-screen logo and the full-screen background. One loader serves the process; each request
 * carries its own call's headers.
 */
internal object CallImageLoader {

    @SuppressLint("StaticFieldLeak") // Holds the application context only.
    private var loader: ImageLoader? = null

    /**
     * The URL to load for [path]: an `http` or `https` URL as it is, anything else as a Flutter
     * asset path, and null for a null or empty path.
     */
    fun resolve(path: String?): String? {
        if (path.isNullOrEmpty()) return null
        if (path.startsWith("http://", ignoreCase = true) ||
            path.startsWith("https://", ignoreCase = true)
        ) {
            return path
        }
        return String.format("file:///android_asset/flutter_assets/%s", path)
    }

    /** The caller's avatar URL: [avatar], or [defaultAvatar] when [avatar] is empty. */
    fun avatarUrl(avatar: String?, defaultAvatar: String?): String? =
        resolve(avatar?.takeIf { it.isNotEmpty() } ?: defaultAvatar)

    /** The headers to send with the image requests of a call, without null values. */
    @Suppress("DEPRECATION")
    fun headers(data: Bundle): Map<String, String> {
        val raw = data.getSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS) as? Map<*, *>
            ?: return emptyMap()
        return buildMap {
            raw.forEach { (key, value) ->
                if (key is String && value != null) put(key, value.toString())
            }
        }
    }

    /** Loads [url] cropped to a circle and hands the bitmap to [target]. */
    fun loadCircle(context: Context, url: String, headers: Map<String, String>, target: Target) {
        val request = request(context, url, headers)
            .transformations(CircleTransform())
            .target(target)
            .build()
        loader(context).enqueue(request)
    }

    /** Loads [url] into [view], showing [placeholder] while it loads and when it fails. */
    fun loadInto(view: ImageView, url: String, headers: Map<String, String>, placeholder: Int) {
        val request = request(view.context, url, headers)
            .placeholder(placeholder)
            .error(placeholder)
            .target(view)
            .build()
        loader(view.context).enqueue(request)
    }

    private fun request(
        context: Context,
        url: String,
        headers: Map<String, String>,
    ): ImageRequest.Builder = ImageRequest.Builder(context).apply {
        headers.forEach { (key, value) -> addHeader(key, value) }
        data(url)
        allowHardware(false)
    }

    private fun loader(context: Context): ImageLoader =
        loader ?: synchronized(this) {
            loader ?: ImageLoader.Builder(context.applicationContext)
                .okHttpClient(
                    OkHttpClient.Builder()
                        .followRedirects(true)
                        .followSslRedirects(true)
                        .build(),
                )
                .build()
                .also { loader = it }
        }
}

/**
 * Hands a loaded bitmap to [onLoaded] unless [isCancelled], and calls [onFinished] once the load
 * succeeds or fails.
 */
internal open class SafeTarget(
    private val onLoaded: (Bitmap) -> Unit,
    private val onFinished: () -> Unit = {},
) : Target {

    var isCancelled = false

    override fun onSuccess(result: Drawable) {
        super.onSuccess(result)
        if (!isCancelled) {
            onLoaded((result as BitmapDrawable).bitmap)
        }
        onFinished()
    }

    override fun onError(error: Drawable?) {
        super.onError(error)
        onFinished()
    }
}
