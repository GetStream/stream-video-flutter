package io.getstream.video.flutter.stream_video_filters.factories

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Matrix
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.net.Uri
import android.util.Log
import androidx.annotation.Keep
import com.google.android.gms.tasks.Tasks
import com.google.android.renderscript.Toolkit
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.segmentation.Segmentation
import com.google.mlkit.vision.segmentation.SegmentationMask
import com.google.mlkit.vision.segmentation.selfie.SelfieSegmenterOptions
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessor
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessorFactoryInterface
import io.getstream.video.flutter.stream_video_filters.common.BitmapVideoFilter
import io.getstream.video.flutter.stream_video_filters.common.Segment
import io.getstream.video.flutter.stream_video_filters.common.VideoFrameProcessorWithBitmapFilter
import io.getstream.video.flutter.stream_video_filters.common.colouredSegmentInt
import io.getstream.video.flutter.stream_video_filters.common.getScalingFactors
import java.net.URL
import java.nio.ByteBuffer
import java.util.concurrent.atomic.AtomicBoolean
import io.flutter.embedding.engine.loader.FlutterLoader
import java.io.InputStream
import android.os.Handler
import android.os.Looper
import android.os.Build;
import io.flutter.FlutterInjector;

/**
 * original source: https://github.com/GetStream/stream-video-android/blob/develop/stream-video-android-filters-video/src/main/kotlin/io/getstream/video/android/filters/video/VirtualBackgroundVideoFilter.kt
 *
 * Applies a virtual background (custom image) to a video call.
 *
 * @param backgroundImageUrlString The image url of the custom background image.
 * @param foregroundThreshold The confidence threshold for the foreground. Pixels with a confidence value greater than or equal to this threshold are considered to be in the foreground. Value is coerced between 0 and 1, inclusive.
 */
class VirtualBackgroundFactory(
    private val appContext: Context,
    private val backgroundImageUrlString: String,
    private val foregroundThreshold: Double = DEFAULT_FOREGROUND_THRESHOLD,
) : VideoFrameProcessorFactoryInterface {

    override fun build(): VideoFrameProcessor {
        return VideoFrameProcessorWithBitmapFilter {
            VirtualBackgroundVideoFilter(appContext, backgroundImageUrlString, foregroundThreshold)
        }
    }

    companion object {
        private const val TAG = "VirtualBackgroundFactory"
    }
}

/**
 * Applies a virtual background (custom image) to a video call.
 *
 * @param backgroundImageUrlString The image url of the custom background image.
 * @param foregroundThreshold The confidence threshold for the foreground. Pixels with a confidence value greater than or equal to this threshold are considered to be in the foreground. Value is coerced between 0 and 1, inclusive.
 */
