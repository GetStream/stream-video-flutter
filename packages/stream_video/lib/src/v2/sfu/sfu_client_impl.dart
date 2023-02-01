import 'package:tart/tart.dart';

import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart'
    as signal_twirp;
import '../../logger/impl/tagged_logger.dart';
import '../errors/video_error_composer.dart';
import '../utils/result.dart';
import 'sfu_client.dart';

/// TODO
class SfuClientImpl extends SfuClientV2 {
  /// TODO
  SfuClientImpl({
    required String baseUrl,
    required this.authToken,
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

  /// TODO
  final String authToken;

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
  Future<Result<sfu.SetPublisherResponse>> setPublisher(
    sfu.SetPublisherRequest request,
  ) async {
    try {
      final response = await _client.setPublisher(_withAuthHeaders(), request);
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
      final response = await _client.updateMuteStates(
        _withAuthHeaders(),
        request,
      );
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
      final response = await _client.updateSubscriptions(
        _withAuthHeaders(),
        request,
      );
      return Result.success(response);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Context _withAuthHeaders([Context? ctx]) {
    ctx ??= Context();
    return withHttpRequestHeaders(ctx, {
      'Authorization': 'Bearer $authToken',
    });
  }
}
