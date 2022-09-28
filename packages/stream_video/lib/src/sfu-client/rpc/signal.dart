import 'package:http/http.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_models/models.pb.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_signal_rpc/signal.pb.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_signal_rpc/signal.pbtwirp.dart';
import 'package:stream_video/src/core/error/error.dart';
import 'package:stream_video/src/core/http/token_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:tart/tart.dart';
import 'package:uuid/uuid.dart';

class SfuSignalingClient {
  SfuSignalingClient(this.tokenManager) {
    client = SignalServerProtobufClient(
      'http://localhost:8080',
      "",
      hooks: ClientHooks(
        onRequestPrepared: onClientRequestPrepared,
      ),
    );
  }
  final TokenManager tokenManager;
  late final SignalServerProtobufClient client;
  final sessionId = Uuid().v4();

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
          sessionId: sessionId,
          publisher: publisher,
          candidate: candidate,
          sdpMid: sdpMid,
          sdpMLineIndex: sdpMLineIndex,
          usernameFragment: usernameFragment,
        ),
      );

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

  Future<UpdateMuteStateResponse> updateAudioMuteState({
    required bool muted,
  }) async {
    try {
      final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response = await client.updateMuteState(
        ctx,
        UpdateMuteStateRequest(
          sessionId: sessionId,
          audioMuteChanged: AudioMuteChanged(muted: muted),
        ),
      );
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

  Future<UpdateMuteStateResponse> updateVideoMuteState({
    required bool muted,
  }) async {
    try {
      final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response = await client.updateMuteState(
        ctx,
        UpdateMuteStateRequest(
          sessionId: sessionId,
          videoMuteChanged: VideoMuteChanged(muted: muted),
        ),
      );
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

  Future<UpdateVideoQualityResponse> requestVideoQuality({
    required String forUserId,
    required VideoQuality videoQuality,
  }) async {
    try {
      final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response = await client.requestVideoQuality(
        ctx,
        UpdateVideoQualityRequest(sessionId: sessionId, streamQualities: [
          StreamQuality(
            userId: forUserId,
            videoQuality: videoQuality,
          ),
        ]),
      );
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

  Future<SetPublisherResponse> setPublisher({String? sdp}) async {
    try {
      final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response = await client.setPublisher(
        ctx,
        SetPublisherRequest(sessionId: sessionId, sdp: sdp),
      );
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

  Future<JoinResponse> join({
    required String? subscriberSdpOffer,
    // required String? sessionId,
    required CodecSettings? codecSettings,
  }) async {
    try {
      final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response = await client.join(
        ctx,
        JoinRequest(
          subscriberSdpOffer: subscriberSdpOffer,
          sessionId: sessionId,
          codecSettings: codecSettings,
        ),
      );
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
}
