package io.getstream.video.flutter.dogfooding

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.ColorMatrix
import android.graphics.ColorMatrixColorFilter
import android.graphics.Paint

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

import io.getstream.video.flutter.stream_video_flutter.service.PictureInPictureHelper
import io.getstream.video.flutter.stream_video_flutter.videoFilters.common.VideoFrameProcessorWithBitmapFilter
import io.getstream.video.flutter.stream_video_flutter.videoFilters.common.BitmapVideoFilter
import io.getstream.webrtc.flutter.videoEffects.ProcessorProvider
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessor
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessorFactoryInterface

class MainActivity: FlutterActivity() {
    private val CHANNEL = "io.getstream.video.flutter.dogfooding.channel"

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        PictureInPictureHelper.enterPictureInPictureIfInCall(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "registerGreyscaleEffect") {
                ProcessorProvider.addProcessor("grayscale", GrayScaleVideoFilterFactory())
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}

class GrayScaleVideoFilterFactory : VideoFrameProcessorFactoryInterface {
    override fun build(): VideoFrameProcessor {
      return VideoFrameProcessorWithBitmapFilter {
        GrayScaleFilter()
      }
    }
  }
  private class GrayScaleFilter : BitmapVideoFilter() {
      override fun applyFilter(videoFrameBitmap: Bitmap) {
          val canvas = Canvas(videoFrameBitmap)
          val paint = Paint().apply {
              val colorMatrix = ColorMatrix().apply {
                  // map the saturation of the color to grayscale
                  setSaturation(0f)
              }
              colorFilter = ColorMatrixColorFilter(colorMatrix)
          }
          canvas.drawBitmap(videoFrameBitmap, 0f, 0f, paint)
      }
  }