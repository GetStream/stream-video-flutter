//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class VideoCallsApi {
  VideoCallsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// End call
  ///
  ///   Sends events: - call.ended  Required permissions: - EndCall 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> endCallWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/mark_ended'
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
  ///   Sends events: - call.ended  Required permissions: - EndCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<EndCallResponse?> endCall(String type, String id,) async {
    final response = await endCallWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EndCallResponse',) as EndCallResponse;
    
    }
    return null;
  }

  /// Get Call
  ///
  ///   Required permissions: - ReadCall 
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
  Future<Response> getCallWithHttpInfo(String type, String id, { String? connectionId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}'
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
  ///   Required permissions: - ReadCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] connectionId:
  Future<GetCallResponse?> getCall(String type, String id, { String? connectionId, }) async {
    final response = await getCallWithHttpInfo(type, id,  connectionId: connectionId, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetCallResponse',) as GetCallResponse;
    
    }
    return null;
  }

  /// Get Call Edge Server
  ///
  /// Retrieve the edge server information and credentials for a call.  Required permissions: - JoinCall 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GetCallEdgeServerRequest] getCallEdgeServerRequest (required):
  Future<Response> getCallEdgeServerWithHttpInfo(String type, String id, GetCallEdgeServerRequest getCallEdgeServerRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/get_edge_server'
      .replaceAll('{type}', type)
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = getCallEdgeServerRequest;

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

  /// Get Call Edge Server
  ///
  /// Retrieve the edge server information and credentials for a call.  Required permissions: - JoinCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GetCallEdgeServerRequest] getCallEdgeServerRequest (required):
  Future<GetCallEdgeServerResponse?> getCallEdgeServer(String type, String id, GetCallEdgeServerRequest getCallEdgeServerRequest,) async {
    final response = await getCallEdgeServerWithHttpInfo(type, id, getCallEdgeServerRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetCallEdgeServerResponse',) as GetCallEdgeServerResponse;
    
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
    final path = r'/edges';

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
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetEdgesResponse',) as GetEdgesResponse;
    
    }
    return null;
  }

  /// Get or create a call
  ///
  /// Gets or creates a new call  Sends events: - call.created  Required permissions: - CreateCall - ReadCall - UpdateCallSettings 
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
  ///
  /// * [String] connectionId:
  Future<Response> getOrCreateCallWithHttpInfo(String type, String id, GetOrCreateCallRequest getOrCreateCallRequest, { String? connectionId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}'
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
  /// Gets or creates a new call  Sends events: - call.created  Required permissions: - CreateCall - ReadCall - UpdateCallSettings 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GetOrCreateCallRequest] getOrCreateCallRequest (required):
  ///
  /// * [String] connectionId:
  Future<GetOrCreateCallResponse?> getOrCreateCall(String type, String id, GetOrCreateCallRequest getOrCreateCallRequest, { String? connectionId, }) async {
    final response = await getOrCreateCallWithHttpInfo(type, id, getOrCreateCallRequest,  connectionId: connectionId, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetOrCreateCallResponse',) as GetOrCreateCallResponse;
    
    }
    return null;
  }

  /// Set call as live
  ///
  ///   Sends events: - call.live_started  Required permissions: - UpdateCall 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> goLiveWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/go_live'
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

  /// Set call as live
  ///
  ///   Sends events: - call.live_started  Required permissions: - UpdateCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<GoLiveResponse?> goLive(String type, String id,) async {
    final response = await goLiveWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GoLiveResponse',) as GoLiveResponse;
    
    }
    return null;
  }

  /// Join call
  ///
  /// Request to join a call  Required permissions: - CreateCall - JoinCall 
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
  ///
  /// * [String] connectionId:
  Future<Response> joinCallWithHttpInfo(String type, String id, JoinCallRequest joinCallRequest, { String? connectionId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/join'
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
  /// Request to join a call  Required permissions: - CreateCall - JoinCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [JoinCallRequest] joinCallRequest (required):
  ///
  /// * [String] connectionId:
  Future<JoinCallResponse?> joinCall(String type, String id, JoinCallRequest joinCallRequest, { String? connectionId, }) async {
    final response = await joinCallWithHttpInfo(type, id, joinCallRequest,  connectionId: connectionId, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'JoinCallResponse',) as JoinCallResponse;
    
    }
    return null;
  }

  /// Query call
  ///
  /// Query calls with filter query  Required permissions: - ReadCall 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [QueryCallsRequest] queryCallsRequest (required):
  ///
  /// * [String] connectionId:
  Future<Response> queryCallsWithHttpInfo(QueryCallsRequest queryCallsRequest, { String? connectionId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/calls';

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
  /// Query calls with filter query  Required permissions: - ReadCall 
  ///
  /// Parameters:
  ///
  /// * [QueryCallsRequest] queryCallsRequest (required):
  ///
  /// * [String] connectionId:
  Future<QueryCallsResponse?> queryCalls(QueryCallsRequest queryCallsRequest, { String? connectionId, }) async {
    final response = await queryCallsWithHttpInfo(queryCallsRequest,  connectionId: connectionId, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'QueryCallsResponse',) as QueryCallsResponse;
    
    }
    return null;
  }

  /// Query call members
  ///
  /// Query call members with filter query  Required permissions: - ReadCall 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [QueryMembersRequest] queryMembersRequest (required):
  Future<Response> queryMembersWithHttpInfo(QueryMembersRequest queryMembersRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/members';

    // ignore: prefer_final_locals
    Object? postBody = queryMembersRequest;

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
  /// Query call members with filter query  Required permissions: - ReadCall 
  ///
  /// Parameters:
  ///
  /// * [QueryMembersRequest] queryMembersRequest (required):
  Future<QueryMembersResponse?> queryMembers(QueryMembersRequest queryMembersRequest,) async {
    final response = await queryMembersWithHttpInfo(queryMembersRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'QueryMembersResponse',) as QueryMembersResponse;
    
    }
    return null;
  }

  /// Send reaction to the call
  ///
  /// Sends reaction to the call  Sends events: - call.reaction_new  Required permissions: - CreateCallReaction 
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
  Future<Response> sendVideoReactionWithHttpInfo(String type, String id, SendReactionRequest sendReactionRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/reaction'
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
  /// Sends reaction to the call  Sends events: - call.reaction_new  Required permissions: - CreateCallReaction 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [SendReactionRequest] sendReactionRequest (required):
  Future<SendReactionResponse?> sendVideoReaction(String type, String id, SendReactionRequest sendReactionRequest,) async {
    final response = await sendVideoReactionWithHttpInfo(type, id, sendReactionRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SendReactionResponse',) as SendReactionResponse;
    
    }
    return null;
  }

  /// Set call as not live
  ///
  ///   Sends events: - call.updated  Required permissions: - UpdateCall 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> stopLiveWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/stop_live'
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

  /// Set call as not live
  ///
  ///   Sends events: - call.updated  Required permissions: - UpdateCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StopLiveResponse?> stopLive(String type, String id,) async {
    final response = await stopLiveWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StopLiveResponse',) as StopLiveResponse;
    
    }
    return null;
  }

  /// Unblocks user on a call
  ///
  /// Removes the block for a user on a call. The user will be able to join the call again.  Sends events: - call.unblocked_user  Required permissions: - BlockUser 
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
  Future<Response> unblockUserWithHttpInfo(String type, String id, UnblockUserRequest unblockUserRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/unblock'
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
  /// Removes the block for a user on a call. The user will be able to join the call again.  Sends events: - call.unblocked_user  Required permissions: - BlockUser 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UnblockUserRequest] unblockUserRequest (required):
  Future<UnblockUserResponse?> unblockUser(String type, String id, UnblockUserRequest unblockUserRequest,) async {
    final response = await unblockUserWithHttpInfo(type, id, unblockUserRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UnblockUserResponse',) as UnblockUserResponse;
    
    }
    return null;
  }

  /// Update Call
  ///
  ///   Sends events: - call.updated  Required permissions: - UpdateCall 
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
  Future<Response> updateCallWithHttpInfo(String type, String id, UpdateCallRequest updateCallRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}'
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
  ///   Sends events: - call.updated  Required permissions: - UpdateCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateCallRequest] updateCallRequest (required):
  Future<UpdateCallResponse?> updateCall(String type, String id, UpdateCallRequest updateCallRequest,) async {
    final response = await updateCallWithHttpInfo(type, id, updateCallRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UpdateCallResponse',) as UpdateCallResponse;
    
    }
    return null;
  }

  /// Update Call Member
  ///
  ///   Sends events: - call.member_added - call.member_removed - call.member_updated  Required permissions: - RemoveCallMember - UpdateCallMember - UpdateCallMemberRole 
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
  Future<Response> updateCallMembersWithHttpInfo(String type, String id, UpdateCallMembersRequest updateCallMembersRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/members'
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
  ///   Sends events: - call.member_added - call.member_removed - call.member_updated  Required permissions: - RemoveCallMember - UpdateCallMember - UpdateCallMemberRole 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateCallMembersRequest] updateCallMembersRequest (required):
  Future<UpdateCallMembersResponse?> updateCallMembers(String type, String id, UpdateCallMembersRequest updateCallMembersRequest,) async {
    final response = await updateCallMembersWithHttpInfo(type, id, updateCallMembersRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UpdateCallMembersResponse',) as UpdateCallMembersResponse;
    
    }
    return null;
  }
}
