import 'dart:async';

import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../../globals.dart';
import '../../../stream_video.dart';
import '../../telemetry/client_event_reporter.dart';
import '../../telemetry/client_event_types.dart';
import '../../token/token_source.dart';
import 'coordinator_message_codec.dart';

var _seq = 0;
const _tag = 'SV:CoordinatorWS';

/// The error carried by a disconnection source, as a [StreamVideoException].
///
/// A core exception is kept as the cause rather than flattened to its message:
/// the accessors on [StreamVideoException] read the verdict from there, and
/// `CoordinatorDisconnectedEvent.apiError` is the only account an app gets of a
/// closure that is not reconnectable.
StreamVideoException? _videoErrorOf(Object? error) => switch (error) {
  null => null,
  final StreamVideoException it => it,
  StreamException(cause: final StreamVideoException it) => it,
  final StreamException it => StreamVideoExceptionWithCause(
    message: it.message,
    cause: it,
  ),
  final it => StreamVideoException(message: '$it'),
};

String _buildUrl(String baseUrl, String apiKey) {
  return '$baseUrl'
      '?api_key=$apiKey'
      '&stream-auth-type=jwt'
      '&X-Stream-Client=${Uri.encodeQueryComponent(xStreamClientHeader)}';
}

class CoordinatorWebSocket {
  CoordinatorWebSocket(
    String url, {
    required this.apiKey,
    required this.userInfo,
    required this.tokenSource,
    this.includeUserDetails = false,
    this.clientEventReporter = const ClientEventReporter.noOp(),
    NetworkStateProvider? networkStateProvider,
  }) {
    _wsUrl = _buildUrl(url, apiKey);

    _client = StreamWebSocketClient(
      tag: _tag,
      optionsBuilder: () => WebSocketOptions(url: _wsUrl),
      messageCodec: CoordinatorMessageCodec(),
      onAuthenticate: _authenticateUser,
      pingRequestBuilder: ([info]) =>
          HealthCheckPingEvent(connectionId: info?.connectionId),
    );

    _retryStrategy = DefaultRetryStrategy();

    _recoveryHandler = ConnectionRecoveryHandler(
      tag: '$_tag:Recovery',
      client: _client,
      networkStateProvider: networkStateProvider,
      retryStrategy: _retryStrategy,
    );

    _client.connectionState.listen(_onConnectionStateChanged);
    _client.events.listen(_onWsEvent);
  }

  late final _logger = taggedLogger(tag: '$_tag-${++_seq}');

  final String apiKey;
  final UserInfo userInfo;
  final TokenSource tokenSource;
  final bool includeUserDetails;

  /// Reports the `CoordinatorWS` telemetry stage, which follows this socket's
  /// connection lifecycle.
  final ClientEventReporter clientEventReporter;

  late final StreamWebSocketClient _client;

  /// The underlying socket client.
  ///
  /// Exposed so tests can drive its connection state directly — they never
  /// establish a real socket.
  @visibleForTesting
  StreamWebSocketClient get client => _client;
  late final ConnectionRecoveryHandler _recoveryHandler;
  late final RetryStrategy _retryStrategy;
  late final String _wsUrl;

  SharedEmitter<CoordinatorEvent> get events => _events;
  final _events = MutableSharedEmitter<CoordinatorEvent>();

  String? _userId;
  String? _connectionId;

  bool _isReconnecting = false;

  final _uuid = const Uuid();

  /// The in-flight `CoordinatorWS` stage id, if a connect attempt is pending.
  String? _coordinatorWsStageId;

  String? get connectionId => _connectionId;

  bool get isConnected => _client.connectionState.value.isConnected;
  bool get isDisconnected {
    final state = _client.connectionState.value;
    return state is Disconnected || state is Initialized;
  }

  Future<Result<None>> connect() async {
    _logger.v(() => '[connect] no args');
    await _client.connect();
    return const Result.success(none);
  }

  Future<Result<None>> disconnect() async {
    _logger.i(() => '[disconnect] no args');
    if (isDisconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return const Result.success(none);
    }
    await _client.disconnect();
    return const Result.success(none);
  }

  Future<void> dispose() => _recoveryHandler.dispose();

