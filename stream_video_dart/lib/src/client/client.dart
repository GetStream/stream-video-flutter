
import 'package:http/http.dart';
import 'package:stream_video_dart/protobuf/video_coordinator_rpc/coordinator_service.pbserver.dart';
import 'package:stream_video_dart/protobuf/video_coordinator_rpc/coordinator_service.pbtwirp.dart';
import 'package:stream_video_dart/src/core/error.dart';
import 'package:tart/tart.dart';

class StreamVideoClient {
  late final CallCoordinatorServiceProtobufClient _client;
  StreamVideoClient() {
    _client = CallCoordinatorServiceProtobufClient(
      "http://localhost:26991",
      "",
      hooks: ClientHooks(
        onRequestPrepared: onClientRequestPrepared,
      ),
      // interceptor: myInterceptor()
    );
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