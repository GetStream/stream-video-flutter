import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Sets [filter] on [call], and throws when it cannot be applied. The
/// previous filter then stays in place.
Future<void> applyVideoFilter(Call call, VideoFilter? filter) async {
  final result = await call.setVideoFilter(filter);
  if (result case Failure(:final error)) throw Exception('$error');
}
