import 'package:http/http.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart';
import 'package:stream_video/src/core/error/video_error.dart';
import 'package:stream_video/src/core/http/token_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:tart/tart.dart';
import 'package:uuid/uuid.dart';

class SignalService {
  SignalService(this.tokenManager, {required this.endpoint}) {
    client = SignalServerProtobufClient(
      endpoint,
      "",
      hooks: ClientHooks(
        onRequestPrepared: onClientRequestPrepared,
      ),
    );
  }
  final String endpoint;
  final TokenManager tokenManager;
  late final SignalServerProtobufClient client;
  final sessionId = Uuid().v4();

  Future<IceCandidateResponse> sendCandidate({
    required bool publisher,
    String? candidate,
    String? sdpMid,
    int? sdpMLineIndex,
    String? usernameFragment,
    required Token token,
  }) async {
    print(endpoint);
    try {
      // final token = await tokenManager.loadToken();
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
    required Token token,
  }) async {
    try {
      // final token = await tokenManager.loadToken();
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
    required Token token,
  }) async {
    try {
      // final token = await tokenManager.loadToken();
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
    required Token token,
  }) async {
    try {
      // final token = await tokenManager.loadToken();
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

  Future<SetPublisherResponse> setPublisher({
    String? sdp,
    required Token token,
  }) async {
    try {
      // final token = await tokenManager.loadToken();
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


  Future<UpdateSubscriptionsResponse> updateSubscriptions({
    String? sdp,
    Map<String, VideoDimension>? subscriptions,
    required Token token,
  }) async {
    try {
      // final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response = await client.updateSubscriptions(
        ctx,
        UpdateSubscriptionsRequest(sessionId: sessionId, subscriptions: subscriptions),
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
    required Token token,
  }) async {
    try {
      // final token = await tokenManager.loadToken();
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

  Future<SendAnswerResponse> sendAnswer({
    required PeerType peerType,
    String? sdp,
    required Token token,
  }) async {
    try {
      // final token = await tokenManager.loadToken();
      final ctx = _withAuth(token);
      final response = await client.sendAnswer(
        ctx,
        SendAnswerRequest(sessionId: sessionId, peerType: peerType, sdp: sdp),
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

  /// onClientRequestPrepared is a client hook used to print out the method name of the RPC call
  Context onClientRequestPrepared(Context ctx, Request req) {
    print(req.url);
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
