import 'package:uuid/uuid.dart';

import '../../globals.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import 'client_event.dart';
import 'client_event_error_mapper.dart';
import 'client_event_transport.dart';
import 'client_event_types.dart';

const _tag = 'SV:ClientEventReporter';

/// Resolves the current user id at send time (the user can change, e.g. guest
/// login resolves the real id after connecting).
typedef UserIdResolver = String Function();

/// Returns the current time. Injectable so tests can be deterministic.
typedef Clock = DateTime Function();

/// Generates a fresh unique id (`join_attempt_id` / `stage_id`). Injectable so
/// tests can be deterministic.
typedef IdGenerator = String Function();

String _defaultId() => const Uuid().v4();

/// Client-level state shared across all calls
class ClientEventContext {
  ClientEventContext({
    required this.resolveUserId,
    Clock now = DateTime.now,
  }) : _now = now;

  final UserIdResolver resolveUserId;
  final Clock _now;

  /// Set by the coordinator socket
  String? coordinatorConnectId;

  ClientEvent build(
    ClientEventStage stage,
    ClientEventType type, {
    ClientEventIdentity callIdentity = const ClientEventIdentity(),
    String? stageId,
    ClientEventOutcome? outcome,
    int? retryCount,
    int? elapsedTime,
    ClientEventFailure? failure,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    return ClientEvent(
      stage: stage,
      type: type,
      userId: resolveUserId(),
      userAgent: xStreamClientHeader,
      sdkVersion: streamVideoVersion,
      timestamp: _now(),
      identity: callIdentity.copyWith(
        coordinatorConnectId: coordinatorConnectId,
      ),
      stageId: stageId,
      outcome: outcome,
      retryCount: retryCount,
      elapsedTime: elapsedTime,
      failure: failure,
      details: details,
    );
  }
}

/// Reports join-lifecycle telemetry to the backend, stage by stage.
abstract interface class ClientEventReporter {
  factory ClientEventReporter({
    required ClientEventTransport transport,
    required UserIdResolver resolveUserId,
    ClientEventErrorMapper errorMapper,
    Clock now,
    IdGenerator generateId,
  }) = _ClientEventReporterImpl;

  /// A reporter that does nothing — used when reporting is disabled.
  const factory ClientEventReporter.noOp() = _NoOpClientEventReporter;

  /// Starts tracking [cid] and generates its initial `join_attempt_id`.
  void registerCall(StreamCallCid cid);

  /// Stops tracking [cid], aborting any still-in-flight stages as failures.
  void unregisterCall(StreamCallCid cid);

  /// Generates a fresh `join_attempt_id` for [cid] (full rejoin / migration)
  void newJoinAttempt(StreamCallCid cid, {required JoinReason reason});

  /// Records the server-side `call_session_id` for [cid], known after the
  /// coordinator join.
  void setCallSessionId(StreamCallCid cid, String callSessionId);

  /// Records the current coordinator connection id.
  void setCoordinatorConnectId(String? connectId);

  /// Emits a call-scoped `initiated` event and returns a `stage_id` to pair with
  /// [completeStage] / [failStage].
  String beginStage(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventDetails details = const ClientEventDetails(),
  });

  /// Emits a connection-scoped `initiated` event (not tied to a call).
  String beginConnectionStage(
    ClientEventStage stage, {
    required String connectId,
    ClientEventDetails details = const ClientEventDetails(),
  });

  /// Emits the `completed` event for the pair opened by [beginStage] /
  /// [beginConnectionStage].
  void completeStage(
    String stageId, {
    required ClientEventOutcome outcome,
    int retryCount = 0,
    ClientEventFailure? failure,
    ClientEventDetails details = const ClientEventDetails(),
  });

  /// Convenience for a `completed` + `failure` event.
  void failStage(
    String stageId, {
    required ClientEventFailure failure,
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  });

  /// Fails [stageId], mapping [error] through the error mapper.
  void failStageWithError(
    String stageId,
    Object? error, {
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  });

  /// Emits a single, unpaired event (e.g. `JoinInitiated`, `FirstVideoFrame`).
  void reportEvent(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventType type = ClientEventType.initiated,
    ClientEventDetails details = const ClientEventDetails(),
  });

  /// Fails every in-flight stage of [cid] with [code]
  void abort(StreamCallCid cid, ClientEventStandardCode code);

  void dispose();
}

