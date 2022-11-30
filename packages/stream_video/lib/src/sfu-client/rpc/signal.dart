import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart';
import 'package:stream_video/src/core/error/video_error.dart';
import 'package:tart/tart.dart';

class Signal {
  Signal({
    required String baseUrl,
    required this.authToken,
    String prefix = '',
    ClientHooks? hooks,
    List<Interceptor> interceptors = const [],
  }) : _client = SignalServerJSONClient(
          baseUrl,
          prefix,
          hooks: hooks,
          interceptor: chainInterceptor(interceptors),
        );

  final String authToken;
  final SignalServer _client;

  Future<SetPublisherResponse> setPublisher(SetPublisherRequest req) async {
    try {
      return _client.setPublisher(_withAuthHeaders(), req);
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<SendAnswerResponse> sendAnswer(SendAnswerRequest req) async {
    try {
      return _client.sendAnswer(_withAuthHeaders(), req);
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<ICETrickleResponse> iceTrickle(ICETrickle req) {
    try {
      return _client.iceTrickle(_withAuthHeaders(), req);
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<UpdateSubscriptionsResponse> updateSubscriptions(
    UpdateSubscriptionsRequest req,
  ) async {
    try {
      return _client.updateSubscriptions(_withAuthHeaders(), req);
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<UpdateMuteStateResponse> updateMuteState(
    UpdateMuteStateRequest req,
  ) async {
    try {
      return _client.updateMuteState(_withAuthHeaders(), req);
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<UpdateVideoQualityResponse> requestVideoQuality(
    UpdateVideoQualityRequest req,
  ) async {
    try {
      return _client.requestVideoQuality(_withAuthHeaders(), req);
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Context _withAuthHeaders([Context? ctx]) {
    ctx ??= Context();
    return withHttpRequestHeaders(ctx, {
      'Authorization': 'Bearer $authToken',
    });
  }
}
