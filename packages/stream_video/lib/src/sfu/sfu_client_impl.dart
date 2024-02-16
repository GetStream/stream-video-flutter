import 'package:stream_video/composed_version.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart'
    as signal_twirp;
import 'package:stream_video/src/errors/video_error_composer.dart';
import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/sfu/sfu_client.dart';
import 'package:stream_video/src/utils/result.dart';
import 'package:tart/tart.dart';
import 'package:uuid/uuid.dart';

class SfuClientImpl extends SfuClient {
  SfuClientImpl({
    required String baseUrl,
    required this.sfuToken,
    String prefix = '',
    ClientHooks? hooks,
    List<Interceptor> interceptors = const [],
  }) : _client = signal_twirp.SignalServerProtobufClient(
          baseUrl,
          prefix,
          hooks: hooks,
          interceptor: chainInterceptor(interceptors),
        );

  final _logger = taggedLogger(tag: 'SV:SfuClient');

  final String sfuToken;

  final signal_twirp.SignalServer _client;

  @override
  Future<Result<sfu.SendAnswerResponse>> sendAnswer(
    sfu.SendAnswerRequest request,
  ) async {
    try {
      final response = await _client.sendAnswer(_withAuthHeaders(), request);
      return Result.success(response);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<sfu.ICETrickleResponse>> sendIceCandidate(
    sfu_models.ICETrickle request,
  ) async {
    try {
      final response = await _client.iceTrickle(_withAuthHeaders(), request);
      return Result.success(response);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<sfu.ICERestartResponse>> restartIce(
    sfu.ICERestartRequest request,
  ) async {
    try {
      final response = await _client.iceRestart(_withAuthHeaders(), request);
      return Result.success(response);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<sfu.SetPublisherResponse>> setPublisher(
    sfu.SetPublisherRequest request,
  ) async {
    try {
      _logger.d(() => '[setPublisher] request: ${request.stringify()}');
      final response = await _client.setPublisher(_withAuthHeaders(), request);
      _logger.v(() => '[setPublisher] response: ${response.stringify()}');
      return Result.success(response);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<sfu.UpdateMuteStatesResponse>> updateMuteState(
    sfu.UpdateMuteStatesRequest request,
  ) async {
    try {
      _logger.d(() => '[updateMuteState] request: $request');
      final response = await _client.updateMuteStates(
        _withAuthHeaders(),
        request,
      );
      _logger.v(() => '[updateMuteState] response: $response');
      return Result.success(response);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<Result<sfu.UpdateSubscriptionsResponse>> updateSubscriptions(
    sfu.UpdateSubscriptionsRequest request,
  ) async {
    try {
      _logger.d(() => '[updateSubscriptions] request: $request');
      final response = await _client.updateSubscriptions(
        _withAuthHeaders(),
        request,
      );
      _logger.v(() => '[updateSubscriptions] response: $response');
      return Result.success(response);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Context _withAuthHeaders([Context? ctx]) {
    ctx ??= Context();
    return withHttpRequestHeaders(ctx, {
      'Authorization': 'Bearer $sfuToken',
      'X-Stream-Client': streamClientVersion,
      'x-client-request-id': const Uuid().v4(),
    });
  }
}

extension on sfu.SetPublisherRequest {
  String stringify() {
    return 'SetPublisherRequest(sessionId: $sessionId, tracks: $tracks, '
        'sdp.length: ${sdp.length})';
  }
}

extension on sfu.SetPublisherResponse {
  String stringify() {
    return 'SetPublisherResponse(sessionId: $sessionId, '
        'iceRestart: $iceRestart, error: $error, sdp.length: ${sdp.length})';
  }
}
