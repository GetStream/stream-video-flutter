// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:math';

import 'package:protobuf/protobuf.dart';
import 'package:tart/tart.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';
import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart'
    as signal_twirp;
import '../call/stats/tracer.dart';
import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../utils/result.dart';
import 'sfu_extensions.dart';

class SfuClient {
  SfuClient({
    required String baseUrl,
    required this.sfuToken,
    required this.sessionSeq,
    required Tracer tracer,
    String prefix = '',
    ClientHooks? hooks,
    List<Interceptor> interceptors = const [],
    this.rpcTimeout = const Duration(seconds: 10),
    this.rpcMaxRetries = 3,
  }) : _client = signal_twirp.SignalServerProtobufClient(
         baseUrl,
         prefix,
         hooks: hooks,
         interceptor: chainInterceptor(interceptors),
       ),
       _logger = taggedLogger(tag: '$sessionSeq-SV:SfuClient'),
       _tracer = tracer;

  final TaggedLogger _logger;
  final Tracer _tracer;
  final signal_twirp.SignalServer _client;

  final int sessionSeq;
  final String sfuToken;
  final Duration rpcTimeout;
  final int rpcMaxRetries;

  int _retryInterval(int numberOfFailures) {
    // try to reconnect in 0.25-5 seconds (random to spread out the load from failures)
    final max = (500 + numberOfFailures * 2000).clamp(0, 5000);
    final min = ((numberOfFailures - 1) * 2000).clamp(250, 5000);
    return (min + Random().nextDouble() * (max - min)).floor();
  }

  Future<Result<T>> _executeWithRetry<T extends GeneratedMessage>({
    required Future<T> Function() call,
  }) async {
    var attempt = 0;
    dynamic dynamicResponse;

    while (attempt < rpcMaxRetries) {
      try {
        final response = await call().timeout(
          rpcTimeout,
          onTimeout: () {
            _logger.w(
              () =>
                  '[_executeWithRetry] SFU HTTP call timed out after '
                  '${rpcTimeout.inSeconds}s',
            );
            throw TimeoutException('SFU HTTP call timed out', rpcTimeout);
          },
        );

        dynamicResponse = response as dynamic;
        if (dynamicResponse.hasError != null &&
            dynamicResponse.hasError() &&
            dynamicResponse.error is sfu_models.Error) {
          final error = dynamicResponse.error as sfu_models.Error;

          if (error.shouldRetry) {
            attempt++;
            if (attempt < rpcMaxRetries) {
              await Future<void>.delayed(
                Duration(milliseconds: _retryInterval(attempt)),
              );
              continue;
            }
          }
          return Result.failure(
            VideoErrors.compose(error, StackTrace.current),
          );
        }

        return Result.success(response);
      } on TimeoutException catch (e, stk) {
        attempt++;
        if (attempt < rpcMaxRetries) {
          await Future<void>.delayed(
            Duration(milliseconds: _retryInterval(attempt)),
          );
          continue;
        }
        return Result.failure(VideoErrors.compose(e, stk));
      }
    }

    return Result.failure(
      VideoErrors.compose(dynamicResponse?.error, StackTrace.current),
    );
  }

  Future<Result<sfu.SendAnswerResponse>> sendAnswer(
    sfu.SendAnswerRequest request,
  ) async {
    try {
      _tracer.trace('sendAnswer', request.toJson());

      return _executeWithRetry<sfu.SendAnswerResponse>(
        call: () => _client.sendAnswer(_withAuthHeaders(), request),
      );
    } catch (e, stk) {
      _tracer.trace('sendAnswer.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<sfu.ICETrickleResponse>> iceTrickle(
    sfu_models.ICETrickle request,
  ) async {
    try {
      _tracer.trace('iceTrickle', request.toJson());

      return _executeWithRetry<sfu.ICETrickleResponse>(
        call: () => _client.iceTrickle(_withAuthHeaders(), request),
      );
    } catch (e, stk) {
      _tracer.trace('iceTrickle.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<sfu.ICERestartResponse>> restartIce(
    sfu.ICERestartRequest request,
  ) async {
    try {
      _tracer.trace('iceRestart', request.toJson());

      return _executeWithRetry<sfu.ICERestartResponse>(
        call: () => _client.iceRestart(_withAuthHeaders(), request),
      );
    } catch (e, stk) {
      _tracer.trace('iceRestart.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<sfu.SetPublisherResponse>> setPublisher(
    sfu.SetPublisherRequest request,
  ) async {
    try {
      _tracer.trace('setPublisher', request.toJson());
      _logger.v(() => '[setPublisher] request: ${request.stringify()}');

      final result = await _executeWithRetry<sfu.SetPublisherResponse>(
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
      _tracer.trace('setPublisher.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<sfu.UpdateMuteStatesResponse>> updateMuteState(
    sfu.UpdateMuteStatesRequest request,
  ) async {
    try {
      _tracer.trace('updateMuteStates', request.toJson());
      _logger.v(() => '[updateMuteState] request: $request');

      final result = await _executeWithRetry<sfu.UpdateMuteStatesResponse>(
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
      _tracer.trace('updateMuteStates.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<sfu.UpdateSubscriptionsResponse>> updateSubscriptions(
    sfu.UpdateSubscriptionsRequest request,
  ) async {
    try {
      _tracer.trace('updateSubscriptions', request.toJson());
      _logger.v(() => '[updateSubscriptions] request: $request');

      final result = await _executeWithRetry<sfu.UpdateSubscriptionsResponse>(
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
      _tracer.trace('updateSubscriptions.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<sfu.StartNoiseCancellationResponse>> startNoiseCancellation(
    sfu.StartNoiseCancellationRequest request,
  ) async {
    try {
      _tracer.trace('startNoiseCancellation', request.toJson());
      _logger.v(() => '[startNoiseCancellation] request: $request');

      final result =
          await _executeWithRetry<sfu.StartNoiseCancellationResponse>(
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
      _tracer.trace('startNoiseCancellation.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<sfu.StopNoiseCancellationResponse>> stopNoiseCancellation(
    sfu.StopNoiseCancellationRequest request,
  ) async {
    try {
      _tracer.trace('stopNoiseCancellation', request.toJson());
      _logger.v(() => '[stopNoiseCancellation] request: $request');

      final result = await _executeWithRetry<sfu.StopNoiseCancellationResponse>(
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
      _tracer.trace('stopNoiseCancellation.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
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
      return _executeWithRetry<sfu.SendStatsResponse>(
        call: () => _client.sendStats(_withAuthHeaders(), request),
      );
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
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
