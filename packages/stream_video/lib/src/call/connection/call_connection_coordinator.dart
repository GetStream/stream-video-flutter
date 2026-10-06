part of '../call.dart';

/// Joins, reconnects and leaves a [Call], and owns its SFU session.
@internal
class CallConnectionCoordinator {
  CallConnectionCoordinator(this._call);

  final Call _call;

  late final _cancelables = Cancelables();
  late final _callJoinLock = Lock();
  late final _callReconnectLock = Lock();
  CallCredentials? _credentials;
  CallSession? _session;

  CallSession? _previousSession;
  StreamPeerConnectionFactory? _pcFactory;

  StatsOptions? _sfuStatsOptions;
  SfuStatsReporter? _sfuStatsReporter;
  String? _unifiedSessionId;

  Duration _fastReconnectDeadline = Duration.zero;
  Future<InternetStatus>? _awaitNetworkAvailableFuture;
  Future<Result<None>>? _awaitMigrationCompleteFuture;

  /// Where the connection is. [_publishStatus] writes the connection status
  /// it projects to; a disconnect written into the state elsewhere moves it to
  /// [ConnectionDisconnected] through [_onStateChanged].
  final _phase = MutableStateEmitter<ConnectionPhase>(
    const ConnectionIdle(),
    sync: true,
  );

  bool get _isLeftOrLeaving => _phase.value.isLeftOrLeaving;

  /// Completes once the call is leaving or has left.
  Future<void> get _whenLeft =>
      _phase.firstWhere((phase) => phase.isLeftOrLeaving);

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
              triggeredByNetwork: true,
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

