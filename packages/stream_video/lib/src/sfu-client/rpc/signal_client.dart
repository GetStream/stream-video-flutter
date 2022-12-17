import 'package:tart/tart.dart';

import '../../../protobuf/video/sfu/models/models.pbserver.dart' as sfu_models;
import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as signal;
import '../../../protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart'
    as signal_twirp;
import '../../core/video_error.dart';

class SignalClient {
  SignalClient({
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

  final String authToken;
  final signal_twirp.SignalServer _client;

  Future<signal.SetPublisherResponse> setPublisher(
    signal.SetPublisherRequest req,
  ) async {
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

  Future<signal.SendAnswerResponse> sendAnswer(
    signal.SendAnswerRequest req,
  ) async {
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

  Future<signal.ICETrickleResponse> iceTrickle(sfu_models.ICETrickle req) {
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

  Future<signal.UpdateSubscriptionsResponse> updateSubscriptions(
    signal.UpdateSubscriptionsRequest req,
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

  Future<signal.UpdateMuteStatesResponse> updateMuteStates(
    signal.UpdateMuteStatesRequest req,
  ) async {
    try {
      return _client.updateMuteStates(_withAuthHeaders(), req);
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
