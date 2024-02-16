import 'package:meta/meta.dart';

import 'package:stream_video/src/webrtc/sdp/sdp.dart';

@internal
abstract class SdpEditor {

  set opusDtxEnabled(bool value);

  set opusRedEnabled(bool value);

  String? edit(Sdp? sdp);
}
