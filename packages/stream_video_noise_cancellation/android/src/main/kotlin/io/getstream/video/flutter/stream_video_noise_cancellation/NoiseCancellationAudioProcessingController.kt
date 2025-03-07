package io.getstream.video.flutter.stream_video_noise_cancellation

import android.content.Context
import org.webrtc.AudioProcessingFactory
import io.getstream.webrtc.flutter.audio.AudioProcessingFactoryProvider
import io.getstream.video.android.noise.cancellation.NoiseCancellation

class NoiseCancellationAudioProcessingController(context: Context) : AudioProcessingFactoryProvider {
    val noiseCancellation: NoiseCancellation
    
    init {
        noiseCancellation = NoiseCancellation(context)
    }
    
    override fun getFactory(): AudioProcessingFactory {
        return noiseCancellation
    }
}
