import 'package:stream_webrtc_interface/src/third_party/webrtc_interface/media_recorder.dart'
    as rtc;

import '../../../stream_dart_webrtc.dart';

class MediaRecorder extends rtc.MediaRecorder {
  MediaRecorder() : _delegate = mediaRecorder();
  final rtc.MediaRecorder _delegate;

  @override
  Future<void> start(
    String path, {
    MediaStreamTrack? videoTrack,
    RecorderAudioChannel? audioChannel,
  }) =>
      _delegate.start(path, videoTrack: videoTrack, audioChannel: audioChannel);

  @override
  Future stop() => _delegate.stop();

  @override
  void startWeb(
    MediaStream stream, {
    Function(dynamic blob, bool isLastOne)? onDataChunk,
    String? mimeType,
    int timeSlice = 1000,
  }) => _delegate.startWeb(
    stream,
    onDataChunk: onDataChunk,
    mimeType: mimeType ?? 'video/webm',
    timeSlice: timeSlice,
  );
}
