package io.getstream.webrtc.flutter.record;

import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.YuvImage;
import android.os.Handler;
import android.os.Looper;

import org.webrtc.JavaI420Buffer;
import org.webrtc.VideoFrame;
import org.webrtc.VideoSink;
import org.webrtc.VideoTrack;
import org.webrtc.YuvHelper;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;

import io.flutter.plugin.common.MethodChannel;

public class FrameCapturer implements VideoSink {
    private final VideoTrack videoTrack;
    private File file;
    private final MethodChannel.Result callback;
    private boolean gotFrame = false;

    public FrameCapturer(VideoTrack track, File file, MethodChannel.Result callback) {
        videoTrack = track;
        this.file = file;
        this.callback = callback;
        track.addSink(this);
    }

    @Override
    public void onFrame(VideoFrame videoFrame) {
        if (gotFrame)
            return;
        gotFrame = true;
        videoFrame.retain();

        final int rotation = videoFrame.getRotation();
        final byte[] nv21;
        final int width;
        final int height;

        VideoFrame.I420Buffer i420Buffer = videoFrame.getBuffer().toI420();
        VideoFrame.I420Buffer rotated = null;
        try {
            // Rotation is applied on the YUV planes, before any encoding happens. This
            // keeps the whole capture to a single pass: there is no intermediate JPEG on
            // disk to decode back into a Bitmap just to turn it. It also matches what the
            // native Android and iOS SDKs do.
            rotated = rotate(i420Buffer, rotation);
            width = rotated.getWidth();
            height = rotated.getHeight();
            nv21 = toNv21(rotated);
        } catch (IllegalArgumentException iae) {
            callback.error("IllegalArgumentException", iae.getLocalizedMessage(), iae);
            return;
        } finally {
            if (rotated != null && rotated != i420Buffer) {
                rotated.release();
            }
            i420Buffer.release();
            videoFrame.release();
            new Handler(Looper.getMainLooper()).post(() -> {
                videoTrack.removeSink(this);
            });
        }

        YuvImage yuvImage = new YuvImage(
            nv21,
            ImageFormat.NV21,
            width,
            height,
            // We omit the strides here. If they were included, the resulting image would
            // have its colors offset.
            null);

        try {
            File parent = file.getParentFile();
            if (parent != null) {
                //noinspection ResultOfMethodCallIgnored
                parent.mkdirs();
            }
        } catch (SecurityException se) {
            callback.error("SecurityException", se.getLocalizedMessage(), se);
            return;
        }

        try (FileOutputStream outputStream = new FileOutputStream(file)) {
            yuvImage.compressToJpeg(
                new Rect(0, 0, width, height),
                100,
                outputStream
            );
            callback.success(null);
        } catch (IOException io) {
            callback.error("IOException", io.getLocalizedMessage(), io);
        } catch (IllegalArgumentException iae) {
            callback.error("IllegalArgumentException", iae.getLocalizedMessage(), iae);
        } finally {
            file = null;
        }
    }

    /**
     * Rotates an I420 buffer by the frame rotation. Returns {@code src} untouched when
     * there is nothing to rotate, so callers must only release the result when it differs
     * from the input.
     */
    private static VideoFrame.I420Buffer rotate(VideoFrame.I420Buffer src, int rotation) {
        // VideoFrame only guarantees the rotation is a multiple of 90, not that it
        // sits in [0, 360). libyuv accepts 0/90/180/270 only, so normalise first.
        final int rotationMode = ((rotation % 360) + 360) % 360;
        if (rotationMode == 0) {
            return src;
        }
        final int srcWidth = src.getWidth();
        final int srcHeight = src.getHeight();
        final boolean swapsAxes = rotationMode % 180 != 0;
        final int dstWidth = swapsAxes ? srcHeight : srcWidth;
        final int dstHeight = swapsAxes ? srcWidth : srcHeight;

        JavaI420Buffer dst = JavaI420Buffer.allocate(dstWidth, dstHeight);
        YuvHelper.I420Rotate(
            src.getDataY(), src.getStrideY(),
            src.getDataU(), src.getStrideU(),
            src.getDataV(), src.getStrideV(),
            dst.getDataY(), dst.getStrideY(),
            dst.getDataU(), dst.getStrideU(),
            dst.getDataV(), dst.getStrideV(),
            srcWidth, srcHeight, rotationMode);
        return dst;
    }

    private static byte[] toNv21(VideoFrame.I420Buffer buffer) {
        final int width = buffer.getWidth();
        final int height = buffer.getHeight();
        final int chromaWidth = (width + 1) / 2;
        final int chromaHeight = (height + 1) / 2;
        final int minSize = width * height + chromaWidth * chromaHeight * 2;

        ByteBuffer yuvBuffer = ByteBuffer.allocateDirect(minSize);
        // NV21 is the same as NV12, only that V and U are stored in the reverse order
        // NV21 (YYYYYYYYY:VUVU)
        // NV12 (YYYYYYYYY:UVUV)
        // Therefore we can use the NV12 helper, but swap the U and V input buffers
        YuvHelper.I420ToNV12(
            buffer.getDataY(), buffer.getStrideY(),
            buffer.getDataV(), buffer.getStrideV(),
            buffer.getDataU(), buffer.getStrideU(),
            yuvBuffer, width, height);

        // I420ToNV12 leaves the buffer positioned at the start of the chroma plane, so
        // rewind before reading it back.
        byte[] nv21 = new byte[minSize];
        yuvBuffer.position(0);
        yuvBuffer.get(nv21);
        return nv21;
    }
}
