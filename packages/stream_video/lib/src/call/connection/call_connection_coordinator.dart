part of '../call.dart';

/// Joins, reconnects and leaves a [Call], and owns its SFU session.
@internal
class CallConnectionCoordinator {
  CallConnectionCoordinator(this._call);

  final Call _call;

  late final _cancelables = Cancelables();
  final _executor = ConnectionExecutor();
  CallCredentials? _credentials;
  CallSession? _session;

  CallSession? _previousSession;
  StreamPeerConnectionFactory? _pcFactory;

  StatsOptions? _sfuStatsOptions;
  SfuStatsReporter? _sfuStatsReporter;
  String? _unifiedSessionId;

  Duration _fastReconnectDeadline = Duration.zero;

  /// Where the connection is. [_publishStatus] writes the connection status
  /// it projects to; a disconnect written into the state elsewhere moves it to
  /// [ConnectionDisconnected] through [_onStateChanged].
  final _phase = MutableStateEmitter<ConnectionPhase>(
    const ConnectionIdle(),
    sync: true,
  );

  bool get _isLeftOrLeaving => _phase.value.isLeftOrLeaving;

  /// Waits for [future], or returns null as soon as the call is leaving.
  Future<T?> _untilLeft<T>(Future<T> future) async {
    final left = Completer<T?>();
    final subscription = _phase.where((phase) => phase.isLeftOrLeaving).listen((
      _,
    ) {
      if (!left.isCompleted) left.complete(null);
    });

    try {
      return await Future.any<T?>([future, left.future]);
    } finally {
      await subscription.cancel();
    }
  }

  /// Waits [duration], or less if the call starts leaving first.
  Future<void> _delayUnlessLeft(Duration duration) {
    return _untilLeft(Future<void>.delayed(duration));
  }

  /// Runs [task] once the join and reconnect work before it has finished.
  /// A reconnect asked for meanwhile, and not taken by [task], starts once
  /// it is done, if the call is still connected.
  ///
  /// Every task goes through here: whichever finishes last is the one that
  /// starts the held reconnect.
  Future<T> _serially<T>(Future<T> Function() task) async {
    try {
      return await _executor.run(task);
    } finally {
      try {
        _startHeldReconnect();
      } catch (error, stackTrace) {
        _call._logger.e(
          () =>
              '[reconnect] starting a held reconnect failed: $error, '
              'stackTrace: $stackTrace',
        );
      }
    }
  }

  /// Starts the strongest reconnect that was asked for while a join or
  /// reconnect ran, once that work has finished. Called from [_serially]
  /// after every task.
  ///
  /// A request is held whatever raised it: a socket or peer connection of the
  /// current session, a network drop, or the SFU. The work can still end
  /// connected after it arrived, so the reconnect starts only while the call
  /// is Connected. In any other phase the call is leaving, has left, or its
  /// join or reconnect failed and it leaves next. [_takeHeldReconnect] has
  /// already dropped requests whose session was replaced or whose cause has
  /// cleared.
  void _startHeldReconnect() {
    final held = _takeHeldReconnect();
    if (held == null) return;

    final phase = _phase.value;
    if (phase is! ConnectionConnected) {
      _call._logger.v(() => '[reconnect] dropped held $held (phase: $phase)');
      return;
    }

    _call._logger.d(() => '[reconnect] starting held $held');
    unawaited(
      _reconnect(
        held.strategy,
        reconnectReason: held.reason,
        trigger: held.trigger,
      ).catchError((Object error, StackTrace stackTrace) {
        _call._logger.e(
          () =>
              '[reconnect] held reconnect failed: $error, '
              'stackTrace: $stackTrace',
        );
      }),
    );
  }

  /// The strongest held reconnect that still applies. A request is dropped
  /// when the session it was asked for has been replaced, or when its
  /// trigger shows the cause has cleared.
  ReconnectRequest? _takeHeldReconnect() {
    final applicable = <ReconnectRequest>[];
    for (final held in _executor.takeHeld()) {
      if (!identical(held.session, _session)) {
        _call._logger.v(
          () => '[reconnect] dropped held $held (session replaced)',
        );
      } else if (!held.trigger.isStillNeeded) {
        _call._logger.v(() => '[reconnect] dropped held $held (cleared)');
      } else {
        applicable.add(held);
      }
    }
    return ReconnectRequest.strongest(applicable);
  }

  /// The strategy of the running reconnect, or
  /// [SfuReconnectionStrategy.unspecified] outside one.
  SfuReconnectionStrategy get _reconnectStrategy => switch (_phase.value) {
    ConnectionReconnecting(:final strategy) => strategy,
    _ => SfuReconnectionStrategy.unspecified,
  };

  /// Rejoin and migrate attempts of the running reconnect.
  int get _reconnectAttempts => switch (_phase.value) {
    ConnectionReconnecting(:final rejoinAttempts) => rejoinAttempts,
    _ => 0,
  };

  /// The attempt [CallStatusReconnecting.attempt] reports.
  int get _reconnectStatusAttempt => switch (_phase.value) {
    ConnectionReconnecting(:final attempt) => attempt,
    _ => 0,
  };

  /// Moves to [next], unless the call is leaving or has left: from
  /// [ConnectionLeaving] only [ConnectionDisconnected] follows, and nothing
  /// follows that.
  void _setPhase(ConnectionPhase next) {
    final current = _phase.value;
    final allowed = switch (current) {
      ConnectionLeaving() => next is ConnectionDisconnected,
      ConnectionDisconnected() => false,
      _ => true,
    };

    if (!allowed) {
      _call._logger.v(() => '[phase] rejected $next (phase: $current)');
      return;
    }

    _call._logger.v(() => '[phase] $current -> $next');
    _phase.value = next;
  }

  /// Updates the running reconnect, if there is one.
  void _updateReconnect(
    ConnectionReconnecting Function(ConnectionReconnecting phase) update,
  ) {
    final phase = _phase.value;
    if (phase is ConnectionReconnecting) _setPhase(update(phase));
  }

  /// Moves the running reconnect, if there is one, to [step] and reports it.
  void _setReconnectStep(CallReconnectPhase step) {
    if (_phase.value is! ConnectionReconnecting) return;
    _updateReconnect((phase) => phase.copyWith(step: step));
    _publishStatus();
  }

  /// Writes the call status the current phase projects to.
  void _publishStatus() {
    final stateManager = _call._stateManager;
    switch (_phase.value) {
      case ConnectionJoining():
        stateManager.lifecycleCallConnecting(
          attempt: 0,
          strategy: SfuReconnectionStrategy.unspecified,
        );
      case ConnectionConnected():
        stateManager.lifecycleCallConnected();
      case ConnectionReconnecting(:final strategy, :final attempt, :final step):
        stateManager.lifecycleCallConnecting(
          attempt: attempt,
          strategy: strategy,
          phase: step,
        );
      case ConnectionReconnectFailed():
        stateManager.lifecycleCallReconnectingFailed();
      case ConnectionDisconnected(:final reason):
        stateManager.lifecycleCallDisconnected(reason: reason);
      case ConnectionIdle():
      case ConnectionLeaving():
        break;
    }
  }

  final Set<SfuClientCapability> _sfuClientCapabilities = {
    SfuClientCapability.subscriberVideoPause, // on by default
  };

  CallConnectOptions _connectOptions = const CallConnectOptions();
  CallConnectOptions? _connectOptionsOverride;

  void _observeState() {
    _call._subscriptions.add(
      _idState,
      _call._stateManager.callStateStream.listen(
        (state) async => _onStateChanged(state),
      ),
    );
  }

  void _observeReconnectEvents() {
    _call._subscriptions.add(
      _idReconnect,
      _call.networkMonitor.onStatusChange.listen(
        (status) {
          if (status == InternetStatus.disconnected) {
            _call._logger.d(
              () => '[observeReconnectEvents] network disconnected',
            );
            _reconnect(
              SfuReconnectionStrategy.fast,
              reconnectReason: 'network disconnected',
              trigger: const NetworkLost(),
            );
          }
        },
      ),
    );
  }

  Future<void> _onStateChanged(CallState state) async {
    final status = state.status;

    if (status is CallStatusReconnectionFailed) {
      await leave(reason: DisconnectReason.reconnectionFailed());
    }

    // A disconnect this coordinator did not start: the call ended remotely,
    // was deleted, or the user was blocked. It leaves like a local leave. A
    // leave already running settles the phase itself.
    if (status is CallStatusDisconnected && !_isLeftOrLeaving) {
      try {
        await _leave(reason: status.reason, remote: true);
      } catch (error, stackTrace) {
        _call._logger.e(
          () => '[leave] remote leave failed: $error, stackTrace: $stackTrace',
        );
      }
    }
  }

