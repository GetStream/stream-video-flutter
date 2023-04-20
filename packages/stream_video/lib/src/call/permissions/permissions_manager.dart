import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../../action/call_action.dart';
import '../../utils/none.dart';

typedef GetStateOrNull = CallState? Function();

@internal
abstract class PermissionsManager {
  Future<Result<None>> endCall();

  Future<Result<None>> apply(CallAction action);
}
