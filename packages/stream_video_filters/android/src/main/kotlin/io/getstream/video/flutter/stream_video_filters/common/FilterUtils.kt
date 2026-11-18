package io.getstream.video.flutter.stream_video_filters.common

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Matrix
import android.graphics.Paint
import android.os.SystemClock
import android.util.Log
import com.google.android.renderscript.Toolkit
import com.google.mlkit.vision.segmentation.SegmentationMask

/**
 * Width, in confidence units, of the transition between background and foreground.
 * A texel whose confidence is more than half of this below the threshold is fully
 * background, more than half above it is fully foreground, and in between the mask
 * ramps smoothly. A hard cut-off (0) turns every confidence wobble at the edge into
 * a visible flicker and leaves the upscaled mask with a staircase outline.
 */
internal const val DEFAULT_MASK_EDGE_SOFTNESS = 0.4

/**
 * Weight of a new segmentation mask against the smoothed previous ones, in (0, 1].
 * 1 disables temporal smoothing. Lower values hide single-mask glitches (an accessory
 * briefly classified as background) at the cost of the edge lagging slightly behind
 * fast movement.
 */
internal const val DEFAULT_MASK_TEMPORAL_WEIGHT = 0.6

/**
 * Longest side of the frame copy handed to ML Kit. The selfie model works on a
 * 256x256 input, and ML Kit resizes the copy to that itself. 640 keeps the copy
 * and that resize cheap while leaving the source at more than twice the model's
 * resolution, so the resize still averages over enough pixels for a clean edge.
 */
internal const val SEGMENTATION_INPUT_LONG_SIDE = 640

private const val MIN_EDGE_RANGE = 0.001f
private const val MIN_TEMPORAL_WEIGHT = 0.05f

/**
 * Buffers reused across masks of the same size by [writeSoftSegmentMask]: the ARGB
 * pixels written to the mask bitmap, a line buffer for reading ML Kit's float mask,
 * and the temporally smoothed confidence of every texel.
 */
internal class SegmentMaskBuffers(val width: Int, val height: Int) {
    val pixels = IntArray(width * height)
    val lineBuffer = FloatArray(width)
    val smoothedConfidence = FloatArray(width * height)

    /** False until the first mask has been written; that one is taken as is. */
    var hasSmoothedConfidence = false
}

/**
 * Writes [segment] of [segmentationMask] into [destination] as an alpha mask: black
 * with alpha 255 where a texel belongs to the segment, transparent where it does
 * not, and a smooth ramp over [edgeSoftness] around [confidenceThreshold] in between.
 *
 * The confidence of every texel is first blended with the previous masks' using
 * [temporalWeight] for the new one, so a texel that only briefly flips between
 * person and background does not blink. [destination] and [buffers] must match the
 * mask size.
 */
internal fun writeSoftSegmentMask(
    segment: Segment,
    // ARGB_8888 bitmap of the mask size
    destination: Bitmap,
    segmentationMask: SegmentationMask,
    confidenceThreshold: Double,
    edgeSoftness: Double,
    temporalWeight: Double,
    buffers: SegmentMaskBuffers,
) {
    val width = segmentationMask.width
    val height = segmentationMask.height
    require(buffers.width == width && buffers.height == height) {
        "Mask buffers are ${buffers.width}x${buffers.height}, mask is ${width}x$height"
    }

    // ML Kit returns the foreground probability of every texel as a float, packed
    // in a byte buffer.
    val probabilities = segmentationMask.buffer.asFloatBuffer()
    probabilities.rewind()

    // Clamp the ramp to the confidence range, so a threshold near 0 or 1 still
    // reaches fully transparent and fully opaque at the ends.
    val lower = (confidenceThreshold - edgeSoftness / 2).coerceAtLeast(0.0).toFloat()
    val upper = (confidenceThreshold + edgeSoftness / 2).coerceAtMost(1.0).toFloat()
    val range = (upper - lower).coerceAtLeast(MIN_EDGE_RANGE)
    val newWeight = temporalWeight.toFloat().coerceIn(MIN_TEMPORAL_WEIGHT, 1f)
    val oldWeight = 1f - newWeight
    val blendWithPrevious = buffers.hasSmoothedConfidence
    val smoothed = buffers.smoothedConfidence
    val pixels = buffers.pixels
    val lineBuffer = buffers.lineBuffer
    val isForeground = segment == Segment.FOREGROUND

    var index = 0
    for (y in 0 until height) {
        probabilities.get(lineBuffer)
        for (x in 0 until width) {
            val confidence =
                if (blendWithPrevious) {
                    smoothed[index] * oldWeight + lineBuffer[x] * newWeight
                } else {
                    lineBuffer[x]
                }
            smoothed[index] = confidence

            // Smoothstep from 0 at `lower` to 1 at `lower + range`.
            val t = ((confidence - lower) / range).coerceIn(0f, 1f)
            val foreground = t * t * (3f - 2f * t)
            val alpha = if (isForeground) foreground else 1f - foreground
            pixels[index] = (alpha * 255f + 0.5f).toInt() shl 24
            index++
        }
    }
    buffers.hasSmoothedConfidence = true

    destination.setPixels(pixels, 0, width, 0, 0, width, height)
}

internal enum class Segment {
    FOREGROUND, BACKGROUND
}

