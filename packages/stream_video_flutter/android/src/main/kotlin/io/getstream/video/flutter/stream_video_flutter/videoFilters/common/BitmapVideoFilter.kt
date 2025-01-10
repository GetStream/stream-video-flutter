package io.getstream.video.flutter.stream_video_flutter.videoFilters.common

import android.graphics.Bitmap

/**
 * A filter that provides a Bitmap of each frame. It's less performant than using the
 * RawVideoFilter because we do YUV<->ARGB conversions internally.
 */
abstract class BitmapVideoFilter {
  abstract fun applyFilter(videoFrameBitmap: Bitmap)
}
