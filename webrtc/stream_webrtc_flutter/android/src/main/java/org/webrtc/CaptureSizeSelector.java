package org.webrtc;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

/**
 * Picks the camera capture format for a requested size.
 *
 * <p>libwebrtc's camera sessions choose the supported size with the smallest
 * {@code |width - requested.width| + |height - requested.height|}
 * ({@link CameraEnumerationAndroid#getClosestSupportedSize}). That rule ignores the aspect ratio,
 * so a camera that offers a 2:1 format next to its 16:9 ones answers a 2560x1440 request with
 * 2560x1280 (difference 160) rather than 1920x1080 (difference 1000). Pixel phones do exactly
 * this, and the encoder then publishes a 1280x2560 portrait frame nobody asked for.
 *
 * <p>This selector keeps the requested aspect ratio first: among the supported sizes whose aspect
 * ratio is within {@link #ASPECT_TOLERANCE} of the request it picks libwebrtc's closest size, so an
 * exact match still wins and the behaviour is unchanged for cameras without odd formats. When no
 * size has the requested aspect ratio it falls back to the sizes with the nearest aspect ratio,
 * then to the closest size among those. The caller passes the chosen size to
 * {@code startCapture}, where libwebrtc's own rule then finds it at difference 0.
 */
public final class CaptureSizeSelector {
    /** Relative aspect-ratio difference that still counts as "the same aspect ratio". */
    static final double ASPECT_TOLERANCE = 0.02;

    private CaptureSizeSelector() {}

    /**
     * The capture format to open for a {@code width}x{@code height} request, or null when
     * there are no sizes to choose from. Sizes and the request are compared orientation-free
     * (long edge over short edge), since camera formats are listed in sensor space.
     */
    @Nullable
    public static Size select(@Nullable List<Size> sizes, int width, int height) {
        if (sizes == null || sizes.isEmpty()) return null;
        // Formats are listed in sensor space (landscape), so compare the request the same way:
        // a portrait 1080x1920 request must find 1920x1080 at difference 0, not 1280x720.
        final int longEdge = Math.max(width, height);
        final int shortEdge = Math.min(width, height);
        if (shortEdge <= 0) {
            return CameraEnumerationAndroid.getClosestSupportedSize(sizes, longEdge, shortEdge);
        }

        final double wanted = aspect(longEdge, shortEdge);
        List<Size> candidates = sizesWithinTolerance(sizes, wanted);
        if (candidates.isEmpty()) candidates = sizesWithNearestAspect(sizes, wanted);
        if (candidates.isEmpty()) {
            return CameraEnumerationAndroid.getClosestSupportedSize(sizes, longEdge, shortEdge);
        }
        return CameraEnumerationAndroid.getClosestSupportedSize(candidates, longEdge, shortEdge);
    }

    /** The sizes whose aspect ratio is within {@link #ASPECT_TOLERANCE} of {@code wanted}. */
    private static List<Size> sizesWithinTolerance(List<Size> sizes, double wanted) {
        List<Size> result = new ArrayList<>();
        for (Size size : sizes) {
            if (size.width <= 0 || size.height <= 0) continue;
            if (deviation(size, wanted) <= ASPECT_TOLERANCE) result.add(size);
        }
        return result;
    }

    /** The sizes whose aspect ratio is nearest to {@code wanted}; several when they share the same ratio. */
    private static List<Size> sizesWithNearestAspect(List<Size> sizes, double wanted) {
        double best = Double.MAX_VALUE;
        for (Size size : sizes) {
            if (size.width <= 0 || size.height <= 0) continue;
            best = Math.min(best, deviation(size, wanted));
        }
        List<Size> result = new ArrayList<>();
        for (Size size : sizes) {
            if (size.width <= 0 || size.height <= 0) continue;
            // Equal ratios divide to the same double, so exact comparison keeps e.g. both 2:1 sizes.
            if (deviation(size, wanted) == best) result.add(size);
        }
        return result;
    }

    /** Relative difference between the size's aspect ratio and the wanted one. */
    private static double deviation(Size size, double wanted) {
        return Math.abs(aspect(size.width, size.height) - wanted) / wanted;
    }

    /** The distinct sizes of the given formats, in first-seen order; formats repeat per frame-rate range. */
    public static List<Size> distinctSizes(@Nullable List<CameraEnumerationAndroid.CaptureFormat> formats) {
        List<Size> sizes = new ArrayList<>();
        if (formats == null) return sizes;
        for (CameraEnumerationAndroid.CaptureFormat format : formats) {
            Size size = new Size(format.width, format.height);
            if (!sizes.contains(size)) sizes.add(size);
        }
        return sizes;
    }

    /** "WxH, WxH, ..." for a log line, or "none". */
    public static String describe(@Nullable List<Size> sizes) {
        if (sizes == null || sizes.isEmpty()) return "none";
        StringBuilder sb = new StringBuilder();
        for (Size size : sizes) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(size.width).append('x').append(size.height);
        }
        return sb.toString();
    }

    static double aspect(int width, int height) {
        return (double) Math.max(width, height) / Math.min(width, height);
    }
}
