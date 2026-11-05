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
import android.os.Build
import android.util.Log
import androidx.annotation.Keep
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.segmentation.Segmentation
import com.google.mlkit.vision.segmentation.SegmentationMask
import com.google.mlkit.vision.segmentation.selfie.SelfieSegmenterOptions
import io.flutter.FlutterInjector
import io.getstream.video.flutter.stream_video_filters.common.BitmapVideoFilter
import io.getstream.video.flutter.stream_video_filters.common.DEFAULT_MASK_EDGE_SOFTNESS
import io.getstream.video.flutter.stream_video_filters.common.DEFAULT_MASK_TEMPORAL_WEIGHT
import io.getstream.video.flutter.stream_video_filters.common.DownscaledBlur
import io.getstream.video.flutter.stream_video_filters.common.SegmentationResult
import io.getstream.video.flutter.stream_video_filters.common.Segment
import io.getstream.video.flutter.stream_video_filters.common.SegmentMaskBuffers
import io.getstream.video.flutter.stream_video_filters.common.SegmentationInput
import io.getstream.video.flutter.stream_video_filters.common.ThrottledLog
import io.getstream.video.flutter.stream_video_filters.common.VideoFrameProcessorWithBitmapFilter
import io.getstream.video.flutter.stream_video_filters.common.getScalingFactors
import io.getstream.video.flutter.stream_video_filters.common.writeSoftSegmentMask
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessor
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessorFactoryInterface
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream
import java.net.URL
import java.util.concurrent.atomic.AtomicBoolean

