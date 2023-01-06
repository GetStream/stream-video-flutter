import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pbtwirp.dart';
import 'package:stream_video/src/token/token_manager.dart';
import 'package:stream_video/src/v2/utils/result.dart';
import 'package:stream_video/src/v2/utils/result_converters.dart';
import 'package:tart/tart.dart';

/// An accessor that allows us to communicate with the API around video calls.
class CoordinatorClient {
  CoordinatorClient({
    required String baseUrl,
    required this.apiKey,
    required this.tokenManager,
  }) : _clientRPCProtobufClient = ClientRPCProtobufClient(
          baseUrl,
          '',
        );

  final String apiKey;
  final TokenManager tokenManager;

  final ClientRPCProtobufClient _clientRPCProtobufClient;

  /// Create a new Device used to receive Push Notifications.
  Future<Result<CreateDeviceResponse>> createDevice(
      CreateDeviceRequest request) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .createDevice(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Deletes a Device used to receive Push Notifications.
  Future<Result<void>> deleteDevice(DeleteDeviceRequest request) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .deleteDevice(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Attempts to create a new call.
  Future<Result<CreateCallResponse>> createCall(CreateCallRequest request) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .createCall(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Gets the call if already exists or attempts to create a new call.
  Future<Result<GetOrCreateCallResponse>> getOrCreateCall(
    GetOrCreateCallRequest request,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .getOrCreateCall(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Attempts to join a [Call]. If successful, gives us more information
  /// about the user and the call itself.
  Future<Result<JoinCallResponse>> joinCall(JoinCallRequest request) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .joinCall(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Finds the correct server to connect to for given user and [request].
  Future<Result<GetCallEdgeServerResponse>> selectCallEdgeServer(
    GetCallEdgeServerRequest request,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .getCallEdgeServer(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Sends a user-based event to the API to notify if we've changed something
  /// in the state of the call.
  Future<Result<SendEventResponse>> sendUserEvent(SendEventRequest request) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .sendEvent(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Sends a custom event with encoded JSON data.
  Future<Result<SendCustomEventResponse>> sendCustomEvent(
    SendCustomEventRequest request,
  ) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .sendCustomEvent(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Sends invite to people for an existing call.
  Future<Result<void>> inviteUsers(UpsertCallMembersRequest request) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .upsertCallMembers(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
    }
  }

  /// Queries users based on the given [request].
  Future<Result<void>> queryUsers(QueryUsersRequest request) {
    try {
      return _withAuthHeaders().then((ctx) {
        return _clientRPCProtobufClient
            .queryUsers(ctx, request)
            .then(Success.new);
      });
    } catch (e, stk) {
      return e.asFailure(stk).asFuture();
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
