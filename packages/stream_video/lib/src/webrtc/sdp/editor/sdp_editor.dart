import 'package:meta/meta.dart';

import '../sdp.dart';

@internal
abstract class SdpEditor {

  set opusDtxEnabled(bool value);

  set opusRedEnabled(bool value);

  String? edit(Sdp? sdp);
}
