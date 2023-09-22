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
  ApiClient({this.basePath = 'https://video.stream-io-api.com', this.authentication,});

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
        case 'APNS':
          return APNS.fromJson(value);
        case 'APNSRequest':
          return APNSRequest.fromJson(value);
        case 'AcceptCallResponse':
          return AcceptCallResponse.fromJson(value);
        case 'AudioSettings':
          return AudioSettings.fromJson(value);
        case 'AudioSettingsRequest':
          return AudioSettingsRequest.fromJson(value);
        case 'BackstageSettings':
          return BackstageSettings.fromJson(value);
        case 'BackstageSettingsRequest':
          return BackstageSettingsRequest.fromJson(value);
        case 'BlockUserRequest':
          return BlockUserRequest.fromJson(value);
        case 'BlockUserResponse':
          return BlockUserResponse.fromJson(value);
        case 'BlockedUserEvent':
          return BlockedUserEvent.fromJson(value);
        case 'BroadcastSettings':
          return BroadcastSettings.fromJson(value);
        case 'BroadcastSettingsRequest':
          return BroadcastSettingsRequest.fromJson(value);
        case 'CallAcceptedEvent':
          return CallAcceptedEvent.fromJson(value);
        case 'CallBroadcastingStartedEvent':
          return CallBroadcastingStartedEvent.fromJson(value);
        case 'CallBroadcastingStoppedEvent':
          return CallBroadcastingStoppedEvent.fromJson(value);
        case 'CallCreatedEvent':
          return CallCreatedEvent.fromJson(value);
        case 'CallEndedEvent':
          return CallEndedEvent.fromJson(value);
        case 'CallIngressResponse':
          return CallIngressResponse.fromJson(value);
        case 'CallLiveStartedEvent':
          return CallLiveStartedEvent.fromJson(value);
        case 'CallMemberAddedEvent':
          return CallMemberAddedEvent.fromJson(value);
        case 'CallMemberRemovedEvent':
          return CallMemberRemovedEvent.fromJson(value);
        case 'CallMemberUpdatedEvent':
          return CallMemberUpdatedEvent.fromJson(value);
        case 'CallMemberUpdatedPermissionEvent':
          return CallMemberUpdatedPermissionEvent.fromJson(value);
        case 'CallNotificationEvent':
          return CallNotificationEvent.fromJson(value);
        case 'CallParticipantResponse':
          return CallParticipantResponse.fromJson(value);
        case 'CallReactionEvent':
          return CallReactionEvent.fromJson(value);
        case 'CallRecording':
          return CallRecording.fromJson(value);
        case 'CallRecordingFailedEvent':
          return CallRecordingFailedEvent.fromJson(value);
        case 'CallRecordingReadyEvent':
          return CallRecordingReadyEvent.fromJson(value);
        case 'CallRecordingStartedEvent':
          return CallRecordingStartedEvent.fromJson(value);
        case 'CallRecordingStoppedEvent':
          return CallRecordingStoppedEvent.fromJson(value);
        case 'CallRejectedEvent':
          return CallRejectedEvent.fromJson(value);
        case 'CallRequest':
          return CallRequest.fromJson(value);
        case 'CallResponse':
          return CallResponse.fromJson(value);
        case 'CallRingEvent':
          return CallRingEvent.fromJson(value);
        case 'CallSessionEndedEvent':
          return CallSessionEndedEvent.fromJson(value);
        case 'CallSessionParticipantJoinedEvent':
          return CallSessionParticipantJoinedEvent.fromJson(value);
        case 'CallSessionParticipantLeftEvent':
          return CallSessionParticipantLeftEvent.fromJson(value);
        case 'CallSessionResponse':
          return CallSessionResponse.fromJson(value);
        case 'CallSessionStartedEvent':
          return CallSessionStartedEvent.fromJson(value);
        case 'CallSettingsRequest':
          return CallSettingsRequest.fromJson(value);
        case 'CallSettingsResponse':
          return CallSettingsResponse.fromJson(value);
        case 'CallStateResponseFields':
          return CallStateResponseFields.fromJson(value);
        case 'CallTypeResponse':
          return CallTypeResponse.fromJson(value);
        case 'CallUpdatedEvent':
          return CallUpdatedEvent.fromJson(value);
        case 'CallUserMuted':
          return CallUserMuted.fromJson(value);
        case 'ConnectUserDetailsRequest':
          return ConnectUserDetailsRequest.fromJson(value);
        case 'ConnectedEvent':
          return ConnectedEvent.fromJson(value);
        case 'ConnectionErrorEvent':
          return ConnectionErrorEvent.fromJson(value);
        case 'CreateCallTypeRequest':
          return CreateCallTypeRequest.fromJson(value);
        case 'CreateCallTypeResponse':
          return CreateCallTypeResponse.fromJson(value);
        case 'CreateDeviceRequest':
          return CreateDeviceRequest.fromJson(value);
        case 'CreateGuestRequest':
          return CreateGuestRequest.fromJson(value);
        case 'CreateGuestResponse':
          return CreateGuestResponse.fromJson(value);
        case 'Credentials':
          return Credentials.fromJson(value);
        case 'CustomVideoEvent':
          return CustomVideoEvent.fromJson(value);
        case 'Device':
          return Device.fromJson(value);
        case 'EdgeResponse':
          return EdgeResponse.fromJson(value);
        case 'EgressHLSResponse':
          return EgressHLSResponse.fromJson(value);
        case 'EgressRTMPResponse':
          return EgressRTMPResponse.fromJson(value);
        case 'EgressResponse':
          return EgressResponse.fromJson(value);
        case 'EndCallResponse':
          return EndCallResponse.fromJson(value);
        case 'EventNotificationSettings':
          return EventNotificationSettings.fromJson(value);
        case 'EventNotificationSettingsRequest':
          return EventNotificationSettingsRequest.fromJson(value);
        case 'GeofenceSettings':
          return GeofenceSettings.fromJson(value);
        case 'GeofenceSettingsRequest':
          return GeofenceSettingsRequest.fromJson(value);
        case 'GetCallResponse':
          return GetCallResponse.fromJson(value);
        case 'GetCallTypeResponse':
          return GetCallTypeResponse.fromJson(value);
        case 'GetEdgesResponse':
          return GetEdgesResponse.fromJson(value);
        case 'GetOrCreateCallRequest':
          return GetOrCreateCallRequest.fromJson(value);
        case 'GetOrCreateCallResponse':
          return GetOrCreateCallResponse.fromJson(value);
        case 'GoLiveRequest':
          return GoLiveRequest.fromJson(value);
        case 'GoLiveResponse':
          return GoLiveResponse.fromJson(value);
        case 'HLSSettings':
          return HLSSettings.fromJson(value);
        case 'HLSSettingsRequest':
          return HLSSettingsRequest.fromJson(value);
        case 'HealthCheckEvent':
          return HealthCheckEvent.fromJson(value);
        case 'ICEServer':
          return ICEServer.fromJson(value);
        case 'JoinCallRequest':
          return JoinCallRequest.fromJson(value);
        case 'JoinCallResponse':
          return JoinCallResponse.fromJson(value);
        case 'ListCallTypeResponse':
          return ListCallTypeResponse.fromJson(value);
        case 'ListDevicesResponse':
          return ListDevicesResponse.fromJson(value);
        case 'ListRecordingsResponse':
          return ListRecordingsResponse.fromJson(value);
        case 'MemberRequest':
          return MemberRequest.fromJson(value);
        case 'MemberResponse':
          return MemberResponse.fromJson(value);
        case 'MuteUsersRequest':
          return MuteUsersRequest.fromJson(value);
        case 'MuteUsersResponse':
          return MuteUsersResponse.fromJson(value);
        case 'NotificationSettings':
          return NotificationSettings.fromJson(value);
        case 'NotificationSettingsRequest':
          return NotificationSettingsRequest.fromJson(value);
        case 'OwnCapability':
          return OwnCapabilityTypeTransformer().decode(value);
        case 'OwnUserResponse':
          return OwnUserResponse.fromJson(value);
        case 'PermissionRequestEvent':
          return PermissionRequestEvent.fromJson(value);
        case 'PinRequest':
          return PinRequest.fromJson(value);
        case 'PinResponse':
          return PinResponse.fromJson(value);
        case 'QueryCallsRequest':
          return QueryCallsRequest.fromJson(value);
        case 'QueryCallsResponse':
          return QueryCallsResponse.fromJson(value);
        case 'QueryMembersRequest':
          return QueryMembersRequest.fromJson(value);
        case 'QueryMembersResponse':
          return QueryMembersResponse.fromJson(value);
        case 'RTMPIngress':
          return RTMPIngress.fromJson(value);
        case 'ReactionResponse':
          return ReactionResponse.fromJson(value);
        case 'RecordSettings':
          return RecordSettings.fromJson(value);
        case 'RecordSettingsRequest':
          return RecordSettingsRequest.fromJson(value);
        case 'RejectCallResponse':
          return RejectCallResponse.fromJson(value);
        case 'RequestPermissionRequest':
          return RequestPermissionRequest.fromJson(value);
        case 'RequestPermissionResponse':
          return RequestPermissionResponse.fromJson(value);
        case 'DurationResponse':
          return DurationResponse.fromJson(value);
        case 'RingSettings':
          return RingSettings.fromJson(value);
        case 'RingSettingsRequest':
          return RingSettingsRequest.fromJson(value);
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
        case 'SendReactionRequest':
          return SendReactionRequest.fromJson(value);
        case 'SendReactionResponse':
          return SendReactionResponse.fromJson(value);
        case 'SortParamRequest':
          return SortParamRequest.fromJson(value);
        case 'StartBroadcastingResponse':
          return StartBroadcastingResponse.fromJson(value);
        case 'StartRecordingResponse':
          return StartRecordingResponse.fromJson(value);
        case 'StartTranscriptionResponse':
          return StartTranscriptionResponse.fromJson(value);
        case 'StopBroadcastingResponse':
          return StopBroadcastingResponse.fromJson(value);
        case 'StopLiveResponse':
          return StopLiveResponse.fromJson(value);
        case 'StopRecordingResponse':
          return StopRecordingResponse.fromJson(value);
        case 'StopTranscriptionResponse':
          return StopTranscriptionResponse.fromJson(value);
        case 'TargetResolution':
          return TargetResolution.fromJson(value);
        case 'TargetResolutionRequest':
          return TargetResolutionRequest.fromJson(value);
        case 'TranscriptionSettings':
          return TranscriptionSettings.fromJson(value);
        case 'TranscriptionSettingsRequest':
          return TranscriptionSettingsRequest.fromJson(value);
        case 'UnblockUserRequest':
          return UnblockUserRequest.fromJson(value);
        case 'UnblockUserResponse':
          return UnblockUserResponse.fromJson(value);
        case 'UnblockedUserEvent':
          return UnblockedUserEvent.fromJson(value);
        case 'UnpinRequest':
          return UnpinRequest.fromJson(value);
        case 'UnpinResponse':
          return UnpinResponse.fromJson(value);
        case 'UpdateCallMembersRequest':
          return UpdateCallMembersRequest.fromJson(value);
        case 'UpdateCallMembersResponse':
          return UpdateCallMembersResponse.fromJson(value);
        case 'UpdateCallRequest':
          return UpdateCallRequest.fromJson(value);
        case 'UpdateCallResponse':
          return UpdateCallResponse.fromJson(value);
        case 'UpdateCallTypeRequest':
          return UpdateCallTypeRequest.fromJson(value);
        case 'UpdateCallTypeResponse':
          return UpdateCallTypeResponse.fromJson(value);
        case 'UpdateUserPermissionsRequest':
          return UpdateUserPermissionsRequest.fromJson(value);
        case 'UpdateUserPermissionsResponse':
          return UpdateUserPermissionsResponse.fromJson(value);
        case 'UpdatedCallPermissionsEvent':
          return UpdatedCallPermissionsEvent.fromJson(value);
        case 'UserRequest':
          return UserRequest.fromJson(value);
        case 'UserResponse':
          return UserResponse.fromJson(value);
        case 'VideoEvent':
          return VideoEvent.fromJson(value);
        case 'VideoSettings':
          return VideoSettings.fromJson(value);
        case 'VideoSettingsRequest':
          return VideoSettingsRequest.fromJson(value);
        case 'WSAuthMessageRequest':
          return WSAuthMessageRequest.fromJson(value);
        case 'WSCallEvent':
          return WSCallEvent.fromJson(value);
        case 'WSClientEvent':
          return WSClientEvent.fromJson(value);
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
