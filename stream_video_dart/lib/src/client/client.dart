import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:stream_video_dart/protobuf/video_coordinator_rpc/coordinator_service.pbserver.dart';
import 'package:stream_video_dart/protobuf/video_coordinator_rpc/coordinator_service.pbtwirp.dart';
import 'package:stream_video_dart/protobuf/video_events/events.pbserver.dart';
import 'package:stream_video_dart/protobuf/video_models/models.pb.dart';
import 'package:stream_video_dart/src/client/state.dart';
import 'package:stream_video_dart/src/core/error/error.dart';

import 'package:stream_video_dart/src/core/http/token.dart';
import 'package:stream_video_dart/src/core/http/token_manager.dart';
import 'package:stream_video_dart/src/ws/websocket.dart';
import 'package:tart/tart.dart';

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

class StreamVideoClient {
  late final CallCoordinatorServiceProtobufClient _client;
  late final WebSocketClient _ws;
  final _tokenManager = TokenManager();
  StreamVideoClient(
    String apiKey, {
    this.logLevel = Level.WARNING,
    String? coordinatorUrl,
    String? baseURL,
    this.logHandlerFunction = StreamVideoClient.defaultLogHandler,
    WebSocketClient? ws,
  }) {
    _client = CallCoordinatorServiceProtobufClient(
      coordinatorUrl ?? "http://localhost:26991",
      "",
      hooks: ClientHooks(
        onRequestPrepared: onClientRequestPrepared,
      ),
      // interceptor: myInterceptor()
    );

    state = ClientState();
    _ws = ws ??
        WebSocketClient(
          logger: logger,
        );
  }

  /// Client specific logger instance.
  /// Refer to the class [Logger] to learn more about the specific
  /// implementation.
  late final Logger logger = detachedLogger('📡');

  /// This client state
  late ClientState state;
  final LogHandlerFunction logHandlerFunction;

  final Level logLevel;

  /// Default log handler function for the [StreamChatClient] logger.
  static void defaultLogHandler(LogRecord record) {
    print(
      '${record.time} '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message} ',
    );
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  }

  /// Default logger for the [StreamChatClient].
  Logger detachedLogger(String name) => Logger.detached(name)
    ..level = logLevel
    ..onRecord.listen(logHandlerFunction);

  Future<void> setUser(User user,
      {Token? token,
      TokenProvider? provider,
      bool connectWebSocket = true}) async {
    logger.info('setting user : ${user.id}');
    logger.info('setting token : ${token!.rawValue}');

    await _tokenManager.setTokenOrProvider(
      user.id,
      token: token,
      provider: provider,
    );

    state.currentUser = user;
  }

  Future<void> connect() async {
    final user = state.currentUser;
    final token = await _tokenManager.loadToken();
    print("TOKEN ${token.rawValue}");
    _ws.connect(user: user!, token: token);
  }

  Future<SelectEdgeServerResponse> selectEdgeServer(
      {required SelectEdgeServerRequest request}) async {
    try {
      final ctx = withHttpRequestHeaders(
          Context(), {'Auth-Token': 'SuperSecretAPIKey'});

      final response = await _client.selectEdgeServer(ctx, request);
      return response;
    } on TwirpError catch (e) {
      final method =
          e.getContext.value(ContextKeys.methodName) ?? 'unknown method';
      throw StreamVideoError(
          'Twirp error on method: $method. Code: ${e.getCode}. Message: ${e.getMsg}');
    } on InvalidTwirpHeader catch (e) {
      throw StreamVideoError('InvalidTwirpHeader: $e');
    } catch (e, stack) {
      throw StreamVideoError('''
      Unknown Exception Occurred: $e
      Stack trace: $stack
      ''');
    }
  }

  Future<CreateCallResponse> createCall(
      {required CreateCallRequest request}) async {
    try {
      final token = await _tokenManager.loadToken();
      final ctx = withHttpRequestHeaders(
          Context(), {'authorization': 'Bearer ${token.rawValue}}'});

      final response = await _client.createCall(ctx, request);
      return response;
    } on TwirpError catch (e) {
      final method =
          e.getContext.value(ContextKeys.methodName) ?? 'unknown method';
      throw StreamVideoError(
          'Twirp error on method: $method. Code: ${e.getCode}. Message: ${e.getMsg}');
    } on InvalidTwirpHeader catch (e) {
      throw StreamVideoError('InvalidTwirpHeader: $e');
    } catch (e, stack) {
      throw StreamVideoError('''
      Unknown Exception Occurred: $e
      Stack trace: $stack
      ''');
    }
  }

  Future<JoinCallResponse> joinCall({required JoinCallRequest request}) async {
    try {
      final ctx = withHttpRequestHeaders(
          Context(), {'Auth-Token': 'SuperSecretAPIKey'});

      final response = await _client.joinCall(ctx, request);
      return response;
    } on TwirpError catch (e) {
      final method =
          e.getContext.value(ContextKeys.methodName) ?? 'unknown method';
      throw StreamVideoError(
          'Twirp error on method: $method. Code: ${e.getCode}. Message: ${e.getMsg}');
    } on InvalidTwirpHeader catch (e) {
      throw StreamVideoError('InvalidTwirpHeader: $e');
    } catch (e, stack) {
      throw StreamVideoError('''
      Unknown Exception Occurred: $e
      Stack trace: $stack
      ''');
    }
  }
}

/// onClientRequestPrepared is a client hook used to print out the method name of the RPC call
Context onClientRequestPrepared(Context ctx, Request req) {
  final methodNameVal = ctx.value(ContextKeys.methodName);
  print('RequestPrepared for $methodNameVal');
  return ctx;
}




/// myInterceptor is an example of how to use an interceptor to catch the context and request
/// before the RPC is made to the server. Depending on how many interceptors there are [next]
/// could represent another interceptor by using [chainInterceptor] or the actual RPC call
// Interceptor myInterceptor(/* pass in any dependencies needed */) {
//   return (Method next) {
//     return (Context ctx, dynamic req) {
//       switch (req.runtimeType) {
//         case Size:
//           print('This will be ran before the makeHat call');
//           break;
//         case SuitSizeReq:
//           print('This will be ran before the makeSuit call');
//       }
//       final serviceName = ctx.value(ContextKeys.serviceName);
//       final methodName = ctx.value(ContextKeys.methodName);
//       final reqDetails = req.toString().replaceAll('\n', '');
//       print('Service: $serviceName, Method: $methodName, Request: $reqDetails');

//       // ALWAYS call the next method (interceptor or RPC call)
//       return next(ctx, req);
//     };
//   };
// }