@Keep
private class VirtualBackgroundVideoFilter(
    private val appContext: Context,
    private val backgroundImageUrlString: String,
    foregroundThreshold: Double = DEFAULT_FOREGROUND_THRESHOLD,
) : BitmapVideoFilter() {
    private val options =
        SelfieSegmenterOptions.Builder().setDetectorMode(SelfieSegmenterOptions.STREAM_MODE)
            .enableRawSizeMask().build()
    private val segmenter = Segmentation.getClient(options)

    @Volatile // volatile as its get and set happen in different threads
    private var segmentationMask: SegmentationMask? = null
    private var processedSegmentationMask: SegmentationMask? = null
    private var scaleBetweenSourceAndMaskMatrix: Matrix? = null

    // used for throttling, we dont want to send to ML model when there is an ongoing processing
    // atomic as its get and set happen in different threads
    private val isProcessing = AtomicBoolean(false)
    private var foregroundThreshold: Double = foregroundThreshold.coerceIn(0.0, 1.0)

    // bitmap to hold the foreground values, 1 for background 0 for foreground, raw mask sized
    private var foregroundMaskBitmap: Bitmap? = null

    // bitmap to upscale the mask bitmap to video frame size
    private var scaledForegroundBitmap: Bitmap? = null
    private val upscalePaint: Paint by lazy {
        Paint().apply {
            // smooths out the edges of shapes
            isAntiAlias = true
        }
    }


    // Loaded on a background thread so a slow URL doesn't block the capture thread.
    // Null while loading and when the load failed; frames are then processed with a
    // blurred copy of themselves as the background (see applyFilter).
    @Volatile
    private var virtualBackgroundBitmap: Bitmap? = null

    init {
        Thread { loadBackgroundImage() }.start()
    }

    private fun loadBackgroundImage() {
        // URLs may carry signed-access query tokens; log only the host.
        val host = Uri.parse(backgroundImageUrlString).host ?: "local"
        val bitmap: Bitmap? = try {
            val uri = Uri.parse(backgroundImageUrlString)
            if (uri.scheme == null) { // this is a local image
                loadImageAssetAsBitmap(appContext, backgroundImageUrlString)
            } else {
                val connection = URL(backgroundImageUrlString).openConnection().apply {
                    connectTimeout = REMOTE_IMAGE_TIMEOUT_MS
                    readTimeout = REMOTE_IMAGE_TIMEOUT_MS
                }
                connection.getInputStream().use { input ->
                    BitmapFactory.decodeStream(input)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load virtual-background image (host=$host)", e)
            null
        }
        if (bitmap == null) {
            Log.e(TAG, "Virtual-background image is missing or could not be decoded (host=$host)")
        }
        virtualBackgroundBitmap = bitmap
    }

    private val foregroundPaint by lazy {
        // destination - video frame
        // source - black mask bitmap of person cutout
        // DST_IN - Keeps the destination pixels that are covered by source pixels.
        Paint().apply {
            xfermode = PorterDuffXfermode(PorterDuff.Mode.DST_IN)
        }
    }

    private val backgroundPaint by lazy {
        // destination - video frame
        // source - scaled video background frame
        // DST_OVER - Source pixels are drawn behind the destination pixels
        Paint().apply { xfermode = PorterDuffXfermode(PorterDuff.Mode.DST_OVER) }
    }

    fun loadImageAssetAsBitmap(context: Context, assetPath: String): Bitmap? {
        var bitmap: Bitmap? = null
        var inputStream: InputStream? = null

        try {
            inputStream = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                context.assets.open("flutter_assets/$assetPath")
            } else {
                val assetLookupKey = FlutterInjector.instance()
                    .flutterLoader()
                    .getLookupKeyForAsset(assetPath)
                val assetManager = context.assets
                val assetFileDescriptor = assetManager.openFd(assetLookupKey)
                assetFileDescriptor.createInputStream()
            }

            bitmap = BitmapFactory.decodeStream(inputStream)
            return bitmap
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            inputStream?.close()
        }
        return null
    }

    private var scaledVirtualBackgroundBitmap: Bitmap? = null
    private var scaleBetweenSourceAndMask: Pair<Float, Float>? = null
    private var maskArray: IntArray? = null
    private var lineBuffer: FloatArray? = null

    private var latestFrameWidth: Int? = null
    private var latestFrameHeight: Int? = null

    private var latestMaskWidth = 0
    private var latestMaskHeight = 0

    override fun applyFilter(videoFrameBitmap: Bitmap) {
        // Null while the image is still loading or when it failed to load. The frame
        // is then still processed, with a blurred copy of itself as the background,
        // so the real background is never sent unfiltered.
        val backgroundImageBitmap = virtualBackgroundBitmap

        if (!isProcessing.getAndSet(true)) {
            // Apply segmentation, starts in webrtc CaptureThread
            val mlImage = InputImage.fromBitmap(videoFrameBitmap, 0)
            segmenter.process(mlImage).addOnSuccessListener { mask ->
                // callbacks happen in main thread
                segmentationMask = mask
            }.addOnFailureListener { e ->
                Log.e(TAG, "Failed to segment image", e)
            }.addOnCompleteListener {
                isProcessing.set(false)
            }
        }

        val mask = segmentationMask
        if (mask == null) {
            // The first segmentation is still running: blur the whole frame rather
            // than sending the raw camera image through until a mask arrives.
            Canvas(videoFrameBitmap).drawBitmap(blurredCopy(videoFrameBitmap), 0f, 0f, null)
            return
        }

        maybeInit(videoFrameBitmap, backgroundImageBitmap, mask)

        if (mask !== processedSegmentationMask) {
            // Color the foreground segment (the person) to a bitmap - foregroundBitmap
            colouredSegmentInt(
                segment = Segment.FOREGROUND,
                destination = foregroundMaskBitmap!!,
                segmentationMask = mask,
                confidenceThreshold = foregroundThreshold,
                maskArray = maskArray!!,
                lineBuffer = lineBuffer!!
            )
            val canvas = Canvas(scaledForegroundBitmap!!)
            // Clear the bitmap before drawing (important to avoid artifacts!)
            canvas.drawColor(0, PorterDuff.Mode.CLEAR)
            // scale the masked bitmap to the video frame size
            canvas.drawBitmap(
                foregroundMaskBitmap!!,
                scaleBetweenSourceAndMaskMatrix!!,
                upscalePaint
            )
            // Mark this mask as processed
            processedSegmentationMask = mask
        }

        // Resolve the background before the frame is modified below: the fallback
        // blurs the frame itself.
        val background = scaledVirtualBackgroundBitmap?.takeUnless { it.isRecycled }
            ?: blurredCopy(videoFrameBitmap)

        val canvas = Canvas(videoFrameBitmap)
        // 1. Punch a hole in the video frame so that only the person is left
        canvas.drawBitmap(scaledForegroundBitmap!!, 0f, 0f, foregroundPaint)

        // 2. Draw the virtual background (or the blurred fallback) behind the person
        canvas.drawBitmap(background, 0f, 0f, backgroundPaint)
    }

    // Reused by blurredCopy: a half-resolution scratch bitmap and the full-size result.
    private var fallbackHalfBitmap: Bitmap? = null
    private var fallbackBitmap: Bitmap? = null
    private val fallbackDownScaleMatrix by lazy { Matrix().apply { preScale(0.5f, 0.5f) } }
    private val fallbackUpScaleMatrix by lazy { Matrix().apply { preScale(2f, 2f) } }
    private val fallbackPaint by lazy { Paint().apply { isFilterBitmap = true } }

    /**
     * A blurred copy of [frame] at its size, used as the background while the image is
     * unavailable and as the whole frame while the first mask is still being computed.
     * Blurs a 0.5-scale copy at [FALLBACK_BLUR_RADIUS], which matches the MEDIUM
     * background-blur preset and avoids a full-resolution CPU blur on every frame.
     * The returned bitmap is owned by this filter and reused across frames.
     */
    private fun blurredCopy(frame: Bitmap): Bitmap {
        val halfWidth = (frame.width / 2).coerceAtLeast(1)
        val halfHeight = (frame.height / 2).coerceAtLeast(1)
        var half = fallbackHalfBitmap
        if (half == null || half.width != halfWidth || half.height != halfHeight) {
            half?.recycle()
            half = Bitmap.createBitmap(halfWidth, halfHeight, Bitmap.Config.ARGB_8888)
            fallbackHalfBitmap = half
        }
        var result = fallbackBitmap
        if (result == null || result.width != frame.width || result.height != frame.height) {
            result?.recycle()
            result = Bitmap.createBitmap(frame.width, frame.height, Bitmap.Config.ARGB_8888)
            fallbackBitmap = result
        }

        Canvas(half).drawBitmap(frame, fallbackDownScaleMatrix, fallbackPaint)
        val blurredHalf = Toolkit.blur(half, FALLBACK_BLUR_RADIUS)
        Canvas(result).drawBitmap(blurredHalf, fallbackUpScaleMatrix, fallbackPaint)
        blurredHalf.recycle()
        return result
    }

    private fun scaleVirtualBackgroundBitmap(bitmap: Bitmap, targetHeight: Int): Bitmap {
        val scale = targetHeight.toFloat() / bitmap.height
        return ensureAlpha(
            Bitmap.createScaledBitmap(
                /* src = */
                bitmap,
                /* dstWidth = */
                (bitmap.width * scale).toInt(),
                /* dstHeight = */
                targetHeight,
                /* filter = */
                true,
            ),
        )
    }

    private fun ensureAlpha(original: Bitmap): Bitmap {
        return if (original.hasAlpha()) {
            original
        } else {
            val bitmapWithAlpha = Bitmap.createBitmap(
                original.width,
                original.height,
                Bitmap.Config.ARGB_8888,
            )
            val canvas = Canvas(bitmapWithAlpha)
            canvas.drawBitmap(original, 0f, 0f, null)
            bitmapWithAlpha
        }
    }

    private fun maybeInit(
        videoFrameBitmap: Bitmap, backgroundImageBitmap: Bitmap?, mask: SegmentationMask
    ) {
        var createScale = false
        if ((scaledVirtualBackgroundBitmap == null && backgroundImageBitmap != null) || scaledForegroundBitmap == null || videoFrameBitmap.width != latestFrameWidth || videoFrameBitmap.height != latestFrameHeight) {
            scaledVirtualBackgroundBitmap?.recycle()
            scaledForegroundBitmap?.recycle()
            scaledVirtualBackgroundBitmap = backgroundImageBitmap?.let {
                scaleVirtualBackgroundBitmap(
                    bitmap = it,
                    targetHeight = videoFrameBitmap.height,
                )
            }
            scaledForegroundBitmap = Bitmap.createBitmap(
                videoFrameBitmap.width, videoFrameBitmap.height, Bitmap.Config.ARGB_8888
            )
            latestFrameWidth = videoFrameBitmap.width
            latestFrameHeight = videoFrameBitmap.height
            createScale = true
        }
        if (latestMaskWidth != mask.width || latestMaskHeight != mask.height) {
            latestMaskWidth = mask.width
            latestMaskHeight = mask.height
            foregroundMaskBitmap?.recycle()
            foregroundMaskBitmap =
                Bitmap.createBitmap(latestMaskWidth, latestMaskHeight, Bitmap.Config.ARGB_8888)
            maskArray = IntArray(latestMaskWidth * latestMaskHeight)
            lineBuffer = FloatArray(latestMaskWidth)
            createScale = true
        }

        if (createScale || scaleBetweenSourceAndMask == null) {
            scaleBetweenSourceAndMask = getScalingFactors(
                widths = Pair(videoFrameBitmap.width, mask.width),
                heights = Pair(videoFrameBitmap.height, mask.height),
            )

            scaleBetweenSourceAndMaskMatrix = Matrix().apply {
                preScale(
                    scaleBetweenSourceAndMask!!.first, scaleBetweenSourceAndMask!!.second
                )
            }
        }
    }

    companion object {
        private const val TAG = "VirtualBackgroundVideoFilter"
        // Radius for the 0.5-scale blurred fallback (see blurredCopy): the same scale and
        // radius as the MEDIUM background-blur preset.
        private const val FALLBACK_BLUR_RADIUS = 10
        private const val REMOTE_IMAGE_TIMEOUT_MS = 10_000
    }
}

private const val DEFAULT_FOREGROUND_THRESHOLD: Double =
    0.9 // 1 is max confidence that pixel is in the foreground