import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

final streamVideoProvider = Provider((ref) {
  return StreamVideo.init('DUMMY_API_KEY');
});

final callProvider = Provider((ref) {
  return Call.fromCid(
    callCid: StreamCallCid(cid: 'test:cid'),
    streamVideo: ref.read(streamVideoProvider),
  );
});