/**
 * original source: https://github.com/GetStream/stream-video-android/blob/develop/stream-video-android-filters-video/src/main/kotlin/io/getstream/video/android/filters/video/VirtualBackgroundVideoFilter.kt
 *
 * Applies a virtual background (custom image) to a video call.
 *
 * @param backgroundImageUrlString The image url of the custom background image.
 * @param foregroundThreshold The confidence at which a pixel counts as foreground. The mask
 * ramps smoothly from background to foreground around this value, so pixels with a confidence
 * well above it are fully in the foreground and well below it fully in the background.
 * Value is coerced between 0 and 1, inclusive.
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
 * @param foregroundThreshold The confidence at which a pixel counts as foreground; see
 * [VirtualBackgroundFactory]. Value is coerced between 0 and 1, inclusive.
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
    private var segmentationResult: SegmentationResult? = null
    private var processedSegmentationMask: SegmentationMask? = null
    private var scaleBetweenSourceAndMaskMatrix: Matrix? = null

    // used for throttling, we dont want to send to ML model when there is an ongoing processing
    // atomic as its get and set happen in different threads
    private val isProcessing = AtomicBoolean(false)
    private var foregroundThreshold: Double = foregroundThreshold.coerceIn(0.0, 1.0)

    // The copy of the frame that ML Kit segments; see SegmentationInput.
    private val segmentationInput = SegmentationInput()
    private val fallbackBlur = DownscaledBlur()
    private val segmentationErrorLog = ThrottledLog(TAG)

    // Alpha mask of the person at the raw mask size, and the buffers that build it
    private var foregroundMaskBitmap: Bitmap? = null
    private var maskBuffers: SegmentMaskBuffers? = null

    // bitmap to upscale the mask bitmap to video frame size
    private var scaledForegroundBitmap: Bitmap? = null
    private val upscalePaint: Paint by lazy {
        Paint().apply {
            // Sample the ~256x256 mask bilinearly when scaling it up to the frame.
            // Without this every mask texel becomes a visible block at the edge.
            isFilterBitmap = true
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
            val bytes = if (uri.scheme == null) { // this is a local image
                readImageAssetBytes(appContext, backgroundImageUrlString)
            } else {
                val connection = URL(backgroundImageUrlString).openConnection().apply {
                    connectTimeout = REMOTE_IMAGE_TIMEOUT_MS
                    readTimeout = REMOTE_IMAGE_TIMEOUT_MS
                }
                connection.getInputStream().use { input -> readLimited(input) }
            }
            bytes?.let { decodeDownsampled(it) }
        } catch (e: Throwable) {
            // Throwable, not Exception: this runs on its own thread, where an
            // OutOfMemoryError from a large image would otherwise crash the app.
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
        // source - alpha mask of the person cutout
        // DST_IN - Keeps the destination pixels that are covered by source pixels,
        // weighted by the source alpha, so the soft mask edge blends into the background.
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

    /**
     * Reads [input] fully, failing once it exceeds [MAX_REMOTE_IMAGE_BYTES] so an
     * unexpectedly large response cannot exhaust memory.
     */
    private fun readLimited(input: InputStream): ByteArray {
        val output = ByteArrayOutputStream()
        val chunk = ByteArray(DEFAULT_BUFFER_SIZE)
        while (true) {
            val read = input.read(chunk)
            if (read < 0) break
            if (output.size() + read > MAX_REMOTE_IMAGE_BYTES) {
                throw IOException("Image is larger than $MAX_REMOTE_IMAGE_BYTES bytes")
            }
            output.write(chunk, 0, read)
        }
        return output.toByteArray()
    }

    private fun readImageAssetBytes(context: Context, assetPath: String): ByteArray? {
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

            return inputStream.readBytes()
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            inputStream?.close()
        }
        return null
    }

    /**
     * Decodes [bytes] with the smallest power-of-two `inSampleSize` that brings the
     * longest side to at most [MAX_DECODED_IMAGE_SIDE], so a large photo does not
     * cost tens of megabytes (and a possible OOM) only to be scaled to the frame.
     */
    private fun decodeDownsampled(bytes: ByteArray): Bitmap? {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeByteArray(bytes, 0, bytes.size, bounds)
        var sampleSize = 1
        var longSide = maxOf(bounds.outWidth, bounds.outHeight)
        while (longSide > MAX_DECODED_IMAGE_SIDE) {
            sampleSize *= 2
            longSide /= 2
        }
        val options = BitmapFactory.Options().apply { inSampleSize = sampleSize }
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.size, options)
    }

    private var scaledVirtualBackgroundBitmap: Bitmap? = null
    private var scaleBetweenSourceAndMask: Pair<Float, Float>? = null

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
            // Apply segmentation, starts in webrtc CaptureThread. ML Kit reads its
            // input after this method has already drawn into videoFrameBitmap, so it
            // gets a copy taken before that.
            val frameWidth = videoFrameBitmap.width
            val frameHeight = videoFrameBitmap.height
            val mlImage = InputImage.fromBitmap(segmentationInput.snapshot(videoFrameBitmap), 0)
            segmenter.process(mlImage).addOnSuccessListener { mask ->
                // callbacks happen in main thread
                segmentationResult = SegmentationResult(mask, frameWidth, frameHeight)
            }.addOnFailureListener { e ->
                segmentationErrorLog.e("Failed to segment image", e)
            }.addOnCompleteListener {
                isProcessing.set(false)
            }
        }

        val result = segmentationResult
        if (result == null) {
            // The first segmentation is still running: blur the whole frame rather
            // than sending the raw camera image through until a mask arrives.
            fallbackBlur.blurInPlace(videoFrameBitmap)
            return
        }
        val mask = result.mask

        maybeInit(videoFrameBitmap, backgroundImageBitmap, mask)

        if (mask !== processedSegmentationMask) {
            // A mask from a frame of another size (rotation) still covers the frames
            // until the next one, but is not blended into the smoothing history.
            val stale = !result.isFromFrameOfSize(videoFrameBitmap.width, videoFrameBitmap.height)
            // Write the person as a soft alpha mask - foregroundMaskBitmap
            writeSoftSegmentMask(
                segment = Segment.FOREGROUND,
                destination = foregroundMaskBitmap!!,
                segmentationMask = mask,
                confidenceThreshold = foregroundThreshold,
                edgeSoftness = DEFAULT_MASK_EDGE_SOFTNESS,
                temporalWeight = if (stale) 1.0 else DEFAULT_MASK_TEMPORAL_WEIGHT,
                buffers = maskBuffers!!,
            )
            if (stale) {
                maskBuffers!!.hasSmoothedConfidence = false
            }
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
            ?: fallbackBlur.blurred(videoFrameBitmap)

        val canvas = Canvas(videoFrameBitmap)
        // 1. Punch a hole in the video frame so that only the person is left
        canvas.drawBitmap(scaledForegroundBitmap!!, 0f, 0f, foregroundPaint)

        // 2. Draw the virtual background (or the blurred fallback) behind the person
        canvas.drawBitmap(background, 0f, 0f, backgroundPaint)
    }

    private val scalePaint by lazy { Paint(Paint.FILTER_BITMAP_FLAG) }

    /**
     * A new ARGB_8888 bitmap (required by the DST_OVER draw) with [bitmap] scaled to
     * [targetHeight]. Always a new bitmap: `Bitmap.createScaledBitmap` returns the
     * source itself when the size already matches, and that source is the decoded
     * image, which must survive the recycle on the next frame-size change.
     */
    private fun scaleVirtualBackgroundBitmap(bitmap: Bitmap, targetHeight: Int): Bitmap {
        val scale = targetHeight.toFloat() / bitmap.height
        val targetWidth = (bitmap.width * scale).toInt().coerceAtLeast(1)
        val scaled = Bitmap.createBitmap(targetWidth, targetHeight, Bitmap.Config.ARGB_8888)
        val matrix = Matrix().apply { setScale(scale, scale) }
        Canvas(scaled).drawBitmap(bitmap, matrix, scalePaint)
        return scaled
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
            // The new foreground bitmap is blank: redraw the current mask into it
            // below even if it is the one already processed, or DST_IN with an
            // empty mask erases the person until the next mask arrives.
            processedSegmentationMask = null
            if (videoFrameBitmap.width != latestFrameWidth || videoFrameBitmap.height != latestFrameHeight) {
                // The scene geometry changed (rotation): the previous masks must
                // not be blended into the new ones.
                maskBuffers?.hasSmoothedConfidence = false
            }
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
            // New buffers also restart the temporal smoothing: a mask of another size
            // cannot be blended with the previous one.
            maskBuffers = SegmentMaskBuffers(latestMaskWidth, latestMaskHeight)
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
        private const val REMOTE_IMAGE_TIMEOUT_MS = 10_000
        // Longest side the background image is decoded at. The frame is at most a
        // few thousand pixels wide, and a full-resolution decode of a camera photo
        // (12 MP, ~48 MB) is what the capture thread would otherwise scale down.
        private const val MAX_DECODED_IMAGE_SIDE = 2048
        // Largest remote image downloaded; well above any reasonable background photo.
        private const val MAX_REMOTE_IMAGE_BYTES = 20 * 1024 * 1024
    }
}

// Midpoint of the soft edge (see DEFAULT_MASK_EDGE_SOFTNESS): with the default softness
// a pixel is fully foreground from 0.8 up and fully background from 0.4 down, so hair
// and accessories, which the model is least sure about, stay partly visible.
private const val DEFAULT_FOREGROUND_THRESHOLD: Double = 0.6