  Future<void> _authenticateUser(
    WsRequestSender authenticator,
    StreamApiException? previousError,
  ) async {
    _logger.i(
      () => '[authenticateUser] url: $_wsUrl, previousError: $previousError',
    );

    // The verdict the server refused the last attempt with, when refusing the
    // token is what it was about.
    final refusal = switch (previousError) {
      final StreamApiException it when it.isTokenExpired => it,
      _ => null,
    };
    final tokenRefused = refusal != null;

    // A static provider can only return the token the server just refused,
    // so the credentials cannot change.
    // Throwing fails the attempt for good (AuthenticationFailed, which is not
    // reconnectable) instead of reconnecting with the same dead token.
    if (tokenRefused && tokenSource.usesStaticProvider) {
      _logger.e(
        () =>
            '[authenticateUser] token refused and cannot be refreshed '
            '(static token provider): $refusal',
      );
      Error.throwWithStackTrace(refusal, StackTrace.current);
    }

    final tokenResult = tokenRefused
        ? await tokenSource.refreshToken()
        : await tokenSource.getToken();

    if (tokenResult is! Success<UserToken>) {
      final failure = tokenResult as Failure;
      _logger.e(
        () => '[authenticateUser] token fetch failed: ${failure.error}',
      );

      final error = failure.error;
      final raised = error is StreamVideoException
          ? error.streamException ?? error
          : error;

      Error.throwWithStackTrace(
        raised,
        failure.stackTrace ?? StackTrace.current,
      );
    }

    final sent = authenticator(
      CoordinatorAuthRequest(
        token: tokenResult.data.rawValue,
        userId: userInfo.id,
        name: includeUserDetails ? userInfo.name : null,
        image: includeUserDetails ? userInfo.image : null,
        extraData: includeUserDetails
            ? userInfo.extraData
            : <String, dynamic>{},
      ),
    );

    if (sent case Failure(:final error, :final stackTrace)) {
      _logger.e(() => '[authenticateUser] sending credentials failed: $error');
      Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
    }
  }

  void _onWsEvent(WsEvent wsEvent) {
    if (wsEvent is! CoordinatorWsEvent) return;
    final event = wsEvent.event;
    if (event == null) return; // suppressed

    if (event is CoordinatorConnectedEvent) {
      _logger.i(() => '[onWsEvent] connected: ${event.connectionId}');
      _userId ??= event.userId;
      _connectionId ??= event.connectionId;

      if (_isReconnecting) {
        _isReconnecting = false;
        _events.emit(event);
        _events.emit(
          CoordinatorReconnectedEvent(
            userId: _userId,
            connectionId: _connectionId,
          ),
        );
        return;
      }
    }

    _events.emit(event);
  }

  void _onConnectionStateChanged(WebSocketConnectionState state) {
    _logger.d(() => '[onConnectionStateChanged] state: $state');

    _reportCoordinatorWsStage(state);

    if (state is! Disconnected) return;

    final source = state.source;
    final wsException = source is ServerInitiated ? source.error : null;

    // An authentication failure is terminal (it is not reconnectable), so this
    // event is the only account the app gets of it. Carry over the error that
    // `_authenticateUser` threw instead of reporting a disconnect with no
    // reason at all.
    final authError = source is AuthenticationFailed
        ? _videoErrorOf(source.error) ??
              StreamVideoException(message: source.closeReason)
        : null;

    final apiError =
        switch (wsException) {
          StreamApiException(:final apiError) => apiError,
          _ => null,
        } ??
        authError?.apiError;

    // Only a transport-level closure carries a close code; a server verdict
    // reported over the socket describes itself through its error payload.
    final closeCode = switch (wsException) {
      StreamNetworkException(:final closeCode?) when closeCode != 0 =>
        closeCode,
      _ => null,
    };

    _events.emit(
      CoordinatorDisconnectedEvent(
        userId: _userId,
        connectionId: _connectionId,
        closeCode: closeCode,
        closeReason:
            wsException?.message ??
            apiError?.message ??
            authError?.message ??
            source.closeReason,
        apiError: apiError,
      ),
    );
    _userId = null;
    _connectionId = null;

    // Mark as reconnecting for non-user-initiated disconnects so that
    // CoordinatorReconnectedEvent is emitted when the handler reconnects.
    if (source is! UserInitiated) {
      _isReconnecting = true;
    }
  }

  /// Retry count captured when the in-flight `CoordinatorWS` stage began.
  int _coordinatorWsStageRetryCount = 0;

  void _reportCoordinatorWsStage(WebSocketConnectionState state) {
    switch (state) {
      case Connecting():
        if (_coordinatorWsStageId != null) break;
        _coordinatorWsStageRetryCount = _retryStrategy.consecutiveFailuresCount;
        final stageId = clientEventReporter.beginConnectionStage(
          ClientEventStage.coordinatorWs,
          connectId: _uuid.v4(),
        );
        _coordinatorWsStageId = stageId.isEmpty ? null : stageId;
      case Connected():
        final stageId = _coordinatorWsStageId;
        if (stageId == null) break;
        _coordinatorWsStageId = null;
        clientEventReporter.completeStage(
          stageId,
          outcome: ClientEventOutcome.success,
          retryCount: _coordinatorWsStageRetryCount,
        );
      case Disconnected(:final source):
        final stageId = _coordinatorWsStageId;
        if (stageId == null) break;
        _coordinatorWsStageId = null;
        clientEventReporter.failStage(
          stageId,
          failure: source is UserInitiated
              ? const ClientEventFailure.clientAborted(
                  'Coordinator WS disconnected',
                )
              : ClientEventFailure(
                  ClientEventStandardCode.serverError,
                  'Coordinator WS disconnected (${source.closeReason})',
                ),
          retryCount: _coordinatorWsStageRetryCount,
        );
      case Initialized() || Authenticating() || Disconnecting():
        break;
    }
  }
}
