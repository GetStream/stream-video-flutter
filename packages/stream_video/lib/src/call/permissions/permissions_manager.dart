import 'package:meta/meta.dart';

import '../../../open_api/video/coordinator/api.dart';
import '../../call_state.dart';
import '../../coordinator/coordinator_client.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../call.dart';
import '../state/call_state_notifier.dart';

typedef GetStateOrNull = CallState? Function();

@internal
class PermissionsManager {
  const PermissionsManager({
    required this.callCid,
    required this.coordinatorClient,
    required this.stateManager,
  });

  TaggedLogger get _logger => const TaggedLogger('SV:PermissionsManager');

  final StreamCallCid callCid;
  final CoordinatorClient coordinatorClient;
  final CallStateNotifier stateManager;

  Future<Result<None>> endCall() async {
    if (!hasPermission(CallPermission.endCall)) {
      return Result.error('has no "end-call" permission');
    }
    _logger.d(() => '[endCall] callCid: $callCid');
    final result = await coordinatorClient.endCall(callCid);
    _logger.v(() => '[endCall] result: $result');
    return result;
  }

  Future<Result<None>> request(
    List<CallPermission> permissions,
  ) async {
    final canRequest = permissions.every(canRequestPermission);
    if (!canRequest) {
      _logger.w(() => '[request] rejected (no permission)');
      return Result.error(
        'Some permissions cannot be requested (see canRequestPermission method)',
      );
    }
    _logger.d(() => '[request] permissions: $permissions');
    final result = coordinatorClient.requestPermissions(
      callCid: callCid,
      permissions: permissions,
    );
    _logger.v(() => '[request] result: $result');
    return result;
  }

  /// Grants the [permissions] to the [userId] in the [callCid].
  Future<Result<None>> grant({
    required String userId,
    List<CallPermission> permissions = const [],
  }) async {
    final canUpdate = hasPermission(CallPermission.updateCallPermissions);
    if (!canUpdate) {
      _logger.w(() => '[grant] rejected (no permission)');
      return Result.error(
        'Cannot grant permissions (see canUpdatePermission method)',
      );
    }
    _logger.d(() => '[grant] userId: $userId, permissions: $permissions');
    final result = await coordinatorClient.updateUserPermissions(
      callCid: callCid,
      userId: userId,
      grantPermissions: permissions,
      revokePermissions: const [],
    );
    _logger.v(() => '[grant] result: $result');
    return result;
  }

  /// Revokes the [permissions] from the [userId] in the [callCid].
  Future<Result<None>> revoke({
    required String userId,
    List<CallPermission> permissions = const [],
  }) async {
    final canUpdate = hasPermission(CallPermission.updateCallPermissions);
    if (!canUpdate) {
      _logger.w(() => '[revoke] rejected (no permission)');
      return Result.error(
        'Cannot revoke permissions (see canUpdatePermission method)',
      );
    }
    _logger.d(() => '[revoke] userId: $userId, permissions: $permissions');
    final result = await coordinatorClient.updateUserPermissions(
      callCid: callCid,
      userId: userId,
      grantPermissions: const [],
      revokePermissions: permissions,
    );
    _logger.v(() => '[revoke] result: $result');
    return result;
  }

  Future<Result<None>> blockUser(String userId) async {
    if (!hasPermission(CallPermission.blockUsers)) {
      _logger.w(() => '[blockUser] rejected (no permission)');
      return Result.error('Cannot block user (no permission)');
    }
    _logger.d(() => '[blockUser] userId: $userId');
    final result = await coordinatorClient.blockUser(
      callCid: callCid,
      userId: userId,
    );
    _logger.v(() => '[blockUser] result: $result');
    return result;
  }

  Future<Result<None>> unblockUser(String userId) async {
    if (!hasPermission(CallPermission.blockUsers)) {
      _logger.w(() => '[unblockUser] rejected (no permission)');
      return Result.error('Cannot unblock user (no permission)');
    }
    _logger.d(() => '[unblockUser] userId: $userId');
    final result = coordinatorClient.unblockUser(
      callCid: callCid,
      userId: userId,
    );
    _logger.v(() => '[unblockUser] result: $result');
    return result;
  }

  Future<Result<None>> startRecording({
    String? recordingExternalStorage,
  }) async {
    if (!hasPermission(CallPermission.startRecordCall)) {
      _logger.w(() => '[startRecording] rejected (no permission)');
      return Result.error('Cannot start recording (no permission)');
    }
    _logger.d(() => '[startRecording] no args');
    final result = await coordinatorClient.startRecording(
      callCid,
      recordingExternalStorage: recordingExternalStorage,
    );
    _logger.v(() => '[startRecording] result: $result');
    return result;
  }

  Future<Result<List<CallRecording>>> listRecordings() async {
    _logger.d(() => '[listRecordings] Call $callCid');
    final result = await coordinatorClient.listRecordings(callCid);
    _logger.v(() => '[listRecordings] result: $result');
    return result;
  }

