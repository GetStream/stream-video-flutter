package io.getstream.video.flutter.stream_video_push_notification

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Log
import android.widget.ImageView
import coil.ImageLoader
import coil.request.ImageRequest
import coil.target.Target
import okhttp3.OkHttpClient

internal object ImageLoaderProvider {
    @SuppressLint("StaticFieldLeak")
    private var instance: ImageLoader? = null

    /** One loader for the process. Headers are added per request, not by the loader. */
    fun get(context: Context): ImageLoader {
        if (instance == null) {
            val client = OkHttpClient.Builder()
                .followRedirects(true)
                .followSslRedirects(true)
                .build()
            instance = ImageLoader.Builder(context.applicationContext).okHttpClient(client).build()
        }
        return instance!!
    }

    fun loadImage(context: Context, url: String, headers: Map<String, String>, target: Target?) {
        val imageLoader = get(context)
        val requestBuilder = ImageRequest.Builder(context)
        headers.forEach { (key, value) -> requestBuilder.addHeader(key, value) }
        requestBuilder.data(url)
        requestBuilder.allowHardware(false)
        requestBuilder.transformations(CircleTransform())
        requestBuilder.target(target)

        imageLoader.enqueue(requestBuilder.build())
    }

    fun loadImage(
        context: Context,
        url: String,
        headers: Map<String, String>,
        placeholder: Int,
        target: ImageView,
    ) {
        val imageLoader = get(context)
        val requestBuilder = ImageRequest.Builder(context)
        headers.forEach { (key, value) -> requestBuilder.addHeader(key, value) }
        requestBuilder.data(url)
        requestBuilder.allowHardware(false)
        requestBuilder.placeholder(placeholder)
        requestBuilder.error(placeholder)
        requestBuilder.target(target)

        imageLoader.enqueue(requestBuilder.build())
    }


}


internal open class SafeTarget(
    private val notificationId: Int,
    private val onLoaded: (Bitmap) -> Unit
) : Target {

    var isCancelled = false

    override fun onSuccess(result: Drawable) {
        super.onSuccess(result)
        Log.d("onSuccess", "-")
        if (!isCancelled) {
            onLoaded((result as BitmapDrawable).bitmap)
        }
    }

    override fun onStart(placeholder: Drawable?) {
        super.onStart(placeholder)
        Log.d("onStart", "-")
    }

    override fun onError(error: Drawable?) {
        super.onError(error)
        Log.d("onError", "-")
    }


}