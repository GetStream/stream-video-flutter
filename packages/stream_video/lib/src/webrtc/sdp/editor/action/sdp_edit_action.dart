import 'package:meta/meta.dart';

import '../../sdp.dart';

@internal
// ignore: one_member_abstracts
abstract class SdpEditAction {
  const SdpEditAction();

  void execute(List<SdpLine> sdpLines);
}