  Future<Result<None>> stopRecording() async {
    if (!hasPermission(CallPermission.stopRecordCall)) {
      _logger.w(() => '[stopRecording] rejected (no permission)');
      return Result.error('Cannot stop recording (no permission)');
    }
    _logger.d(() => '[stopRecording] no args');
    final result = await coordinatorClient.stopRecording(callCid);
    _logger.v(() => '[stopRecording] result: $result');
    return result;
  }

  Future<Result<None>> startTranscription({
    bool? enableClosedCaptions,
    TranscriptionSettingsLanguage? language,
    String? transcriptionExternalStorage,
  }) async {
    if (!hasPermission(CallPermission.startTranscriptionCall)) {
      _logger.w(() => '[startTranscription] rejected (no permission)');
      return Result.error('Cannot start transcription (no permission)');
    }
    _logger.d(() => '[startTranscription] no args');
    final result = await coordinatorClient.startTranscription(
      callCid,
      enableClosedCaptions: enableClosedCaptions,
      language: language,
      transcriptionExternalStorage: transcriptionExternalStorage,
    );
    _logger.v(() => '[startTranscription] result: $result');
    return result;
  }

  Future<Result<List<CallTranscription>>> listTranscriptions() async {
    _logger.d(() => '[listTranscriptions] Call $callCid');
    final result = await coordinatorClient.listTranscriptions(callCid);
    _logger.v(() => '[listTranscriptions] result: $result');
    return result;
  }

  Future<Result<None>> stopTranscription() async {
    if (!hasPermission(CallPermission.startTranscriptionCall)) {
      _logger.w(() => '[stopTranscription] rejected (no permission)');
      return Result.error('Cannot stop transcription (no permission)');
    }
    _logger.d(() => '[stopTranscription] no args');
    final result = await coordinatorClient.stopTranscription(callCid);
    _logger.v(() => '[stopTranscription] result: $result');
    return result;
  }

  Future<Result<None>> startClosedCaptions({
    bool? enableTranscription,
    TranscriptionSettingsLanguage? language,
    String? transcriptionExternalStorage,
  }) async {
    if (!hasPermission(CallPermission.startClosedCaptionsCall)) {
      _logger.w(() => '[startClosedCaptions] rejected (no permission)');
      return Result.error('Cannot start closed captions (no permission)');
    }
    _logger.d(() => '[startClosedCaptions] no args');
    final result = await coordinatorClient.startClosedCaptions(
      callCid,
      enableTranscription: enableTranscription,
      language: language,
      transcriptionExternalStorage: transcriptionExternalStorage,
    );
    _logger.v(() => '[startClosedCaptions] result: $result');
    return result;
  }

  Future<Result<None>> stopClosedCaptions() async {
    if (!hasPermission(CallPermission.stopClosedCaptionsCall)) {
      _logger.w(() => '[stopClosedCaptions] rejected (no permission)');
      return Result.error('Cannot stop closed captions (no permission)');
    }
    _logger.d(() => '[stopClosedCaptions] no args');
    final result = await coordinatorClient.stopClosedCaptions(callCid);
    _logger.v(() => '[stopClosedCaptions] result: $result');
    return result;
  }

  Future<Result<String?>> startBroadcasting() async {
    if (!hasPermission(CallPermission.startBroadcastCall)) {
      _logger.w(() => '[startBroadcasting] rejected (no permission)');
      return Result.error('Cannot start broadcasting (no permission)');
    }
    _logger.d(() => '[startBroadcasting] no args');
    final result = await coordinatorClient.startBroadcasting(callCid);
    _logger.v(() => '[startBroadcasting] result: $result');
    return result;
  }

  Future<Result<None>> stopBroadcasting() async {
    if (!hasPermission(CallPermission.stopBroadcastCall)) {
      _logger.w(() => '[stopBroadcasting] rejected (no permission)');
      return Result.error('Cannot stop broadcasting (no permission)');
    }
    _logger.d(() => '[stopBroadcasting] no args');
    final result = await coordinatorClient.stopBroadcasting(callCid);
    _logger.v(() => '[stopBroadcasting] result: $result');
    return result;
  }

  Future<Result<None>> muteUsers({
    required List<String> userIds,
    TrackType track = TrackType.audio,
  }) async {
    if (!hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteUsers] rejected (no permission)');
      return Result.error('Cannot mute users (no permission)');
    }
    _logger.d(() => '[muteUsers] userIds: $userIds');

    late final Result<None> result;
    if (track == TrackType.all) {
      result = await coordinatorClient.muteUsers(
        callCid: callCid,
        userIds: userIds,
        audio: true,
        video: true,
        screenshare: true,
      );
    } else {
      result = await coordinatorClient.muteUsers(
        callCid: callCid,
        userIds: userIds,
        audio: track == TrackType.audio,
        video: track == TrackType.video,
        screenshare: track == TrackType.screenshare,
      );
    }

