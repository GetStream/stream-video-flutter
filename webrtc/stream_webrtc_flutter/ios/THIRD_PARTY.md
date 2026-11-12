# Third-party code

These files in `ios/` come from [flutter-webrtc](https://github.com/flutter-webrtc/flutter-webrtc), through Stream's fork [GetStream/webrtc-flutter](https://github.com/GetStream/webrtc-flutter). The fork's changes are under the same MIT licence.

- Upstream: https://github.com/flutter-webrtc/flutter-webrtc
- Baseline: flutter-webrtc v1.5.2, through GetStream/webrtc-flutter at `9b4f503` (stream_webrtc_flutter 4.0.0)
- Copied into this repository: 2026-10-22
- Copyright holder: (c) 2018 湖北捷智云技术有限公司
- Licence: MIT, see `LICENSE`

This is not a hermetic snapshot: the code keeps being modified in this repository, and those changes stay under the MIT licence.

Files that are not on this list are Stream code, under the licence in the package's root `LICENSE`.

## Files

- `.gitignore`
- `stream_webrtc_flutter.podspec`
- `stream_webrtc_flutter/Package.swift`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/AudioManager.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/AudioProcessingAdapter.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/AudioUtils.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/Broadcast/FlutterBroadcastScreenCapturer.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/Broadcast/FlutterSocketConnection.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/Broadcast/FlutterSocketConnectionFrameReader.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/CameraUtils.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRPScreenRecorder.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCAudioSink.mm`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCDataChannel.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCDesktopCapturer.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCEncryptionManager.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCFrameCapturer.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCMediaRecorder.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCMediaStream.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCPeerConnection.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCVideoPlatformView.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCVideoPlatformViewController.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCVideoPlatformViewFactory.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterRTCVideoRenderer.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/FlutterWebRTCPlugin.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/LocalAudioTrack.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/LocalVideoTrack.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/NativePeerConnectionFactory.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/ProcessorProvider.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/VideoEffectProcessor.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/VideoProcessingAdapter.m`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/audio_sink_bridge.cpp`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/AudioManager.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/AudioProcessingAdapter.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/AudioUtils.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/Broadcast/FlutterBroadcastScreenCapturer.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/Broadcast/FlutterSocketConnection.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/Broadcast/FlutterSocketConnectionFrameReader.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/CameraUtils.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterDataPacketCryptor.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRPScreenRecorder.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCAudioSink-Interface.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCAudioSink.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCDataChannel.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCDesktopCapturer.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCEncryptionManager.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCFrameCapturer.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCMediaRecorder.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCMediaStream.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCPeerConnection.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCVideoPlatformView.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCVideoPlatformViewController.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCVideoPlatformViewFactory.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterRTCVideoRenderer.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/FlutterWebRTCPlugin.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/LocalAudioTrack.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/LocalTrack.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/LocalVideoTrack.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/NativePeerConnectionFactory.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/ProcessorProvider.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/RTCAudioSource+Private.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/VideoEffectProcessor.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/VideoFactoriesPrivate.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/VideoFrameProcessor.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/VideoProcessingAdapter.h`
- `stream_webrtc_flutter/Sources/stream_webrtc_flutter/include/stream_webrtc_flutter/media_stream_interface.h`