  Future<Result<None>> join({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    int maxJoinRetries = 3,
    bool? hintHighScaleLivestreamPublisher,
  }) {
    final phase = _phase.value;
    if (phase is ConnectionJoining) {
      _call._logger.d(() => '[join] awaiting the join already in progress');
      return phase.request;
    }

    final request = _joinOnce(
      connectOptions: connectOptions,
      membersLimit: membersLimit,
      maxJoinRetries: maxJoinRetries,
      hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
    );

    // Only a first join counts as joining. From any other phase _joinOnce
    // settles on its own: connected, left, or a reconnect in progress.
    if (phase is! ConnectionIdle) return request;

    final joining = ConnectionJoining(request);
    _setPhase(joining);
    return request.whenComplete(() {
      if (identical(_phase.value, joining)) _setPhase(const ConnectionIdle());
    });
  }

  Future<Result<None>> _joinOnce({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    int maxJoinRetries = 3,
    bool? hintHighScaleLivestreamPublisher,
  }) async {
    await _call._init();

    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[join] rejected (call was left)');
      return failureWithError('call was left');
    }

    if (_call.state.value.status is CallStatusConnected) {
      _call._logger.w(() => '[join] rejected (connected)');
      return const Result.success(none);
    }

    // A reconnecting call is already the active call, so this comes before
    // the check for one.
    if (_phase.value is ConnectionReconnecting) {
      _call._logger.v(() => '[join] await the running reconnect');

      final ConnectionPhase settled;
      try {
        // Queued behind the reconnect, so it reads the phase the reconnect
        // ended on. Through _serially, so a reconnect held meanwhile starts
        // after that read.
        settled = await _serially(
          () async => _phase.value,
        ).timeout(_call._stateManager.callState.preferences.connectTimeout);
      } on TimeoutException {
        _call._logger.e(() => '[join] timed out waiting for ongoing connect');
        return failureWithError('timed out waiting for ongoing connect');
      }

      if (settled is ConnectionConnected) {
        _call._logger.v(() => '[join] ongoing connect succeeded');
        return const Result.success(none);
      }

      final status = _call.state.value.status;
      _call._logger.e(() => '[join] ongoing connect failed: $status');
      return failureWithError('ongoing connect failed: $status');
    }

    if (_call._streamVideo.state.activeCalls.value.any(
      (call) => call.callCid == _call.callCid,
    )) {
      _call._logger.w(
        () => '[join] rejected (a call with the same cid is in progress)',
      );

      return failureWithError('a call with the same cid is in progress');
    }

