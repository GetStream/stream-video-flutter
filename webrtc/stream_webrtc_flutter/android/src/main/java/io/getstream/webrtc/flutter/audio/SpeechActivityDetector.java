package io.getstream.webrtc.flutter.audio;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.webrtc.audio.JavaAudioDeviceModule;
import org.webrtc.audio.JavaAudioDeviceModule.AudioSamples;
import org.webrtc.audio.JavaAudioDeviceModule.SamplesReadyCallback;

/**
 * Speaking-while-muted detector.
 *
 * Mirrors the Stream Android SDK's {@code SoundInputProcessor} (-45 dB
 * threshold, 600 ms window).
 *
 */
public class SpeechActivityDetector implements SamplesReadyCallback {

    /** Receiver of speech-activity transitions. */
    public interface Delegate {
        void onSpeechActivityChanged(boolean speaking);
    }

    private static final String TAG = "SpeechActivityDetector";
    private static final double THRESHOLD_DBFS = -45.0;
    private static final long WINDOW_NS = 600_000_000L; // 600 ms

    private final Delegate delegate;
    // Sliding window of (timestampNs, dbfs) entries. Audio thread only.
    private final java.util.ArrayDeque<long[]> window = new java.util.ArrayDeque<>();
    private boolean speaking = false;

    public SpeechActivityDetector(@NonNull Delegate delegate) {
        this.delegate = delegate;
    }

    @Override
    public void onWebRtcAudioRecordSamplesReady(AudioSamples samples) {
        final byte[] data = samples.getData();
        final int channels = samples.getChannelCount();
        if (data == null || data.length < 2 || channels < 1) return;

        // 16-bit signed little-endian PCM.
        final int sampleCount = data.length / 2;
        long sumSq = 0;
        for (int i = 0; i < sampleCount; i++) {
            final int lo = data[i * 2] & 0xff;
            final int hi = data[i * 2 + 1];
            final short s = (short) ((hi << 8) | lo);
            sumSq += (long) s * (long) s;
        }
        final double meanSq = (double) sumSq / (double) sampleCount;
        if (meanSq <= 0) return;
        final double rms = Math.sqrt(meanSq);
        final double dbfs = 20.0 * Math.log10(rms / 32768.0);

        final long nowNs = System.nanoTime();
        window.addLast(new long[] {nowNs, Double.doubleToRawLongBits(dbfs)});
        while (!window.isEmpty() && (nowNs - window.peekFirst()[0]) > WINDOW_NS) {
            window.pollFirst();
        }

        // Average dBFS across the window. With short windows of silence
        // suppressing the average toward -inf, a transition still fires
        // crisply on the threshold crossing.
        double sum = 0.0;
        int count = 0;
        for (long[] entry : window) {
            sum += Double.longBitsToDouble(entry[1]);
            count++;
        }
        if (count == 0) return;
        final double avg = sum / count;

        final boolean wasSpeaking = speaking;
        if (!wasSpeaking && avg >= THRESHOLD_DBFS) {
            speaking = true;
            try {
                delegate.onSpeechActivityChanged(true);
            } catch (Throwable t) {
                Log.w(TAG, "delegate(started) threw: " + t);
            }
        } else if (wasSpeaking && avg < THRESHOLD_DBFS) {
            speaking = false;
            try {
                delegate.onSpeechActivityChanged(false);
            } catch (Throwable t) {
                Log.w(TAG, "delegate(ended) threw: " + t);
            }
        }
    }
}
