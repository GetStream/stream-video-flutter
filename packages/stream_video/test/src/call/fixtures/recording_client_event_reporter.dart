import 'package:stream_video/src/telemetry/client_event.dart';
import 'package:stream_video/src/telemetry/client_event_reporter.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/stream_video.dart';

/// Reporter that records the aborts and join attempts a call reports.
///
/// Every other member delegates to the no-op reporter. Set
/// [onReportJoinAttempt] to run code, such as a throw, inside
/// [reportJoinAttempt].
class RecordingClientEventReporter implements ClientEventReporter {
  RecordingClientEventReporter({this.onReportJoinAttempt});

  static const _delegate = ClientEventReporter.noOp();

  /// Runs on every [reportJoinAttempt], after it is recorded.
  void Function()? onReportJoinAttempt;

  /// Every abort code reported, in order.
  final aborts = <ClientEventStandardCode>[];

  /// The calls registered and not unregistered since.
  final registered = <String>{};

  /// Every join attempt reason reported, in order.
  final joinAttempts = <JoinReason>[];

  /// The reason of every new join attempt asked for directly, in order.
  final newJoinAttempts = <JoinReason>[];

  @override
  void abort(StreamCallCid cid, ClientEventStandardCode code) {
    aborts.add(code);
  }

  @override
  void reportJoinAttempt(StreamCallCid cid, {required JoinReason reason}) {
    joinAttempts.add(reason);
    onReportJoinAttempt?.call();
  }

  @override
  void registerCall(StreamCallCid cid) {
    registered.add(cid.value);
    _delegate.registerCall(cid);
  }

  @override
  void unregisterCall(StreamCallCid cid) {
    registered.remove(cid.value);
    _delegate.unregisterCall(cid);
  }

  @override
  void newJoinAttempt(StreamCallCid cid, {required JoinReason reason}) {
    newJoinAttempts.add(reason);
    _delegate.newJoinAttempt(cid, reason: reason);
  }

  @override
  void setCallSessionId(StreamCallCid cid, String callSessionId) =>
      _delegate.setCallSessionId(cid, callSessionId);

  @override
  void setCoordinatorConnectId(String? connectId) =>
      _delegate.setCoordinatorConnectId(connectId);

  @override
  String beginStage(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventDetails details = const ClientEventDetails(),
  }) => _delegate.beginStage(cid, stage, details: details);

  @override
  String beginConnectionStage(
    ClientEventStage stage, {
    required String connectId,
    ClientEventDetails details = const ClientEventDetails(),
  }) => _delegate.beginConnectionStage(
    stage,
    connectId: connectId,
    details: details,
  );

  @override
  void completeStage(
    String stageId, {
    required ClientEventOutcome outcome,
    int retryCount = 0,
    ClientEventFailure? failure,
    ClientEventDetails details = const ClientEventDetails(),
  }) => _delegate.completeStage(
    stageId,
    outcome: outcome,
    retryCount: retryCount,
    failure: failure,
    details: details,
  );

  @override
  void failStage(
    String stageId, {
    required ClientEventFailure failure,
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  }) => _delegate.failStage(
    stageId,
    failure: failure,
    retryCount: retryCount,
    details: details,
  );

  @override
  void failStageWithError(
    String stageId,
    Object? error, {
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  }) => _delegate.failStageWithError(
    stageId,
    error,
    retryCount: retryCount,
    details: details,
  );

  @override
  void reportEvent(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventType type = ClientEventType.initiated,
    ClientEventDetails details = const ClientEventDetails(),
  }) => _delegate.reportEvent(cid, stage, type: type, details: details);

  @override
  void dispose() => _delegate.dispose();
}
