package io.getstream.video.flutter.stream_video_filters.common

import android.graphics.Matrix
import android.opengl.GLES20
import android.opengl.GLUtils
import android.util.Log
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessor
import org.webrtc.JavaI420Buffer
import org.webrtc.SurfaceTextureHelper
import org.webrtc.TextureBufferImpl
import org.webrtc.VideoFrame
import org.webrtc.YuvConverter

// Original Sources
// https://github.com/GetStream/stream-video-android/blob/9a3b8e92b74bc4408781b5274fc602034d616983/stream-video-android-core/src/main/kotlin/io/getstream/video/android/core/call/video/FilterVideoProcessor.kt
// https://github.com/SHIVAJIKUMAR007/real-time-VideoProcessing/blob/5bb96a8b0c3c602a458ece1774f68ea913336f9f/android/app/src/main/java/com/vchat/backgroundEffect/BackgroundBlurFactory.java

class VideoFrameProcessorWithBitmapFilter(bitmapVideoFilterFunc: () -> BitmapVideoFilter) :
  VideoFrameProcessor {
  private val yuvConverter = YuvConverter()
  private val yuvFrame = YuvFrame()
  private var inputWidth = 0
  private var inputHeight = 0
  private var inputBuffer: VideoFrame.TextureBuffer? = null
  private var yuvBuffer: VideoFrame.I420Buffer? = null
  private val textures = IntArray(1)
  private var blackBuffer: JavaI420Buffer? = null

  private val bitmapVideoFilter by lazy {
    bitmapVideoFilterFunc.invoke()
  }

  init {
    GLES20.glGenTextures(1, textures, 0)
  }

  override fun process(frame: VideoFrame, surfaceTextureHelper: SurfaceTextureHelper): VideoFrame {
    // Step 1: Video Frame to Bitmap
    val inputFrameBitmap = yuvFrame.bitmapFromVideoFrame(frame)
    if (inputFrameBitmap == null) {
      // The frame could not be converted, so the filter cannot run on it. Send a
      // black frame of the same size rather than the unfiltered camera image.
      return blackFrameLike(frame)
    }

    // Prepare helpers (runs only once or if the dimensions change)
    initialize(
      inputFrameBitmap.width,
      inputFrameBitmap.height,
      surfaceTextureHelper,
    )

    // Step 2: Apply filter
    bitmapVideoFilter.applyFilter(inputFrameBitmap)

    // Step 3: Bitmap to Video Frame
    // feed back the modified bitmap
    GLES20.glTexParameteri(
      GLES20.GL_TEXTURE_2D,
      GLES20.GL_TEXTURE_MIN_FILTER,
      GLES20.GL_NEAREST,
    )
    GLES20.glTexParameteri(
      GLES20.GL_TEXTURE_2D,
      GLES20.GL_TEXTURE_MAG_FILTER,
      GLES20.GL_NEAREST,
    )
    GLUtils.texImage2D(GLES20.GL_TEXTURE_2D, 0, inputFrameBitmap, 0)
    // Convert the buffer back to YUV (VideoFrame needs YUV)
    yuvBuffer = yuvConverter.convert(inputBuffer)
    return VideoFrame(yuvBuffer, 0, frame.timestampNs)
  }

  /**
   * A black frame with the size, rotation and timestamp of [frame]. The black buffer is
   * reused while the size stays the same; every returned frame holds its own reference,
   * which the caller releases.
   */
  private fun blackFrameLike(frame: VideoFrame): VideoFrame {
    val width = frame.buffer.width
    val height = frame.buffer.height
    var buffer = blackBuffer
    if (buffer == null || buffer.width != width || buffer.height != height) {
      buffer?.release()
      buffer = JavaI420Buffer.allocate(width, height).apply {
        // Y = 0 with neutral chroma (128) is black.
        fillPlane(dataY, 0)
        fillPlane(dataU, 128)
        fillPlane(dataV, 128)
      }
      blackBuffer = buffer
    }
    buffer.retain()
    return VideoFrame(buffer, frame.rotation, frame.timestampNs)
  }

  private fun fillPlane(plane: java.nio.ByteBuffer, value: Int) {
    val position = plane.position()
    while (plane.hasRemaining()) {
      plane.put(value.toByte())
    }
    plane.position(position)
  }

  private fun initialize(width: Int, height: Int, textureHelper: SurfaceTextureHelper) {
    // TODO: temporarily disabled due to crash: java.lang.IllegalStateException: release() called on an object with refcount < 1
//     yuvBuffer?.release()

    if (this.inputWidth != width || this.inputHeight != height) {
      Log.d(TAG, "initialize - width: $width height: $height")
      this.inputWidth = width
      this.inputHeight = height
      inputBuffer?.release()

      val type = VideoFrame.TextureBuffer.Type.RGB

      val matrix = Matrix()
      // This is vertical flip - we need to investigate why the image is flipped vertically and
      // why we need to correct it here.
      matrix.preScale(1.0f, -1.0f)
      val surfaceTextureHelper: SurfaceTextureHelper = textureHelper
      this.inputBuffer = TextureBufferImpl(
        inputWidth, inputHeight, type, textures[0], matrix, surfaceTextureHelper.handler,
        yuvConverter, null as Runnable?,
      )
    }
  }

  companion object {
    private const val TAG = "VideoFrameProcessorWithBitmapFilter"
  }
}
