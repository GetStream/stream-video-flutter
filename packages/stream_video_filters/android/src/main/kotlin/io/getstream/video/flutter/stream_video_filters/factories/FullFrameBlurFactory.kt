package io.getstream.video.flutter.stream_video_filters.factories

import android.graphics.Bitmap
import android.graphics.Canvas
import com.google.android.renderscript.Toolkit
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessor
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessorFactoryInterface
import io.getstream.video.flutter.stream_video_filters.common.BitmapVideoFilter
import io.getstream.video.flutter.stream_video_filters.common.VideoFrameProcessorWithBitmapFilter

class FullFrameBlurFactory : VideoFrameProcessorFactoryInterface {
    override fun build(): VideoFrameProcessor {
        return VideoFrameProcessorWithBitmapFilter {
            FullFrameBlurFilter()
        }
    }
}

private class FullFrameBlurFilter : BitmapVideoFilter() {
    override fun applyFilter(videoFrameBitmap: Bitmap) {
        val blurredBitmap = Toolkit.blur(videoFrameBitmap, BLUR_RADIUS)
        val canvas = Canvas(videoFrameBitmap)
        canvas.drawBitmap(blurredBitmap, 0f, 0f, null)
        blurredBitmap.recycle()
    }

    companion object {
        private const val BLUR_RADIUS = 25
    }
}
