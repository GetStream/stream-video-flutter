import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../test/src/mocks.dart';

void main() {
  // participants should be removed
  StreamCallParticipants(
    call: MockCall(),
    participants: const [],
  );
}