    if (status is CallStatusDisconnected) {
      _setPhase(ConnectionDisconnected(status.reason));
      await _clear('status-disconnected');
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

    if (_call._streamVideo.state.activeCalls.value.any(
      (call) => call.callCid == _call.callCid,
    )) {
      _call._logger.w(
        () => '[join] rejected (a call with the same cid is in progress)',
      );

      return failureWithError('a call with the same cid is in progress');
    }

    if (_call.state.value.status is CallStatusConnecting ||
        _call.state.value.status is CallStatusJoining) {
      _call._logger.v(() => '[join] await ongoing connect to resolve');

      try {
        final currentState = await _call.state
            .firstWhere(
              (it) =>
                  it.status is! CallStatusConnecting &&
                  it.status is! CallStatusJoining,
            )
            .timeout(_call._stateManager.callState.preferences.connectTimeout);

        if (currentState.status is CallStatusConnected ||
            currentState.status is CallStatusJoined) {
          _call._logger.v(() => '[join] ongoing connect succeeded');
          return const Result.success(none);
        } else {
          _call._logger.e(
            () => '[join] ongoing connect failed: ${currentState.status}',
          );
          return failureWithError(
            'ongoing connect failed: ${currentState.status}',
          );
        }
      } on TimeoutException {
        _call._logger.e(() => '[join] timed out waiting for ongoing connect');
        return failureWithError('timed out waiting for ongoing connect');
      }
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

    await _call._streamVideo.state.setActiveCall(_call);

    _call._streamVideo.clientEventReporter
      ..registerCall(_call.callCid)
      ..reportEvent(_call.callCid, ClientEventStage.joinInitiated);

    final result =
        await _join(
              connectOptions: connectOptions,
              membersLimit: membersLimit,
              maxJoinRetries: maxJoinRetries,
              hintHighScaleLivestreamPublisher:
                  hintHighScaleLivestreamPublisher,
            )
            .asCancelable()
            .storeIn(_idConnect, _cancelables)
            .valueOrDefault(failureWithError('connect cancelled'));

    if (result.isSuccess) {
      _call._logger.v(() => '[join] finished: $result');
    } else {
      _call._logger.e(() => '[join] failed: $result');
      final videoError = result.getErrorOrNull();
      await leave(
        reason: videoError != null
            ? DisconnectReason.failure(videoError)
            : null,
      );
    }

    return result;
  }

  Future<Result<None>> _join({
    CallConnectOptions? connectOptions,
    int? membersLimit,
    int maxJoinRetries = 3,
    String? reconnectReason,
    bool? hintHighScaleLivestreamPublisher,
    bool disconnectOnMaxRetries = true,
  }) async {
    if (_callJoinLock.locked) {
      _call._logger.w(() => '[join] rejected (already joining)');
      return failureWithError('already joining');
    }

    return _callJoinLock.synchronized(() async {
      final sfuJoinFailures = <String, int>{};
      String? sfuToForceExclude;
      final sfusToExclude = <String>[];

      // What the last attempt failed with, so an exhausted budget reports the
      // verdict rather than only the fact that it ran out.
      StreamVideoException? lastError;
      StackTrace? lastStackTrace;

      for (var attempt = 0; attempt < max(maxJoinRetries, 1); attempt++) {
        final result = await runCatchingResult(
          () => _doJoin(
            connectOptions: connectOptions,
            membersLimit: membersLimit,
            sfuToForceExclude: sfuToForceExclude,
            sfusToExclude: List.unmodifiable(sfusToExclude),
            reconnectReason: reconnectReason,
            hintHighScaleLivestreamPublisher: hintHighScaleLivestreamPublisher,
            joinAttempt: attempt,
          ),
        );

        if (result.isSuccess) {
          _call._logger.v(
            () => '[join] attempt $attempt, cid: ${_call.callCid}, success',
          );
          sfuToForceExclude = null;
          return result;
        } else {
          _call._logger.e(
            () =>
                '[join] attempt $attempt, cid: ${_call.callCid}, failed: $result',
          );

          final error = result.getErrorOrNull();
          lastError = error;
          lastStackTrace = result.stackTraceOrNull();

          if (_isUnrecoverableCoordinatorError(error)) {
            _call._logger.e(
              () => '[join] unrecoverable coordinator error, not retrying',
            );
            await leave(reason: DisconnectReason.failure(error!));
            return result;
          }

          final joinCause = error?.rawCause;
          if (error != null && joinCause is SessionConnectionFailure) {
            final connectionFailure = joinCause;

            if (_isUnrecoverableSfuError(connectionFailure)) {
              _call._logger.e(
                () => '[join] unrecoverable SFU error, not retrying',
              );
              await leave(
                reason: DisconnectReason.failure(error),
              );
              return result;
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
                () =>
                    '[join] $sfuMigrateReason for SFU: $sfuName, migrating...',
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

        await Future<void>.delayed(
          _call._retryPolicy.backoff(attempt),
        );
      }

      final failure =
          lastError ??
          StreamVideoException(
            message: 'failed to join after $maxJoinRetries attempts',
          );

      if (disconnectOnMaxRetries) {
        await leave(reason: DisconnectReason.failure(failure));
      }

      return Result.failure(failure, lastStackTrace);
    });
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

  Future<Result<None>> _doJoin({
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

    if (validation.isFailure) {
      _call._logger.w(() => '[join] rejected (validation): $validation');
      return validation;
    }

    _call._logger.v(() => '[join] validated');

    final performingMigration =
        _reconnectStrategy == SfuReconnectionStrategy.migrate;
    final performingRejoin =
        _reconnectStrategy == SfuReconnectionStrategy.rejoin;
    final performingFastReconnect =
        _reconnectStrategy == SfuReconnectionStrategy.fast;

    final result = await _awaitIfNeeded();
    if (result.isFailure) {
      _call._logger.e(() => '[join] waiting failed: $result');

      await _call.reject(reason: CallRejectReason.timeout());

      return result;
    }

    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[join] rejected (call was left)');
      return failureWithError('call was left');
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

      final error = (joinedResult as Failure).videoError;
      await leave(reason: DisconnectReason.failure(error));
      return joinedResult;
    }

    _credentials = joinedResult.data;
    _previousSession = _session;

    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[join] rejected (call was left during joining)');
      return failureWithError('call was left');
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

    if (!canFastReconnect) {
      _call._logger.v(
        () =>
            '[join] creating new sfu session (rejoin: $performingRejoin, migration: $performingMigration)',
      );

      _session = await _call._sessionFactory.makeCallSession(
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
        onReconnectionNeeded: (pc, strategy) {
          _session?.trace(TraceTag.pcReconnectionNeeded, {
            'peerConnectionId': pc.type.name,
            'reconnectionStrategy': strategy.name,
          });

          _reconnect(
            strategy,
            reconnectReason: '${pc.type.name} pc disconnected',
          );
        },
        clientPublishOptions:
            _call._stateManager.callState.preferences.clientPublishOptions,
      );

      if (performingMigration) {
        _awaitMigrationCompleteFuture = _session!.waitForMigrationComplete();
      }

      _call.dynascaleManager.init(
        sfuClient: _session!.sfuClient,
        sessionId: _session!.sessionId,
      );

      if (_isLeftOrLeaving) {
        _call._logger.w(
          () => '[join] rejected (call was left during session creation)',
        );
        return failureWithError('call was left');
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
        return failureWithError(
          error.message,
          cause: SessionConnectionFailure(error: error),
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
          _updateReconnect((phase) => phase.copyWith(rejoinPending: true));
        }

        return failureWithError('fast reconnecting failed');
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
    return const Result.success(none);
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
          _call._onSfuEvent(event).catchError(
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

  Future<void> _onSfuConnectionEvent(SfuEvent sfuEvent) async {
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

  Future<void> _reconnect(
    SfuReconnectionStrategy strategy, {
    String? reconnectReason,
    bool triggeredByNetwork = false,
  }) async {
    if (_callJoinLock.locked) {
      if (strategy == SfuReconnectionStrategy.rejoin) {
        _updateReconnect((phase) => phase.copyWith(rejoinPending: true));
      }
      _call._logger.w(
        () => '[_reconnect] skipping reconnect (join in progress)',
      );
      return;
    }

    if (_isLeftOrLeaving) {
      _call._logger.w(() => '[reconnect] rejected (call was left)');
      return;
    }

    // A call that has never established a session has nothing to reconnect to.
    if (_session == null && _previousSession == null) {
      _call._logger.w(
        () => '[reconnect] rejected $strategy (call has never been joined)',
      );
      return;
    }

    if (_callReconnectLock.locked) {
      if (strategy == SfuReconnectionStrategy.rejoin) {
        _updateReconnect((phase) => phase.copyWith(rejoinPending: true));
      }
      _call._logger.w(
        () =>
            '[reconnect] rejected $strategy (reconnect in progress: $_reconnectStrategy)',
      );
      return;
    }

    await _callReconnectLock.synchronized(() async {
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

        final strategyAttempt =
            _reconnectStrategy == SfuReconnectionStrategy.fast
            ? fastReconnectAttemptsCount
            : _reconnectAttempts;
        await Future<void>.delayed(
          _call._retryPolicy.backoff(
            max(strategyAttempt, unexpectedErrorCount),
          ),
        );

        final mustPerformRejoin =
            DateTime.now().difference(reconnectStartTime) >
            _fastReconnectDeadline;

        final current = _phase.value;
        final hasPendingRejoin =
            current is ConnectionReconnecting && current.rejoinPending;

        final hasClosedPeerConnection =
            (_session?.rtcManager?.publisher?.isClosed() ?? false) ||
            (_session?.rtcManager?.subscriber.isClosed() ?? false);

        final hasReachedFastReconnectLimit = fastReconnectAttemptsCount >= 2;

        final isAlreadyRejoining =
            _reconnectStrategy == SfuReconnectionStrategy.rejoin;

        final shouldRejoin =
            isAlreadyRejoining ||
            hasPendingRejoin ||
            mustPerformRejoin ||
            wasMigrating ||
            hasReachedFastReconnectLimit ||
            hasClosedPeerConnection;

        if (!shouldRejoin) {
          fastReconnectAttemptsCount++;
        }

        _updateReconnect(
          (phase) => phase.copyWith(
            strategy: shouldRejoin
                ? SfuReconnectionStrategy.rejoin
                : SfuReconnectionStrategy.fast,
            rejoinPending: false,
          ),
        );
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
        _awaitNetworkAvailableFuture = _awaitNetworkAvailable(
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
          final networkStatus = await _awaitNetworkAvailableFuture;
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

          final joinReason = triggeredByNetwork
              ? JoinReason.networkAvailable
              : _reconnectStrategy.joinReason;
          if (joinReason != null) {
            _call._streamVideo.clientEventReporter.reportJoinAttempt(
              _call.callCid,
              reason: joinReason,
            );
          }

          _setReconnectStep(CallReconnectPhase.joining);

          final reconnectResult = switch (_reconnectStrategy) {
            SfuReconnectionStrategy.fast => await _reconnectFast(
              reason: reconnectReason,
            ),
            SfuReconnectionStrategy.rejoin => await _reconnectRejoin(
              reason: reconnectReason,
            ),
            SfuReconnectionStrategy.migrate => await _reconnectMigrate(
              reason: reconnectReason,
            ),
            _ => const Result.success(none),
          };

          // The attempt ran to completion, so the throw counter no longer
          // applies to the backoff.
          unexpectedErrorCount = 0;

          if (reconnectResult.isSuccess) {
            _session?.trace(TraceTag.callReconnectSuccess, {
              'strategy': strategy.name,
            });
          } else {
            _call._logger.w(
              () =>
                  '[reconnect] failed: ${reconnectResult.getErrorOrNull()}, '
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
    });
  }

  Future<Result<None>> _reconnectFast({String? reason}) async {
    return _join(
      reconnectReason: reason,
      maxJoinRetries: 1,
      disconnectOnMaxRetries: false,
    );
  }

  Future<Result<None>> _reconnectRejoin({String? reason}) async {
    _updateReconnect(
      (phase) => phase.copyWith(rejoinAttempts: phase.rejoinAttempts + 1),
    );
    return _join(reconnectReason: reason, disconnectOnMaxRetries: false);
  }

  Future<Result<None>> _reconnectMigrate({String? reason}) async {
    final migrateTimeStopwatch = Stopwatch()..start();

    _updateReconnect(
      (phase) => phase.copyWith(rejoinAttempts: phase.rejoinAttempts + 1),
    );
    final joinResult = await _join(
      reconnectReason: reason,
      disconnectOnMaxRetries: false,
    );

    if (joinResult.isFailure) {
      _call._logger.e(() => '[reconnectMigrate] join failed: $joinResult');
      return joinResult;
    }

    await _previousSession?.close(StreamVideoCloseCode.disposeOldSocket);

    final migrationResult = await _awaitMigrationCompleteFuture;
    if (migrationResult == null) {
      _call._logger.e(() => '[reconnectMigrate] migration failed');
      return failureWithError('migration failed');
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
        return const Result.success(none);
      },
      failure: (_) {
        _call._logger.e(
          () => '[reconnectMigrate] migration did not complete correctly',
        );
        return failureWithError('migration did not complete correctly');
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

        final lifecycleFuture = _whenLeft.then((_) {
          _call._logger.w(() => '[_awaitNetworkAvailable] call was left');
          return InternetStatus.disconnected;
        });

        // Race the network against leaving, so a call that is left stops
        // waiting for the network.
        final connectionStatus =
            await Future.any([
                  networkFuture,
                  lifecycleFuture,
                ])
                .asCancelable()
                .storeIn(_idFastReconnectTimeout, _cancelables)
                .valueOrDefault(InternetStatus.disconnected);

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
            await Future<void>.delayed(settleDelay);
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
      _call._logger.v(() => '[awaitIfNeeded] return cancelable');

      final lifecycleFuture = _whenLeft.then<Result<None>>(
        (_) {
          _call._logger.w(() => '[awaitIfNeeded] call was left');
          return const Result.failure('call was left');
        },
      );

      // Race the wait against leaving, so a call that is left stops waiting
      // for the call status to change.
      return Future.any([
        futureResult,
        lifecycleFuture,
      ]).asCancelable().storeIn(_idAwait, _cancelables).value;
    }

    return const Result.success(none);
  }

  Future<Result<None>> leave({DisconnectReason? reason}) async {
    _call._logger.i(() => '[leave] reason: $reason');

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
  /// work at its next check, sends the SFU leave message, and runs [_clear]. Returns `true`
  /// when the cleanup actually ran; `false` if it was short-circuited because
  /// a disconnect was already in flight or the call was already disconnected.
  Future<bool> _disconnect({required String sfuLeaveReason}) async {
    if (_phase.value is ConnectionLeaving) {
      _call._logger.i(() => '[disconnect] rejected (already disconnecting)');
      return false;
    }

    final status = _call.state.value.status;
    if (_phase.value is ConnectionDisconnected ||
        status is CallStatusDisconnected) {
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
