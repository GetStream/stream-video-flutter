# Third-party code

These files in `android/` come from [flutter-webrtc](https://github.com/flutter-webrtc/flutter-webrtc), through Stream's fork [GetStream/webrtc-flutter](https://github.com/GetStream/webrtc-flutter). The fork's changes are under the same MIT licence.

- Upstream: https://github.com/flutter-webrtc/flutter-webrtc
- Baseline: flutter-webrtc v1.5.2, through GetStream/webrtc-flutter at `9b4f503` (stream_webrtc_flutter 4.0.0)
- Copied into this repository: 2026-10-22
- Copyright holder: (c) 2018 湖北捷智云技术有限公司
- Licence: MIT, see `LICENSE`

This is not a hermetic snapshot: the code keeps being modified in this repository, and those changes stay under the MIT licence.

The changes to `SimulcastVideoEncoderFactoryWrapper.kt` that came from Shiguredo are under the Apache License 2.0; see `NOTICE` in the package root.

Files that are not on this list are Stream code, under the licence in the package's root `LICENSE`.

## Files

- `build.gradle`
- `gradle.properties`
- `proguard-rules.pro`
- `settings.gradle`
- `src/main/AndroidManifest.xml`
- `src/main/java/io/getstream/webrtc/flutter/CameraEventsHandler.java`
- `src/main/java/io/getstream/webrtc/flutter/DataChannelObserver.java`
- `src/main/java/io/getstream/webrtc/flutter/FlutterRTCEncryptionManager.java`
- `src/main/java/io/getstream/webrtc/flutter/FlutterRTCVideoRenderer.java`
- `src/main/java/io/getstream/webrtc/flutter/FlutterWebRTCPlugin.java`
- `src/main/java/io/getstream/webrtc/flutter/GetUserMediaImpl.java`
- `src/main/java/io/getstream/webrtc/flutter/LocalTrack.java`
- `src/main/java/io/getstream/webrtc/flutter/MethodCallHandlerImpl.java`
- `src/main/java/io/getstream/webrtc/flutter/NativePeerConnectionFactory.java`
- `src/main/java/io/getstream/webrtc/flutter/OrientationAwareScreenCapturer.java`
- `src/main/java/io/getstream/webrtc/flutter/PeerConnectionObserver.java`
- `src/main/java/io/getstream/webrtc/flutter/SimulcastVideoEncoderFactoryWrapper.kt`
- `src/main/java/io/getstream/webrtc/flutter/StateProvider.java`
- `src/main/java/io/getstream/webrtc/flutter/SurfaceTextureRenderer.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/AudioBufferMixer.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/AudioDeviceKind.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/AudioFocusManager.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/AudioProcessingAdapter.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/AudioProcessingController.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/AudioProcessingFactoryProvider.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/AudioSwitchManager.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/AudioUtils.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/LocalAudioTrack.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/PlaybackSamplesReadyCallbackAdapter.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/RecordSamplesReadyCallbackAdapter.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/ScreenAudioCapturer.java`
- `src/main/java/io/getstream/webrtc/flutter/audio/SpeechActivityDetector.java`
- `src/main/java/io/getstream/webrtc/flutter/record/AudioChannel.java`
- `src/main/java/io/getstream/webrtc/flutter/record/AudioFileRenderer.java`
- `src/main/java/io/getstream/webrtc/flutter/record/AudioSamplesInterceptor.java`
- `src/main/java/io/getstream/webrtc/flutter/record/AudioTrackInterceptor.java`
- `src/main/java/io/getstream/webrtc/flutter/record/EncoderConfig.java`
- `src/main/java/io/getstream/webrtc/flutter/record/FrameCapturer.java`
- `src/main/java/io/getstream/webrtc/flutter/record/MediaRecorderImpl.java`
- `src/main/java/io/getstream/webrtc/flutter/record/OutputAudioSamplesInterceptor.java`
- `src/main/java/io/getstream/webrtc/flutter/record/VideoFileRenderer.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/AnyThreadResult.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/AnyThreadSink.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/Callback.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/ConstraintsArray.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/ConstraintsMap.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/EglUtils.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/MediaConstraintsUtils.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/ObjectType.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/PermissionUtils.java`
- `src/main/java/io/getstream/webrtc/flutter/utils/Utils.java`
- `src/main/java/io/getstream/webrtc/flutter/video/LocalVideoTrack.java`
- `src/main/java/io/getstream/webrtc/flutter/video/VideoCapturerInfo.java`
- `src/main/java/io/getstream/webrtc/flutter/video/camera/CameraRegionUtils.java`
- `src/main/java/io/getstream/webrtc/flutter/video/camera/CameraUtils.java`
- `src/main/java/io/getstream/webrtc/flutter/video/camera/DeviceOrientationManager.java`
- `src/main/java/io/getstream/webrtc/flutter/video/camera/Point.java`
- `src/main/java/io/getstream/webrtc/flutter/video/camera/SdkCapabilityChecker.java`
- `src/main/java/io/getstream/webrtc/flutter/videoEffects/ProcessorProvider.java`
- `src/main/java/io/getstream/webrtc/flutter/videoEffects/VideoEffectProcessor.java`
- `src/main/java/io/getstream/webrtc/flutter/videoEffects/VideoFrameProcessor.java`
- `src/main/java/io/getstream/webrtc/flutter/videoEffects/VideoFrameProcessorFactoryInterface.java`
- `src/main/java/org/webrtc/Camera1Helper.java`
- `src/main/java/org/webrtc/Camera2Helper.java`
- `src/main/java/org/webrtc/CaptureSizeSelector.java`
- `src/main/java/org/webrtc/audio/WebRtcAudioTrackUtils.java`
- `src/main/java/org/webrtc/video/CustomVideoDecoderFactory.java`
- `src/main/java/org/webrtc/video/CustomVideoEncoderFactory.java`
- `src/test/java/org/webrtc/CaptureSizeSelectorTest.java`
