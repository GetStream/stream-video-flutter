// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:protobuf/protobuf.dart';
import 'package:tart/tart.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';
import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart'
    as signal_twirp;
import '../call/stats/trace_tag.dart';
import '../call/stats/tracer.dart';
import '../errors/stream_video_exception_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../retry/retry_policy.dart';
import '../utils/result.dart';
import 'sfu_extensions.dart';

class SfuClient {
  SfuClient({
    required String baseUrl,
    required this.sfuToken,
    required this.sessionSeq,
    required Tracer tracer,
    required RetryPolicy retryPolicy,
    String prefix = '',
    ClientHooks? hooks,
    List<Interceptor> interceptors = const [],
    Duration? rpcTimeout,
    int? rpcMaxRetries,
  }) : rpcTimeout = rpcTimeout ?? retryPolicy.config.sfuRpcTimeout,
       rpcMaxRetries = rpcMaxRetries ?? retryPolicy.config.sfuRpcMaxRetries,
       _client = signal_twirp.SignalServerProtobufClient(
         baseUrl,
         prefix,
         hooks: hooks,
         interceptor: chainInterceptor(interceptors),
       ),
       _logger = taggedLogger(tag: '$sessionSeq-SV:SfuClient'),
       _tracer = tracer,
       _retryPolicy = retryPolicy;

  final TaggedLogger _logger;
  final Tracer _tracer;
  final RetryPolicy _retryPolicy;
  final signal_twirp.SignalServer _client;

  final int sessionSeq;
  final String sfuToken;

  /// How long one attempt may take. From [RetryConfig.sfuRpcTimeout] unless a
  /// caller overrode it.
  final Duration rpcTimeout;

  /// How many attempts an RPC gets. From [RetryConfig.sfuRpcMaxRetries] unless
  /// a caller overrode it.
  final int rpcMaxRetries;

  /// Runs [call] until it produces a verdict, or the retry budget runs out.
  Future<Result<T>> _executeWithRetry<T extends GeneratedMessage>({
    required Future<T> Function() call,
    required String label,
  }) async {
    var attempt = 0;
    Object? lastError;
    StackTrace? lastStackTrace;

    while (attempt < rpcMaxRetries) {
      try {
        final response = await call().timeout(
          rpcTimeout,
          onTimeout: () {
            _logger.w(
              () =>
                  '[$label] SFU HTTP call timed out after '
                  '${rpcTimeout.inSeconds}s',
            );
            throw TimeoutException('SFU HTTP call timed out', rpcTimeout);
          },
        );

        // Every signal response declares an optional `error` field.
        final dynamicResponse = response as dynamic;
        final sfuError = (dynamicResponse.hasError() as bool)
            ? dynamicResponse.error as sfu_models.Error
            : null;

        if (sfuError == null) return Result.success(response);

        lastError = sfuError;
        lastStackTrace = StackTrace.current;
        if (!sfuError.shouldRetry) {
          return Result.failure(
            StreamVideoExceptions.compose(sfuError, lastStackTrace),
            lastStackTrace,
          );
        }

        _logger.w(
          () => '[$label] SFU asked to retry: ${sfuError.message}',
        );
      } on Exception catch (e, stk) {
        lastError = e;
        lastStackTrace = stk;
        _logger.w(() => '[$label] attempt ${attempt + 1} failed: $e');
      }

      attempt++;
      if (attempt >= rpcMaxRetries) break;

      // The same policy the coordinator's retries use, so behaviour under loss
      // is set by intent rather than by which layer the call went through.
      await Future<void>.delayed(_retryPolicy.backoff(attempt));
    }

    // The budget ran out. `lastError` is set on every path that reaches here,
    // but a zero retry budget would leave it null.
    return Result.failure(
      StreamVideoExceptions.compose(
        lastError ??
            'SFU call "$label" made no attempt '
                '(rpcMaxRetries: $rpcMaxRetries)',
        lastStackTrace,
      ),
      lastStackTrace,
    );
  }

