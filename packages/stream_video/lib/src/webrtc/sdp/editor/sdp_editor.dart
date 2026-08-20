import 'package:meta/meta.dart';

import '../sdp.dart';

@internal
// ignore: one_member_abstracts
abstract class SdpEditor {
  String? edit(Sdp? sdp);
}
