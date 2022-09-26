import 'package:http/http.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_signal_rpc/signal.pb.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_signal_rpc/signal.pbtwirp.dart';
import 'package:stream_video/src/core/error/error.dart';
import 'package:stream_video/src/core/http/token_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:tart/tart.dart';
import 'package:webrtc_interface/src/rtc_ice_candidate.dart';

class SfuSignalingClient {
  SfuSignalingClient(this.tokenManager) {
    client = SignalServerProtobufClient('http://localhost:8080', "",
        hooks: ClientHooks(
          onRequestPrepared: onClientRequestPrepared,
        ));
  }
  final TokenManager tokenManager;
  late final SignalServerProtobufClient client;
  //his.sessionId = uuidv4();

  Future<IceCandidateResponse> sendCandidate({
    required bool publisher,
    String? candidate,
    String? sdpMid,
    int? sdpMLineIndex,
    String? usernameFragment,
  }) async {
    try {
      final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response = await client.sendIceCandidate(
          ctx,
          IceCandidateRequest(
              publisher: publisher,
              candidate: candidate,
              sdpMid: sdpMid,
              sdpMLineIndex: sdpMLineIndex,
              usernameFragment: usernameFragment));

      return response;
    } on TwirpError catch (e) {
      final method =
          e.getContext.value(ContextKeys.methodName) ?? 'unknown method';
      throw StreamVideoError(
        'Twirp error on method: $method. Code: ${e.getCode}. Message: ${e.getMsg}',
      );
    } on InvalidTwirpHeader catch (e) {
      throw StreamVideoError('InvalidTwirpHeader: $e');
    } catch (e, stack) {
      throw StreamVideoError('''
      Unknown Exception Occurred: $e
      Stack trace: $stack
      ''');
    }
  }

  /// onClientRequestPrepared is a client hook used to print out the method name of the RPC call
  Context onClientRequestPrepared(Context ctx, Request req) {
    final methodNameVal = ctx.value(ContextKeys.methodName);
    print('RequestPrepared for $methodNameVal');
    return ctx;
  }

  Context _withAuth(Token token) {
    return withHttpRequestHeaders(
      Context(),
      {'authorization': 'Bearer ${token.rawValue}'},
    );
  }

  Future<SetPublisherResponse> setPublisher({String? sdp}) async {
    try {
      final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response =
          await client.setPublisher(ctx, SetPublisherRequest(sdp: sdp));
      return response;
    } on TwirpError catch (e) {
      final method =
          e.getContext.value(ContextKeys.methodName) ?? 'unknown method';
      throw StreamVideoError(
        'Twirp error on method: $method. Code: ${e.getCode}. Message: ${e.getMsg}',
      );
    } on InvalidTwirpHeader catch (e) {
      throw StreamVideoError('InvalidTwirpHeader: $e');
    } catch (e, stack) {
      throw StreamVideoError('''
      Unknown Exception Occurred: $e
      Stack trace: $stack
      ''');
    }
  }

// updateAudioMuteState
// updateVideoMuteState

// requestVideoQuality
// updateSubscriptions
  // sendIceCandidate
}
