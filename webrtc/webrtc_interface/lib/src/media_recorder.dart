import 'enums.dart';
import 'media_stream.dart';
import 'media_stream_track.dart';

abstract class MediaRecorder {
  /// Starts recording to file at [path].
  /// Optionally, on Android choose [audioChannel] to record.
  /// On web platform use [startWeb] instead.
  Future<void> start(
    String path, {
    MediaStreamTrack? videoTrack,
    RecorderAudioChannel? audioChannel,
  });

  /// Only for Flutter Web
  void startWeb(
    MediaStream stream, {
    Function(dynamic blob, bool isLastOne)? onDataChunk,
    String mimeType,
    int timeSlice = 1000,
  });

  Future<dynamic> stop();
}
