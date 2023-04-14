import 'package:meta/meta.dart';

import '../policy/sdp_policy.dart';
import '../sdp.dart';

@internal
abstract class SdpEditor {

  void addRule(SdpMungingRule rule);

  void removeRule<T extends SdpMungingRule>();

  String? edit(Sdp? sdp);
}