  Future<Result<sfu.SendAnswerResponse>> sendAnswer(
    sfu.SendAnswerRequest request,
  ) async {
    try {
      _tracer.trace(TraceTag.sendAnswer, request.toJson());

      return await _executeWithRetry<sfu.SendAnswerResponse>(
        label: 'sendAnswer',
        call: () => _client.sendAnswer(_withAuthHeaders(), request),
      );
    } catch (e, stk) {
      _tracer.trace(TraceTag.sendAnswerFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<sfu.ICETrickleResponse>> iceTrickle(
    sfu_models.ICETrickle request,
  ) async {
    try {
      _tracer.trace(TraceTag.iceTrickle, request.toJson());

      return await _executeWithRetry<sfu.ICETrickleResponse>(
        label: 'iceTrickle',
        call: () => _client.iceTrickle(_withAuthHeaders(), request),
      );
    } catch (e, stk) {
      _tracer.trace(TraceTag.iceTrickleFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<sfu.ICERestartResponse>> restartIce(
    sfu.ICERestartRequest request,
  ) async {
    try {
      _tracer.trace(TraceTag.iceRestart, request.toJson());

      return await _executeWithRetry<sfu.ICERestartResponse>(
        label: 'iceRestart',
        call: () => _client.iceRestart(_withAuthHeaders(), request),
      );
    } catch (e, stk) {
      _tracer.trace(TraceTag.iceRestartFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<sfu.SetPublisherResponse>> setPublisher(
    sfu.SetPublisherRequest request,
  ) async {
    try {
      _tracer.trace(TraceTag.setPublisher, request.toJson());
      _logger.v(() => '[setPublisher] request: ${request.stringify()}');

      final result = await _executeWithRetry<sfu.SetPublisherResponse>(
        label: 'setPublisher',
        call: () => _client.setPublisher(_withAuthHeaders(), request),
      );

      if (result.isSuccess) {
        _logger.v(
          () =>
              '[setPublisher] response: ${(result as Success<sfu.SetPublisherResponse>).data.stringify()}',
        );
      }

      return result;
    } catch (e, stk) {
      _tracer.trace(TraceTag.setPublisherFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<sfu.UpdateMuteStatesResponse>> updateMuteState(
    sfu.UpdateMuteStatesRequest request,
  ) async {
    try {
      _tracer.trace(TraceTag.updateMuteStates, request.toJson());
      _logger.v(() => '[updateMuteState] request: $request');

      final result = await _executeWithRetry<sfu.UpdateMuteStatesResponse>(
        label: 'updateMuteStates',
        call: () => _client.updateMuteStates(_withAuthHeaders(), request),
      );

      if (result.isSuccess) {
        _logger.v(
          () =>
              '[updateMuteState] response: ${(result as Success<sfu.UpdateMuteStatesResponse>).data}',
        );
      }

      return result;
    } catch (e, stk) {
      _tracer.trace(TraceTag.updateMuteStatesFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<sfu.UpdateSubscriptionsResponse>> updateSubscriptions(
    sfu.UpdateSubscriptionsRequest request,
  ) async {
    try {
      _tracer.trace(TraceTag.updateSubscriptions, request.toJson());
      _logger.v(() => '[updateSubscriptions] request: $request');

      final result = await _executeWithRetry<sfu.UpdateSubscriptionsResponse>(
        label: 'updateSubscriptions',
        call: () => _client.updateSubscriptions(_withAuthHeaders(), request),
      );

      if (result.isSuccess) {
        _logger.v(
          () =>
              '[updateSubscriptions] response: ${(result as Success<sfu.UpdateSubscriptionsResponse>).data}',
        );
      }

      return result;
    } catch (e, stk) {
      _tracer.trace(TraceTag.updateSubscriptionsFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<sfu.StartNoiseCancellationResponse>> startNoiseCancellation(
    sfu.StartNoiseCancellationRequest request,
  ) async {
    try {
      _tracer.trace(TraceTag.startNoiseCancellation, request.toJson());
      _logger.v(() => '[startNoiseCancellation] request: $request');

      final result =
          await _executeWithRetry<sfu.StartNoiseCancellationResponse>(
            label: 'startNoiseCancellation',
            call: () =>
                _client.startNoiseCancellation(_withAuthHeaders(), request),
          );

      if (result.isSuccess) {
        _logger.v(
          () =>
              '[startNoiseCancellation] response: ${(result as Success<sfu.StartNoiseCancellationResponse>).data}',
        );
      }

      return result;
    } catch (e, stk) {
      _tracer.trace(TraceTag.startNoiseCancellationFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<sfu.StopNoiseCancellationResponse>> stopNoiseCancellation(
    sfu.StopNoiseCancellationRequest request,
  ) async {
    try {
      _tracer.trace(TraceTag.stopNoiseCancellation, request.toJson());
      _logger.v(() => '[stopNoiseCancellation] request: $request');

      final result = await _executeWithRetry<sfu.StopNoiseCancellationResponse>(
        label: 'stopNoiseCancellation',
        call: () => _client.stopNoiseCancellation(_withAuthHeaders(), request),
      );

      if (result.isSuccess) {
        _logger.v(
          () =>
              '[stopNoiseCancellation] response: ${(result as Success<sfu.StopNoiseCancellationResponse>).data}',
        );
      }

      return result;
    } catch (e, stk) {
      _tracer.trace(TraceTag.stopNoiseCancellationFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Context _withAuthHeaders([Context? ctx]) {
    ctx ??= Context();
    return withHttpRequestHeaders(ctx, {
      'Authorization': 'Bearer $sfuToken',
      'X-Stream-Client': xStreamClientHeader,
      'x-client-request-id': const Uuid().v4(),
    });
  }

  Future<Result<sfu.SendStatsResponse>> sendStats(
    sfu.SendStatsRequest request,
  ) async {
    try {
      return await _executeWithRetry<sfu.SendStatsResponse>(
        label: 'sendStats',
        call: () => _client.sendStats(_withAuthHeaders(), request),
      );
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }
}

extension on sfu.SetPublisherRequest {
  String stringify() {
    return 'SetPublisherRequest(sessionId: $sessionId, tracks: $tracks, '
        'sdp: $sdp)';
  }
}

extension on sfu.SetPublisherResponse {
  String stringify() {
    return 'SetPublisherResponse(sessionId: $sessionId, '
        'iceRestart: $iceRestart, error: $error, sdp: $sdp)';
  }
}
