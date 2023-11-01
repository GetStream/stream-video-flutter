import '../../../open_api/video/coordinator/api.dart' as open;
import '../../errors/video_error.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/call_cid.dart';
import '../../models/call_metadata.dart';
import '../../models/call_permission.dart';
import '../../models/call_reaction.dart';
import '../../models/call_received_created_data.dart';
import '../../models/call_received_data.dart';
import '../../models/call_settings.dart';
import '../../models/guest_created_data.dart';
import '../../models/push_device.dart';
import '../../models/push_provider.dart';
import '../../models/queried_calls.dart';
import '../../models/queried_members.dart';
import '../../models/user_info.dart';
import '../../retry/retry_manager.dart';
import '../../retry/retry_policy.dart';
import '../../shared_emitter.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../coordinator_client.dart';
import '../models/coordinator_events.dart';
import '../models/coordinator_models.dart';

class CoordinatorClientRetry extends CoordinatorClient {
  CoordinatorClientRetry({
    required CoordinatorClient delegate,
    required RetryPolicy retryPolicy,
  })  : _delegate = delegate,
        _retryManager = RpcRetryManager(retryPolicy);

  final CoordinatorClient _delegate;
  final RpcRetryManager _retryManager;

  final _logger = taggedLogger(tag: 'SV:CoordinatorClientRetry');

