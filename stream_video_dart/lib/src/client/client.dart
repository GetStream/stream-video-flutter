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
  late final WebSocket _ws;
  final _tokenManager = TokenManager();
  // final _connectionIdManager = ConnectionIdManager();
  StreamVideoClient(
    String apiKey, {
    this.logLevel = Level.WARNING,
    String? coordinatorUrl,
    String? baseURL,
    this.logHandlerFunction = StreamVideoClient.defaultLogHandler,
    WebSocket? ws,
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
        WebSocket(
          apiKey: apiKey,
          baseURL: "whatever",
          // handler: handler,
          tokenManager: _tokenManager,
          state: state,
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

  void setUser(User user,
      {Token? token,
      TokenProvider? provider,
      bool connectWebSocket = true}) async {
    if (_ws.connectionCompleter?.isCompleted == false) {
      throw const StreamVideoError(
        'User already getting connected, try calling `disconnectUser` '
        'before trying to connect again',
      );
    }

    logger.info('setting user : ${user.id}');

    await _tokenManager.setTokenOrProvider(
      user.id,
      token: token,
      provider: provider,
    );

    state.currentUser = user;

    // if (!connectWebSocket) return state.currentUser;

    // try {
    //   // if (_originalChatPersistenceClient != null) {
    //   //   _chatPersistenceClient = _originalChatPersistenceClient;
    //   //   await _chatPersistenceClient!.connect(ownUser.id);
    //   // }
    //   final connectedUser = await openConnection(
    //     includeUserDetailsInConnectCall: true,
    //   );
    //   return state.currentUser = connectedUser;
    // } catch (e, stk) {
    //   if (e is StreamWebSocketError ) {//&& e.isRetriable
    //     // final event = await _chatPersistenceClient?.getConnectionInfo();
    //     // if (event != null) return ownUser.merge(event.me);
    //   }
    //   logger.severe('error connecting user : ${user.id}', e, stk);
    //   rethrow;
    // }
  }

  /// Creates a new WebSocket connection with the current user.
  /// If [includeUserDetailsInConnectCall] is true it will include the current
  /// user details in the connect call.
  // Future<User> openConnection({
  //   bool includeUserDetailsInConnectCall = false,
  // }) async {
  //   assert(
  //     state.currentUser != null,
  //     'User is not set on client, '
  //     'use `connectUser` or `connectAnonymousUser` instead',
  //   );

  //   final user = state.currentUser!;

  //   logger.info('Opening web-socket connection for ${user.id}');

  //   if (_ws.connectionStatus == ConnectionStatus.connecting) {
  //     throw StreamVideoError('Connection already in progress for ${user.id}');
  //   }

  //   if (_ws.connectionStatus == ConnectionStatus.connected) {
  //     throw StreamVideoError('Connection already available for ${user.id}');
  //   }

  //   _ws.connectionStatus = ConnectionStatus.connecting;

  //   // skipping `ws` seed connection status -> ConnectionStatus.disconnected
  //   // otherwise `client.wsConnectionStatusStream` will emit in order
  //   // 1. ConnectionStatus.disconnected -> client seed status
  //   // 2. ConnectionStatus.connecting -> client connecting status
  //   // 3. ConnectionStatus.disconnected -> ws seed status
  //   // _connectionStatusSubscription =
  //   //     _ws.connectionStatusStream.skip(1).listen(_connectionStatusHandler);

  //   try {
  //     final event = await _ws.connect(
  //       user,
  //       includeUserDetails: includeUserDetailsInConnectCall,
  //     );
  //     // return user.merge(event.authPayload.user.);
  //   } catch (e, stk) {
  //     logger.severe('error connecting ws', e, stk);
  //     rethrow;
  //   }
  // }

  Future<WebsocketEvent> connect() async {
    final user = state.currentUser!;
    final event = await _ws.connect(user);
    return event;
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
      final ctx = withHttpRequestHeaders(
          Context(), {'Auth-Token': 'SuperSecretAPIKey'});

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