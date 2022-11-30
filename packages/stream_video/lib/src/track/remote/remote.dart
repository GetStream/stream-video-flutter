import 'package:stream_video/src/track/track.dart';

abstract class RemoteTrack extends Track {
  RemoteTrack({
    required super.name,
    required super.kind,
    required super.source,
    required super.mediaStream,
    required super.mediaStreamTrack,
    super.receiver,
  });

  @override
  Future<bool> start() async {
    final didStart = await super.start();
    if (didStart) {
      await enable();
    }
    return didStart;
  }

  @override
  Future<bool> stop() async {
    final didStop = await super.stop();
    if (didStop) {
      await disable();
    }
    return didStop;
  }
}
