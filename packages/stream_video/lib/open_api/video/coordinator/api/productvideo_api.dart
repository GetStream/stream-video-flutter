//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProductvideoApi {
  ProductvideoApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Accept Call
  ///
  ///   Sends events: - call.accepted
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> acceptCallWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/accept'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Accept Call
  ///
  ///   Sends events: - call.accepted
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<AcceptCallResponse?> acceptCall(
    String type,
    String id,
  ) async {
    final response = await acceptCallWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'AcceptCallResponse',
      ) as AcceptCallResponse;
    }
    return null;
  }

  /// Block user on a call
  ///
  /// Block a user, preventing them from joining the call until they are unblocked.  Sends events: - call.blocked_user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [BlockUserRequest] blockUserRequest (required):
  ///   BlockUserRequest
  Future<Response> blockUserWithHttpInfo(
    String type,
    String id,
    BlockUserRequest blockUserRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/block'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = blockUserRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Block user on a call
  ///
  /// Block a user, preventing them from joining the call until they are unblocked.  Sends events: - call.blocked_user
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [BlockUserRequest] blockUserRequest (required):
  ///   BlockUserRequest
  Future<BlockUserResponse?> blockUser(
    String type,
    String id,
    BlockUserRequest blockUserRequest,
  ) async {
    final response = await blockUserWithHttpInfo(
      type,
      id,
      blockUserRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'BlockUserResponse',
      ) as BlockUserResponse;
    }
    return null;
  }

  /// Collect user feedback
  ///
  ///   Sends events: - call.user_feedback_submitted
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [CollectUserFeedbackRequest] collectUserFeedbackRequest (required):
  Future<Response> collectUserFeedbackWithHttpInfo(
    String type,
    String id,
    CollectUserFeedbackRequest collectUserFeedbackRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/feedback'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = collectUserFeedbackRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Collect user feedback
  ///
  ///   Sends events: - call.user_feedback_submitted
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [CollectUserFeedbackRequest] collectUserFeedbackRequest (required):
  Future<CollectUserFeedbackResponse?> collectUserFeedback(
    String type,
    String id,
    CollectUserFeedbackRequest collectUserFeedbackRequest,
  ) async {
    final response = await collectUserFeedbackWithHttpInfo(
      type,
      id,
      collectUserFeedbackRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'CollectUserFeedbackResponse',
      ) as CollectUserFeedbackResponse;
    }
    return null;
  }

  /// Create device
  ///
  /// Adds a new device to a user, if the same device already exists the call will have no effect
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateDeviceRequest] createDeviceRequest (required):
  ///   CreateDeviceRequest
  Future<Response> createDeviceWithHttpInfo(
    CreateDeviceRequest createDeviceRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/devices';

    // ignore: prefer_final_locals
    Object? postBody = createDeviceRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create device
  ///
  /// Adds a new device to a user, if the same device already exists the call will have no effect
  ///
  /// Parameters:
  ///
  /// * [CreateDeviceRequest] createDeviceRequest (required):
  ///   CreateDeviceRequest
  // MANUAL_EDIT Response -> DurationResponse
  Future<DurationResponse?> createDevice(
    CreateDeviceRequest createDeviceRequest,
  ) async {
    final response = await createDeviceWithHttpInfo(
      createDeviceRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'DurationResponse',
      ) as DurationResponse;
    }
    return null;
  }

  /// Create Guest
  ///
  ///
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateGuestRequest] createGuestRequest (required):
  Future<Response> createGuestWithHttpInfo(
    CreateGuestRequest createGuestRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/guest';

    // ignore: prefer_final_locals
    Object? postBody = createGuestRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create Guest
  ///
  ///
  ///
  /// Parameters:
  ///
  /// * [CreateGuestRequest] createGuestRequest (required):
  Future<CreateGuestResponse?> createGuest(
    CreateGuestRequest createGuestRequest,
  ) async {
    final response = await createGuestWithHttpInfo(
      createGuestRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'CreateGuestResponse',
      ) as CreateGuestResponse;
    }
    return null;
  }

  /// Delete Call
  ///
  ///   Sends events: - call.deleted
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [DeleteCallRequest] deleteCallRequest (required):
  ///   DeleteCallRequest
  Future<Response> deleteCallWithHttpInfo(
    String type,
    String id,
    DeleteCallRequest deleteCallRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/delete'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = deleteCallRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete Call
  ///
  ///   Sends events: - call.deleted
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [DeleteCallRequest] deleteCallRequest (required):
  ///   DeleteCallRequest
  Future<DeleteCallResponse?> deleteCall(
    String type,
    String id,
    DeleteCallRequest deleteCallRequest,
  ) async {
    final response = await deleteCallWithHttpInfo(
      type,
      id,
      deleteCallRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'DeleteCallResponse',
      ) as DeleteCallResponse;
    }
    return null;
  }

  /// Delete device
  ///
  /// Deletes one device
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> deleteDeviceWithHttpInfo(
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/devices';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    queryParams.addAll(_queryParams('', 'id', id));

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete device
  ///
  /// Deletes one device
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  // MANUAL_EDIT Response -> DurationResponse
  Future<DurationResponse?> deleteDevice(
    String id,
  ) async {
    final response = await deleteDeviceWithHttpInfo(
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'DurationResponse',
      ) as DurationResponse;
    }
    return null;
  }

  /// Delete recording
  ///
  /// Deletes recording
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] session (required):
  ///
  /// * [String] filename (required):
  Future<Response> deleteRecordingWithHttpInfo(
    String type,
    String id,
    String session,
    String filename,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/{session}/recordings/{filename}'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id)
        .replaceAll('{session}', session)
        .replaceAll('{filename}', filename);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete recording
  ///
  /// Deletes recording
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] session (required):
  ///
  /// * [String] filename (required):
  Future<DeleteRecordingResponse?> deleteRecording(
    String type,
    String id,
    String session,
    String filename,
  ) async {
    final response = await deleteRecordingWithHttpInfo(
      type,
      id,
      session,
      filename,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'DeleteRecordingResponse',
      ) as DeleteRecordingResponse;
    }
    return null;
  }

  /// Delete transcription
  ///
  /// Deletes transcription
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] session (required):
  ///
  /// * [String] filename (required):
  Future<Response> deleteTranscriptionWithHttpInfo(
    String type,
    String id,
    String session,
    String filename,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/{session}/transcriptions/{filename}'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id)
        .replaceAll('{session}', session)
        .replaceAll('{filename}', filename);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete transcription
  ///
  /// Deletes transcription
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] session (required):
  ///
  /// * [String] filename (required):
  Future<DeleteTranscriptionResponse?> deleteTranscription(
    String type,
    String id,
    String session,
    String filename,
  ) async {
    final response = await deleteTranscriptionWithHttpInfo(
      type,
      id,
      session,
      filename,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'DeleteTranscriptionResponse',
      ) as DeleteTranscriptionResponse;
    }
    return null;
  }

  /// End call
  ///
  ///   Sends events: - call.ended
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> endCallWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/mark_ended'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// End call
  ///
  ///   Sends events: - call.ended
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<EndCallResponse?> endCall(
    String type,
    String id,
  ) async {
    final response = await endCallWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'EndCallResponse',
      ) as EndCallResponse;
    }
    return null;
  }

  /// Get Call
  ///
  ///
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] connectionId:
  ///
  /// * [int] membersLimit:
  ///
  /// * [bool] ring:
  ///
  /// * [bool] notify:
  ///
  /// * [bool] video:
  Future<Response> getCallWithHttpInfo(
    String type,
    String id, {
    String? connectionId,
    int? membersLimit,
    bool? ring,
    bool? notify,
    bool? video,
  }) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (connectionId != null) {
      queryParams.addAll(_queryParams('', 'connection_id', connectionId));
    }
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

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get Call
  ///
  ///
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] connectionId:
  ///
  /// * [int] membersLimit:
  ///
  /// * [bool] ring:
  ///
  /// * [bool] notify:
  ///
  /// * [bool] video:
  Future<GetCallResponse?> getCall(
    String type,
    String id, {
    String? connectionId,
    int? membersLimit,
    bool? ring,
    bool? notify,
    bool? video,
  }) async {
    final response = await getCallWithHttpInfo(
      type,
      id,
      connectionId: connectionId,
      membersLimit: membersLimit,
      ring: ring,
      notify: notify,
      video: video,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'GetCallResponse',
      ) as GetCallResponse;
    }
    return null;
  }

  /// Get call report
  ///
  ///
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] sessionId:
  Future<Response> getCallReportWithHttpInfo(
    String type,
    String id, {
    String? sessionId,
  }) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/report'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (sessionId != null) {
      queryParams.addAll(_queryParams('', 'session_id', sessionId));
    }

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get call report
  ///
  ///
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] sessionId:
  Future<GetCallReportResponse?> getCallReport(
    String type,
    String id, {
    String? sessionId,
  }) async {
    final response = await getCallReportWithHttpInfo(
      type,
      id,
      sessionId: sessionId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'GetCallReportResponse',
      ) as GetCallReportResponse;
    }
    return null;
  }

  /// Get Edges
  ///
  /// Returns the list of all edges available for video calls.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getEdgesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/video/edges';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get Edges
  ///
  /// Returns the list of all edges available for video calls.
  Future<GetEdgesResponse?> getEdges() async {
    final response = await getEdgesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'GetEdgesResponse',
      ) as GetEdgesResponse;
    }
    return null;
  }

  /// Get or create a call
  ///
  /// Gets or creates a new call  Sends events: - call.created - call.notification - call.ring
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GetOrCreateCallRequest] getOrCreateCallRequest (required):
  ///   GetOrCreateCallRequest
  ///
  /// * [String] connectionId:
  Future<Response> getOrCreateCallWithHttpInfo(
    String type,
    String id,
    GetOrCreateCallRequest getOrCreateCallRequest, {
    String? connectionId,
  }) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = getOrCreateCallRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (connectionId != null) {
      queryParams.addAll(_queryParams('', 'connection_id', connectionId));
    }

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get or create a call
  ///
  /// Gets or creates a new call  Sends events: - call.created - call.notification - call.ring
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GetOrCreateCallRequest] getOrCreateCallRequest (required):
  ///   GetOrCreateCallRequest
  ///
  /// * [String] connectionId:
  Future<GetOrCreateCallResponse?> getOrCreateCall(
    String type,
    String id,
    GetOrCreateCallRequest getOrCreateCallRequest, {
    String? connectionId,
  }) async {
    final response = await getOrCreateCallWithHttpInfo(
      type,
      id,
      getOrCreateCallRequest,
      connectionId: connectionId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'GetOrCreateCallResponse',
      ) as GetOrCreateCallResponse;
    }
    return null;
  }

  /// Set call as live
  ///
  ///   Sends events: - call.live_started
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GoLiveRequest] goLiveRequest (required):
  ///   GoLiveRequest
  Future<Response> goLiveWithHttpInfo(
    String type,
    String id,
    GoLiveRequest goLiveRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/go_live'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = goLiveRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Set call as live
  ///
  ///   Sends events: - call.live_started
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GoLiveRequest] goLiveRequest (required):
  ///   GoLiveRequest
  Future<GoLiveResponse?> goLive(
    String type,
    String id,
    GoLiveRequest goLiveRequest,
  ) async {
    final response = await goLiveWithHttpInfo(
      type,
      id,
      goLiveRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'GoLiveResponse',
      ) as GoLiveResponse;
    }
    return null;
  }

  /// Join call
  ///
  /// Request to join a call
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [JoinCallRequest] joinCallRequest (required):
  ///   JoinCallRequest
  ///
  /// * [String] connectionId:
  Future<Response> joinCallWithHttpInfo(
    String type,
    String id,
    JoinCallRequest joinCallRequest, {
    String? connectionId,
  }) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/join'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = joinCallRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (connectionId != null) {
      queryParams.addAll(_queryParams('', 'connection_id', connectionId));
    }

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Join call
  ///
  /// Request to join a call
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [JoinCallRequest] joinCallRequest (required):
  ///   JoinCallRequest
  ///
  /// * [String] connectionId:
  Future<JoinCallResponse?> joinCall(
    String type,
    String id,
    JoinCallRequest joinCallRequest, {
    String? connectionId,
  }) async {
    final response = await joinCallWithHttpInfo(
      type,
      id,
      joinCallRequest,
      connectionId: connectionId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'JoinCallResponse',
      ) as JoinCallResponse;
    }
    return null;
  }

  /// List devices
  ///
  /// Returns all available devices
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listDevicesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/video/devices';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// List devices
  ///
  /// Returns all available devices
  Future<ListDevicesResponse?> listDevices() async {
    final response = await listDevicesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'ListDevicesResponse',
      ) as ListDevicesResponse;
    }
    return null;
  }

  /// List recordings
  ///
  /// Lists recordings
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> listRecordingsWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/recordings'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// List recordings
  ///
  /// Lists recordings
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<ListRecordingsResponse?> listRecordings(
    String type,
    String id,
  ) async {
    final response = await listRecordingsWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'ListRecordingsResponse',
      ) as ListRecordingsResponse;
    }
    return null;
  }

  /// List transcriptions
  ///
  /// Lists transcriptions
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> listTranscriptionsWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/transcriptions'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// List transcriptions
  ///
  /// Lists transcriptions
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<ListTranscriptionsResponse?> listTranscriptions(
    String type,
    String id,
  ) async {
    final response = await listTranscriptionsWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'ListTranscriptionsResponse',
      ) as ListTranscriptionsResponse;
    }
    return null;
  }

  /// Mute users
  ///
  /// Mutes users in a call
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [MuteUsersRequest] muteUsersRequest (required):
  ///   MuteUsersRequest
  Future<Response> muteUsersWithHttpInfo(
    String type,
    String id,
    MuteUsersRequest muteUsersRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/mute_users'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = muteUsersRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Mute users
  ///
  /// Mutes users in a call
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [MuteUsersRequest] muteUsersRequest (required):
  ///   MuteUsersRequest
  Future<MuteUsersResponse?> muteUsers(
    String type,
    String id,
    MuteUsersRequest muteUsersRequest,
  ) async {
    final response = await muteUsersWithHttpInfo(
      type,
      id,
      muteUsersRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'MuteUsersResponse',
      ) as MuteUsersResponse;
    }
    return null;
  }

  /// Query Aggregate call Stats
  ///
  ///
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [QueryAggregateCallStatsRequest] queryAggregateCallStatsRequest (required):
  Future<Response> queryAggregateCallStatsWithHttpInfo(
    QueryAggregateCallStatsRequest queryAggregateCallStatsRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/stats';

    // ignore: prefer_final_locals
    Object? postBody = queryAggregateCallStatsRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Query Aggregate call Stats
  ///
  ///
  ///
  /// Parameters:
  ///
  /// * [QueryAggregateCallStatsRequest] queryAggregateCallStatsRequest (required):
  Future<QueryAggregateCallStatsResponse?> queryAggregateCallStats(
    QueryAggregateCallStatsRequest queryAggregateCallStatsRequest,
  ) async {
    final response = await queryAggregateCallStatsWithHttpInfo(
      queryAggregateCallStatsRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'QueryAggregateCallStatsResponse',
      ) as QueryAggregateCallStatsResponse;
    }
    return null;
  }

  /// Query call members
  ///
  /// Query call members with filter query
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [QueryCallMembersRequest] queryCallMembersRequest (required):
  Future<Response> queryCallMembersWithHttpInfo(
    QueryCallMembersRequest queryCallMembersRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/members';

    // ignore: prefer_final_locals
    Object? postBody = queryCallMembersRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Query call members
  ///
  /// Query call members with filter query
  ///
  /// Parameters:
  ///
  /// * [QueryCallMembersRequest] queryCallMembersRequest (required):
  Future<QueryCallMembersResponse?> queryCallMembers(
    QueryCallMembersRequest queryCallMembersRequest,
  ) async {
    final response = await queryCallMembersWithHttpInfo(
      queryCallMembersRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'QueryCallMembersResponse',
      ) as QueryCallMembersResponse;
    }
    return null;
  }

  /// Query call participants
  ///
  /// Returns a list of participants connected to the call
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] type (required):
  ///
  /// * [QueryCallParticipantsRequest] queryCallParticipantsRequest (required):
  ///
  /// * [int] limit:
  Future<Response> queryCallParticipantsWithHttpInfo(
    String id,
    String type,
    QueryCallParticipantsRequest queryCallParticipantsRequest, {
    int? limit,
  }) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/participants'
        .replaceAll('{id}', id)
        .replaceAll('{type}', type);

    // ignore: prefer_final_locals
    Object? postBody = queryCallParticipantsRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Query call participants
  ///
  /// Returns a list of participants connected to the call
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] type (required):
  ///
  /// * [QueryCallParticipantsRequest] queryCallParticipantsRequest (required):
  ///
  /// * [int] limit:
  Future<QueryCallParticipantsResponse?> queryCallParticipants(
    String id,
    String type,
    QueryCallParticipantsRequest queryCallParticipantsRequest, {
    int? limit,
  }) async {
    final response = await queryCallParticipantsWithHttpInfo(
      id,
      type,
      queryCallParticipantsRequest,
      limit: limit,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'QueryCallParticipantsResponse',
      ) as QueryCallParticipantsResponse;
    }
    return null;
  }

  /// Query Call Stats
  ///
  ///
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [QueryCallStatsRequest] queryCallStatsRequest (required):
  Future<Response> queryCallStatsWithHttpInfo(
    QueryCallStatsRequest queryCallStatsRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/stats';

    // ignore: prefer_final_locals
    Object? postBody = queryCallStatsRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Query Call Stats
  ///
  ///
  ///
  /// Parameters:
  ///
  /// * [QueryCallStatsRequest] queryCallStatsRequest (required):
  Future<QueryCallStatsResponse?> queryCallStats(
    QueryCallStatsRequest queryCallStatsRequest,
  ) async {
    final response = await queryCallStatsWithHttpInfo(
      queryCallStatsRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'QueryCallStatsResponse',
      ) as QueryCallStatsResponse;
    }
    return null;
  }

  /// Query call
  ///
  /// Query calls with filter query
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [QueryCallsRequest] queryCallsRequest (required):
  ///   QueryCallsRequest
  ///
  /// * [String] connectionId:
  Future<Response> queryCallsWithHttpInfo(
    QueryCallsRequest queryCallsRequest, {
    String? connectionId,
  }) async {
    // ignore: prefer_const_declarations
    final path = r'/video/calls';

    // ignore: prefer_final_locals
    Object? postBody = queryCallsRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (connectionId != null) {
      queryParams.addAll(_queryParams('', 'connection_id', connectionId));
    }

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Query call
  ///
  /// Query calls with filter query
  ///
  /// Parameters:
  ///
  /// * [QueryCallsRequest] queryCallsRequest (required):
  ///   QueryCallsRequest
  ///
  /// * [String] connectionId:
  Future<QueryCallsResponse?> queryCalls(
    QueryCallsRequest queryCallsRequest, {
    String? connectionId,
  }) async {
    final response = await queryCallsWithHttpInfo(
      queryCallsRequest,
      connectionId: connectionId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'QueryCallsResponse',
      ) as QueryCallsResponse;
    }
    return null;
  }

  /// Reject Call
  ///
  ///   Sends events: - call.rejected
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [RejectCallRequest] rejectCallRequest (required):
  ///   RejectCallRequest
  Future<Response> rejectCallWithHttpInfo(
    String type,
    String id,
    RejectCallRequest rejectCallRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/reject'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = rejectCallRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Reject Call
  ///
  ///   Sends events: - call.rejected
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [RejectCallRequest] rejectCallRequest (required):
  ///   RejectCallRequest
  Future<RejectCallResponse?> rejectCall(
    String type,
    String id,
    RejectCallRequest rejectCallRequest,
  ) async {
    final response = await rejectCallWithHttpInfo(
      type,
      id,
      rejectCallRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'RejectCallResponse',
      ) as RejectCallResponse;
    }
    return null;
  }

  /// Request permission
  ///
  /// Request permission to perform an action  Sends events: - call.permission_request
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [RequestPermissionRequest] requestPermissionRequest (required):
  ///   RequestPermissionRequest
  Future<Response> requestPermissionWithHttpInfo(
    String type,
    String id,
    RequestPermissionRequest requestPermissionRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/request_permission'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = requestPermissionRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Request permission
  ///
  /// Request permission to perform an action  Sends events: - call.permission_request
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [RequestPermissionRequest] requestPermissionRequest (required):
  ///   RequestPermissionRequest
  Future<RequestPermissionResponse?> requestPermission(
    String type,
    String id,
    RequestPermissionRequest requestPermissionRequest,
  ) async {
    final response = await requestPermissionWithHttpInfo(
      type,
      id,
      requestPermissionRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'RequestPermissionResponse',
      ) as RequestPermissionResponse;
    }
    return null;
  }

  /// Send custom event
  ///
  /// Sends custom event to the call  Sends events: - custom
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [SendCallEventRequest] sendCallEventRequest (required):
  ///   SendCallEventRequest
  Future<Response> sendCallEventWithHttpInfo(
    String type,
    String id,
    SendCallEventRequest sendCallEventRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/event'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = sendCallEventRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Send custom event
  ///
  /// Sends custom event to the call  Sends events: - custom
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [SendCallEventRequest] sendCallEventRequest (required):
  ///   SendCallEventRequest
  Future<SendCallEventResponse?> sendCallEvent(
    String type,
    String id,
    SendCallEventRequest sendCallEventRequest,
  ) async {
    final response = await sendCallEventWithHttpInfo(
      type,
      id,
      sendCallEventRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'SendCallEventResponse',
      ) as SendCallEventResponse;
    }
    return null;
  }

  /// Send reaction to the call
  ///
  /// Sends reaction to the call  Sends events: - call.reaction_new
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [SendReactionRequest] sendReactionRequest (required):
  Future<Response> sendVideoReactionWithHttpInfo(
    String type,
    String id,
    SendReactionRequest sendReactionRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/reaction'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = sendReactionRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Send reaction to the call
  ///
  /// Sends reaction to the call  Sends events: - call.reaction_new
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [SendReactionRequest] sendReactionRequest (required):
  Future<SendReactionResponse?> sendVideoReaction(
    String type,
    String id,
    SendReactionRequest sendReactionRequest,
  ) async {
    final response = await sendVideoReactionWithHttpInfo(
      type,
      id,
      sendReactionRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'SendReactionResponse',
      ) as SendReactionResponse;
    }
    return null;
  }

  /// Start closed captions
  ///
  /// Starts closed captions
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartClosedCaptionsRequest] startClosedCaptionsRequest (required):
  Future<Response> startClosedCaptionsWithHttpInfo(
    String type,
    String id,
    StartClosedCaptionsRequest startClosedCaptionsRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/start_closed_captions'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = startClosedCaptionsRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Start closed captions
  ///
  /// Starts closed captions
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartClosedCaptionsRequest] startClosedCaptionsRequest (required):
  Future<StartClosedCaptionsResponse?> startClosedCaptions(
    String type,
    String id,
    StartClosedCaptionsRequest startClosedCaptionsRequest,
  ) async {
    final response = await startClosedCaptionsWithHttpInfo(
      type,
      id,
      startClosedCaptionsRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StartClosedCaptionsResponse',
      ) as StartClosedCaptionsResponse;
    }
    return null;
  }

  /// Start frame recording
  ///
  /// Starts frame by frame recording  Sends events: - call.frame_recording_started
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartFrameRecordingRequest] startFrameRecordingRequest (required):
  ///   StartFrameRecordingRequest
  Future<Response> startFrameRecordingWithHttpInfo(
    String type,
    String id,
    StartFrameRecordingRequest startFrameRecordingRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/start_frame_recording'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = startFrameRecordingRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Start frame recording
  ///
  /// Starts frame by frame recording  Sends events: - call.frame_recording_started
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartFrameRecordingRequest] startFrameRecordingRequest (required):
  ///   StartFrameRecordingRequest
  Future<StartFrameRecordingResponse?> startFrameRecording(
    String type,
    String id,
    StartFrameRecordingRequest startFrameRecordingRequest,
  ) async {
    final response = await startFrameRecordingWithHttpInfo(
      type,
      id,
      startFrameRecordingRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StartFrameRecordingResponse',
      ) as StartFrameRecordingResponse;
    }
    return null;
  }

  /// Start HLS broadcasting
  ///
  /// Starts HLS broadcasting
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> startHLSBroadcastingWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/start_broadcasting'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Start HLS broadcasting
  ///
  /// Starts HLS broadcasting
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StartHLSBroadcastingResponse?> startHLSBroadcasting(
    String type,
    String id,
  ) async {
    final response = await startHLSBroadcastingWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StartHLSBroadcastingResponse',
      ) as StartHLSBroadcastingResponse;
    }
    return null;
  }

  /// Start RTMP broadcasts
  ///
  /// Starts RTMP broadcasts for the provided RTMP destinations
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartRTMPBroadcastsRequest] startRTMPBroadcastsRequest (required):
  ///   StartRTMPBroadcastsRequest
  Future<Response> startRTMPBroadcastsWithHttpInfo(
    String type,
    String id,
    StartRTMPBroadcastsRequest startRTMPBroadcastsRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/rtmp_broadcasts'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = startRTMPBroadcastsRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Start RTMP broadcasts
  ///
  /// Starts RTMP broadcasts for the provided RTMP destinations
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartRTMPBroadcastsRequest] startRTMPBroadcastsRequest (required):
  ///   StartRTMPBroadcastsRequest
  Future<StartRTMPBroadcastsResponse?> startRTMPBroadcasts(
    String type,
    String id,
    StartRTMPBroadcastsRequest startRTMPBroadcastsRequest,
  ) async {
    final response = await startRTMPBroadcastsWithHttpInfo(
      type,
      id,
      startRTMPBroadcastsRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StartRTMPBroadcastsResponse',
      ) as StartRTMPBroadcastsResponse;
    }
    return null;
  }

  /// Start recording
  ///
  /// Starts recording  Sends events: - call.recording_started
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartRecordingRequest] startRecordingRequest (required):
  ///   StartRecordingRequest
  Future<Response> startRecordingWithHttpInfo(
    String type,
    String id,
    StartRecordingRequest startRecordingRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/start_recording'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = startRecordingRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Start recording
  ///
  /// Starts recording  Sends events: - call.recording_started
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartRecordingRequest] startRecordingRequest (required):
  ///   StartRecordingRequest
  Future<StartRecordingResponse?> startRecording(
    String type,
    String id,
    StartRecordingRequest startRecordingRequest,
  ) async {
    final response = await startRecordingWithHttpInfo(
      type,
      id,
      startRecordingRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StartRecordingResponse',
      ) as StartRecordingResponse;
    }
    return null;
  }

  /// Start transcription
  ///
  /// Starts transcription
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartTranscriptionRequest] startTranscriptionRequest (required):
  Future<Response> startTranscriptionWithHttpInfo(
    String type,
    String id,
    StartTranscriptionRequest startTranscriptionRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/start_transcription'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = startTranscriptionRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Start transcription
  ///
  /// Starts transcription
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StartTranscriptionRequest] startTranscriptionRequest (required):
  Future<StartTranscriptionResponse?> startTranscription(
    String type,
    String id,
    StartTranscriptionRequest startTranscriptionRequest,
  ) async {
    final response = await startTranscriptionWithHttpInfo(
      type,
      id,
      startTranscriptionRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StartTranscriptionResponse',
      ) as StartTranscriptionResponse;
    }
    return null;
  }

  /// Stop all RTMP broadcasts for a call
  ///
  /// Stop all RTMP broadcasts for the provided call
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> stopAllRTMPBroadcastsWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/rtmp_broadcasts/stop'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Stop all RTMP broadcasts for a call
  ///
  /// Stop all RTMP broadcasts for the provided call
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StopAllRTMPBroadcastsResponse?> stopAllRTMPBroadcasts(
    String type,
    String id,
  ) async {
    final response = await stopAllRTMPBroadcastsWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StopAllRTMPBroadcastsResponse',
      ) as StopAllRTMPBroadcastsResponse;
    }
    return null;
  }

  /// Stop closed captions
  ///
  /// Stops closed captions  Sends events: - call.transcription_stopped
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StopClosedCaptionsRequest] stopClosedCaptionsRequest (required):
  Future<Response> stopClosedCaptionsWithHttpInfo(
    String type,
    String id,
    StopClosedCaptionsRequest stopClosedCaptionsRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/stop_closed_captions'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = stopClosedCaptionsRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Stop closed captions
  ///
  /// Stops closed captions  Sends events: - call.transcription_stopped
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StopClosedCaptionsRequest] stopClosedCaptionsRequest (required):
  Future<StopClosedCaptionsResponse?> stopClosedCaptions(
    String type,
    String id,
    StopClosedCaptionsRequest stopClosedCaptionsRequest,
  ) async {
    final response = await stopClosedCaptionsWithHttpInfo(
      type,
      id,
      stopClosedCaptionsRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StopClosedCaptionsResponse',
      ) as StopClosedCaptionsResponse;
    }
    return null;
  }

  /// Stop frame recording
  ///
  /// Stops frame recording  Sends events: - call.frame_recording_stopped
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> stopFrameRecordingWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/stop_frame_recording'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Stop frame recording
  ///
  /// Stops frame recording  Sends events: - call.frame_recording_stopped
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StopFrameRecordingResponse?> stopFrameRecording(
    String type,
    String id,
  ) async {
    final response = await stopFrameRecordingWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StopFrameRecordingResponse',
      ) as StopFrameRecordingResponse;
    }
    return null;
  }

  /// Stop HLS broadcasting
  ///
  /// Stops HLS broadcasting
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> stopHLSBroadcastingWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/stop_broadcasting'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Stop HLS broadcasting
  ///
  /// Stops HLS broadcasting
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StopHLSBroadcastingResponse?> stopHLSBroadcasting(
    String type,
    String id,
  ) async {
    final response = await stopHLSBroadcastingWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StopHLSBroadcastingResponse',
      ) as StopHLSBroadcastingResponse;
    }
    return null;
  }

  /// Set call as not live
  ///
  ///   Sends events: - call.updated
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StopLiveRequest] stopLiveRequest (required):
  ///   StopLiveRequest
  Future<Response> stopLiveWithHttpInfo(
    String type,
    String id,
    StopLiveRequest stopLiveRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/stop_live'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = stopLiveRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Set call as not live
  ///
  ///   Sends events: - call.updated
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StopLiveRequest] stopLiveRequest (required):
  ///   StopLiveRequest
  Future<StopLiveResponse?> stopLive(
    String type,
    String id,
    StopLiveRequest stopLiveRequest,
  ) async {
    final response = await stopLiveWithHttpInfo(
      type,
      id,
      stopLiveRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StopLiveResponse',
      ) as StopLiveResponse;
    }
    return null;
  }

  /// Stop RTMP broadcasts
  ///
  /// Stop RTMP broadcasts for the provided RTMP destinations
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] name (required):
  ///
  /// * [Object] body (required):
  ///   StopRTMPBroadcastsRequest
  Future<Response> stopRTMPBroadcastWithHttpInfo(
    String type,
    String id,
    String name,
    Object body,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/rtmp_broadcasts/{name}/stop'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id)
        .replaceAll('{name}', name);

    // ignore: prefer_final_locals
    Object? postBody = body;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Stop RTMP broadcasts
  ///
  /// Stop RTMP broadcasts for the provided RTMP destinations
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] name (required):
  ///
  /// * [Object] body (required):
  ///   StopRTMPBroadcastsRequest
  Future<StopRTMPBroadcastsResponse?> stopRTMPBroadcast(
    String type,
    String id,
    String name,
    Object body,
  ) async {
    final response = await stopRTMPBroadcastWithHttpInfo(
      type,
      id,
      name,
      body,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StopRTMPBroadcastsResponse',
      ) as StopRTMPBroadcastsResponse;
    }
    return null;
  }

  /// Stop recording
  ///
  /// Stops recording  Sends events: - call.recording_stopped
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> stopRecordingWithHttpInfo(
    String type,
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/stop_recording'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Stop recording
  ///
  /// Stops recording  Sends events: - call.recording_stopped
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StopRecordingResponse?> stopRecording(
    String type,
    String id,
  ) async {
    final response = await stopRecordingWithHttpInfo(
      type,
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StopRecordingResponse',
      ) as StopRecordingResponse;
    }
    return null;
  }

  /// Stop transcription
  ///
  /// Stops transcription  Sends events: - call.transcription_stopped
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StopTranscriptionRequest] stopTranscriptionRequest (required):
  Future<Response> stopTranscriptionWithHttpInfo(
    String type,
    String id,
    StopTranscriptionRequest stopTranscriptionRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/stop_transcription'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = stopTranscriptionRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Stop transcription
  ///
  /// Stops transcription  Sends events: - call.transcription_stopped
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [StopTranscriptionRequest] stopTranscriptionRequest (required):
  Future<StopTranscriptionResponse?> stopTranscription(
    String type,
    String id,
    StopTranscriptionRequest stopTranscriptionRequest,
  ) async {
    final response = await stopTranscriptionWithHttpInfo(
      type,
      id,
      stopTranscriptionRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'StopTranscriptionResponse',
      ) as StopTranscriptionResponse;
    }
    return null;
  }

  /// Unblocks user on a call
  ///
  /// Removes the block for a user on a call. The user will be able to join the call again.  Sends events: - call.unblocked_user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UnblockUserRequest] unblockUserRequest (required):
  ///   UnblockUserRequest
  Future<Response> unblockUserWithHttpInfo(
    String type,
    String id,
    UnblockUserRequest unblockUserRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/unblock'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = unblockUserRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Unblocks user on a call
  ///
  /// Removes the block for a user on a call. The user will be able to join the call again.  Sends events: - call.unblocked_user
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UnblockUserRequest] unblockUserRequest (required):
  ///   UnblockUserRequest
  Future<UnblockUserResponse?> unblockUser(
    String type,
    String id,
    UnblockUserRequest unblockUserRequest,
  ) async {
    final response = await unblockUserWithHttpInfo(
      type,
      id,
      unblockUserRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'UnblockUserResponse',
      ) as UnblockUserResponse;
    }
    return null;
  }

  /// Update Call
  ///
  ///   Sends events: - call.updated
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateCallRequest] updateCallRequest (required):
  ///   UpdateCallRequest
  Future<Response> updateCallWithHttpInfo(
    String type,
    String id,
    UpdateCallRequest updateCallRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updateCallRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update Call
  ///
  ///   Sends events: - call.updated
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateCallRequest] updateCallRequest (required):
  ///   UpdateCallRequest
  Future<UpdateCallResponse?> updateCall(
    String type,
    String id,
    UpdateCallRequest updateCallRequest,
  ) async {
    final response = await updateCallWithHttpInfo(
      type,
      id,
      updateCallRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'UpdateCallResponse',
      ) as UpdateCallResponse;
    }
    return null;
  }

  /// Update Call Member
  ///
  ///   Sends events: - call.member_added - call.member_removed - call.member_updated
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateCallMembersRequest] updateCallMembersRequest (required):
  ///   UpdateCallMembersRequest
  Future<Response> updateCallMembersWithHttpInfo(
    String type,
    String id,
    UpdateCallMembersRequest updateCallMembersRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/members'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updateCallMembersRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update Call Member
  ///
  ///   Sends events: - call.member_added - call.member_removed - call.member_updated
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateCallMembersRequest] updateCallMembersRequest (required):
  ///   UpdateCallMembersRequest
  Future<UpdateCallMembersResponse?> updateCallMembers(
    String type,
    String id,
    UpdateCallMembersRequest updateCallMembersRequest,
  ) async {
    final response = await updateCallMembersWithHttpInfo(
      type,
      id,
      updateCallMembersRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'UpdateCallMembersResponse',
      ) as UpdateCallMembersResponse;
    }
    return null;
  }

  /// Update user permissions
  ///
  /// Updates user permissions  Sends events: - call.permissions_updated
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateUserPermissionsRequest] updateUserPermissionsRequest (required):
  Future<Response> updateUserPermissionsWithHttpInfo(
    String type,
    String id,
    UpdateUserPermissionsRequest updateUserPermissionsRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/user_permissions'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updateUserPermissionsRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update user permissions
  ///
  /// Updates user permissions  Sends events: - call.permissions_updated
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateUserPermissionsRequest] updateUserPermissionsRequest (required):
  Future<UpdateUserPermissionsResponse?> updateUserPermissions(
    String type,
    String id,
    UpdateUserPermissionsRequest updateUserPermissionsRequest,
  ) async {
    final response = await updateUserPermissionsWithHttpInfo(
      type,
      id,
      updateUserPermissionsRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'UpdateUserPermissionsResponse',
      ) as UpdateUserPermissionsResponse;
    }
    return null;
  }

  /// Video Connect (WebSocket)
  ///
  /// Establishes WebSocket connection for user to video  Sends events: - health.check - connection.ok
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> videoConnectWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/video/longpoll';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Video Connect (WebSocket)
  ///
  /// Establishes WebSocket connection for user to video  Sends events: - health.check - connection.ok
  Future<void> videoConnect() async {
    final response = await videoConnectWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Pin
  ///
  /// Pins a track for all users in the call.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [PinRequest] pinRequest (required):
  ///   PinRequest
  Future<Response> videoPinWithHttpInfo(
    String type,
    String id,
    PinRequest pinRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/pin'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = pinRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Pin
  ///
  /// Pins a track for all users in the call.
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [PinRequest] pinRequest (required):
  ///   PinRequest
  Future<PinResponse?> videoPin(
    String type,
    String id,
    PinRequest pinRequest,
  ) async {
    final response = await videoPinWithHttpInfo(
      type,
      id,
      pinRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'PinResponse',
      ) as PinResponse;
    }
    return null;
  }

  /// Unpin
  ///
  /// Unpins a track for all users in the call.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UnpinRequest] unpinRequest (required):
  ///   UnpinRequest
  Future<Response> videoUnpinWithHttpInfo(
    String type,
    String id,
    UnpinRequest unpinRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/video/call/{type}/{id}/unpin'
        .replaceAll('{type}', type)
        .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = unpinRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Unpin
  ///
  /// Unpins a track for all users in the call.
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UnpinRequest] unpinRequest (required):
  ///   UnpinRequest
  Future<UnpinResponse?> videoUnpin(
    String type,
    String id,
    UnpinRequest unpinRequest,
  ) async {
    final response = await videoUnpinWithHttpInfo(
      type,
      id,
      unpinRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'UnpinResponse',
      ) as UnpinResponse;
    }
    return null;
  }
}