    // Before the call is marked active, because a call that cannot get its key
    // is not going to be joined and should not look like it is being.
    final e2eeResult = await _call._e2ee.resolve();
    if (e2eeResult is Failure) {
      _call._logger.e(
        () => '[join] rejected: ${e2eeResult.videoError.message}',
      );
      return e2eeResult;
    }

    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[join] rejected (call was left)');
      return failureWithError('call was left');
    }

    await _call._streamVideo.state.setActiveCall(_call);

    // Marking the call active can wait on another call leaving. A leave of
    // this call in that time has already cleaned up, so undo the marking
    // rather than register a call nothing would unregister.
    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[join] rejected (call was left)');
      await _call._streamVideo.state.removeActiveCall(_call);
      return failureWithError('call was left');
    }

    _call._streamVideo.clientEventReporter
      ..registerCall(_call.callCid)
      ..reportEvent(_call.callCid, ClientEventStage.joinInitiated);

    final outcome =
        await _serially(
              () => _join(
                connectOptions: connectOptions,
                membersLimit: membersLimit,
                maxJoinRetries: maxJoinRetries,
                hintHighScaleLivestreamPublisher:
                    hintHighScaleLivestreamPublisher,
              ),
            )
            .asCancelable()
            .storeIn(_idConnect, _cancelables)
            .valueOrDefault(const JoinCancelled());

    // The join's leave decision; the reconnect loop makes its own.
    switch (outcome) {
      case JoinSucceeded():
        _call._logger.v(() => '[join] finished');
        return const Result.success(none);
      case JoinCancelled():
        _call._logger.w(() => '[join] cancelled (call was left)');
        // The cause says why: a local leave, or a remote end or rejection.
        final status = _call.state.value.status;
        return failureWithError(
          'connect cancelled',
          cause: status is CallStatusDisconnected ? status.reason : null,
        );
      case JoinRingUnanswered(:final error, :final stackTrace):
        _call._logger.e(() => '[join] ring not answered: $error');
        await _call.reject(reason: CallRejectReason.timeout());
        return Result.failure(error, stackTrace);
      case JoinFailed(:final error, :final stackTrace):
        _call._logger.e(() => '[join] failed: $error');
        await leave(reason: DisconnectReason.failure(error));
        return Result.failure(error, stackTrace);
    }
  }

  /// Runs up to [maxJoinRetries] join attempts. Never leaves the call; the
  /// caller decides from the outcome.
  Future<JoinOutcome> _join({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    int maxJoinRetries = 3,
    String? reconnectReason,
    bool? hintHighScaleLivestreamPublisher,
  }) async {
    final sfuJoinFailures = <String, int>{};
    String? sfuToForceExclude;
    final sfusToExclude = <String>[];

    // What the last attempt failed with, so an exhausted budget reports the
    // verdict rather than only the fact that it ran out.
    StreamVideoException? lastError;
    StackTrace? lastStackTrace;

    for (var attempt = 0; attempt < max(maxJoinRetries, 1); attempt++) {
      final outcome = await _doJoinCatching(
        connectOptions: connectOptions,
        membersLimit: membersLimit,
        sfuToForceExclude: sfuToForceExclude,
        sfusToExclude: List.unmodifiable(sfusToExclude),
        reconnectReason: reconnectReason,
        hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
        joinAttempt: attempt,
      );

      if (outcome is! JoinRetry) {
        _call._logger.v(
          () =>
              '[join] attempt $attempt, cid: ${_call.callCid}, '
              'outcome: ${outcome.runtimeType}',
        );
        return outcome;
      } else {
        final error = outcome.error;
        _call._logger.e(
          () =>
              '[join] attempt $attempt, cid: ${_call.callCid}, failed: $error',
        );

        lastError = error;
        lastStackTrace = outcome.stackTrace;

        if (_isUnrecoverableCoordinatorError(error)) {
          _call._logger.e(
            () => '[join] unrecoverable coordinator error, not retrying',
          );
          return JoinGiveUp(error, outcome.stackTrace);
        }

        final joinCause = error.rawCause;
        if (joinCause is SessionConnectionFailure) {
          final connectionFailure = joinCause;

          if (_isUnrecoverableSfuError(connectionFailure)) {
            _call._logger.e(
              () => '[join] unrecoverable SFU error, not retrying',
            );
            return JoinGiveUp(error, outcome.stackTrace);
          }

          final switchSfu = _isJoinErrorCode(connectionFailure);
          final sfuName = _credentials?.sfuServer.name ?? '';

          sfuJoinFailures.update(
            sfuName,
            (value) => value + 1,
            ifAbsent: () => 1,
          );

          if (switchSfu || sfuJoinFailures[sfuName]! >= 2) {
            final sfuMigrateReason = switchSfu
                ? 'join error code'
                : 'too many failures';

            _call._logger.e(
              () => '[join] $sfuMigrateReason for SFU: $sfuName, migrating...',
            );

            _session?.trace(TraceTag.callJoinMigrate, {
              'migrateFrom': sfuName,
              'reason': sfuMigrateReason,
            });

            sfuToForceExclude = sfuName;
            sfusToExclude
              ..clear()
              ..addAll(sfuJoinFailures.keys);
          }
        }
      }

      await _delayUnlessLeft(_call._retryPolicy.backoff(attempt));
      if (_isLeftOrLeaving) return const JoinCancelled();
    }

    final failure =
        lastError ??
        StreamVideoException(
          message: 'failed to join after $maxJoinRetries attempts',
        );

    return JoinRetry(failure, lastStackTrace);
  }

  /// Runs [_doJoin], turning a thrown error into [JoinRetry]. [_join] then
  /// decides whether the error is worth retrying.
  Future<JoinOutcome> _doJoinCatching({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    String? sfuToForceExclude,
    List<String> sfusToExclude = const [],
    String? reconnectReason,
    bool? hintHighScaleLivestreamPublisher,
    int joinAttempt = 0,
  }) async {
    try {
      return await _doJoin(
        connectOptions: connectOptions,
        membersLimit: membersLimit,
        sfuToForceExclude: sfuToForceExclude,
        sfusToExclude: sfusToExclude,
        reconnectReason: reconnectReason,
        hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
        joinAttempt: joinAttempt,
      );
    } catch (error, stackTrace) {
      return JoinRetry(
        StreamVideoExceptionWithCause(
          message: error.toString(),
          cause: error,
          stackTrace: stackTrace,
        ),
        stackTrace,
      );
    }
  }

  SfuError? _extractSfuError(SessionConnectionFailure failure) {
    return failure.error.sfuError;
  }

  bool _isJoinErrorCode(SessionConnectionFailure failure) {
    return _extractSfuError(failure)?.code.isJoinErrorCode ?? false;
  }

  bool _isUnrecoverableSfuError(SessionConnectionFailure failure) {
    return _extractSfuError(failure)?.reconnectStrategy ==
        SfuReconnectionStrategy.disconnect;
  }

  /// Whether the coordinator API refused the join in a way that will not
  /// change.
  bool _isUnrecoverableCoordinatorError(StreamVideoException? error) {
    if (error == null) return false;

    // The server can declare that retrying will not help, which settles it.
    if (error.isUnrecoverable) return true;

    // No status means the join never reached a server verdict, so the refusal
    // is not the coordinator API's — a reconnect can still get through.
    final status = error.apiStatusCode;
    if (status == null) return false;
    if (status < 400 || status >= 500) return false;

    return status != 401 && status != 408 && status != 429;
  }

  /// Retry count attached to client-event stage completions.
  int _clientEventRetryCount(int joinAttempt) {
    return _reconnectStrategy == SfuReconnectionStrategy.unspecified
        ? joinAttempt
        : _reconnectAttempts;
  }

  Future<JoinOutcome> _doJoin({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    String? sfuToForceExclude,
    List<String> sfusToExclude = const [],
    String? reconnectReason,
    bool? hintHighScaleLivestreamPublisher,
    int joinAttempt = 0,
  }) async {
    _call._logger.d(() => '[join] options: $_connectOptions');
    final connectionTimeStopwatch = Stopwatch()..start();

    final validation = await _call._stateManager.validateUserId(
      _call._streamVideo.currentUser.id,
    );

    if (validation is Failure) {
      _call._logger.w(() => '[join] rejected (validation): $validation');
      return JoinRetry(validation.videoError, validation.stackTrace);
    }

    _call._logger.v(() => '[join] validated');

    final performingMigration =
        _reconnectStrategy == SfuReconnectionStrategy.migrate;
    final performingRejoin =
        _reconnectStrategy == SfuReconnectionStrategy.rejoin;
    final performingFastReconnect =
        _reconnectStrategy == SfuReconnectionStrategy.fast;

    final ringing =
        _call.state.value.status is CallStatusOutgoing ||
        _call.state.value.status is CallStatusIncoming;
    final result = await _awaitIfNeeded();
    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[join] rejected (call was left)');
      return const JoinCancelled();
    }

    if (result is Failure) {
      _call._logger.e(() => '[join] waiting failed: $result');
      return ringing
          ? JoinRingUnanswered(result.videoError, result.stackTrace)
          : JoinGiveUp(result.videoError, result.stackTrace);
    }

    // Within a reconnect this restates the joining status the loop set just
    // before dispatching the attempt, and so changes nothing.
    _publishStatus();

    final clientEventRetryCount = _clientEventRetryCount(joinAttempt);

    final joinedResult = await _joinIfNeeded(
      connectOptions: connectOptions,
      membersLimit: membersLimit,
      forceMigratingFrom: sfuToForceExclude,
      migratingFromList: sfusToExclude,
      hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
      clientEventRetryCount: clientEventRetryCount,
    );

    if (joinedResult is! Success<CallCredentials>) {
      _call._logger.e(() => '[join] coordinator joining failed: $joinedResult');

      final failure = joinedResult as Failure;
      return JoinRetry(failure.videoError, failure.stackTrace);
    }

    _credentials = joinedResult.data;
    _previousSession = _session;

    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[join] rejected (call was left during joining)');
      return const JoinCancelled();
    }

    final reconnectDetails =
        _reconnectStrategy == SfuReconnectionStrategy.unspecified
        ? null
        : await _previousSession?.getReconnectDetails(
            _reconnectStrategy,
            reconnectAttempts: _reconnectAttempts,
            reason: reconnectReason,
          );

    // A fast reconnect resumes the previous SFU session, so it needs both that
    // session and the details describing what to resume. A strategy set by a
    // network blip before this call ever joined has neither.
    final resumableSession = _previousSession;
    final canFastReconnect =
        performingFastReconnect &&
        resumableSession != null &&
        reconnectDetails != null;

    if (performingFastReconnect && !canFastReconnect) {
      _call._logger.w(
        () =>
            '[join] fast reconnect asked for with nothing to resume '
            'creating a new sfu session instead',
      );
    }

    Future<Result<None>>? migrationComplete;
    if (!canFastReconnect) {
      _call._logger.v(
        () =>
            '[join] creating new sfu session (rejoin: $performingRejoin, migration: $performingMigration)',
      );

      // Read by the session's own callbacks, so a reconnect it asks for names
      // it rather than whichever session is current by then.
      late final CallSession session;
      session = await _call._sessionFactory.makeCallSession(
        // a new session_id is necessary for the REJOIN strategy.
        // we use the previous session_id if available
        sessionId: performingRejoin ? null : _previousSession?.sessionId,
        sessionSeq: _reconnectAttempts,
        credentials: _credentials!,
        stateManager: _call._stateManager,
        dynascaleManager: _call.dynascaleManager,
        networkMonitor: _call.networkMonitor,
        streamVideo: _call._streamVideo,
        statsOptions: _sfuStatsOptions!,
        pcFactory: _call._ensurePcFactory(),
        e2eeManager: _call._e2ee.manager,
        leftoverTraceRecords:
            _previousSession
                ?.getTrace()
                .expand((slice) => slice.snapshot)
                .toList() ??
            const [],
        onSuspendedAudioTrackRecorded: (trackId) {
          _call._suspendedTrackStates[trackId] =
              SuspendedTrackState.neverStarted;
        },
        onReconnectionNeeded: (pc, strategy, reason) {
          _session?.trace(TraceTag.pcReconnectionNeeded, {
            'peerConnectionId': pc.type.name,
            'reconnectionStrategy': strategy.name,
          });

          _reconnect(
            strategy,
            reconnectReason: '${pc.type.name} pc disconnected',
            trigger: switch (reason) {
              ReconnectionNeededReason.connectionFailed => PeerConnectionFailed(
                pc,
              ),
              ReconnectionNeededReason.stuck => PeerConnectionStuck(pc),
            },
            source: session,
          );
        },
        clientPublishOptions:
            _call._stateManager.callState.preferences.clientPublishOptions,
      );
      _session = session;

      if (performingMigration) {
        migrationComplete = _session!.waitForMigrationComplete();
      }

      _call.dynascaleManager.init(
        sfuClient: _session!.sfuClient,
        sessionId: _session!.sessionId,
      );

      if (_isLeftOrLeaving) {
        _call._logger.w(
          () => '[join] rejected (call was left during session creation)',
        );
        return const JoinCancelled();
      }

      _call._logger.d(() => '[join] starting sfu session');

      final sessionResult = await _startSession(
        _session!,
        reconnectDetails: reconnectDetails,
        clientEventRetryCount: clientEventRetryCount,
      );

      if (sessionResult is! Success<None>) {
        _call._logger.e(
          () => '[join] sfu session start failed: $sessionResult',
        );

        final error = (sessionResult as Failure).videoError;
        return JoinRetry(
          StreamVideoExceptionWithCause(
            message: error.message,
            cause: SessionConnectionFailure(error: error),
          ),
        );
      }
    } else {
      _call._logger.v(
        () =>
            '[join] reusing previous sfu session (rejoin: $performingRejoin, migration: $performingMigration)',
      );

      _session = resumableSession;

      _call._logger.d(() => '[join] fast reconnecting');
      final result = await resumableSession.fastReconnect(
        reconnectDetails: reconnectDetails,
        capabilities: _sfuClientCapabilities,
        unifiedSessionId: _unifiedSessionId,
      );

      if (result.isFailure) {
        _call._logger.e(() => '[join] fast reconnecting failed: $result');

        // The SFU dropped the session and seated this join as a new, empty
        // participant. Another fast attempt would resume that one and succeed
        // over a subscriber that never receives media, so the next attempt has
        // to be a rejoin. Raised as a hint rather than by switching strategy
        // here, so the escalation stays with the reconnect loop.
        if (result.getErrorOrNull() is SfuSessionNotResumedException) {
          _call._logger.w(
            () => '[join] sfu session not resumable, rejoin pending',
          );
          _executor.hold(
            ReconnectRequest(
              SfuReconnectionStrategy.rejoin,
              trigger: const SfuRequested(),
              reason: 'sfu session not resumed',
              session: _session,
            ),
          );
        }

        return const JoinRetry(
          StreamVideoException(message: 'fast reconnecting failed'),
        );
      }

      _call._logger.v(() => '[join] fast reconnecting success');
      _fastReconnectDeadline =
          result.getDataOrNull()?.fastReconnectDeadline ??
          _fastReconnectDeadline;
    }

    _session?.startPublisherConnectionCheck();

    // make sure we only track connection timing if we are not calling this method as part of a migration flow
    connectionTimeStopwatch.stop();
    if (!performingMigration) {
      unawaited(
        _sfuStatsReporter?.sendSfuStats(
          reconnectionStrategy: _reconnectStrategy,
          connectionTimeMs: connectionTimeStopwatch.elapsedMilliseconds,
        ),
      );
    }

    if (performingRejoin) {
      _call._logger.v(() => '[join] leaving previous session');
      _previousSession?.leave(
        reason:
            'Closing previous WS after reconnect with strategy: ${_reconnectStrategy.name}',
      );
      await _previousSession?.dispose();
    }

    // For migration we have to wait for confirmation before we can complete the flow
    if (!performingMigration) {
      _call._logger.v(() => '[join] connected');
      _previousSession = null;
      _setPhase(const ConnectionConnected());
      _publishStatus();
    }

    // Re-bind audio filter after rejoin/migrate, as iOS may drop it.
    if ((performingRejoin || performingMigration) &&
        _call._streamVideo.isAudioProcessorConfigured() &&
        _call.state.value.isAudioProcessing) {
      unawaited(
        _call._streamVideo.setAudioProcessingEnabled(true).then((result) {
          if (result.isFailure) {
            _call._logger.w(
              () =>
                  '[join] re-binding audio processing after reconnect failed: $result',
            );
          }
        }),
      );
    }
    // A join response rebuilds every participant carrying no viewport
    // visibility, and viewports report only what changes about them.
    _call.viewportVisibility.reapplyAll();

    _call._logger.v(() => '[join] completed');
    return JoinSucceeded(migrationComplete: migrationComplete);
  }

  Future<Result<CallCredentials>> _joinIfNeeded({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    String? forceMigratingFrom,
    List<String> migratingFromList = const [],
    bool? hintHighScaleLivestreamPublisher,
    int clientEventRetryCount = 0,
  }) async {
    _call._logger.d(
      () =>
          '[joinIfNeeded] options: $connectOptions, '
          'reconnectionStrategy: $_reconnectStrategy',
    );

    final credentials = _credentials;
    final prevState = _call._stateManager.callState;

    if (credentials == null ||
        _sfuStatsOptions == null ||
        forceMigratingFrom != null ||
        _reconnectStrategy == SfuReconnectionStrategy.rejoin ||
        _reconnectStrategy == SfuReconnectionStrategy.migrate) {
      _call._logger.d(() => '[joinIfNeeded] joining');

      final migratingFrom =
          forceMigratingFrom ??
          (_reconnectStrategy == SfuReconnectionStrategy.migrate
              ? _session?.config.sfuName
              : null);

      // When migrating, include the current SFU in the exclusion list
      // so the coordinator API picks a different SFU.
      final effectiveMigratingFromList = [
        ...migratingFromList,
        if (migratingFrom != null && !migratingFromList.contains(migratingFrom))
          migratingFrom,
      ];

      final joinedResult = await _performJoinCallRequest(
        create: true,
        connectOptions: connectOptions,
        migratingFrom: migratingFrom,
        migratingFromList: effectiveMigratingFromList,
        membersLimit: membersLimit,
        hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
        clientEventRetryCount: clientEventRetryCount,
      );

      return joinedResult.foldResult(
        success: (success) {
          _credentials = success.data.credentials;
          _sfuStatsOptions = success.data.statsOptions;

          _session?.rtcManager?.subscriber.tracer.setEnabled(
            _sfuStatsOptions!.enableRtcStats,
          );
          _session?.rtcManager?.publisher?.tracer.setEnabled(
            _sfuStatsOptions!.enableRtcStats,
          );
          _session?.setTraceEnabled(_sfuStatsOptions!.enableRtcStats);

          return Result.success(success.data.credentials);
        },
        failure: (failure) {
          _call._logger.e(() => '[joinIfNeeded] failed: $failure');
          _call._stateManager.state = prevState;
          return failure;
        },
      );
    }

    _call._logger.w(
      () => '[joinIfNeeded] rejected (already joined): $_credentials',
    );
    return Result.success(credentials);
  }

  Future<Result<CallJoinedData>> _performJoinCallRequest({
    bool create = false,
    bool video = false,
    String? migratingFrom,
    List<String> migratingFromList = const [],
    int? membersLimit,
    CallConnectOptions? connectOptions,
    bool? hintHighScaleLivestreamPublisher,
    int clientEventRetryCount = 0,
  }) async {
    _call._logger.d(
      () =>
          '[joinCall] cid: ${_call.callCid}, migratingFrom: $migratingFrom, migratingFromList: $migratingFromList',
    );

    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[joinCall] rejected (call was left)');
      return failureWithError('call was left');
    }

    final reporter = _call._streamVideo.clientEventReporter;
    final joinStageId = reporter.beginStage(
      _call.callCid,
      ClientEventStage.coordinatorJoin,
    );

    final joinResult = await _call._coordinatorClient.joinCall(
      callCid: _call.callCid,
      create: create,
      migratingFrom: migratingFrom,
      migratingFromList: migratingFromList,
      video: video,
      membersLimit: membersLimit,
      hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
      e2ee: _call._e2ee.manager != null,
    );

    if (joinResult is! Success<CoordinatorJoined>) {
      final failure = joinResult as Failure;
      reporter.failStageWithError(
        joinStageId,
        failure.error,
        retryCount: clientEventRetryCount,
      );
      _call._logger.e(() => '[joinCall] join failed: $joinResult');
      return failure;
    }

    // Server call_session_id is now known; stamp it on subsequent stages.
    reporter
      ..setCallSessionId(_call.callCid, joinResult.data.metadata.session.id)
      ..completeStage(
        joinStageId,
        outcome: ClientEventOutcome.success,
        retryCount: clientEventRetryCount,
      );

    final receivedOrCreated = CallReceivedOrCreatedData(
      wasCreated: joinResult.data.wasCreated,
      data: CallCreatedData(
        callCid: _call.callCid,
        metadata: joinResult.data.metadata,
      ),
    );

    // Apply call settings to connect options only when not reconnecting.
    if (_reconnectStrategy == SfuReconnectionStrategy.unspecified) {
      await _call._applyCallSettingsToConnectOptions(
        receivedOrCreated.data.metadata.settings,
      );

      if (connectOptions != null) {
        _connectOptions = _connectOptions.merge(connectOptions);
      }

      if (_connectOptionsOverride != null) {
        _connectOptions = _connectOptions.merge(_connectOptionsOverride!);
        _connectOptionsOverride = null;
      }
    }

    _call._logger.v(
      () => '[joinCall] joinedMetadata: ${joinResult.data.metadata}',
    );

    final joined = CallJoinedData(
      callCid: _call.callCid,
      wasCreated: joinResult.data.wasCreated,
      metadata: joinResult.data.metadata,
      credentials: joinResult.data.credentials,
      statsOptions: joinResult.data.statsOptions,
    );

    _call._stateManager.lifecycleCallJoined(
      joined,
      callConnectOptions: connectOptions,
    );

    if (_call._streamVideo.isAudioProcessorConfigured() &&
        joinResult.data.metadata.settings.audio.noiseCancellation?.mode ==
            NoiseCancellationSettingsMode.autoOn) {
      // AutoOn will enable noise cancellation if the device has sufficient processing power
      unawaited(
        _call.startAudioProcessing(
          requireAdvancedAudioProcessingSupport: true,
        ),
      );
    }

    _call._logger.v(() => '[joinCall] completed: $joined');
    return Result.success(joined);
  }

  Future<Result<None>> _startSession(
    CallSession session, {
    ReconnectDetails? reconnectDetails,
    int clientEventRetryCount = 0,
  }) async {
    _call._logger.d(
      () => '[startSession] sessionId: $session',
    );

    _session = session;
    _unifiedSessionId ??= _session?.sessionId;

    await _flushAndStopSfuStatsReporter();
    _call._subscriptions.cancel(_idSessionStats);
    _call._subscriptions.cancel(_idSessionEvents);

    _call._subscriptions.add(
      _idSessionEvents,
      session.events.listen((event) {
        event
            .mapToCallEvent(_call.state.value)
            .emitIfNotNull(_call._callEvents);
        unawaited(
          _call._onSfuEvent(event, session: session).catchError(
            (Object error, StackTrace stackTrace) {
              _call._logger.e(
                () =>
                    '[onSfuEvent] failed to handle ${event.runtimeType}: '
                    '$error, stackTrace: $stackTrace',
              );
            },
          ),
        );
      }),
    );

    _call._stateManager.lifecycleCallSessionStart(
      sessionId: session.sessionId,
    );

    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[startSession] rejected (call was left)');
      return failureWithError('call was left');
    }

    final result = await session.start(
      reconnectDetails: reconnectDetails,
      capabilities: _sfuClientCapabilities,
      clientEventRetryCount: clientEventRetryCount,
      onRtcManagerCreatedCallback: (_) async {
        _call._logger.v(() => '[startSession] applying connect options');
        unawaited(
          _call._applyConnectOptions().catchError((
            dynamic error,
            StackTrace stackTrace,
          ) {
            _call._logger.e(
              () =>
                  '[startSession] failed to apply connect options: $error, stackTrace: $stackTrace',
            );
          }),
        );
      },
      isAnonymousUser:
          _call._streamVideo.state.currentUser.type == UserType.anonymous,
      unifiedSessionId: _unifiedSessionId,
    );

    if (session.statsReporter != null) {
      _call._subscriptions.add(
        _idSessionStats,
        session.statsReporter!
            .run(
              interval: _call
                  ._stateManager
                  .callState
                  .preferences
                  .callStatsReportingInterval,
            )
            .listen(
              (stats) {
                _call._stats.emit(stats);
                // Telemetry: feed subscriber stats for first-frame detection.
                session.rtcManager?.onSubscriberStats(
                  stats.subscriberStatsBundle.stats,
                );
              },
            ),
      );
    }

    if (_sfuStatsOptions != null) {
      _sfuStatsReporter =
          SfuStatsReporter(
            callSession: session,
            stateManager: _call._stateManager,
            statsOptions: _sfuStatsOptions!,
            unifiedSessionId: _unifiedSessionId,
          )..run(
            interval: Duration(
              milliseconds: _sfuStatsOptions!.reportingIntervalMs,
            ),
          );
    }

    return result.foldResult(
      success: (success) {
        _call._logger.v(() => '[startSession] success: $success');
        _fastReconnectDeadline = success.data.fastReconnectDeadline;
        return const Result.success(none);
      },
      failure: (failure) {
        _call._logger.e(() => '[startSession] failed: $failure');
        return failure;
      },
    );
  }

  /// Handles the connection events of [session], the session that sent
  /// [sfuEvent]; a reconnect it asks for is for that session.
  Future<void> _onSfuConnectionEvent(
    SfuEvent sfuEvent, {
    required CallSession session,
  }) async {
    if (sfuEvent is SfuSocketDisconnected) {
      await _sfuStatsReporter?.sendSfuStats();
      // Don't attempt reconnection if leaving the call was triggered, or if the
      // closure itself says another attempt is pointless. That verdict comes
      // from the disconnection source rather than the close code, which a
      // server can set to a normal value even when something went wrong.
      if (!_isLeftOrLeaving && sfuEvent.reason.isReconnectable) {
        _call._logger.w(() => '[onSfuEvent] socket disconnected');

        _session?.trace(TraceTag.sfuSocketDisconnected, {
          'closeCode': sfuEvent.reason.closeCode,
          'closeReason': sfuEvent.reason.closeReason,
        });
        await _reconnect(
          SfuReconnectionStrategy.fast,
          reconnectReason:
              'sfu socket disconnected, closeCode: ${sfuEvent.reason.closeCode}, closeReason: ${sfuEvent.reason.closeReason}',
          trigger: SfuSocketLost(session),
          source: session,
        );
      } else if (_isLeftOrLeaving) {
        _call._logger.d(
          () =>
              '[onSfuEvent] socket disconnected, leaving call was triggered - no reconnection',
        );
      } else {
        _call._logger.w(
          () =>
              '[onSfuEvent] socket disconnected, closure is not reconnectable '
              '(closeCode: ${sfuEvent.reason.closeCode}, '
              'closeReason: ${sfuEvent.reason.closeReason}) - leaving',
        );

        _session?.trace(TraceTag.sfuSocketDisconnected, {
          'closeCode': sfuEvent.reason.closeCode,
          'closeReason': sfuEvent.reason.closeReason,
          'isReconnectable': false,
        });

        await leave(reason: DisconnectReason.ended());
      }
    } else if (sfuEvent is SfuSocketFailed) {
      _call._logger.w(() => '[onSfuEvent] socket failed');
      _session?.trace(TraceTag.sfuSocketFailed, {
        'error': sfuEvent.error.message,
      });

      if (_isLeftOrLeaving) {
        _call._logger.d(
          () =>
              '[onSfuEvent] socket failed, leaving call was triggered - no reconnection',
        );
      } else if (!sfuEvent.isReconnectable) {
        _call._logger.e(
          () =>
              '[onSfuEvent] socket failed unrecoverably: '
              '${sfuEvent.error.message}',
        );

        await leave(reason: DisconnectReason.failure(sfuEvent.error));
      } else {
        await _reconnect(
          SfuReconnectionStrategy.fast,
          reconnectReason: 'sfu socket failed: ${sfuEvent.error.message}',
          trigger: SfuSocketLost(session),
          source: session,
        );
      }
    } else if (sfuEvent is SfuGoAwayEvent) {
      _call._logger.w(() => '[onSfuEvent] go away, migrating sfu');
      _session?.trace(TraceTag.sfuSocketGoAway, {
        'reason': sfuEvent.goAwayReason.name,
      });
      await _reconnect(
        SfuReconnectionStrategy.migrate,
        reconnectReason: 'go away',
        trigger: const SfuRequested(),
        source: session,
      );
    }
    // error event
    else if (sfuEvent is SfuErrorEvent) {
      _session?.trace(TraceTag.sfuSocketError, {
        'code': sfuEvent.error.code.name,
        'error': sfuEvent.error.message,
        'strategy': sfuEvent.error.reconnectStrategy.name,
      });

      // SFU_FULL, SFU_SHUTTING_DOWN, CALL_PARTICIPANT_LIMIT_REACHED are join
      // errors. Although they may specify a `migrate` strategy, they should be
      // handled by the join retry logic in the join flow with a REJOIN to a new SFU instead.
      if (sfuEvent.error.code.isJoinErrorCode) {
        _call._logger.w(
          () => '[onSfuEvent] skipping join error code: ${sfuEvent.error.code}',
        );
        return;
      }

      switch (sfuEvent.error.reconnectStrategy) {
        case SfuReconnectionStrategy.rejoin:
        case SfuReconnectionStrategy.fast:
        case SfuReconnectionStrategy.migrate:
          _call._logger.w(
            () =>
                '[onSfuEvent] SFU error: ${sfuEvent.error}, reconnect strategy: ${sfuEvent.error.reconnectStrategy}',
          );

          await _reconnect(
            sfuEvent.error.reconnectStrategy,
            reconnectReason: 'sfu error: ${sfuEvent.error.message}',
            trigger: const SfuRequested(),
            source: session,
          );
          break;
        case SfuReconnectionStrategy.disconnect:
          _call._logger.w(
            () => '[onSfuEvent] SFU error: ${sfuEvent.error}, leaving call',
          );
          await leave(reason: DisconnectReason.sfuError(sfuEvent.error));
          break;
        case SfuReconnectionStrategy.unspecified:
          _call._logger.w(() => '[onSfuEvent] SFU error: ${sfuEvent.error}');
          break;
      }
    }
  }

  /// Reconnects with [strategy], or, while other join or reconnect work runs,
  /// holds the request for it. [trigger] is what asked for it. [source] is
  /// the session the reconnect is for; by default the current one. A held
  /// request is always for the current session: one for a replaced session
  /// is dropped.
  ///
  /// Every reconnect starts here. The strategy each cause asks for:
  ///
  /// | Cause                                                | Strategy      |
  /// | ---------------------------------------------------- | ------------- |
  /// | The SFU socket closes or fails                       | fast          |
  /// | The device goes offline                              | fast          |
  /// | A peer connection's state turns failed               | rejoin        |
  /// | The SFU refuses an ICE restart: signal lost          | fast          |
  /// | The SFU refuses an ICE restart: otherwise            | rejoin        |
  /// | An ICE restart fails without an answer from the SFU  | none, logged  |
  /// | A local publisher ICE restart fails                  | rejoin        |
  /// | The publisher has not started connecting after 15 s  | rejoin        |
  /// | A stalled publisher offer renegotiation does not fix | fast          |
  /// | A track mid that does not resolve                    | fast          |
  /// | The SFU sends a GoAway                               | migrate       |
  /// | An SFU error naming fast, rejoin or migrate          | that strategy |
  ///
  /// A socket closure that is not reconnectable, and an SFU error naming
  /// disconnect, leave the call instead. An SFU error naming no strategy is
  /// ignored, and one with a join error code is left to the join's own
  /// retries. The SFU refusing an ICE restart because the session is
  /// migrating out counts as refusing it otherwise; that request is dropped
  /// once the migration replaces the session.
  ///
  /// A failed attempt is retried as a rejoin when:
  ///
  /// - it was a rejoin;
  /// - the fast-reconnect deadline has passed;
  /// - three fast attempts have failed;
  /// - a migration has failed;
  /// - a peer connection is failed or closed;
  /// - a rejoin or migrate was asked for meanwhile, which includes the SFU not
  ///   resuming the session on a fast reconnect.
  ///
  /// Otherwise it is retried as fast.
  Future<void> _reconnect(
    SfuReconnectionStrategy strategy, {
    required ReconnectTrigger trigger,
    String? reconnectReason,
    CallSession? source,
  }) async {
    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[reconnect] rejected (call was left)');
      return;
    }

    // From a session already replaced, such as the old one during or after a
    // rejoin.
    if (source != null && !identical(source, _session)) {
      _call._logger.v(
        () => '[reconnect] dropped $strategy (session replaced)',
      );
      return;
    }

    if (_executor.isBusy) {
      _call._logger.w(
        () =>
            '[reconnect] held $strategy from $trigger (connection work running)',
      );
      final replaced = _executor.hold(
        ReconnectRequest(
          strategy,
          trigger: trigger,
          reason: reconnectReason,
          session: source ?? _session,
        ),
      );
      for (final request in replaced) {
        _call._logger.v(
          () => '[reconnect] dropped held $request (session replaced)',
        );
      }
      return;
    }

    // A call that has never established a session has nothing to reconnect to.
    if (_session == null && _previousSession == null) {
      _call._logger.w(
        () => '[reconnect] rejected $strategy (call has never been joined)',
      );
      return;
    }

    await _serially(() async {
      try {
        await _reconnectLoop(strategy, reconnectReason, trigger);
      } catch (error, stackTrace) {
        _call._logger.e(
          () =>
              '[reconnect] failed outside an attempt: $error, '
              'stackTrace: $stackTrace',
        );
        // Nothing would move the call on from Reconnecting, so give up as a
        // failed reconnect, which leaves the call.
        if (_phase.value is ConnectionReconnecting) {
          _setPhase(const ConnectionReconnectFailed());
          _publishStatus();
        }
      }
    });
  }

  /// Runs reconnect attempts with [strategy] until the call is connected, the
  /// reconnect fails, or the call is left.
  Future<void> _reconnectLoop(
    SfuReconnectionStrategy strategy,
    String? reconnectReason,
    ReconnectTrigger trigger,
  ) async {
    _setPhase(ConnectionReconnecting(strategy: strategy));

    final reconnectStartTime = DateTime.now();
    var fastReconnectAttemptsCount = 0;

    // Counts consecutive unexpected throws. The per-strategy counters only
    // advance when a strategy actually runs, so a throw raised before the
    // dispatch (telemetry, network wait, stats) would otherwise keep the
    // backoff pinned at zero. Reset as soon as an attempt completes without
    // throwing.
    var unexpectedErrorCount = 0;

    // Shared post-failure handling: back off, then decide whether to
    // escalate to `rejoin` or retry with `fast`.
    Future<void> handleReconnectFailure({required bool wasMigrating}) async {
      // The attempt is over, and the next one has not started: the backoff
      // below is waiting, not joining.
      _setReconnectStep(CallReconnectPhase.waiting);

      final strategyAttempt = _reconnectStrategy == SfuReconnectionStrategy.fast
          ? fastReconnectAttemptsCount
          : _reconnectAttempts;
      await _delayUnlessLeft(
        _call._retryPolicy.backoff(
          max(strategyAttempt, unexpectedErrorCount),
        ),
      );

      final mustPerformRejoin =
          DateTime.now().difference(reconnectStartTime) >
          _fastReconnectDeadline;

      // A rejoin or migrate asked for during the attempt or its backoff makes
      // the next attempt the same, unless something below asks for a rejoin.
      final held = _takeHeldReconnect();
      final heldStrategy = held?.strategy;
      final hasPendingRejoin = heldStrategy == SfuReconnectionStrategy.rejoin;
      final hasPendingMigrate = heldStrategy == SfuReconnectionStrategy.migrate;
      if (held != null && !hasPendingRejoin && !hasPendingMigrate) {
        _call._logger.v(() => '[reconnect] next attempt covers held $held');
      }

      // A failed or closed peer connection is not recovered by a fast
      // reconnect.
      final hasUnhealthyPeerConnection =
          !(_session?.rtcManager?.publisher?.isHealthy() ?? true) ||
          !(_session?.rtcManager?.subscriber.isHealthy() ?? true);

      final hasReachedFastReconnectLimit = fastReconnectAttemptsCount >= 2;

      final isAlreadyRejoining =
          _reconnectStrategy == SfuReconnectionStrategy.rejoin;

      final shouldRejoin =
          isAlreadyRejoining ||
          hasPendingRejoin ||
          mustPerformRejoin ||
          wasMigrating ||
          hasReachedFastReconnectLimit ||
          hasUnhealthyPeerConnection;

      final next = shouldRejoin
          ? SfuReconnectionStrategy.rejoin
          : hasPendingMigrate
          ? SfuReconnectionStrategy.migrate
          : SfuReconnectionStrategy.fast;

      if (next == SfuReconnectionStrategy.fast) {
        fastReconnectAttemptsCount++;
      }

      _updateReconnect((phase) => phase.copyWith(strategy: next));
    }

    do {
      // Wait for a stable network before reconnecting with rejoin/migrate
      // to prevent starting an SDP exchange on a transient connection that drops before the answer arrives.
      final stabilityWindow =
          (_reconnectStrategy == SfuReconnectionStrategy.rejoin ||
              _reconnectStrategy == SfuReconnectionStrategy.migrate)
          ? const Duration(seconds: 3)
          : Duration.zero;

      if (_call.state.value.preferences.reconnectTimeout > Duration.zero) {
        final elapsed = DateTime.now().difference(reconnectStartTime);
        if (elapsed > _call.state.value.preferences.reconnectTimeout) {
          _call._logger.w(() => '[reconnect] reconnection timeout');
          _setPhase(const ConnectionReconnectFailed());
          _publishStatus();
          return;
        }
      }

      if (_isLeftOrLeaving) {
        _call._logger.w(() => '[reconnect] rejected (call was left)');
        return;
      }

      _session?.trace(TraceTag.callReconnect, {
        'strategy': strategy.name,
        'reason': reconnectReason,
      });

      _updateReconnect(
        (phase) => phase.copyWith(
          attempt: phase.attempt + 1,
          step: CallReconnectPhase.waiting,
        ),
      );
      _publishStatus();

      // Started only once the status says waiting, so an offline report
      // from the wait cannot be overwritten by it.
      final networkAvailable = _awaitNetworkAvailable(
        stabilityWindow: stabilityWindow,
        onStatus: (status) => _setReconnectStep(
          status == InternetStatus.connected
              ? CallReconnectPhase.waiting
              : CallReconnectPhase.offline,
        ),
      );

      _call._logger.d(
        () =>
            '[reconnect] strategy: $_reconnectStrategy, '
            'attempt: $_reconnectStatusAttempt',
      );

      // Captured before dispatch: a failed attempt changes the strategy.
      final wasMigrating =
          _reconnectStrategy == SfuReconnectionStrategy.migrate;

      try {
        final networkStatus = await networkAvailable;
        _call._logger.v(() => '[reconnect] network: $networkStatus');

        if (_isLeftOrLeaving) {
          _call._logger.w(
            () => '[reconnect] rejected (call was left during network wait)',
          );
          _session?.trace(TraceTag.callReconnectFailed, {
            'strategy': strategy.name,
            'error': 'call was left',
          });
          return;
        }

        if (networkStatus == InternetStatus.disconnected) {
          _call._logger.w(() => '[reconnect] reconnection timeout');
          _session?.trace(TraceTag.callReconnectFailed, {
            'strategy': strategy.name,
            'error': 'reconnection timeout',
          });
          _setPhase(const ConnectionReconnectFailed());
          _publishStatus();
          return;
        }

        unawaited(_sfuStatsReporter?.sendSfuStats());

        final joinReason = trigger is NetworkLost
            ? JoinReason.networkAvailable
            : _reconnectStrategy.joinReason;
        if (joinReason != null) {
          _call._streamVideo.clientEventReporter.reportJoinAttempt(
            _call.callCid,
            reason: joinReason,
          );
        }

        // Reconnects asked for since the loop started, such as the other
        // peer connection dropping too, are taken into this attempt.
        final held = _takeHeldReconnect();
        if (held != null) {
          _call._logger.d(() => '[reconnect] taking held $held');
          if (held.isStrongerThan(_reconnectStrategy)) {
            _updateReconnect(
              (phase) => phase.copyWith(strategy: held.strategy),
            );
          }
        }

        _setReconnectStep(CallReconnectPhase.joining);

        final outcome = switch (_reconnectStrategy) {
          SfuReconnectionStrategy.fast => await _reconnectFast(
            reason: reconnectReason,
          ),
          SfuReconnectionStrategy.rejoin => await _reconnectRejoin(
            reason: reconnectReason,
          ),
          SfuReconnectionStrategy.migrate => await _reconnectMigrate(
            reason: reconnectReason,
          ),
          _ => const JoinSucceeded(),
        };

        // The attempt ran to completion, so the throw counter no longer
        // applies to the backoff.
        unexpectedErrorCount = 0;

        switch (outcome) {
          case JoinSucceeded():
            _session?.trace(TraceTag.callReconnectSuccess, {
              'strategy': strategy.name,
            });
          case JoinCancelled():
            _call._logger.w(() => '[reconnect] cancelled (call was left)');
            return;
          case JoinGiveUp(:final error) || JoinRingUnanswered(:final error):
            _call._logger.e(() => '[reconnect] giving up: $error');
            await leave(reason: DisconnectReason.failure(error));
            return;
          case JoinRetry(:final error):
            _call._logger.w(
              () =>
                  '[reconnect] failed: $error, '
                  'strategy: $_reconnectStrategy, attempt: $_reconnectAttempts',
            );

            await handleReconnectFailure(wasMigrating: wasMigrating);
        }
      } catch (error) {
        switch (error) {
          case StreamApiException(unrecoverable: true):
          case StreamApiError() when error.unrecoverable ?? false:
            _call._logger.w(() => '[reconnect] unrecoverable error');
            _setPhase(const ConnectionReconnectFailed());
            _publishStatus();

            _session?.trace(TraceTag.callReconnectFailed, {
              'strategy': strategy.name,
              'error': error.toString(),
            });

            return;
          default:
            _call._logger.e(
              () =>
                  '[reconnect] unexpected error: $error, strategy: $_reconnectStrategy, attempt: $_reconnectAttempts',
            );

            // Treat an unexpected throw like a failed reconnect result.
            // Without this the loop retries the same strategy with no delay
            // and no escalation, and since `reconnectTimeout` defaults to
            // zero it spins until the call is left.
            unexpectedErrorCount++;
            await handleReconnectFailure(wasMigrating: wasMigrating);
        }
      }
    } while (_phase.value is ConnectionReconnecting);
  }

  Future<JoinOutcome> _reconnectFast({String? reason}) async {
    return _join(reconnectReason: reason, maxJoinRetries: 1);
  }

  Future<JoinOutcome> _reconnectRejoin({String? reason}) async {
    _updateReconnect(
      (phase) => phase.copyWith(rejoinAttempts: phase.rejoinAttempts + 1),
    );
    return _join(reconnectReason: reason);
  }

  Future<JoinOutcome> _reconnectMigrate({String? reason}) async {
    final migrateTimeStopwatch = Stopwatch()..start();

    _updateReconnect(
      (phase) => phase.copyWith(rejoinAttempts: phase.rejoinAttempts + 1),
    );
    final outcome = await _join(reconnectReason: reason);

    if (outcome is! JoinSucceeded) {
      _call._logger.e(() => '[reconnectMigrate] join failed: $outcome');
      return outcome;
    }

    await _previousSession?.close(StreamVideoCloseCode.disposeOldSocket);

    final migrationComplete = outcome.migrationComplete;
    if (migrationComplete == null) {
      _call._logger.e(() => '[reconnectMigrate] migration failed');
      return const JoinRetry(
        StreamVideoException(message: 'migration failed'),
      );
    }

    final migrationResult = await _untilLeft(migrationComplete);
    if (migrationResult == null) {
      _call._logger.w(() => '[reconnectMigrate] cancelled (call was left)');
      return const JoinCancelled();
    }

    return migrationResult.foldResult(
      success: (_) {
        _setPhase(const ConnectionConnected());
        _publishStatus();
        migrateTimeStopwatch.stop();
        unawaited(
          _sfuStatsReporter?.sendSfuStats(
            connectionTimeMs: migrateTimeStopwatch.elapsedMilliseconds,
            reconnectionStrategy: SfuReconnectionStrategy.migrate,
          ),
        );
        return const JoinSucceeded();
      },
      failure: (_) {
        _call._logger.e(
          () => '[reconnectMigrate] migration did not complete correctly',
        );
        return const JoinRetry(
          StreamVideoException(
            message: 'migration did not complete correctly',
          ),
        );
      },
    );
  }

  /// Waits until the network becomes available **and** stays connected for
  /// [stabilityWindow]. When [stabilityWindow] is [Duration.zero] (the
  /// default), the method returns as soon as connectivity is detected.
  ///
  /// The total time spent in this method is bounded by
  /// [CallPreferences.networkAvailabilityTimeout]. If the network keeps
  /// flickering (connecting then dropping within the stability window),
  /// the remaining budget shrinks on each iteration until it is exhausted.
  ///
  /// [onStatus] hears every network status the wait sees, so the reconnect can
  /// tell being offline from waiting on a network that is up.
  Future<InternetStatus> _awaitNetworkAvailable({
    Duration stabilityWindow = Duration.zero,
    void Function(InternetStatus status)? onStatus,
  }) async {
    final previousCheckInterval = _call.networkMonitor.checkInterval;
    final budget = _call.state.value.preferences.networkAvailabilityTimeout;
    final deadline = Stopwatch()..start();

    try {
      _call.networkMonitor.setIntervalAndResetTimer(
        _call._streamVideo.options.networkMonitorSettings.offlineCheckInterval,
      );

      while (true) {
        final remaining = budget - deadline.elapsed;
        if (remaining <= Duration.zero) {
          _call._logger.w(
            () => '[_awaitNetworkAvailable] total budget exhausted',
          );
          return InternetStatus.disconnected;
        }

        final networkFuture = _call.networkMonitor.onStatusChange
            .startWithFuture(_call.networkMonitor.internetStatus)
            .doOnData((status) => onStatus?.call(status))
            .firstWhere((status) => status == InternetStatus.connected)
            .timeout(
              remaining,
              onTimeout: () {
                _call._logger.w(() => '[_awaitNetworkAvailable] timeout');
                return InternetStatus.disconnected;
              },
            );

        final connectionStatus = await _untilLeft(networkFuture);
        if (connectionStatus == null) {
          _call._logger.w(() => '[_awaitNetworkAvailable] call was left');
          return InternetStatus.disconnected;
        }

        if (connectionStatus == InternetStatus.disconnected) {
          return connectionStatus;
        }

        if (stabilityWindow <= Duration.zero) {
          return connectionStatus;
        }

        // Verify the connection holds for the full stability window.
        try {
          await _call.networkMonitor.onStatusChange
              .where((s) => s == InternetStatus.disconnected)
              .first
              .timeout(stabilityWindow);

          // Stream emitted before timeout → network dropped during window.
          onStatus?.call(InternetStatus.disconnected);
          _call._logger.w(
            () =>
                '[_awaitNetworkAvailable] network dropped during '
                '${stabilityWindow.inSeconds}s stability window, retrying',
          );
          _session?.trace(TraceTag.awaitNetworkUnstable, {
            'stabilityWindowSeconds': stabilityWindow.inSeconds,
          });

          // Wait out one check interval before looking again. The monitor
          // cannot report anything new before its next probe, so retrying
          // sooner only spins — a flapping monitor otherwise drives this loop
          // thousands of times a minute for as long as the budget lasts.
          final checkInterval = _call
              ._streamVideo
              .options
              .networkMonitorSettings
              .offlineCheckInterval;
          final left = budget - deadline.elapsed;
          final settleDelay = left < checkInterval ? left : checkInterval;

          if (settleDelay > Duration.zero) {
            await _delayUnlessLeft(settleDelay);
          }
        } on TimeoutException {
          // No drop detected within the window — network is stable.
          _call._logger.v(
            () =>
                '[_awaitNetworkAvailable] network stable for '
                '${stabilityWindow.inSeconds}s',
          );
          return InternetStatus.connected;
        } catch (_) {
          // Stream closed or unexpected error — treat as disconnected so the
          // reconnect loop exits rather than spinning on a dead stream.
          return InternetStatus.disconnected;
        }
      }
    } finally {
      _call.networkMonitor.setIntervalAndResetTimer(previousCheckInterval);
    }
  }

  Future<Result<None>> _awaitIfNeeded() async {
    final state = _call.state.value;
    final status = state.status;
    final settings = state.settings;

    Future<Result<None>>? futureResult;
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      final timeout = settings.ring.autoCancelTimeout;
      _call._logger.d(() => '[awaitIfNeeded] outgoing timeout: $timeout');
      futureResult = _call._awaitOutgoingToBeAccepted(timeout);
    } else if (status is CallStatusIncoming && !status.acceptedByMe) {
      final timeout = settings.ring.autoRejectTimeout;
      _call._logger.d(() => '[awaitIfNeeded] incoming timeout: $timeout');
      futureResult = _call._awaitIncomingToBeAccepted(timeout);
    } else if (status is CallStatusJoining) {
      // TODO we don't need this case, since we no longer join from LobbyView
      _call._logger.d(() => '[awaitIfNeeded] joining to become joined');
      futureResult = _call._awaitCallToBeJoined();
    }

    if (futureResult != null) {
      final result = await _untilLeft(futureResult);
      if (result == null) {
        _call._logger.w(() => '[awaitIfNeeded] call was left');
        return failureWithError('call was left');
      }
      return result;
    }

    return const Result.success(none);
  }

  Future<Result<None>> leave({DisconnectReason? reason}) {
    return _leave(reason: reason);
  }

  /// Leaves the call for [reason]. A [remote] leave follows a disconnect
  /// written into the state from elsewhere, so the status is already
  /// disconnected.
  Future<Result<None>> _leave({
    DisconnectReason? reason,
    bool remote = false,
  }) async {
    _call._logger.i(() => '[leave] reason: $reason, remote: $remote');

    final abortCode = switch (reason) {
      DisconnectReasonEnded() ||
      DisconnectReasonCallEnded() => ClientEventStandardCode.backendLeave,
      // Reconnection gave up — treat as a device-offline
      DisconnectReasonReconnectionFailed() =>
        ClientEventStandardCode.networkOffline,
      _ => ClientEventStandardCode.clientAborted,
    };
    _call._streamVideo.clientEventReporter
      ..abort(_call.callCid, abortCode)
      ..unregisterCall(_call.callCid);

    final bool didDisconnect;
    try {
      didDisconnect = await _disconnect(
        sfuLeaveReason: _sfuLeaveReason(reason),
        remote: remote,
      );
    } catch (_) {
      // A teardown that throws still leaves the call.
      _settleDisconnected(reason);
      rethrow;
    }

    if (didDisconnect) _settleDisconnected(reason);

    _call._logger.v(() => '[leave] finished');
    return const Result.success(none);
  }

  Future<Result<None>> end({String? reason}) async {
    _call._logger.d(() => '[end] status: ${_call.state.value.status}');

    if (_call.state.value.status is! CallStatusActive) {
      _call._logger.w(
        () => '[end] rejected (invalid status): ${_call.state.value.status}',
      );
      return failureWithError('invalid status: ${_call.state.value.status}');
    }

    final bool didDisconnect;
    try {
      didDisconnect = await _disconnect(
        sfuLeaveReason: reason ?? 'user is ending the call',
      );
    } catch (_) {
      // The teardown failed here, but the call still ends for everyone.
      await _call._permissionsManager.endCall();
      _settleDisconnected(DisconnectReason.ended());
      rethrow;
    }

    // If another disconnect already ran (or is running), don't fire the
    // server-side endCall a second time and don't re-emit the lifecycle
    // event.
    if (!didDisconnect) {
      _call._logger.v(() => '[end] disconnect short-circuited');
      return const Result.success(none);
    }

    final result = await _call._permissionsManager.endCall();
    _setPhase(ConnectionDisconnected(DisconnectReason.ended()));
    _call._stateManager.lifecycleCallEnded();

    _call._logger.v(() => '[end] completed: $result');
    return result;
  }

  /// Moves to [ConnectionDisconnected] and reports the call disconnected for
  /// [reason].
  void _settleDisconnected(DisconnectReason? reason) {
    _setPhase(ConnectionDisconnected(reason));
    _publishStatus();
  }

  /// Shared cleanup sequence for [leave] and [end].
  ///
  /// Moves to [ConnectionLeaving], which stops in-flight join and reconnect
  /// work at its next check, sends the SFU leave message, and runs [_clear].
  /// Returns `true` when the cleanup ran; `false` if it was short-circuited
  /// because a disconnect was already in flight or the call had left. A
  /// [remote] disconnect runs even though the status already says
  /// disconnected, since that status is what started it.
  Future<bool> _disconnect({
    required String sfuLeaveReason,
    bool remote = false,
  }) async {
    if (_phase.value is ConnectionLeaving) {
      _call._logger.i(() => '[disconnect] rejected (already disconnecting)');
      return false;
    }

    final status = _call.state.value.status;
    if (_phase.value is ConnectionDisconnected ||
        (!remote && status is CallStatusDisconnected)) {
      _setPhase(
        ConnectionDisconnected(
          status is CallStatusDisconnected ? status.reason : null,
        ),
      );
      _call._logger.d(() => '[disconnect] rejected (status is disconnected)');
      return false;
    }

    _setPhase(const ConnectionLeaving());

    try {
      _session?.leave(reason: sfuLeaveReason);
    } finally {
      await _clear('disconnect');
    }

    return true;
  }

  Future<void> _flushAndStopSfuStatsReporter() async {
    final reporter = _sfuStatsReporter;
    if (reporter == null) return;

    final status = _call.state.value.status;
    if (status is CallStatusDisconnected) {
      _session?.trace(
        'call.leaveReason',
        _sfuLeaveReason(status.reason),
      );
    }

    await reporter.flush();
    reporter.stop();
    _sfuStatsReporter = null;
  }

  String _sfuLeaveReason(DisconnectReason? reason) {
    if (reason == null) return 'user is leaving the call';

    return switch (reason) {
      final DisconnectReasonRejected rejected =>
        'rejected: ${rejected.reason?.value ?? 'unspecified'}',
      final DisconnectReasonFailure failure => 'failure: ${failure.error}',
      final DisconnectReasonSfuError sfuError => 'sfu error: ${sfuError.error}',
      final DisconnectReasonCancelled cancelled =>
        'cancelled: ${cancelled.byUserId}',
      DisconnectReasonReplaced _ => 'replaced by another call',
      DisconnectReasonReconnectionFailed _ => 'reconnection failed',
      DisconnectReasonLastParticipantLeft _ => 'last participant left',
      DisconnectReasonCallEnded _ => 'call ended externally',
      DisconnectReasonEnded _ => 'call ended',
      DisconnectReasonTimeout _ => 'timeout',
      DisconnectReasonManuallyClosed _ => 'manually closed',
      DisconnectReasonBlocked _ => 'blocked',
      _ => 'user is leaving the call',
    };
  }

  Future<void> _clear(String src) async {
    _call._logger.d(() => '[clear] src: $src');

    // The client state is cleared even when an earlier step throws, so a
    // call that failed to tear down fully is not left looking active.
    try {
      _call._reactions.cancelTimers();
      _call._closedCaptions.reset();
      _call._moderation.cancelTimer();

      _call._stopRingStatePolling();

      for (final operation in _call._sfuStatsTimers) {
        await operation.cancel();
      }

      await _flushAndStopSfuStatsReporter();
      _call._subscriptions.cancelAll();
      _cancelables.cancelAll();

      // The audio processor is owned by StreamVideo, not by an individual
      // Call, so stopping it on this call's teardown would silently drop noise
      // cancellation on any other still-active call that also wants it. Only
      // stop the global processor when no other active call is configured for
      if (_call._streamVideo.isAudioProcessorConfigured() &&
          _call.state.value.settings.audio.noiseCancellation?.mode ==
              NoiseCancellationSettingsMode.autoOn) {
        final anotherCallWantsAutoOn = _call
            ._streamVideo
            .state
            .activeCalls
            .value
            .any(
              (other) =>
                  other.callCid != _call.callCid &&
                  other.state.value.status is! CallStatusDisconnected &&
                  other.state.value.settings.audio.noiseCancellation?.mode ==
                      NoiseCancellationSettingsMode.autoOn,
            );
        if (!anotherCallWantsAutoOn) {
          unawaited(
            _call.stopAudioProcessing().catchError((Object e) {
              _call._logger.w(() => '[clear] stopAudioProcessing failed: $e');
              return const Result.success(none);
            }),
          );
        } else {
          _call._logger.d(
            () =>
                '[clear] keeping audio processor running '
                '(another active call has autoOn)',
          );
        }
      }

      if (_session != null) {
        await _session!.dispose().catchError((Object e) {
          _call._logger.w(() => '[clear] session dispose failed: $e');
        });
      }

      final pcFactory = _pcFactory;
      _pcFactory = null;
      if (pcFactory != null) {
        unawaited(
          pcFactory.dispose().catchError((Object e) {
            _call._logger.w(() => '[clear] pcFactory dispose failed: $e');
          }),
        );
      }

      await _call.dynascaleManager.dispose();
      _call.viewportVisibility.clear();
      await _call.clearE2EEManager();
    } finally {
      _call._streamVideo.clearCallAcceptedOnThisDevice(_call.callCid, _call);
      _call._streamVideo.releaseRingingCall(_call.callCid, _call);
      await _call._streamVideo.state.removeActiveCall(_call);
      if (_call._streamVideo.state.outgoingCall.value?.callCid ==
          _call.callCid) {
        await _call._streamVideo.state.setOutgoingCall(null);
      }

      if (identical(_call._streamVideo.state.incomingCall.value, _call)) {
        await _call._streamVideo.state.setIncomingCall(null);
      }
    }

    _call._logger.v(() => '[clear] completed');
  }
}
