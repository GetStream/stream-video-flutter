package io.getstream.video.flutter.stream_video_filters.factories

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Matrix
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import com.google.android.renderscript.Toolkit
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.segmentation.Segmentation
import com.google.mlkit.vision.segmentation.SegmentationMask
import com.google.mlkit.vision.segmentation.selfie.SelfieSegmenterOptions
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessor
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessorFactoryInterface
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
import java.util.concurrent.atomic.AtomicBoolean

// Original Sources
// https://github.com/GetStream/stream-video-android/blob/develop/stream-video-android-filters-video/src/main/kotlin/io/getstream/video/android/filters/video/BlurredBackgroundVideoFilter.kt
/**
 * Applies a blur effect to the background of a video call.
 *
 * @param blurIntensity The intensity of the blur effect. See [BlurIntensity] for options. Defaults to [BlurIntensity.MEDIUM].
 * @param foregroundThreshold The confidence at which a pixel counts as foreground. The mask
 * ramps smoothly from background to foreground around this value, so pixels with a confidence
 * well above it are fully in the foreground and well below it fully in the background.
 * Value is coerced between 0 and 1, inclusive.
 */
class BackgroundBlurFactory(
    private val blurIntensity: BlurIntensity = BlurIntensity.MEDIUM,
    private val foregroundThreshold: Double = DEFAULT_FOREGROUND_THRESHOLD,
) : VideoFrameProcessorFactoryInterface {
    override fun build(): VideoFrameProcessor {
        return VideoFrameProcessorWithBitmapFilter {
            BlurredBackgroundVideoFilter(blurIntensity, foregroundThreshold)
        }
    }
}

