import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pbtwirp.dart';
import 'package:stream_video/src/core/video_error.dart';
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/token/token_manager.dart';
import 'package:tart/tart.dart';

class CoordinatorClient with EventEmittable<CoordinatorEvent> {
  CoordinatorClient({
    required String baseUrl,
    required this.apiKey,
    required this.tokenManager,
    String prefix = '',
    ClientHooks? hooks,
    List<Interceptor> interceptors = const [],
  }) : _clientRPCProtobufClient = ClientRPCProtobufClient(
          baseUrl,
          prefix,
          hooks: hooks,
          interceptor: chainInterceptor(interceptors),
        );

  final String apiKey;
  final TokenManager tokenManager;

  final ClientRPCProtobufClient _clientRPCProtobufClient;

  Future<CreateCallResponse> createCall(CreateCallRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.createCall(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<GetOrCreateCallResponse> getOrCreateCall(GetOrCreateCallRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.getOrCreateCall(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<JoinCallResponse> joinCall(JoinCallRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.joinCall(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<GetCallEdgeServerResponse> getCallEdgeServer(
    GetCallEdgeServerRequest req,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.getCallEdgeServer(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<UpdateCallResponse> updateCall(UpdateCallRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.updateCall(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<UpdateCallPermissionsResponse> updateCallPermissions(
    UpdateCallPermissionsRequest req,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.updateCallPermissions(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<EndCallResponse> endCall(EndCallRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.endCall(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<QueryCallsResponse> queryCalls(QueryCallsRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.queryCalls(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<QueryMembersResponse> queryMembers(QueryMembersRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.queryMembers(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<CreateDeviceResponse> createDevice(CreateDeviceRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.createDevice(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<DeleteDeviceResponse> deleteDevice(DeleteDeviceRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.deleteDevice(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<QueryDevicesResponse> queryDevices(QueryDevicesRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.queryDevices(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<UpsertCallMembersResponse> upsertCallMembers(
    UpsertCallMembersRequest req,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.upsertCallMembers(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<DeleteCallMembersResponse> deleteCallMembers(
    DeleteCallMembersRequest req,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.deleteCallMembers(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<SendEventResponse> sendEvent(SendEventRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.sendEvent(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<SendCustomEventResponse> sendCustomEvent(
    SendCustomEventRequest req,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.sendCustomEvent(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<ReportCallStatsResponse> reportCallStats(ReportCallStatsRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.reportCallStats(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<ReportCallStatEventResponse> reportCallStatEvent(
    ReportCallStatEventRequest req,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.reportCallStatEvent(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<ReviewCallResponse> reviewCall(ReviewCallRequest req) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.reviewCall(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<ReportIssueResponse> reportIssue(ReportIssueRequest req) async {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient.reportIssue(ctx, req);
      });
    } on TwirpError catch (e, stk) {
      // TODO: Use StreamVideoError.fromTwirpError instead.
      final error = StreamVideoError(e.getMsg);
      Error.throwWithStackTrace(error, stk);
    } catch (e, stk) {
      final error = StreamVideoError('Unknown Exception Occurred: $e');
      Error.throwWithStackTrace(error, stk);
    }
  }

  Future<Context> _withAuthHeaders([Context? ctx]) async {
    ctx ??= Context();
    final token = await tokenManager.loadToken();
    return withHttpRequestHeaders(ctx, {
      'api_key': apiKey,
      'Authorization': 'Bearer ${token.rawValue}',
    });
  }
}