  @override
  Future<Result<None>> blockUser({
    required StreamCallCid callCid,
    required String userId,
  }) {
    return _retryManager.execute(
      () => _delegate.blockUser(
        callCid: callCid,
        userId: userId,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('blockUser', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> createDevice({
    required String id,
    required PushProvider pushProvider,
    String? pushProviderName,
    String? userId,
    bool? voipToken,
  }) {
    return _retryManager.execute(
      () => _delegate.createDevice(
        id: id,
        pushProvider: pushProvider,
        pushProviderName: pushProviderName,
        userId: userId,
        voipToken: voipToken,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('createDevice', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<List<PushDevice>>> listDevices({
    required String userId,
  }) {
    return _retryManager.execute(
      () => _delegate.listDevices(
        userId: userId,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('listDevices', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> deleteDevice({
    required String id,
    String? userId,
  }) {
    return _retryManager.execute(
      () => _delegate.deleteDevice(
        id: id,
        userId: userId,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('deleteDevice', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> endCall(StreamCallCid callCid) {
    return _retryManager.execute(
      () => _delegate.endCall(callCid),
      (error, nextAttemptDelay) async {
        _logRetry('endCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  SharedEmitter<CoordinatorEvent> get events => _delegate.events;

  @override
  Future<Result<CallReceivedData>> getCall({
    required StreamCallCid callCid,
    int? membersLimit,
    bool? ringing,
    bool? notify,
  }) {
    return _retryManager.execute(
      () => _delegate.getCall(
        callCid: callCid,
        membersLimit: membersLimit,
        ringing: ringing,
        notify: notify,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('getCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallReceivedOrCreatedData>> getOrCreateCall({
    required StreamCallCid callCid,
    bool? ringing,
    List<open.MemberRequest>? members,
  }) {
    return _retryManager.execute(
      () => _delegate.getOrCreateCall(
        callCid: callCid,
        ringing: ringing,
        members: members,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('getOrCreateCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallMetadata>> goLive({
    required StreamCallCid callCid,
    bool? startHls,
    bool? startRecording,
    bool? startTranscription,
  }) {
    return _retryManager.execute(
      () => _delegate.goLive(
        callCid: callCid,
        startHls: startHls,
        startRecording: startRecording,
        startTranscription: startTranscription,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('goLive', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> addMembers({
    required StreamCallCid callCid,
    required Iterable<open.MemberRequest> members,
  }) {
    return _retryManager.execute(
      () => _delegate.addMembers(
        callCid: callCid,
        members: members,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('addMembers', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> removeMembers({
    required StreamCallCid callCid,
    required Iterable<String> removeIds,
  }) async {
    return _retryManager.execute(
      () => _delegate.removeMembers(
        callCid: callCid,
        removeIds: removeIds,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('removeMembers', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> updateCallMembers({
    required StreamCallCid callCid,
    Iterable<open.MemberRequest> updateMembers = const [],
    Iterable<String> removeIds = const [],
  }) {
    return _retryManager.execute(
      () => _delegate.updateCallMembers(
        callCid: callCid,
        updateMembers: updateMembers,
        removeIds: removeIds,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('updateCallMembers', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CoordinatorJoined>> joinCall({
    required StreamCallCid callCid,
    String? datacenterId,
    bool? ringing,
    bool? create,
  }) {
    return _retryManager.execute(
      () => _delegate.joinCall(
        callCid: callCid,
        datacenterId: datacenterId,
        ringing: ringing,
        create: create,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('joinCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> acceptCall({required StreamCallCid cid}) {
    return _retryManager.execute(
      () => _delegate.acceptCall(cid: cid),
      (error, nextAttemptDelay) async {
        _logRetry('acceptCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> rejectCall({required StreamCallCid cid}) {
    return _retryManager.execute(
      () => _delegate.rejectCall(cid: cid),
      (error, nextAttemptDelay) async {
        _logRetry('rejectCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> muteUsers({
    required StreamCallCid callCid,
    required List<String> userIds,
    bool? muteAllUsers,
    bool? audio,
    bool? video,
    bool? screenshare,
  }) {
    return _retryManager.execute(
      () => _delegate.muteUsers(
        callCid: callCid,
        userIds: userIds,
        muteAllUsers: muteAllUsers,
        audio: audio,
        video: video,
        screenshare: screenshare,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('muteUsers', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> connectUser(UserInfo user) {
    return _delegate.connectUser(user);
  }

  @override
  Future<Result<None>> openConnection() {
    return _delegate.openConnection();
  }

  @override
  Future<Result<None>> closeConnection() {
    return _delegate.closeConnection();
  }

  @override
  Future<Result<None>> disconnectUser() {
    return _delegate.disconnectUser();
  }

  @override
  Future<Result<QueriedCalls>> queryCalls({
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    List<open.SortParamRequest> sorts = const [],
    int? limit,
  }) {
    return _retryManager.execute(
      () => _delegate.queryCalls(
        filterConditions: filterConditions,
        next: next,
        prev: prev,
        sorts: sorts,
        limit: limit,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('queryCalls', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<QueriedMembers>> queryMembers({
    required StreamCallCid callCid,
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    List<open.SortParamRequest> sorts = const [],
    int? limit,
  }) {
    return _retryManager.execute(
      () => _delegate.queryMembers(
        callCid: callCid,
        filterConditions: filterConditions,
        next: next,
        prev: prev,
        sorts: sorts,
        limit: limit,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('queryMembers', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> requestPermissions({
    required StreamCallCid callCid,
    required List<CallPermission> permissions,
  }) {
    return _retryManager.execute(
      () => _delegate.requestPermissions(
        callCid: callCid,
        permissions: permissions,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('requestPermissions', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> sendCustomEvent({
    required StreamCallCid callCid,
    required String eventType,
    Map<String, Object> custom = const {},
  }) {
    return _retryManager.execute(
      () => _delegate.sendCustomEvent(
        callCid: callCid,
        eventType: eventType,
        custom: custom,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('sendCustomEvent', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallReaction>> sendReaction({
    required StreamCallCid callCid,
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  }) {
    return _retryManager.execute(
      () => _delegate.sendReaction(
        callCid: callCid,
        reactionType: reactionType,
        emojiCode: emojiCode,
        custom: custom,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('sendReaction', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<String?>> startBroadcasting(StreamCallCid callCid) {
    return _retryManager.execute(
      () => _delegate.startBroadcasting(callCid),
      (error, nextAttemptDelay) async {
        _logRetry('startBroadcasting', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> startRecording(StreamCallCid callCid) {
    return _retryManager.execute(
      () => _delegate.startRecording(callCid),
      (error, nextAttemptDelay) async {
        _logRetry('startRecording', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<List<open.CallRecording>>> listRecordings(
    StreamCallCid callCid,
    String sessionId,
  ) {
    return _retryManager.execute(
      () => _delegate.listRecordings(callCid, sessionId),
      (error, nextAttemptDelay) async {
        _logRetry('listRecordings', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> stopBroadcasting(StreamCallCid callCid) {
    return _retryManager.execute(
      () => _delegate.stopBroadcasting(callCid),
      (error, nextAttemptDelay) async {
        _logRetry('stopBroadcasting', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallMetadata>> stopLive(StreamCallCid callCid) {
    return _retryManager.execute(
      () => _delegate.stopLive(callCid),
      (error, nextAttemptDelay) async {
        _logRetry('stopLive', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> stopRecording(StreamCallCid callCid) {
    return _retryManager.execute(
      () => _delegate.stopRecording(callCid),
      (error, nextAttemptDelay) async {
        _logRetry('stopRecording', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> unblockUser({
    required StreamCallCid callCid,
    required String userId,
  }) {
    return _retryManager.execute(
      () => _delegate.unblockUser(
        callCid: callCid,
        userId: userId,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('unblockUser', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallMetadata>> updateCall({
    required StreamCallCid callCid,
    Map<String, Object> custom = const {},
    StreamRingSettings? ring,
    StreamAudioSettings? audio,
    StreamVideoSettings? video,
    StreamScreenShareSettings? screenShare,
    StreamRecordingSettings? recording,
    StreamTranscriptionSettings? transcription,
    StreamBackstageSettings? backstage,
    StreamGeofencingSettings? geofencing,
  }) {
    return _retryManager.execute(
      () => _delegate.updateCall(
        callCid: callCid,
        custom: custom,
        ring: ring,
        audio: audio,
        video: video,
        screenShare: screenShare,
        recording: recording,
        transcription: transcription,
        backstage: backstage,
        geofencing: geofencing,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('updateCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> updateUserPermissions({
    required StreamCallCid callCid,
    required String userId,
    required List<CallPermission> grantPermissions,
    required List<CallPermission> revokePermissions,
  }) {
    return _retryManager.execute(
      () => _delegate.updateUserPermissions(
        callCid: callCid,
        userId: userId,
        grantPermissions: grantPermissions,
        revokePermissions: revokePermissions,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('updateUserPermissions', error, nextAttemptDelay);
      },
    );
  }

  void _logRetry(
    String req,
    VideoError error,
    Duration nextAttemptDelay,
  ) {
    _logger.w(
      () => '[$req] failed: $error, '
          'retrying in ${nextAttemptDelay.inMilliseconds} ms',
    );
  }

  @override
  Future<Result<GuestCreatedData>> loadGuest({
    required String id,
    String? name,
    String? role,
    String? image,
    List<String>? teams,
    Map<String, Object> custom = const {},
  }) {
    return _retryManager.execute(
      () => _delegate.loadGuest(
        id: id,
        name: name,
        role: role,
        image: image,
        teams: teams,
        custom: custom,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('loadGuest', error, nextAttemptDelay);
      },
    );
  }
}