/**
 * A finished ML Kit mask together with the size of the frame its input was taken
 * from. A mask from a frame of another size (rotation) does not line up with the
 * current frame, so the filters blur the whole frame until a matching one arrives.
 */
internal class SegmentationResult(
    val mask: SegmentationMask,
    val frameWidth: Int,
    val frameHeight: Int,
) {
    fun isFromFrameOfSize(width: Int, height: Int) =
        frameWidth == width && frameHeight == height
}

/**
 * A full-frame Gaussian blur done on a half-resolution copy, with the radius of the
 * MEDIUM background-blur preset. Used in place of the real background while no mask
 * or no background image is available yet, so the camera image is never sent
 * unfiltered. Owns and reuses its scratch bitmaps.
 */
internal class DownscaledBlur(private val radius: Int = FALLBACK_BLUR_RADIUS) {
    private var halfBitmap: Bitmap? = null
    private var resultBitmap: Bitmap? = null
    private val downScaleMatrix = Matrix().apply { preScale(0.5f, 0.5f) }
    private val upScaleMatrix = Matrix().apply { preScale(2f, 2f) }
    private val paint = Paint(Paint.FILTER_BITMAP_FLAG)

    /** A blurred copy of [frame] at its size, owned by this object and reused. */
    fun blurred(frame: Bitmap): Bitmap {
        val halfWidth = (frame.width / 2).coerceAtLeast(1)
        val halfHeight = (frame.height / 2).coerceAtLeast(1)
        var half = halfBitmap
        if (half == null || half.width != halfWidth || half.height != halfHeight) {
            half?.recycle()
            half = Bitmap.createBitmap(halfWidth, halfHeight, Bitmap.Config.ARGB_8888)
            halfBitmap = half
        }
        var result = resultBitmap
        if (result == null || result.width != frame.width || result.height != frame.height) {
            result?.recycle()
            result = Bitmap.createBitmap(frame.width, frame.height, Bitmap.Config.ARGB_8888)
            resultBitmap = result
        }

        Canvas(half).drawBitmap(frame, downScaleMatrix, paint)
        val blurredHalf = Toolkit.blur(half, radius)
        Canvas(result).drawBitmap(blurredHalf, upScaleMatrix, paint)
        blurredHalf.recycle()
        return result
    }

    /** Replaces [frame] with a blurred copy of itself. */
    fun blurInPlace(frame: Bitmap) {
        Canvas(frame).drawBitmap(blurred(frame), 0f, 0f, null)
    }

    companion object {
        // The same scale and radius as the MEDIUM background-blur preset.
        private const val FALLBACK_BLUR_RADIUS = 10
    }
}

/**
 * A reusable, downscaled copy of the video frame that is handed to ML Kit.
 *
 * `InputImage.fromBitmap` only keeps a reference to the bitmap, and ML Kit reads it
 * on its own executor after `process()` has returned, while the filter keeps drawing
 * the composite into the frame bitmap on the capture thread. Segmenting the frame
 * bitmap itself therefore often segments a frame whose background has already been
 * replaced, feeding the previous mask's edge errors into the next mask. The copy is
 * written only while no segmentation is in flight.
 */
internal class SegmentationInput(private val maxLongSide: Int = SEGMENTATION_INPUT_LONG_SIDE) {
    private var bitmap: Bitmap? = null
    private val matrix = Matrix()
    private val paint = Paint(Paint.FILTER_BITMAP_FLAG)

    /** Copies [frame] into the reused bitmap and returns it. */
    fun snapshot(frame: Bitmap): Bitmap {
        val scale = minOf(1f, maxLongSide.toFloat() / maxOf(frame.width, frame.height))
        val width = (frame.width * scale).toInt().coerceAtLeast(1)
        val height = (frame.height * scale).toInt().coerceAtLeast(1)

        var target = bitmap
        if (target == null || target.width != width || target.height != height) {
            target?.recycle()
            target = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            bitmap = target
        }
        matrix.setScale(width.toFloat() / frame.width, height.toFloat() / frame.height)
        Canvas(target).drawBitmap(frame, matrix, paint)
        return target
    }
}

/**
 * Computes the ratio between the bitmap dimensions and the segmentation mask dimensions.
 * This allows us to map mask coordinates back to the original bitmap coordinates.
 */
internal fun getScalingFactors(widths: Pair<Int, Int>, heights: Pair<Int, Int>) =
    Pair(widths.first.toFloat() / widths.second, heights.first.toFloat() / heights.second)

/**
 * Logs an error at most once per [intervalMs], so a failure that repeats on every
 * frame does not flood the log. The number of failures that were not logged is
 * reported with the next message.
 */
internal class ThrottledLog(
    private val tag: String,
    private val intervalMs: Long = DEFAULT_LOG_INTERVAL_MS,
) {
    private var lastLogAt = 0L
    private var suppressed = 0

    @Synchronized
    fun e(message: String, throwable: Throwable? = null) {
        val now = SystemClock.elapsedRealtime()
        if (lastLogAt != 0L && now - lastLogAt < intervalMs) {
            suppressed++
            return
        }
        val suffix = if (suppressed > 0) " ($suppressed more since the last report)" else ""
        Log.e(tag, message + suffix, throwable)
        lastLogAt = now
        suppressed = 0
    }

    companion object {
        private const val DEFAULT_LOG_INTERVAL_MS = 5_000L
    }
}
