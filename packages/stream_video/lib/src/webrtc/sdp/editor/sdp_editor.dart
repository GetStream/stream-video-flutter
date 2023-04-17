import 'package:meta/meta.dart';

import '../policy/rule/sdp_munging_rule.dart';
import '../sdp.dart';

@internal
abstract class SdpEditor {

  void upsert(SdpMungingRule rule);

  void removeWhereType<T extends SdpMungingRule>();

  String? edit(Sdp? sdp);
}
