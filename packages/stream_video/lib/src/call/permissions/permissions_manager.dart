import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../../models/call_permission.dart';
import '../../utils/none.dart';

typedef GetStateOrNull = CallState? Function();

@internal
abstract class PermissionsManager {
  Future<Result<None>> request(
    List<CallPermission> permissions,
  );

  Future<Result<None>> grant({
    required String userId,
    List<CallPermission> permissions = const [],
  });

  Future<Result<None>> revoke({
    required String userId,
    List<CallPermission> permissions = const [],
  });

  Future<Result<None>> endCall();

  Future<Result<None>> blockUser(String userId);

  Future<Result<None>> unblockUser(String userId);

  Future<Result<None>> startRecording();

  Future<Result<None>> stopRecording();

  Future<Result<None>> startBroadcasting();

  Future<Result<None>> stopBroadcasting();

  Future<Result<None>> muteUsers(List<String> userIds);
}
