//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ApiClient {
  ApiClient({this.basePath = 'https://chat.stream-io-api.com', this.authentication,});

  final String basePath;
  final Authentication? authentication;

  var _client = Client();
  final _defaultHeaderMap = <String, String>{};

  /// Returns the current HTTP [Client] instance to use in this class.
  ///
  /// The return value is guaranteed to never be null.
  Client get client => _client;

  /// Requests to use a new HTTP [Client] in this class.
  set client(Client newClient) {
    _client = newClient;
  }

  Map<String, String> get defaultHeaderMap => _defaultHeaderMap;

  void addDefaultHeader(String key, String value) {
     _defaultHeaderMap[key] = value;
  }

  // We don't use a Map<String, String> for queryParams.
  // If collectionFormat is 'multi', a key might appear multiple times.
  Future<Response> invokeAPI(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType,
  ) async {
    await authentication?.applyToParams(queryParams, headerParams);

    headerParams.addAll(_defaultHeaderMap);
    if (contentType != null) {
      headerParams['Content-Type'] = contentType;
    }

    final urlEncodedQueryParams = queryParams.map((param) => '$param');
    final queryString = urlEncodedQueryParams.isNotEmpty ? '?${urlEncodedQueryParams.join('&')}' : '';
    final uri = Uri.parse('$basePath$path$queryString');

    try {
      // Special case for uploading a single file which isn't a 'multipart/form-data'.
      if (
        body is MultipartFile && (contentType == null ||
        !contentType.toLowerCase().startsWith('multipart/form-data'))
      ) {
        final request = StreamedRequest(method, uri);
        request.headers.addAll(headerParams);
        request.contentLength = body.length;
        body.finalize().listen(
          request.sink.add,
          onDone: request.sink.close,
          // ignore: avoid_types_on_closure_parameters
          onError: (Object error, StackTrace trace) => request.sink.close(),
          cancelOnError: true,
        );
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      if (body is MultipartRequest) {
        final request = MultipartRequest(method, uri);
        request.fields.addAll(body.fields);
        request.files.addAll(body.files);
        request.headers.addAll(body.headers);
        request.headers.addAll(headerParams);
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      final msgBody = contentType == 'application/x-www-form-urlencoded'
        ? formParams
        : await serializeAsync(body);
      final nullableHeaderParams = headerParams.isEmpty ? null : headerParams;

      switch(method) {
        case 'POST': return await _client.post(uri, headers: nullableHeaderParams, body: msgBody,);
        case 'PUT': return await _client.put(uri, headers: nullableHeaderParams, body: msgBody,);
        case 'DELETE': return await _client.delete(uri, headers: nullableHeaderParams, body: msgBody,);
        case 'PATCH': return await _client.patch(uri, headers: nullableHeaderParams, body: msgBody,);
        case 'HEAD': return await _client.head(uri, headers: nullableHeaderParams,);
        case 'GET': return await _client.get(uri, headers: nullableHeaderParams,);
      }
    } on SocketException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Socket operation failed: $method $path',
        error,
        trace,
      );
    } on TlsException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'TLS/SSL communication failed: $method $path',
        error,
        trace,
      );
    } on IOException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'I/O operation failed: $method $path',
        error,
        trace,
      );
    } on ClientException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'HTTP connection failed: $method $path',
        error,
        trace,
      );
    } on Exception catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Exception occurred: $method $path',
        error,
        trace,
      );
    }

    throw ApiException(
      HttpStatus.badRequest,
      'Invalid HTTP operation: $method $path',
    );
  }

  Future<dynamic> deserializeAsync(String json, String targetType, {bool growable = false,}) async =>
    // ignore: deprecated_member_use_from_same_package
    deserialize(json, targetType, growable: growable);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use deserializeAsync() instead.')
  dynamic deserialize(String json, String targetType, {bool growable = false,}) {
    // Remove all spaces. Necessary for regular expressions as well.
    targetType = targetType.replaceAll(' ', ''); // ignore: parameter_assignments

    // If the expected target type is String, nothing to do...
    return targetType == 'String'
      ? json
      : _deserialize(jsonDecode(json), targetType, growable: growable);
  }

  // ignore: deprecated_member_use_from_same_package
  Future<String> serializeAsync(Object? value) async => serialize(value);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use serializeAsync() instead.')
  String serialize(Object? value) => value == null ? '' : json.encode(value);

  static dynamic _deserialize(dynamic value, String targetType, {bool growable = false}) {
    try {
      switch (targetType) {
        case 'String':
          return value is String ? value : value.toString();
        case 'int':
          return value is int ? value : int.parse('$value');
        case 'double':
          return value is double ? value : double.parse('$value');
        case 'bool':
          if (value is bool) {
            return value;
          }
          final valueString = '$value'.toLowerCase();
          return valueString == 'true' || valueString == '1';
        case 'DateTime':
          return value is DateTime ? value : DateTime.tryParse(value);
        case 'APIError':
          return APIError.fromJson(value);
        case 'Any':
          return Any.fromJson(value);
        case 'AudioSettings':
          return AudioSettings.fromJson(value);
        case 'BackstageSettings':
          return BackstageSettings.fromJson(value);
        case 'BlockUserRequest':
          return BlockUserRequest.fromJson(value);
        case 'BlockUserResponse':
          return BlockUserResponse.fromJson(value);
        case 'BroadcastSettings':
          return BroadcastSettings.fromJson(value);
        case 'CallAccepted':
          return CallAccepted.fromJson(value);
        case 'CallBlockedUser':
          return CallBlockedUser.fromJson(value);
        case 'CallCancelled':
          return CallCancelled.fromJson(value);
        case 'CallCreated':
          return CallCreated.fromJson(value);
        case 'CallEnded':
          return CallEnded.fromJson(value);
        case 'CallPermissionRequest':
          return CallPermissionRequest.fromJson(value);
        case 'CallPermissionsUpdated':
          return CallPermissionsUpdated.fromJson(value);
        case 'CallRecordingStarted':
          return CallRecordingStarted.fromJson(value);
        case 'CallRecordingStopped':
          return CallRecordingStopped.fromJson(value);
        case 'CallRejected':
          return CallRejected.fromJson(value);
        case 'CallRequest':
          return CallRequest.fromJson(value);
        case 'CallResponse':
          return CallResponse.fromJson(value);
        case 'CallSettingsRequest':
          return CallSettingsRequest.fromJson(value);
        case 'CallSettingsResponse':
          return CallSettingsResponse.fromJson(value);
        case 'CallStateResponseFields':
          return CallStateResponseFields.fromJson(value);
        case 'CallUnblockedUser':
          return CallUnblockedUser.fromJson(value);
        case 'CallUpdated':
          return CallUpdated.fromJson(value);
        case 'Coordinates':
          return Coordinates.fromJson(value);
        case 'Credentials':
          return Credentials.fromJson(value);
        case 'Custom':
          return Custom.fromJson(value);
        case 'DatacenterResponse':
          return DatacenterResponse.fromJson(value);
        case 'Device':
          return Device.fromJson(value);
        case 'EndCallResponse':
          return EndCallResponse.fromJson(value);
        case 'GeofenceSettings':
          return GeofenceSettings.fromJson(value);
        case 'GeofenceSettingsRequest':
          return GeofenceSettingsRequest.fromJson(value);
        case 'GetCallEdgeServerRequest':
          return GetCallEdgeServerRequest.fromJson(value);
        case 'GetCallEdgeServerResponse':
          return GetCallEdgeServerResponse.fromJson(value);
        case 'GetOrCreateCallRequest':
          return GetOrCreateCallRequest.fromJson(value);
        case 'GetOrCreateCallResponse':
          return GetOrCreateCallResponse.fromJson(value);
        case 'GoLiveResponse':
          return GoLiveResponse.fromJson(value);
        case 'HLSSettings':
          return HLSSettings.fromJson(value);
        case 'HealthCheck':
          return HealthCheck.fromJson(value);
        case 'ICEServer':
          return ICEServer.fromJson(value);
        case 'JoinCallRequest':
          return JoinCallRequest.fromJson(value);
        case 'JoinCallResponse':
          return JoinCallResponse.fromJson(value);
        case 'MemberRequest':
          return MemberRequest.fromJson(value);
        case 'MemberResponse':
          return MemberResponse.fromJson(value);
        case 'MuteUsersRequest':
          return MuteUsersRequest.fromJson(value);
        case 'MuteUsersResponse':
          return MuteUsersResponse.fromJson(value);
        case 'OwnUserResponse':
          return OwnUserResponse.fromJson(value);
        case 'PaginationParamsRequest':
          return PaginationParamsRequest.fromJson(value);
        case 'QueryCallsRequest':
          return QueryCallsRequest.fromJson(value);
        case 'QueryCallsResponse':
          return QueryCallsResponse.fromJson(value);
        case 'QueryMembersRequest':
          return QueryMembersRequest.fromJson(value);
        case 'QueryMembersResponse':
          return QueryMembersResponse.fromJson(value);
        case 'RecordSettings':
          return RecordSettings.fromJson(value);
        case 'RecordSettingsRequest':
          return RecordSettingsRequest.fromJson(value);
        case 'RequestPermissionRequest':
          return RequestPermissionRequest.fromJson(value);
        case 'RequestPermissionResponse':
          return RequestPermissionResponse.fromJson(value);
        case 'SFUResponse':
          return SFUResponse.fromJson(value);
        case 'ScreensharingSettings':
          return ScreensharingSettings.fromJson(value);
        case 'ScreensharingSettingsRequest':
          return ScreensharingSettingsRequest.fromJson(value);
        case 'SendEventRequest':
          return SendEventRequest.fromJson(value);
        case 'SendEventResponse':
          return SendEventResponse.fromJson(value);
        case 'SortParamRequest':
          return SortParamRequest.fromJson(value);
        case 'StopLiveResponse':
          return StopLiveResponse.fromJson(value);
        case 'UnblockUserRequest':
          return UnblockUserRequest.fromJson(value);
        case 'UnblockUserResponse':
          return UnblockUserResponse.fromJson(value);
        case 'UpdateCallRequest':
          return UpdateCallRequest.fromJson(value);
        case 'UpdateCallResponse':
          return UpdateCallResponse.fromJson(value);
        case 'UpdateUserPermissionsRequest':
          return UpdateUserPermissionsRequest.fromJson(value);
        case 'UpdateUserPermissionsResponse':
          return UpdateUserPermissionsResponse.fromJson(value);
        case 'UserRequest':
          return UserRequest.fromJson(value);
        case 'UserResponse':
          return UserResponse.fromJson(value);
        case 'VideoSettings':
          return VideoSettings.fromJson(value);
        case 'VideoSettingsRequest':
          return VideoSettingsRequest.fromJson(value);
        default:
          dynamic match;
          if (value is List && (match = _regList.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => _deserialize(v, match, growable: growable,))
              .toList(growable: growable);
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => _deserialize(v, match, growable: growable,))
              .toSet();
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)?.group(1)) != null) {
            return Map<String, dynamic>.fromIterables(
              value.keys.cast<String>(),
              value.values.map<dynamic>((dynamic v) => _deserialize(v, match, growable: growable,)),
            );
          }
      }
    } on Exception catch (error, trace) {
      throw ApiException.withInner(HttpStatus.internalServerError, 'Exception during deserialization.', error, trace,);
    }
    throw ApiException(HttpStatus.internalServerError, 'Could not find a suitable class for deserialization',);
  }
}

/// Primarily intended for use in an isolate.
class DeserializationMessage {
  const DeserializationMessage({
    required this.json,
    required this.targetType,
    this.growable = false,
  });

  /// The JSON value to deserialize.
  final String json;

  /// Target type to deserialize to.
  final String targetType;

  /// Whether to make deserialized lists or maps growable.
  final bool growable;
}

/// Primarily intended for use in an isolate.
Future<dynamic> deserializeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : ApiClient._deserialize(
        jsonDecode(message.json),
        targetType,
        growable: message.growable,
      );
}

/// Primarily intended for use in an isolate.
Future<String> serializeAsync(Object? value) async => value == null ? '' : json.encode(value);
