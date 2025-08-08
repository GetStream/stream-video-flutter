//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element, unused_import
// ignore_for_file: use_string_in_part_of_directives
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: prefer_final_locals
// ignore_for_file: prefer_single_quotes
// ignore_for_file: unnecessary_raw_strings

part of openapi.api;

class DefaultApi {
  DefaultApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  Future<T?> invokeAPI<T>(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType,
    String returnType,
  ) async {
    final response = await apiClient.invokeAPI(
      path,
      method,
      queryParams,
      body,
      headerParams,
      formParams,
      contentType,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (returnType != 'void' &&
        response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        returnType,
      ) as T;
    }
    return null;
  }

  Future<AcceptCallResponse?> acceptCall(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/accept"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'AcceptCallResponse',
    );
  }

  Future<BlockUserResponse?> blockUser(
    String type,
    String id,
    BlockUserRequest blockUserRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/block"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      blockUserRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'BlockUserResponse',
    );
  }

  Future<CollectUserFeedbackResponse?> collectUserFeedback(
    String type,
    String id,
    CollectUserFeedbackRequest collectUserFeedbackRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/feedback"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      collectUserFeedbackRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'CollectUserFeedbackResponse',
    );
  }

  Future<DurationResponse?> createDevice(
    CreateDeviceRequest createDeviceRequest,
  ) async {
    const path = r"/video/devices";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      createDeviceRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'DurationResponse',
    );
  }

  Future<CreateGuestResponse?> createGuest(
    CreateGuestRequest createGuestRequest,
  ) async {
    const path = r"/video/guest";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      createGuestRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'CreateGuestResponse',
    );
  }

  Future<DeleteCallResponse?> deleteCall(
    String type,
    String id,
    DeleteCallRequest? deleteCallRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/delete"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      deleteCallRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'DeleteCallResponse',
    );
  }

  Future<DurationResponse?> deleteDevice(
    String id,
  ) async {
    const path = r"/video/devices";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];
    queryParams.addAll(_queryParams('', 'id', id));

    return invokeAPI(
      path,
      'DELETE',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'DurationResponse',
    );
  }

  Future<DeleteRecordingResponse?> deleteRecording(
    String type,
    String id,
    String session,
    String filename,
  ) async {
    var path = r"/video/call/{type}/{id}/{session}/recordings/{filename}"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id)
        .replaceAll('{session}', session)
        .replaceAll('{filename}', filename);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'DELETE',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'DeleteRecordingResponse',
    );
  }

  Future<DeleteTranscriptionResponse?> deleteTranscription(
    String type,
    String id,
    String session,
    String filename,
  ) async {
    var path = r"/video/call/{type}/{id}/{session}/transcriptions/{filename}"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id)
        .replaceAll('{session}', session)
        .replaceAll('{filename}', filename);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'DELETE',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'DeleteTranscriptionResponse',
    );
  }

  Future<EndCallResponse?> endCall(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/mark_ended"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'EndCallResponse',
    );
  }

  Future<GetCallResponse?> getCall(
    String type,
    String id,
    int? membersLimit,
    bool? ring,
    bool? notify,
    bool? video,
  ) async {
    var path = r"/video/call/{type}/{id}"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    if (membersLimit != null) {
      queryParams.addAll(_queryParams('', 'members_limit', membersLimit));
    }
    if (ring != null) {
      queryParams.addAll(_queryParams('', 'ring', ring));
    }
    if (notify != null) {
      queryParams.addAll(_queryParams('', 'notify', notify));
    }
    if (video != null) {
      queryParams.addAll(_queryParams('', 'video', video));
    }

    return invokeAPI(
      path,
      'GET',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'GetCallResponse',
    );
  }

  Future<GetCallReportResponse?> getCallReport(
    String type,
    String id,
    String? sessionId,
  ) async {
    var path = r"/video/call/{type}/{id}/report"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    if (sessionId != null) {
      queryParams.addAll(_queryParams('', 'session_id', sessionId));
    }

    return invokeAPI(
      path,
      'GET',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'GetCallReportResponse',
    );
  }

  Future<GetEdgesResponse?> getEdges() async {
    const path = r"/video/edges";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'GET',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'GetEdgesResponse',
    );
  }

  Future<GetOrCreateCallResponse?> getOrCreateCall(
    String type,
    String id,
    GetOrCreateCallRequest? getOrCreateCallRequest,
  ) async {
    var path = r"/video/call/{type}/{id}"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      getOrCreateCallRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'GetOrCreateCallResponse',
    );
  }

  Future<GoLiveResponse?> goLive(
    String type,
    String id,
    GoLiveRequest? goLiveRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/go_live"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      goLiveRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'GoLiveResponse',
    );
  }

  Future<JoinCallResponse?> joinCall(
    String type,
    String id,
    JoinCallRequest joinCallRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/join"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      joinCallRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'JoinCallResponse',
    );
  }

  Future<ListDevicesResponse?> listDevices() async {
    const path = r"/video/devices";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'GET',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'ListDevicesResponse',
    );
  }

  Future<ListRecordingsResponse?> listRecordings(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/recordings"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'GET',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'ListRecordingsResponse',
    );
  }

  Future<ListTranscriptionsResponse?> listTranscriptions(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/transcriptions"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'GET',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'ListTranscriptionsResponse',
    );
  }

  Future<MuteUsersResponse?> muteUsers(
    String type,
    String id,
    MuteUsersRequest? muteUsersRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/mute_users"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      muteUsersRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'MuteUsersResponse',
    );
  }

  Future<QueryAggregateCallStatsResponse?> queryAggregateCallStats(
    QueryAggregateCallStatsRequest? queryAggregateCallStatsRequest,
  ) async {
    const path = r"/video/stats";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      queryAggregateCallStatsRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'QueryAggregateCallStatsResponse',
    );
  }

  Future<QueryCallMembersResponse?> queryCallMembers(
    QueryCallMembersRequest queryCallMembersRequest,
  ) async {
    const path = r"/video/call/members";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      queryCallMembersRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'QueryCallMembersResponse',
    );
  }

  Future<QueryCallParticipantsResponse?> queryCallParticipants(
    String id,
    String type,
    int? limit,
    QueryCallParticipantsRequest? queryCallParticipantsRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/participants"
        .replaceAll('{id}', id)
        .replaceAll('{type}', type);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    return invokeAPI(
      path,
      'POST',
      queryParams,
      queryCallParticipantsRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'QueryCallParticipantsResponse',
    );
  }

  Future<QueryCallStatsResponse?> queryCallStats(
    QueryCallStatsRequest? queryCallStatsRequest,
  ) async {
    const path = r"/video/call/stats";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      queryCallStatsRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'QueryCallStatsResponse',
    );
  }

  Future<QueryCallsResponse?> queryCalls(
    QueryCallsRequest? queryCallsRequest,
  ) async {
    const path = r"/video/calls";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      queryCallsRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'QueryCallsResponse',
    );
  }

  Future<RejectCallResponse?> rejectCall(
    String type,
    String id,
    RejectCallRequest? rejectCallRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/reject"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      rejectCallRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'RejectCallResponse',
    );
  }

  Future<RequestPermissionResponse?> requestPermission(
    String type,
    String id,
    RequestPermissionRequest requestPermissionRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/request_permission"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      requestPermissionRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'RequestPermissionResponse',
    );
  }

  Future<SendCallEventResponse?> sendCallEvent(
    String type,
    String id,
    SendCallEventRequest? sendCallEventRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/event"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      sendCallEventRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'SendCallEventResponse',
    );
  }

  Future<SendReactionResponse?> sendVideoReaction(
    String type,
    String id,
    SendReactionRequest sendReactionRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/reaction"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      sendReactionRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'SendReactionResponse',
    );
  }

  Future<StartClosedCaptionsResponse?> startClosedCaptions(
    String type,
    String id,
    StartClosedCaptionsRequest? startClosedCaptionsRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/start_closed_captions"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      startClosedCaptionsRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StartClosedCaptionsResponse',
    );
  }

  Future<StartFrameRecordingResponse?> startFrameRecording(
    String type,
    String id,
    StartFrameRecordingRequest? startFrameRecordingRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/start_frame_recording"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      startFrameRecordingRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StartFrameRecordingResponse',
    );
  }

  Future<StartHLSBroadcastingResponse?> startHLSBroadcasting(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/start_broadcasting"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StartHLSBroadcastingResponse',
    );
  }

  Future<StartRTMPBroadcastsResponse?> startRTMPBroadcasts(
    String type,
    String id,
    StartRTMPBroadcastsRequest startRTMPBroadcastsRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/rtmp_broadcasts"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      startRTMPBroadcastsRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StartRTMPBroadcastsResponse',
    );
  }

  Future<StartRecordingResponse?> startRecording(
    String type,
    String id,
    StartRecordingRequest? startRecordingRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/start_recording"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      startRecordingRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StartRecordingResponse',
    );
  }

  Future<StartTranscriptionResponse?> startTranscription(
    String type,
    String id,
    StartTranscriptionRequest? startTranscriptionRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/start_transcription"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      startTranscriptionRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StartTranscriptionResponse',
    );
  }

  Future<StopAllRTMPBroadcastsResponse?> stopAllRTMPBroadcasts(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/rtmp_broadcasts/stop"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StopAllRTMPBroadcastsResponse',
    );
  }

  Future<StopClosedCaptionsResponse?> stopClosedCaptions(
    String type,
    String id,
    StopClosedCaptionsRequest? stopClosedCaptionsRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/stop_closed_captions"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      stopClosedCaptionsRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StopClosedCaptionsResponse',
    );
  }

  Future<StopFrameRecordingResponse?> stopFrameRecording(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/stop_frame_recording"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StopFrameRecordingResponse',
    );
  }

  Future<StopHLSBroadcastingResponse?> stopHLSBroadcasting(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/stop_broadcasting"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StopHLSBroadcastingResponse',
    );
  }

  Future<StopLiveResponse?> stopLive(
    String type,
    String id,
    StopLiveRequest? stopLiveRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/stop_live"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      stopLiveRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StopLiveResponse',
    );
  }

  Future<StopRTMPBroadcastsResponse?> stopRTMPBroadcast(
    String type,
    String id,
    String name,
  ) async {
    var path = r"/video/call/{type}/{id}/rtmp_broadcasts/{name}/stop"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id)
        .replaceAll('{name}', name);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StopRTMPBroadcastsResponse',
    );
  }

  Future<StopRecordingResponse?> stopRecording(
    String type,
    String id,
  ) async {
    var path = r"/video/call/{type}/{id}/stop_recording"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StopRecordingResponse',
    );
  }

  Future<StopTranscriptionResponse?> stopTranscription(
    String type,
    String id,
    StopTranscriptionRequest? stopTranscriptionRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/stop_transcription"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      stopTranscriptionRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'StopTranscriptionResponse',
    );
  }

  Future<UnblockUserResponse?> unblockUser(
    String type,
    String id,
    UnblockUserRequest unblockUserRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/unblock"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      unblockUserRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'UnblockUserResponse',
    );
  }

  Future<UpdateCallResponse?> updateCall(
    String type,
    String id,
    UpdateCallRequest? updateCallRequest,
  ) async {
    var path = r"/video/call/{type}/{id}"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'PATCH',
      queryParams,
      updateCallRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'UpdateCallResponse',
    );
  }

  Future<UpdateCallMembersResponse?> updateCallMembers(
    String type,
    String id,
    UpdateCallMembersRequest? updateCallMembersRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/members"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      updateCallMembersRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'UpdateCallMembersResponse',
    );
  }

  Future<UpdateUserPermissionsResponse?> updateUserPermissions(
    String type,
    String id,
    UpdateUserPermissionsRequest updateUserPermissionsRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/user_permissions"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      updateUserPermissionsRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'UpdateUserPermissionsResponse',
    );
  }

  Future<void> videoConnect() async {
    const path = r"/video/longpoll";

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'GET',
      queryParams,
      null,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'void',
    );
  }

  Future<PinResponse?> videoPin(
    String type,
    String id,
    PinRequest pinRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/pin"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      pinRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'PinResponse',
    );
  }

  Future<UnpinResponse?> videoUnpin(
    String type,
    String id,
    UnpinRequest unpinRequest,
  ) async {
    var path = r"/video/call/{type}/{id}/unpin"
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};
    const contentTypes = <String>[];

    return invokeAPI(
      path,
      'POST',
      queryParams,
      unpinRequest,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      'UnpinResponse',
    );
  }
}
