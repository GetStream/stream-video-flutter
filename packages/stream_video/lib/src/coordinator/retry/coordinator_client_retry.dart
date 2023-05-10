import '../../../open_api/video/coordinator/api.dart';
import '../../errors/video_error.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/call_cid.dart';
import '../../models/call_device.dart';
import '../../models/call_metadata.dart';
import '../../models/call_reaction.dart';
import '../../models/call_received_created_data.dart';
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
import '../models/coordinator_inputs.dart';
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
  Future<Result<None>> blockUser(BlockUserInput input) {
    return _retryManager.execute(
      () => _delegate.blockUser(input),
      (error, nextAttemptDelay) async {
        _logRetry('blockUser', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallDevice>> createDevice(CreateDeviceInput input) {
    return _retryManager.execute(
      () => _delegate.createDevice(input),
      (error, nextAttemptDelay) async {
        _logRetry('createDevice', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> deleteDevice(DeleteDeviceInput input) {
    return _retryManager.execute(
      () => _delegate.deleteDevice(input),
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
  Future<Result<SfuServerSelected>> findBestCallEdgeServer({
    required StreamCallCid callCid,
    required List<SfuEdge> edges,
  }) {
    return _delegate.findBestCallEdgeServer(
      callCid: callCid,
      edges: edges,
    );
  }

  @override
  Future<Result<CallReceivedOrCreatedData>> getOrCreateCall(
    GetOrCreateCallInput input,
  ) {
    return _retryManager.execute(
      () => _delegate.getOrCreateCall(input),
      (error, nextAttemptDelay) async {
        _logRetry('getOrCreateCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallMetadata>> goLive(StreamCallCid callCid) {
    return _retryManager.execute(
      () => _delegate.goLive(callCid),
      (error, nextAttemptDelay) async {
        _logRetry('goLive', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> inviteUsers(UpsertCallMembersInput input) {
    return _retryManager.execute(
      () => _delegate.inviteUsers(input),
      (error, nextAttemptDelay) async {
        _logRetry('inviteUsers', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CoordinatorJoined>> joinCall(JoinCallInput input) {
    return _retryManager.execute(
      () => _delegate.joinCall(input),
      (error, nextAttemptDelay) async {
        _logRetry('joinCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> muteUsers(MuteUsersInput input) {
    return _retryManager.execute(
      () => _delegate.muteUsers(input),
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
  Future<Result<QueriedCalls>> queryCalls(QueryCallsInput input) {
    return _retryManager.execute(
      () => _delegate.queryCalls(input),
      (error, nextAttemptDelay) async {
        _logRetry('queryCalls', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<QueriedMembers>> queryMembers(QueryUsersInput input) {
    return _retryManager.execute(
      () => _delegate.queryMembers(input),
      (error, nextAttemptDelay) async {
        _logRetry('queryMembers', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> requestPermissions(RequestPermissionsInput input) {
    return _retryManager.execute(
      () => _delegate.requestPermissions(input),
      (error, nextAttemptDelay) async {
        _logRetry('requestPermissions', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<SfuServerSelected>> selectCallEdgeServer({
    required StreamCallCid callCid,
    required Map<String, SfuLatency> latencyByEdge,
  }) {
    return _retryManager.execute(
      () => _delegate.selectCallEdgeServer(
        callCid: callCid,
        latencyByEdge: latencyByEdge,
      ),
      (error, nextAttemptDelay) async {
        _logRetry('selectCallEdgeServer', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> sendCustomEvent(CustomEventInput input) {
    return _retryManager.execute(
      () => _delegate.sendCustomEvent(input),
      (error, nextAttemptDelay) async {
        _logRetry('sendCustomEvent', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallReaction>> sendReaction(ReactionInput input) {
    return _retryManager.execute(
      () => _delegate.sendReaction(input),
      (error, nextAttemptDelay) async {
        _logRetry('sendReaction', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> sendUserEvent(EventInput input) {
    return _retryManager.execute(
      () => _delegate.sendUserEvent(input),
      (error, nextAttemptDelay) async {
        _logRetry('sendUserEvent', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> startBroadcasting(StreamCallCid callCid) {
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
  Future<Result<List<CallRecording>>> listRecordings(
      StreamCallCid callCid,
      String session,
      ) {
    return _retryManager.execute(
          () => _delegate.listRecordings(callCid, session),
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
  Future<Result<None>> unblockUser(UnblockUserInput input) {
    return _retryManager.execute(
      () => _delegate.unblockUser(input),
      (error, nextAttemptDelay) async {
        _logRetry('unblockUser', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<CallMetadata>> updateCall(UpdateCallInput input) {
    return _retryManager.execute(
      () => _delegate.updateCall(input),
      (error, nextAttemptDelay) async {
        _logRetry('updateCall', error, nextAttemptDelay);
      },
    );
  }

  @override
  Future<Result<None>> updateUserPermissions(UpdateUserPermissionsInput input) {
    return _retryManager.execute(
      () => _delegate.updateUserPermissions(input),
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
}