    _logger.v(() => '[muteUsers] result: $result');
    return result;
  }

  Future<Result<None>> muteSelf({TrackType track = TrackType.audio}) async {
    if (!hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteSelf] rejected (no permission)');
      return Result.error('Cannot mute self (no permission)');
    }
    _logger.d(() => '[muteSelf] muting current user');

    final selfUID = stateManager.callState.currentUserId;
    return muteUsers(userIds: [selfUID], track: track);
  }

  Future<Result<None>> muteOthers({TrackType track = TrackType.audio}) async {
    if (!hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteOthers] rejected (no permission)');
      return Result.error('Cannot mute other users (no permission)');
    }
    _logger.d(() => '[muteOthers] muting other users');

    final usersToMute = <String>[];
    for (final participant in stateManager.callState.otherParticipants) {
      if ((track == TrackType.all && participant.publishedTracks.isNotEmpty) ||
          participant.publishedTracks.containsKey(track.toSFUTrackType())) {
        usersToMute.add(participant.userId);
      }
    }
    return muteUsers(userIds: usersToMute, track: track);
  }

  Future<Result<None>> muteAllUsers({TrackType track = TrackType.all}) async {
    if (!hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteAllUsers] rejected (no permission)');
      return Result.error('Cannot mute users (no permission)');
    }
    _logger.d(() => '[muteAllUsers] muting all users');

    return coordinatorClient.muteUsers(
      callCid: callCid,
      muteAllUsers: true,
      userIds: const [],
      audio: track == TrackType.audio || track == TrackType.all,
      video: track == TrackType.video || track == TrackType.all,
      screenshare: track == TrackType.screenshare || track == TrackType.all,
    );
  }

  Future<Result<None>> pinForEveryone({
    required String userId,
    required String sessionId,
  }) async {
    if (!hasPermission(CallPermission.pinForEveryone)) {
      _logger.w(() => '[pinForEveryone] rejected (no permission)');
      return Result.error('Cannot pin session for everyone (no permission)');
    }

    _logger.d(() => '[pinForEveryone] pinning $userId for everyone');

    return coordinatorClient.videoPin(
      callCid: callCid,
      sessionId: sessionId,
      userId: userId,
    );
  }

  Future<Result<None>> unpinForEveryone({
    required String userId,
    required String sessionId,
  }) async {
    if (!hasPermission(CallPermission.pinForEveryone)) {
      _logger.w(() => '[unpinForEveryone] rejected (no permission)');
      return Result.error('Cannot unpin session for everyone (no permission)');
    }

    _logger.d(() => '[unpinForEveryone] unpinning $userId for everyone');

    return coordinatorClient.videoUnpin(
      callCid: callCid,
      sessionId: sessionId,
      userId: userId,
    );
  }

  Future<Result<CallReaction>> sendReaction({
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  }) async {
    if (!hasPermission(CallPermission.createReaction)) {
      _logger.w(() => '[sendReaction] rejected (no permission)');
      return Result.error('Cannot send reaction (no permission)');
    }
    final result = await coordinatorClient.sendReaction(
      callCid: callCid,
      reactionType: reactionType,
      emojiCode: emojiCode,
      custom: custom,
    );
    _logger.v(() => '[sendReaction] result: $result');
    return result;
  }

  Future<Result<QueriedMembers>> queryMembers({
    Map<String, Object> filterConditions = const {},
    String? next,
    String? prev,
    List<SortParamRequest> sorts = const [],
    int? limit,
  }) async {
    if (!hasPermission(CallPermission.readCall)) {
      _logger.w(() => '[queryMembers] rejected (no permission)');
      return Result.error('Cannot query members (no permission)');
    }
    final result = coordinatorClient.queryMembers(
      callCid: callCid,
      filterConditions: filterConditions,
      next: next,
      prev: prev,
      sorts: sorts,
      limit: limit,
    );
    _logger.v(() => '[queryMembers] result: $result');
    return result;
  }

  bool canRequestPermission(CallPermission permission) {
    final settings = stateManager.callStateStream.valueOrNull?.settings;
    if (settings == null) {
      _logger.w(() => 'canRequestPermission: no settings');
      return false;
    }

    if (permission == CallPermission.sendAudio) {
      return settings.audio.accessRequestEnabled;
    } else if (permission == CallPermission.sendVideo) {
      return settings.video.accessRequestEnabled;
    } else if (permission == CallPermission.screenshare) {
      return settings.screenShare.accessRequestEnabled;
    }

    _logger.w(() => 'canRequestPermission: unknown permission: $permission');
    return false;
  }

  bool hasPermission(CallPermission permission) {
    final capabilities =
        stateManager.callStateStream.valueOrNull?.ownCapabilities;
    if (capabilities == null || capabilities.isEmpty) {
      _logger.w(() => '[hasPermission] rejected (no capabilities)');
      return false;
    }
    return capabilities.contains(permission);
  }
}