private class BlurredBackgroundVideoFilter(
    private val blurIntensity: BlurIntensity,
    foregroundThreshold: Double,
) : BitmapVideoFilter() {
    private val options =
        SelfieSegmenterOptions.Builder().setDetectorMode(SelfieSegmenterOptions.STREAM_MODE)
            .enableRawSizeMask().build()
    private val segmenter = Segmentation.getClient(options)

    @Volatile // volatile as its get and set happen in different threads
    private var segmentationResult: SegmentationResult? = null
    private var processedSegmentationMask: SegmentationMask? = null

    // used for throttling, we dont want to send to ML model when there is an ongoing processing
    // atomic as its get and set happen in different threads
    private val isProcessing = AtomicBoolean(false)
    private var foregroundThreshold: Double = foregroundThreshold.coerceIn(0.0, 1.0)
    private var scaleBetweenSourceAndMask: Pair<Float, Float>? = null
    private var scaleBetweenSourceAndMaskMatrix: Matrix? = null

    // The copy of the frame that ML Kit segments; see SegmentationInput.
    private val segmentationInput = SegmentationInput()
    private val fallbackBlur = DownscaledBlur()
    private val segmentationErrorLog = ThrottledLog("VideoFilters")

    // Alpha mask of the background at the raw mask size, and the buffers that build it
    private var backgroundMaskBitmap: Bitmap? = null
    private var maskBuffers: SegmentMaskBuffers? = null

    // bitmap to hold a downscaled version (0.5) of the actual background, to optimise blur step
    private var downScaledBackgroundBitmap: Bitmap? = null

    private val downScaleMatrix by lazy { Matrix().apply { preScale(0.5f, 0.5f) } }
    private val downScalePaint by lazy {
        Paint().apply {
            // apply bilinear filtering by scaling
            isFilterBitmap = true
        }
    }
    private var maskToDownScaledBackgroundScale: Matrix? = null
    private val maskToDownScalePaint by lazy {
        // destination - downscaled background
        // source - alpha mask of the background
        // DST_IN - Keeps the destination pixels that are covered by source pixels,
        // weighted by the source alpha, so the soft mask edge blends into the person.
        Paint().apply {
            xfermode = PorterDuffXfermode(PorterDuff.Mode.DST_IN)
            // Sample the ~256x256 mask bilinearly when scaling it up. Without this
            // every mask texel becomes a visible block at the edge.
            isFilterBitmap = true
            // smooth the edges
            isAntiAlias = true
        }
    }

    // scale for downscaled blurred background to videoframe size
    private val upScaleMatrix by lazy { Matrix().apply { preScale(2f, 2f) } }

    private var currentFrameWidth = 0
    private var currentFrameHeight = 0
    private var currentMaskWidth = 0
    private var currentMaskHeight = 0


    override fun applyFilter(videoFrameBitmap: Bitmap) {
        if (!isProcessing.getAndSet(true)) {
            // Apply segmentation. ML Kit reads its input after this method has already
            // drawn into videoFrameBitmap, so it gets a copy taken before that.
            val frameWidth = videoFrameBitmap.width
            val frameHeight = videoFrameBitmap.height
            val mlImage = InputImage.fromBitmap(segmentationInput.snapshot(videoFrameBitmap), 0)
            segmenter.process(mlImage).addOnSuccessListener { mask ->
                segmentationResult = SegmentationResult(mask, frameWidth, frameHeight)
            }.addOnFailureListener { e ->
                segmentationErrorLog.e("Failed to segment image", e)
            }.addOnCompleteListener {
                isProcessing.set(false)
            }
        }

        val result = segmentationResult
        if (result == null) {
            // The first segmentation is still running (this includes loading the
            // model): blur the whole frame rather than sending the raw camera image
            // through until a mask arrives.
            fallbackBlur.blurInPlace(videoFrameBitmap)
            return
        }
        if (!result.isFromFrameOfSize(videoFrameBitmap.width, videoFrameBitmap.height)) {
            // The mask comes from a frame of another size (rotation), so it no longer
            // lines up with this frame. Blur the whole frame until a matching mask
            // arrives rather than letting the stretched mask expose the background.
            fallbackBlur.blurInPlace(videoFrameBitmap)
            return
        }
        val mask = result.mask

        maybeInit(videoFrameBitmap, mask)

        if (mask !== processedSegmentationMask) {
            writeSoftSegmentMask(
                segment = Segment.BACKGROUND,
                destination = backgroundMaskBitmap!!,
                segmentationMask = mask,
                confidenceThreshold = foregroundThreshold,
                edgeSoftness = DEFAULT_MASK_EDGE_SOFTNESS,
                temporalWeight = DEFAULT_MASK_TEMPORAL_WEIGHT,
                buffers = maskBuffers!!,
            )
            processedSegmentationMask = mask
        }

        val scaledBackgroundCanvas = Canvas(downScaledBackgroundBitmap!!)
        scaledBackgroundCanvas.drawBitmap(
            videoFrameBitmap, downScaleMatrix, downScalePaint
        )

        scaledBackgroundCanvas.drawBitmap(
            backgroundMaskBitmap!!,
            maskToDownScaledBackgroundScale!!,
            maskToDownScalePaint
        )

        // Blur the background bitmap
        val blurredBackgroundBitmap =
            Toolkit.blur(downScaledBackgroundBitmap!!, blurIntensity.radius)

        // Draw the blurred background bitmap on the original bitmap
        val canvas = Canvas(videoFrameBitmap)
        canvas.drawBitmap(blurredBackgroundBitmap, upScaleMatrix, downScalePaint)

        blurredBackgroundBitmap.recycle()
    }

    private fun maybeInit(videoFrameBitmap: Bitmap, mask: SegmentationMask) {
        var createScale = false
        if (currentFrameWidth != videoFrameBitmap.width || currentFrameHeight != videoFrameBitmap.height) {
            currentFrameWidth = videoFrameBitmap.width
            currentFrameHeight = videoFrameBitmap.height
            // The scene geometry changed (rotation): the previous masks must not be
            // blended into the new ones.
            maskBuffers?.hasSmoothedConfidence = false
            downScaledBackgroundBitmap?.recycle()
            downScaledBackgroundBitmap = Bitmap.createBitmap(
                currentFrameWidth / 2, currentFrameHeight / 2, Bitmap.Config.ARGB_8888
            )
            createScale = true
        }
        if (currentMaskWidth != mask.width || currentMaskHeight != mask.height) {
            currentMaskWidth = mask.width
            currentMaskHeight = mask.height
            backgroundMaskBitmap?.recycle()
            backgroundMaskBitmap =
                Bitmap.createBitmap(currentMaskWidth, currentMaskHeight, Bitmap.Config.ARGB_8888)
            // New buffers also restart the temporal smoothing: a mask of another size
            // cannot be blended with the previous one.
            maskBuffers = SegmentMaskBuffers(currentMaskWidth, currentMaskHeight)
            createScale = true
        }

        if (createScale || scaleBetweenSourceAndMask == null) {
            scaleBetweenSourceAndMask = getScalingFactors(
                widths = Pair(currentFrameWidth, currentMaskWidth),
                heights = Pair(currentFrameHeight, currentMaskHeight),
            )
            scaleBetweenSourceAndMaskMatrix = Matrix().apply {
                preScale(
                    scaleBetweenSourceAndMask!!.first, scaleBetweenSourceAndMask!!.second
                )
            }
            maskToDownScaledBackgroundScale = Matrix().apply {
                preScale(
                    scaleBetweenSourceAndMask!!.first / 2, scaleBetweenSourceAndMask!!.second / 2
                )
            }
        }
    }
}

/**
 * The intensity of the background blur effect. Used in [BlurredBackgroundVideoFilter].
 * Range is 1 to 25
 */
enum class BlurIntensity(val radius: Int) {
    LIGHT(5),
    MEDIUM(10),
    HEAVY(15),
}

// Midpoint of the soft edge (see DEFAULT_MASK_EDGE_SOFTNESS): with the default softness
// a pixel is fully foreground from 0.8 up and fully background from 0.4 down, so hair
// and accessories, which the model is least sure about, stay partly visible.
private const val DEFAULT_FOREGROUND_THRESHOLD: Double = 0.6
