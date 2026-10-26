package io.getstream.webrtc.flutter.audio;

import org.webrtc.AudioProcessingFactory;

// Define the common interface
public interface AudioProcessingFactoryProvider {
    AudioProcessingFactory getFactory();
}