/// Per-call attempt state.
class _CallState {
  _CallState(this.cid, this.joinAttemptId);

  final StreamCallCid cid;
  String joinAttemptId;
  JoinReason joinReason = JoinReason.firstAttempt;
  String? callSessionId;

  ClientEventIdentity get identity => ClientEventIdentity(
    callType: cid.type.toString(),
    callId: cid.id,
    joinAttemptId: joinAttemptId,
    joinReason: joinReason,
    callSessionId: callSessionId,
  );
}

/// A stage pair awaiting its `completed` event.
class _PendingStage {
  _PendingStage({
    required this.stage,
    required this.startedAt,
    required this.identity,
    this.cidValue,
  });

  final ClientEventStage stage;
  final DateTime startedAt;
  final ClientEventIdentity identity;
  final String? cidValue;
}

class _ClientEventReporterImpl implements ClientEventReporter {
  _ClientEventReporterImpl({
    required this.transport,
    required UserIdResolver resolveUserId,
    this.errorMapper = const ClientEventErrorMapper(),
    Clock now = DateTime.now,
    IdGenerator generateId = _defaultId,
  }) : _context = ClientEventContext(resolveUserId: resolveUserId, now: now),
       _now = now,
       _generateId = generateId;

  final ClientEventTransport transport;
  final ClientEventErrorMapper errorMapper;
  final ClientEventContext _context;
  final Clock _now;
  final IdGenerator _generateId;

  final _logger = taggedLogger(tag: _tag);

  /// cid value -> call state.
  final Map<String, _CallState> _calls = {};

  /// stage_id -> pending pair (both call- and connection-scoped).
  final Map<String, _PendingStage> _pending = {};

  @override
  void registerCall(StreamCallCid cid) {
    _calls[cid.value] = _CallState(cid, _generateId());
    _logger.d(() => '[registerCall] cid: ${cid.value}');
  }

  @override
  void unregisterCall(StreamCallCid cid) {
    abort(cid, ClientEventStandardCode.clientAborted);
    _calls.remove(cid.value);
    _logger.d(() => '[unregisterCall] cid: ${cid.value}');
  }

  @override
  void newJoinAttempt(
    StreamCallCid cid, {
    required JoinReason reason,
  }) {
    final call = _calls[cid.value];
    if (call == null) return;

    call
      ..joinAttemptId = _generateId()
      ..joinReason = reason;
    _logger.d(
      () =>
          '[newJoinAttempt] cid: ${cid.value}, '
          'id: ${call.joinAttemptId}, reason: ${reason.wireValue}',
    );
  }

  @override
  void setCallSessionId(StreamCallCid cid, String callSessionId) {
    _calls[cid.value]?.callSessionId = callSessionId;
  }

  @override
  void setCoordinatorConnectId(String? connectId) {
    _context.coordinatorConnectId = connectId;
  }

  @override
  String beginStage(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    final call = _calls[cid.value];
    if (call == null) {
      _logger.w(() => '[beginStage] cid not registered: ${cid.value}');
      return '';
    }

    return _begin(
      stage,
      identity: call.identity,
      cidValue: cid.value,
      details: details,
    );
  }

