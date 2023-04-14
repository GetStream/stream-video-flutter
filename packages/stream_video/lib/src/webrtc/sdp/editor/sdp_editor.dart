import 'package:meta/meta.dart';

import '../sdp.dart';

@internal
abstract class SdpEditor {
  String? edit(Sdp? sdp);
}
