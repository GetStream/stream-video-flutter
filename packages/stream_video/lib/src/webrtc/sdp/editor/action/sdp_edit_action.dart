import 'package:meta/meta.dart';

import 'package:stream_video/src/webrtc/sdp/sdp.dart';

@internal
abstract class SdpEditAction {
  const SdpEditAction();

  void execute(List<SdpLine> sdpLines);
}