  @override
  String beginConnectionStage(
    ClientEventStage stage, {
    required String connectId,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    // Records the connection id so it's also stamped on later call-scoped
    _context.coordinatorConnectId = connectId;
    return _begin(
      stage,
      identity: const ClientEventIdentity(),
      details: details,
    );
  }

  @override
  void completeStage(
    String stageId, {
    required ClientEventOutcome outcome,
    int retryCount = 0,
    ClientEventFailure? failure,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    if (stageId.isEmpty) return;

    final pending = _pending.remove(stageId);
    if (pending == null) {
      _logger.w(() => '[completeStage] unknown stageId: $stageId');
      return;
    }

    final elapsedMs = _now().difference(pending.startedAt).inMilliseconds;

    // Refresh the late-bound call_session_id (only known after CoordinatorJoin)
    // while keeping the begin-time attempt identity stable.
    final callSessionId = pending.cidValue == null
        ? null
        : _calls[pending.cidValue]?.callSessionId;

    _dispatch(
      _context.build(
        pending.stage,
        ClientEventType.completed,
        callIdentity: pending.identity.copyWith(callSessionId: callSessionId),
        stageId: stageId,
        outcome: outcome,
        retryCount: retryCount,
        elapsedTime: elapsedMs,
        failure: failure,
        details: details,
      ),
    );
  }

  @override
  void failStage(
    String stageId, {
    required ClientEventFailure failure,
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    completeStage(
      stageId,
      outcome: ClientEventOutcome.failure,
      retryCount: retryCount,
      failure: failure,
      details: details,
    );
  }

  @override
  void failStageWithError(
    String stageId,
    Object? error, {
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    failStage(
      stageId,
      failure: errorMapper.map(error),
      retryCount: retryCount,
      details: details,
    );
  }

  @override
  void reportEvent(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventType type = ClientEventType.initiated,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    final call = _calls[cid.value];
    if (call == null) {
      _logger.w(() => '[reportEvent] cid not registered: ${cid.value}');
      return;
    }
    _dispatch(
      _context.build(
        stage,
        type,
        callIdentity: call.identity,
        stageId: stage.carriesStageId ? _generateId() : null,
        details: details,
      ),
    );
  }

  @override
  void abort(StreamCallCid cid, ClientEventStandardCode code) {
    final stageIds = _pending.entries
        .where((entry) => entry.value.cidValue == cid.value)
        .map((entry) => entry.key)
        .toList(growable: false);

    if (stageIds.isEmpty) return;

    _logger.d(
      () =>
          '[abort] cid: ${cid.value}, code: ${code.wireValue}, '
          'inFlight: ${stageIds.length}',
    );

    for (final stageId in stageIds) {
      failStage(
        stageId,
        failure: ClientEventFailure(code, 'Aborted: ${code.wireValue}'),
      );
    }
  }

  @override
  void dispose() {
    _calls.clear();
    _pending.clear();
    transport.close();
  }

  String _begin(
    ClientEventStage stage, {
    required ClientEventIdentity identity,
    String? cidValue,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    final stageId = _generateId();
    _pending[stageId] = _PendingStage(
      stage: stage,
      startedAt: _now(),
      identity: identity,
      cidValue: cidValue,
    );

    _dispatch(
      _context.build(
        stage,
        ClientEventType.initiated,
        callIdentity: identity,
        stageId: stageId,
        details: details,
      ),
    );

    return stageId;
  }

  void _dispatch(ClientEvent event) {
    _logger.v(
      () =>
          '[dispatch] ${event.stage.wireValue}/${event.type.wireValue}'
          "${event.outcome != null ? '/${event.outcome!.wireValue}' : ''} "
          '${event.toJson()}',
    );

    // Fire-and-forget: never let telemetry break the join.
    transport.send([event]);
  }
}

/// No-op reporter used when client event reporting is disabled.
class _NoOpClientEventReporter implements ClientEventReporter {
  const _NoOpClientEventReporter();

  @override
  void registerCall(StreamCallCid cid) {}

  @override
  void unregisterCall(StreamCallCid cid) {}

  @override
  void newJoinAttempt(StreamCallCid cid, {required JoinReason reason}) {}

  @override
  void setCallSessionId(StreamCallCid cid, String callSessionId) {}

  @override
  void setCoordinatorConnectId(String? connectId) {}

  @override
  String beginStage(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventDetails details = const ClientEventDetails(),
  }) => '';

  @override
  String beginConnectionStage(
    ClientEventStage stage, {
    required String connectId,
    ClientEventDetails details = const ClientEventDetails(),
  }) => '';

  @override
  void completeStage(
    String stageId, {
    required ClientEventOutcome outcome,
    int retryCount = 0,
    ClientEventFailure? failure,
    ClientEventDetails details = const ClientEventDetails(),
  }) {}

  @override
  void failStage(
    String stageId, {
    required ClientEventFailure failure,
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  }) {}

  @override
  void failStageWithError(
    String stageId,
    Object? error, {
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  }) {}

  @override
  void reportEvent(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventType type = ClientEventType.initiated,
    ClientEventDetails details = const ClientEventDetails(),
  }) {}

  @override
  void abort(StreamCallCid cid, ClientEventStandardCode code) {}

  @override
  void dispose() {}
}
