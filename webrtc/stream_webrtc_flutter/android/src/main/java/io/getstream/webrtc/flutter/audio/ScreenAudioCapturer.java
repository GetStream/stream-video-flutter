package io.getstream.webrtc.flutter.audio;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.media.AudioAttributes;
import android.media.AudioFormat;
import android.media.AudioPlaybackCaptureConfiguration;
import android.media.AudioRecord;
import android.media.projection.MediaProjection;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

/**
 * ScreenAudioCapturer captures audio from screen content using
 * AudioPlaybackCaptureConfiguration.
 * This requires Android Q (API 29) or higher.
 * 
 * The captured audio can be mixed with microphone audio to transmit both during
 * screen sharing.
 */
public class ScreenAudioCapturer {
    private static final String TAG = "ScreenAudioCapturer";

    // Audio configuration constants
    private static final int INPUT_BITS_PER_SAMPLE = 16; // 16-bit PCM
    private static final int CALLBACK_BUFFER_SIZE_MS = 10;
    private static final int BUFFERS_PER_SECOND = 1000 / CALLBACK_BUFFER_SIZE_MS;
    private static final int SAMPLE_RATE = 48000; // Standard WebRTC sample rate

    private final Context context;
    private final int numChannels;
    private volatile AudioRecord screenAudioRecord;
    private MediaProjection mediaProjection;
    private volatile ByteBuffer screenAudioBuffer;
    private volatile boolean isCapturing = false;

    public ScreenAudioCapturer(Context context, int numChannels) {
        this.context = context;
        this.numChannels = numChannels;
    }

    /**
     * Starts capturing screen audio using the provided MediaProjection.
     * Requires Android Q (API 29) or higher.
     */
    @RequiresApi(api = Build.VERSION_CODES.Q)
    public boolean startCapture(MediaProjection mediaProjection) {
        if (mediaProjection == null) {
            Log.e(TAG, "MediaProjection is null, cannot start screen audio capture");
            return false;
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            Log.w(TAG, "Screen audio capture requires Android Q (API 29) or higher");
            return false;
        }

        if (ActivityCompat.checkSelfPermission(context,
                Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
            Log.w(TAG, "RECORD_AUDIO permission not granted, cannot capture screen audio");
            return false;
        }

        this.mediaProjection = mediaProjection;

        try {
            // Calculate buffer size using the configured channel count
            int bytesPerFrame = numChannels * (INPUT_BITS_PER_SAMPLE / 8);
            int bufferCapacity = bytesPerFrame * (SAMPLE_RATE / BUFFERS_PER_SECOND);

            screenAudioBuffer = ByteBuffer.allocateDirect(bufferCapacity);
            screenAudioBuffer.order(ByteOrder.LITTLE_ENDIAN);

            int channelMask = (numChannels == 2)
                    ? AudioFormat.CHANNEL_IN_STEREO
                    : AudioFormat.CHANNEL_IN_MONO;

            AudioFormat format = new AudioFormat.Builder()
                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                    .setSampleRate(SAMPLE_RATE)
                    .setChannelMask(channelMask)
                    .build();

            AudioPlaybackCaptureConfiguration playbackConfig = new AudioPlaybackCaptureConfiguration.Builder(
                    mediaProjection)
                    .addMatchingUsage(AudioAttributes.USAGE_MEDIA)
                    .addMatchingUsage(AudioAttributes.USAGE_GAME)
                    .addMatchingUsage(AudioAttributes.USAGE_UNKNOWN)
                    .build();

            screenAudioRecord = new AudioRecord.Builder()
                    .setAudioFormat(format)
                    .setAudioPlaybackCaptureConfig(playbackConfig)
                    .build();

            if (screenAudioRecord.getState() != AudioRecord.STATE_INITIALIZED) {
                Log.e(TAG, "AudioRecord failed to initialize");
                release();
                return false;
            }

            screenAudioRecord.startRecording();
            isCapturing = true;

            Log.d(TAG, "Screen audio capture started successfully (channels=" + numChannels + ")");
            return true;

        } catch (Exception e) {
            Log.e(TAG, "Failed to start screen audio capture", e);
            release();
            return false;
        }
    }

    /**
     * Gets the next set of screen audio bytes on demand by reading directly from
     * AudioRecord.
     */
    public ByteBuffer getScreenAudioBytes(int bytesRequested) {
        if (!isCapturing || bytesRequested <= 0) {
            return null;
        }

        AudioRecord localAudioRecord = screenAudioRecord;
        if (localAudioRecord == null) {
            return null;
        }

        try {
            ByteBuffer localBuffer = screenAudioBuffer;

            // Ensure buffer has enough capacity
            if (localBuffer == null || localBuffer.capacity() < bytesRequested) {
                localBuffer = ByteBuffer.allocateDirect(bytesRequested);
                localBuffer.order(ByteOrder.LITTLE_ENDIAN);
                screenAudioBuffer = localBuffer;
            }

            localBuffer.clear();
            localBuffer.limit(bytesRequested);

            int bytesRead = localAudioRecord.read(
                    localBuffer,
                    bytesRequested,
                    AudioRecord.READ_BLOCKING);

            if (bytesRead > 0) {
                localBuffer.limit(bytesRead);
                localBuffer.position(0);
                return localBuffer;
            }

        } catch (Exception e) {
            if (isCapturing) {
                Log.e(TAG, "Error reading screen audio", e);
            }
        }

        return null;
    }

    /**
     * Stops capturing screen audio and releases resources.
     */
    public void stopCapture() {
        isCapturing = false;

        AudioRecord localAudioRecord = screenAudioRecord;
        screenAudioRecord = null;

        if (localAudioRecord != null) {
            // Run cleanup on a background thread to avoid blocking the caller
            new Thread(() -> {
                try {
                    localAudioRecord.stop();
                    Log.d(TAG, "Screen audio capture stopped");
                } catch (Exception e) {
                    Log.e(TAG, "Error stopping screen audio capture", e);
                }
                try {
                    localAudioRecord.release();
                    Log.d(TAG, "Screen audio record released");
                } catch (Exception e) {
                    Log.e(TAG, "Error releasing AudioRecord", e);
                }
            }, "ScreenAudioCapturer-cleanup").start();
        }

        mediaProjection = null;
        screenAudioBuffer = null;
    }

    private void release() {
        isCapturing = false;

        if (screenAudioRecord != null) {
            try {
                screenAudioRecord.stop();
            } catch (Exception e) {
                Log.e(TAG, "Error stopping AudioRecord in release", e);
            }
            try {
                screenAudioRecord.release();
            } catch (Exception e) {
                Log.e(TAG, "Error releasing AudioRecord", e);
            }
            screenAudioRecord = null;
        }

        mediaProjection = null;
        screenAudioBuffer = null;
    }

    public boolean isCapturing() {
        return isCapturing;
    }

    /**
     * Checks if screen audio capture is supported on this device.
     */
    public static boolean isSupported() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q;
    }
}
