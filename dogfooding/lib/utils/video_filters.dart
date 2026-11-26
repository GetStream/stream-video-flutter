import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Sets [filter] through [setVideoFilter], and sets [current] back when
/// [filter] cannot be applied, so the filter in use stays the one shown.
Future<Result<None>> setVideoFilterOrRevert(
  VideoFilter? filter, {
  required VideoFilter? current,
  required Future<Result<None>> Function(VideoFilter? filter) setVideoFilter,
}) async {
  final result = await setVideoFilter(filter);
  if (result.isFailure && current != filter) {
    await setVideoFilter(current);
  }
  return result;
}

/// Sets [filter] on [call] as [setVideoFilterOrRevert] does, and throws when
/// it cannot be applied.
Future<void> applyVideoFilter(Call call, VideoFilter? filter) async {
  final result = await setVideoFilterOrRevert(
    filter,
    current: call.videoFilter,
    setVideoFilter: call.setVideoFilter,
  );
  if (result case Failure(:final error)) throw Exception('$error');
}
