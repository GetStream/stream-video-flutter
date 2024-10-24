//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ApiClient {
  ApiClient({
    this.basePath = 'https://stream-io-api.com',
    this.authentication,
  });

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
    final queryString = urlEncodedQueryParams.isNotEmpty
        ? '?${urlEncodedQueryParams.join('&')}'
        : '';
    final uri = Uri.parse('$basePath$path$queryString');

    try {
      // Special case for uploading a single file which isn't a 'multipart/form-data'.
      if (body is MultipartFile &&
          (contentType == null ||
              !contentType.toLowerCase().startsWith('multipart/form-data'))) {
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

      switch (method) {
        case 'POST':
          return await _client.post(
            uri,
            headers: nullableHeaderParams,
            body: msgBody,
          );
        case 'PUT':
          return await _client.put(
            uri,
            headers: nullableHeaderParams,
            body: msgBody,
          );
        case 'DELETE':
          return await _client.delete(
            uri,
            headers: nullableHeaderParams,
            body: msgBody,
          );
        case 'PATCH':
          return await _client.patch(
            uri,
            headers: nullableHeaderParams,
            body: msgBody,
          );
        case 'HEAD':
          return await _client.head(
            uri,
            headers: nullableHeaderParams,
          );
        case 'GET':
          return await _client.get(
            uri,
            headers: nullableHeaderParams,
          );
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

  Future<dynamic> deserializeAsync(
    String value,
    String targetType, {
    bool growable = false,
  }) async =>
      // ignore: deprecated_member_use_from_same_package
      deserialize(value, targetType, growable: growable);

  @Deprecated(
      'Scheduled for removal in OpenAPI Generator 6.x. Use deserializeAsync() instead.')
  dynamic deserialize(
    String value,
    String targetType, {
    bool growable = false,
  }) {
    // Remove all spaces. Necessary for regular expressions as well.
    targetType =
        targetType.replaceAll(' ', ''); // ignore: parameter_assignments

    // If the expected target type is String, nothing to do...
    return targetType == 'String'
        ? value
        : fromJson(json.decode(value), targetType, growable: growable);
  }

  // ignore: deprecated_member_use_from_same_package
  Future<String> serializeAsync(Object? value) async => serialize(value);

  @Deprecated(
      'Scheduled for removal in OpenAPI Generator 6.x. Use serializeAsync() instead.')
  String serialize(Object? value) => value == null ? '' : json.encode(value);

  /// Returns a native instance of an OpenAPI class matching the [specified type][targetType].
  static dynamic fromJson(
    dynamic value,
    String targetType, {
    bool growable = false,
  }) {
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
        case 'AcceptCallResponse':
          return AcceptCallResponse.fromJson(value);
        case 'Action':
          return Action.fromJson(value);
        case 'ActionLog':
          return ActionLog.fromJson(value);
        case 'AggregatedStats':
          return AggregatedStats.fromJson(value);
        case 'Attachment':
          return Attachment.fromJson(value);
        case 'AudioSettingsRequest':
          return AudioSettingsRequest.fromJson(value);
        case 'AudioSettingsResponse':
          return AudioSettingsResponse.fromJson(value);
        case 'BackstageSettingsRequest':
          return BackstageSettingsRequest.fromJson(value);
        case 'BackstageSettingsResponse':
          return BackstageSettingsResponse.fromJson(value);
        case 'Ban':
          return Ban.fromJson(value);
        case 'BlockListOptions':
          return BlockListOptions.fromJson(value);
        case 'BlockUserRequest':
          return BlockUserRequest.fromJson(value);
        case 'BlockUserResponse':
          return BlockUserResponse.fromJson(value);
        case 'BlockedUserEvent':
          return BlockedUserEvent.fromJson(value);
        case 'BroadcastSettingsRequest':
          return BroadcastSettingsRequest.fromJson(value);
        case 'BroadcastSettingsResponse':
          return BroadcastSettingsResponse.fromJson(value);
        case 'CallAcceptedEvent':
          return CallAcceptedEvent.fromJson(value);
        case 'CallClosedCaption':
          return CallClosedCaption.fromJson(value);
        case 'CallCreatedEvent':
          return CallCreatedEvent.fromJson(value);
        case 'CallDeletedEvent':
          return CallDeletedEvent.fromJson(value);
        case 'CallEndedEvent':
          return CallEndedEvent.fromJson(value);
        case 'CallEvent':
          return CallEvent.fromJson(value);
        case 'CallHLSBroadcastingFailedEvent':
          return CallHLSBroadcastingFailedEvent.fromJson(value);
        case 'CallHLSBroadcastingStartedEvent':
          return CallHLSBroadcastingStartedEvent.fromJson(value);
        case 'CallHLSBroadcastingStoppedEvent':
          return CallHLSBroadcastingStoppedEvent.fromJson(value);
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
        case 'CallMissedEvent':
          return CallMissedEvent.fromJson(value);
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
        case 'CallRtmpBroadcastFailedEvent':
          return CallRtmpBroadcastFailedEvent.fromJson(value);
        case 'CallRtmpBroadcastStartedEvent':
          return CallRtmpBroadcastStartedEvent.fromJson(value);
        case 'CallRtmpBroadcastStoppedEvent':
          return CallRtmpBroadcastStoppedEvent.fromJson(value);
        case 'CallSessionEndedEvent':
          return CallSessionEndedEvent.fromJson(value);
        case 'CallSessionParticipantCountsUpdatedEvent':
          return CallSessionParticipantCountsUpdatedEvent.fromJson(value);
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
        case 'CallStatsReportSummaryResponse':
          return CallStatsReportSummaryResponse.fromJson(value);
        case 'CallTimeline':
          return CallTimeline.fromJson(value);
        case 'CallTranscription':
          return CallTranscription.fromJson(value);
        case 'CallTranscriptionFailedEvent':
          return CallTranscriptionFailedEvent.fromJson(value);
        case 'CallTranscriptionReadyEvent':
          return CallTranscriptionReadyEvent.fromJson(value);
        case 'CallTranscriptionStartedEvent':
          return CallTranscriptionStartedEvent.fromJson(value);
        case 'CallTranscriptionStoppedEvent':
          return CallTranscriptionStoppedEvent.fromJson(value);
        case 'CallUpdatedEvent':
          return CallUpdatedEvent.fromJson(value);
        case 'CallUserMutedEvent':
          return CallUserMutedEvent.fromJson(value);
        case 'Channel':
          return Channel.fromJson(value);
        case 'ChannelConfig':
          return ChannelConfig.fromJson(value);
        case 'ChannelConfigWithInfo':
          return ChannelConfigWithInfo.fromJson(value);
        case 'ChannelMember':
          return ChannelMember.fromJson(value);
        case 'ChannelMute':
          return ChannelMute.fromJson(value);
        case 'ChannelResponse':
          return ChannelResponse.fromJson(value);
        case 'ClosedCaptionEvent':
          return ClosedCaptionEvent.fromJson(value);
        case 'CollectUserFeedbackRequest':
          return CollectUserFeedbackRequest.fromJson(value);
        case 'CollectUserFeedbackResponse':
          return CollectUserFeedbackResponse.fromJson(value);
        case 'Command':
          return Command.fromJson(value);
        case 'ConnectUserDetailsRequest':
          return ConnectUserDetailsRequest.fromJson(value);
        case 'ConnectedEvent':
          return ConnectedEvent.fromJson(value);
        case 'ConnectionErrorEvent':
          return ConnectionErrorEvent.fromJson(value);
        case 'Coordinates':
          return Coordinates.fromJson(value);
        case 'Count':
          return Count.fromJson(value);
        case 'CountrywiseAggregateStats':
          return CountrywiseAggregateStats.fromJson(value);
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
        case 'Data':
          return Data.fromJson(value);
        case 'DeleteCallRequest':
          return DeleteCallRequest.fromJson(value);
        case 'DeleteCallResponse':
          return DeleteCallResponse.fromJson(value);
        case 'DeleteRecordingResponse':
          return DeleteRecordingResponse.fromJson(value);
        case 'DeleteTranscriptionResponse':
          return DeleteTranscriptionResponse.fromJson(value);
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
        case 'EnrichedActivity':
          return EnrichedActivity.fromJson(value);
        case 'EnrichedReaction':
          return EnrichedReaction.fromJson(value);
        case 'Field':
          return Field.fromJson(value);
        case 'Flag2':
          return Flag2.fromJson(value);
        case 'GeofenceSettingsRequest':
          return GeofenceSettingsRequest.fromJson(value);
        case 'GeofenceSettingsResponse':
          return GeofenceSettingsResponse.fromJson(value);
        case 'GeolocationResult':
          return GeolocationResult.fromJson(value);
        case 'GetCallResponse':
          return GetCallResponse.fromJson(value);
        case 'GetCallStatsResponse':
          return GetCallStatsResponse.fromJson(value);
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
        case 'HLSSettingsRequest':
          return HLSSettingsRequest.fromJson(value);
        case 'HLSSettingsResponse':
          return HLSSettingsResponse.fromJson(value);
        case 'HealthCheckEvent':
          return HealthCheckEvent.fromJson(value);
        case 'ICEServer':
          return ICEServer.fromJson(value);
        case 'ImageData':
          return ImageData.fromJson(value);
        case 'Images':
          return Images.fromJson(value);
        case 'JoinCallRequest':
          return JoinCallRequest.fromJson(value);
        case 'JoinCallResponse':
          return JoinCallResponse.fromJson(value);
        case 'LabelThresholds':
          return LabelThresholds.fromJson(value);
        case 'LayoutSettingsRequest':
          return LayoutSettingsRequest.fromJson(value);
        case 'LimitsSettingsRequest':
          return LimitsSettingsRequest.fromJson(value);
        case 'LimitsSettingsResponse':
          return LimitsSettingsResponse.fromJson(value);
        case 'ListDevicesResponse':
          return ListDevicesResponse.fromJson(value);
        case 'ListRecordingsResponse':
          return ListRecordingsResponse.fromJson(value);
        case 'ListTranscriptionsResponse':
          return ListTranscriptionsResponse.fromJson(value);
        case 'Location':
          return Location.fromJson(value);
        case 'MOSStats':
          return MOSStats.fromJson(value);
        case 'MediaPubSubHint':
          return MediaPubSubHint.fromJson(value);
        case 'MemberRequest':
          return MemberRequest.fromJson(value);
        case 'MemberResponse':
          return MemberResponse.fromJson(value);
        case 'Message':
          return Message.fromJson(value);
        case 'ModerationCustomActionEvent':
          return ModerationCustomActionEvent.fromJson(value);
        case 'ModerationFlaggedEvent':
          return ModerationFlaggedEvent.fromJson(value);
        case 'ModerationMarkReviewedEvent':
          return ModerationMarkReviewedEvent.fromJson(value);
        case 'ModerationPayload':
          return ModerationPayload.fromJson(value);
        case 'MuteUsersRequest':
          return MuteUsersRequest.fromJson(value);
        case 'MuteUsersResponse':
          return MuteUsersResponse.fromJson(value);
        case 'NoiseCancellationSettings':
          return NoiseCancellationSettings.fromJson(value);
        case 'NullBool':
          return NullBool.fromJson(value);
        case 'NullTime':
          return NullTime.fromJson(value);
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
        case 'Poll':
          return Poll.fromJson(value);
        case 'PollOption':
          return PollOption.fromJson(value);
        case 'PollVote':
          return PollVote.fromJson(value);
        case 'PrivacySettings':
          return PrivacySettings.fromJson(value);
        case 'PrivacySettingsResponse':
          return PrivacySettingsResponse.fromJson(value);
        case 'PublishedTrackInfo':
          return PublishedTrackInfo.fromJson(value);
        case 'PublisherAggregateStats':
          return PublisherAggregateStats.fromJson(value);
        case 'PushNotificationSettings':
          return PushNotificationSettings.fromJson(value);
        case 'PushNotificationSettingsInput':
          return PushNotificationSettingsInput.fromJson(value);
        case 'PushNotificationSettingsResponse':
          return PushNotificationSettingsResponse.fromJson(value);
        case 'QueryCallMembersRequest':
          return QueryCallMembersRequest.fromJson(value);
        case 'QueryCallMembersResponse':
          return QueryCallMembersResponse.fromJson(value);
        case 'QueryCallStatsRequest':
          return QueryCallStatsRequest.fromJson(value);
        case 'QueryCallStatsResponse':
          return QueryCallStatsResponse.fromJson(value);
        case 'QueryCallsRequest':
          return QueryCallsRequest.fromJson(value);
        case 'QueryCallsResponse':
          return QueryCallsResponse.fromJson(value);
        case 'RTMPBroadcastRequest':
          return RTMPBroadcastRequest.fromJson(value);
        case 'RTMPIngress':
          return RTMPIngress.fromJson(value);
        case 'RTMPSettingsRequest':
          return RTMPSettingsRequest.fromJson(value);
        case 'RTMPSettingsResponse':
          return RTMPSettingsResponse.fromJson(value);
        case 'Reaction':
          return Reaction.fromJson(value);
        case 'ReactionGroupResponse':
          return ReactionGroupResponse.fromJson(value);
        case 'ReactionResponse':
          return ReactionResponse.fromJson(value);
        case 'ReadReceipts':
          return ReadReceipts.fromJson(value);
        case 'ReadReceiptsResponse':
          return ReadReceiptsResponse.fromJson(value);
        case 'RecordSettingsRequest':
          return RecordSettingsRequest.fromJson(value);
        case 'RecordSettingsResponse':
          return RecordSettingsResponse.fromJson(value);
        case 'RejectCallRequest':
          return RejectCallRequest.fromJson(value);
        case 'RejectCallResponse':
          return RejectCallResponse.fromJson(value);
        case 'RequestPermissionRequest':
          return RequestPermissionRequest.fromJson(value);
        case 'RequestPermissionResponse':
          return RequestPermissionResponse.fromJson(value);
        // MANUAL_EDIT: Response -> DurationResponse
        case 'DurationResponse':
          return DurationResponse.fromJson(value);
        case 'ReviewQueueItem':
          return ReviewQueueItem.fromJson(value);
        case 'RingSettingsRequest':
          return RingSettingsRequest.fromJson(value);
        case 'RingSettingsResponse':
          return RingSettingsResponse.fromJson(value);
        case 'SFULocationResponse':
          return SFULocationResponse.fromJson(value);
        case 'SFUResponse':
          return SFUResponse.fromJson(value);
        case 'ScreensharingSettingsRequest':
          return ScreensharingSettingsRequest.fromJson(value);
        case 'ScreensharingSettingsResponse':
          return ScreensharingSettingsResponse.fromJson(value);
        case 'SendCallEventRequest':
          return SendCallEventRequest.fromJson(value);
        case 'SendCallEventResponse':
          return SendCallEventResponse.fromJson(value);
        case 'SendReactionRequest':
          return SendReactionRequest.fromJson(value);
        case 'SendReactionResponse':
          return SendReactionResponse.fromJson(value);
        case 'SortParamRequest':
          return SortParamRequest.fromJson(value);
        case 'StartHLSBroadcastingResponse':
          return StartHLSBroadcastingResponse.fromJson(value);
        case 'StartRTMPBroadcastsRequest':
          return StartRTMPBroadcastsRequest.fromJson(value);
        case 'StartRTMPBroadcastsResponse':
          return StartRTMPBroadcastsResponse.fromJson(value);
        case 'StartRecordingRequest':
          return StartRecordingRequest.fromJson(value);
        case 'StartRecordingResponse':
          return StartRecordingResponse.fromJson(value);
        case 'StartTranscriptionRequest':
          return StartTranscriptionRequest.fromJson(value);
        case 'StartTranscriptionResponse':
          return StartTranscriptionResponse.fromJson(value);
        case 'StatsOptions':
          return StatsOptions.fromJson(value);
        case 'StopAllRTMPBroadcastsResponse':
          return StopAllRTMPBroadcastsResponse.fromJson(value);
        case 'StopHLSBroadcastingResponse':
          return StopHLSBroadcastingResponse.fromJson(value);
        case 'StopLiveResponse':
          return StopLiveResponse.fromJson(value);
        case 'StopRTMPBroadcastsResponse':
          return StopRTMPBroadcastsResponse.fromJson(value);
        case 'StopRecordingResponse':
          return StopRecordingResponse.fromJson(value);
        case 'StopTranscriptionResponse':
          return StopTranscriptionResponse.fromJson(value);
        case 'Subsession':
          return Subsession.fromJson(value);
        case 'TURNAggregatedStats':
          return TURNAggregatedStats.fromJson(value);
        case 'TargetResolution':
          return TargetResolution.fromJson(value);
        case 'Thresholds':
          return Thresholds.fromJson(value);
        case 'ThumbnailResponse':
          return ThumbnailResponse.fromJson(value);
        case 'ThumbnailsSettingsRequest':
          return ThumbnailsSettingsRequest.fromJson(value);
        case 'ThumbnailsSettingsResponse':
          return ThumbnailsSettingsResponse.fromJson(value);
        case 'TimeStats':
          return TimeStats.fromJson(value);
        case 'TranscriptionSettingsRequest':
          return TranscriptionSettingsRequest.fromJson(value);
        case 'TranscriptionSettingsResponse':
          return TranscriptionSettingsResponse.fromJson(value);
        case 'TypingIndicators':
          return TypingIndicators.fromJson(value);
        case 'TypingIndicatorsResponse':
          return TypingIndicatorsResponse.fromJson(value);
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
        case 'UpdateUserPermissionsRequest':
          return UpdateUserPermissionsRequest.fromJson(value);
        case 'UpdateUserPermissionsResponse':
          return UpdateUserPermissionsResponse.fromJson(value);
        case 'UpdatedCallPermissionsEvent':
          return UpdatedCallPermissionsEvent.fromJson(value);
        case 'UserBannedEvent':
          return UserBannedEvent.fromJson(value);
        case 'UserDeactivatedEvent':
          return UserDeactivatedEvent.fromJson(value);
        case 'UserDeletedEvent':
          return UserDeletedEvent.fromJson(value);
        case 'UserEventPayload':
          return UserEventPayload.fromJson(value);
        case 'UserFlaggedEvent':
          return UserFlaggedEvent.fromJson(value);
        case 'UserInfoResponse':
          return UserInfoResponse.fromJson(value);
        case 'UserMuteResponse':
          return UserMuteResponse.fromJson(value);
        case 'UserMutedEvent':
          return UserMutedEvent.fromJson(value);
        case 'UserObject':
          return UserObject.fromJson(value);
        case 'UserPresenceChangedEvent':
          return UserPresenceChangedEvent.fromJson(value);
        case 'UserReactivatedEvent':
          return UserReactivatedEvent.fromJson(value);
        case 'UserRequest':
          return UserRequest.fromJson(value);
        case 'UserResponse':
          return UserResponse.fromJson(value);
        case 'UserSessionStats':
          return UserSessionStats.fromJson(value);
        case 'UserStats':
          return UserStats.fromJson(value);
        case 'UserUnbannedEvent':
          return UserUnbannedEvent.fromJson(value);
        case 'UserUnmutedEvent':
          return UserUnmutedEvent.fromJson(value);
        case 'UserUpdatedEvent':
          return UserUpdatedEvent.fromJson(value);
        case 'VideoQuality':
          return VideoQuality.fromJson(value);
        case 'VideoResolution':
          return VideoResolution.fromJson(value);
        case 'VideoSettingsRequest':
          return VideoSettingsRequest.fromJson(value);
        case 'VideoSettingsResponse':
          return VideoSettingsResponse.fromJson(value);
        case 'WSAuthMessage':
          return WSAuthMessage.fromJson(value);
        case 'WSClientEvent':
          return WSClientEvent.fromJson(value);
        case 'WSEvent':
          return WSEvent.fromJson(value);
        case 'WebhookEvent':
          return WebhookEvent.fromJson(value);
        default:
          dynamic match;
          if (value is List &&
              (match = _regList.firstMatch(targetType)?.group(1)) != null) {
            return value
                .map<dynamic>((dynamic v) => fromJson(
                      v,
                      match,
                      growable: growable,
                    ))
                .toList(growable: growable);
          }
          if (value is Set &&
              (match = _regSet.firstMatch(targetType)?.group(1)) != null) {
            return value
                .map<dynamic>((dynamic v) => fromJson(
                      v,
                      match,
                      growable: growable,
                    ))
                .toSet();
          }
          if (value is Map &&
              (match = _regMap.firstMatch(targetType)?.group(1)) != null) {
            return Map<String, dynamic>.fromIterables(
              value.keys.cast<String>(),
              value.values.map<dynamic>((dynamic v) => fromJson(
                    v,
                    match,
                    growable: growable,
                  )),
            );
          }
      }
    } on Exception catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.internalServerError,
        'Exception during deserialization.',
        error,
        trace,
      );
    }
    throw ApiException(
      HttpStatus.internalServerError,
      'Could not find a suitable class for deserialization',
    );
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
Future<dynamic> decodeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String' ? message.json : json.decode(message.json);
}

/// Primarily intended for use in an isolate.
Future<dynamic> deserializeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
      ? message.json
      : ApiClient.fromJson(
          json.decode(message.json),
          targetType,
          growable: message.growable,
        );
}

/// Primarily intended for use in an isolate.
Future<String> serializeAsync(Object? value) async =>
    value == null ? '' : json.encode(value);
