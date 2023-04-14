import 'package:meta/meta.dart';

import '../../sdp.dart';

@internal
abstract class SdpEditAction {
  const SdpEditAction();

  void execute(List<SdpLine> sdpLines);
}
