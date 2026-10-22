package io.getstream.webrtc.flutter.audio;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

/**
 * AudioBufferMixer provides utilities for mixing audio buffers.
 * Used to combine microphone audio with screen audio during screen sharing.
 */
public class AudioBufferMixer {

    /**
     * Mixes two audio buffers by adding their samples together.
     * The buffers are expected to be in PCM 16-bit little-endian format.
     * 
     * The mixing process:
     * 1. Converts both buffers from ByteBuffer to short arrays
     * 2. Adds corresponding samples together
     * 3. Clips values to prevent overflow
     * 4. Writes the result back into the destination buffer
     *
     * @param destBuffer The destination buffer (modified in-place) - typically
     *                   microphone audio
     * @param srcBuffer  The source buffer to mix in - typically screen audio
     * @param bytesToMix The number of bytes to mix
     */
    public static void mixBuffers(ByteBuffer destBuffer, ByteBuffer srcBuffer, int bytesToMix) {
        if (destBuffer == null || srcBuffer == null || bytesToMix <= 0) {
            return;
        }

        int samplesToMix = bytesToMix / 2; // 16-bit = 2 bytes per sample

        // Ensure correct byte order
        destBuffer.order(ByteOrder.LITTLE_ENDIAN);
        srcBuffer.order(ByteOrder.LITTLE_ENDIAN);

        // Reset positions for reading
        destBuffer.position(0);
        srcBuffer.position(0);

        // Create temporary arrays for mixing
        short[] destSamples = new short[samplesToMix];
        short[] srcSamples = new short[samplesToMix];

        // Read samples
        int destSamplesToRead = Math.min(samplesToMix, destBuffer.remaining() / 2);
        int srcSamplesToRead = Math.min(samplesToMix, srcBuffer.remaining() / 2);

        destBuffer.asShortBuffer().get(destSamples, 0, destSamplesToRead);
        srcBuffer.asShortBuffer().get(srcSamples, 0, srcSamplesToRead);

        // Mix samples with clipping
        // Only mix up to the minimum of both buffers, then copy remaining samples
        int mixableCount = Math.min(destSamplesToRead, srcSamplesToRead);

        byte[] mixedBytes = new byte[bytesToMix];
        for (int i = 0; i < samplesToMix; i++) {
            int sum;
            if (i < mixableCount) {
                // Both buffers have valid data at this index - mix them
                sum = destSamples[i] + srcSamples[i];
            } else if (i < destSamplesToRead) {
                // Only dest buffer has valid data at this index
                sum = destSamples[i];
            } else if (i < srcSamplesToRead) {
                // Only src buffer has valid data at this index
                sum = srcSamples[i];
            } else {
                // Neither buffer has valid data - output silence
                sum = 0;
            }

            if (sum > Short.MAX_VALUE) {
                sum = Short.MAX_VALUE;
            } else if (sum < Short.MIN_VALUE) {
                sum = Short.MIN_VALUE;
            }

            int byteIndex = i * 2;
            mixedBytes[byteIndex] = (byte) (sum & 0xFF);
            mixedBytes[byteIndex + 1] = (byte) ((sum >> 8) & 0xFF);
        }

        destBuffer.clear();
        destBuffer.put(mixedBytes);
    }

    /**
     * Mixes screen audio into the microphone audio buffer.
     *
     * @param micBuffer    The microphone audio buffer (modified in-place)
     * @param screenBuffer The screen audio buffer
     * @param bytesToMix   The number of bytes to mix
     */
    public static void mixScreenAudioWithMicrophone(
            ByteBuffer micBuffer,
            ByteBuffer screenBuffer,
            int bytesToMix) {

        if (screenBuffer == null || bytesToMix <= 0) {
            return;
        }

        if (micBuffer == null) {
            return;
        }

        // Mix both audio sources
        mixBuffers(micBuffer, screenBuffer, bytesToMix);
    }
}
