package io.getstream.video.flutter.stream_video_push_notification.notification

import android.content.Context
import android.os.Bundle
import android.widget.ImageView
import coil.target.Target
import io.getstream.video.flutter.stream_video_push_notification.ImageLoaderProvider
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants

/**
 * Resolves and loads the images a call shows: the caller's avatar, the full-screen logo and the
 * full-screen background.
 */
internal object AvatarLoader {

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
        ImageLoaderProvider.loadImage(context, url, headers, target)
    }

    /** Loads [url] into [view], showing [placeholder] while it loads and when it fails. */
    fun loadInto(view: ImageView, url: String, headers: Map<String, String>, placeholder: Int) {
        ImageLoaderProvider.loadImage(view.context, url, headers, placeholder, view)
    }
}
