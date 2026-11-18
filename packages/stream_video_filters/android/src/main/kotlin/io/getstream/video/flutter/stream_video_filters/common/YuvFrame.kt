package io.getstream.video.flutter.stream_video_filters.common

import android.graphics.Bitmap
import io.github.crow_misia.libyuv.AbgrBuffer
import io.github.crow_misia.libyuv.I420Buffer
import io.github.crow_misia.libyuv.PlanePrimitive
import io.github.crow_misia.libyuv.RotateMode
import io.github.crow_misia.libyuv.RowStride
import org.webrtc.VideoFrame

/**
 * Converts WebRTC frames to bitmaps. Owns its scratch buffers and the output bitmap, so
 * every processor needs its own instance: two capture threads sharing one would recycle
 * or overwrite each other's bitmap mid-frame.
 */
class YuvFrame {
  private var libYuvRotatedI420Buffer: I420Buffer? = null
  private var libYuvAbgrBuffer: AbgrBuffer? = null
  private var bitmap: Bitmap? = null
  private val errorLog = ThrottledLog(TAG)

  /**
   * Converts VideoFrame.Buffer YUV frame to an ARGB_8888 Bitmap. Applies stored rotation.
   * @return The converted frame, in a Bitmap that is owned by this object and reused for
   * the next frame. The caller must be done with it before converting another frame.
   */
  fun bitmapFromVideoFrame(videoFrame: VideoFrame?): Bitmap? {
    if (videoFrame == null) {
      return null
    }

    return try {
      val webRtcI420Buffer = videoFrame.buffer.toI420()
        ?: throw IllegalStateException("toI420() returned null")
      try {
        createLibYuvI420Buffer(webRtcI420Buffer).use { libYuvI420Buffer ->
          rotateLibYuvI420Buffer(libYuvI420Buffer, videoFrame.rotation)
        }
      } finally {
        webRtcI420Buffer.release()
      }
      createLibYuvAbgrBuffer()
      copyAbgrBufferToBitmap()
    } catch (t: Throwable) {
      errorLog.e("Failed to convert a VideoFrame", t)
      null
    }
  }

  private fun createLibYuvI420Buffer(webRtcI420Buffer: VideoFrame.I420Buffer): I420Buffer {
    val width = webRtcI420Buffer.width
    val height = webRtcI420Buffer.height

    return I420Buffer.wrap(
      planeY = PlanePrimitive(RowStride(webRtcI420Buffer.strideY), webRtcI420Buffer.dataY),
      planeU = PlanePrimitive(RowStride(webRtcI420Buffer.strideU), webRtcI420Buffer.dataU),
      planeV = PlanePrimitive(RowStride(webRtcI420Buffer.strideV), webRtcI420Buffer.dataV),
      width = width,
      height = height,
    )
  }

  private fun rotateLibYuvI420Buffer(libYuvI420Buffer: I420Buffer, rotationDegrees: Int) {
    val width = libYuvI420Buffer.width
    val height = libYuvI420Buffer.height

    when (rotationDegrees) {
      90, -270 -> changeOrientation(libYuvI420Buffer, width, height, RotateMode.ROTATE_90) // upside down, 90
      180, -180 -> keepOrientation(libYuvI420Buffer, width, height, RotateMode.ROTATE_180) // right, 180
      270, -90 -> changeOrientation(libYuvI420Buffer, width, height, RotateMode.ROTATE_270) // upright, 270
      else -> keepOrientation(libYuvI420Buffer, width, height, RotateMode.ROTATE_0) // left, 0, default
    }
  }

  private fun changeOrientation(
    libYuvI420Buffer: I420Buffer,
    width: Int,
    height: Int,
    rotateMode: RotateMode,
  ) {
    // swapped width and height
    if (height != libYuvRotatedI420Buffer?.width || width != libYuvRotatedI420Buffer?.height) {
      libYuvRotatedI420Buffer?.close()
      libYuvRotatedI420Buffer = I420Buffer.allocate(height, width)
    }
    libYuvI420Buffer.rotate(libYuvRotatedI420Buffer!!, rotateMode)
  }

  private fun keepOrientation(
    libYuvI420Buffer: I420Buffer,
    width: Int,
    height: Int,
    rotateMode: RotateMode,
  ) {
    if (width != libYuvRotatedI420Buffer?.width || height != libYuvRotatedI420Buffer?.height) {
      libYuvRotatedI420Buffer?.close()
      libYuvRotatedI420Buffer = I420Buffer.allocate(width, height)
    }
    libYuvI420Buffer.rotate(libYuvRotatedI420Buffer!!, rotateMode)
  }

  private fun createLibYuvAbgrBuffer() {
    val width = libYuvRotatedI420Buffer!!.width
    val height = libYuvRotatedI420Buffer!!.height

    if (width != libYuvAbgrBuffer?.width || height != libYuvAbgrBuffer?.height) {
      libYuvAbgrBuffer?.close()
      libYuvAbgrBuffer = AbgrBuffer.allocate(width, height)
    }
    libYuvRotatedI420Buffer!!.convertTo(libYuvAbgrBuffer!!)
  }

  /**
   * Copies the ABGR buffer into the bitmap reused across frames, which is reallocated
   * only when the frame size changes.
   */
  private fun copyAbgrBufferToBitmap(): Bitmap {
    val abgr = libYuvAbgrBuffer!!
    var target = bitmap
    if (target == null || target.width != abgr.width || target.height != abgr.height) {
      target?.recycle()
      target = Bitmap.createBitmap(abgr.width, abgr.height, Bitmap.Config.ARGB_8888)
      bitmap = target
    }
    val buffer = abgr.asBuffer()
    buffer.position(0)
    target.copyPixelsFromBuffer(buffer)
    return target
  }

  companion object {
    private const val TAG = "YuvFrame"
  }
}
