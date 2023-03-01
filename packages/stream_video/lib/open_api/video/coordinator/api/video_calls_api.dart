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

  /// Block user on a call
  ///
  /// Block a user, preventing them from joining the call until they are unblocked.
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
  Future<Response> blockUserWithHttpInfo(String type, String id, BlockUserRequest blockUserRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/block'
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
  /// Block a user, preventing them from joining the call until they are unblocked.
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [BlockUserRequest] blockUserRequest (required):
  Future<BlockUserResponse?> blockUser(String type, String id, BlockUserRequest blockUserRequest,) async {
    final response = await blockUserWithHttpInfo(type, id, blockUserRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BlockUserResponse',) as BlockUserResponse;
    
    }
    return null;
  }

  /// End call
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

  /// Get Call Edge Server
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

  /// Get or create a call
  ///
  /// Gets or creates a new call
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
  Future<Response> getOrCreateCallWithHttpInfo(String type, String id, GetOrCreateCallRequest getOrCreateCallRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}'
      .replaceAll('{type}', type)
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = getOrCreateCallRequest;

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

  /// Get or create a call
  ///
  /// Gets or creates a new call
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GetOrCreateCallRequest] getOrCreateCallRequest (required):
  Future<GetOrCreateCallResponse?> getOrCreateCall(String type, String id, GetOrCreateCallRequest getOrCreateCallRequest,) async {
    final response = await getOrCreateCallWithHttpInfo(type, id, getOrCreateCallRequest,);
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

  /// Join call (type, id)
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
  ///
  /// * [String] connectionId:
  Future<Response> joinCallTypeId0WithHttpInfo(String type, String id, JoinCallRequest joinCallRequest, { String? connectionId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/join_call/{type}/{id}'
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

  /// Join call (type, id)
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
  ///
  /// * [String] connectionId:
  Future<JoinCallResponse?> joinCallTypeId0(String type, String id, JoinCallRequest joinCallRequest, { String? connectionId, }) async {
    final response = await joinCallTypeId0WithHttpInfo(type, id, joinCallRequest,  connectionId: connectionId, );
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

  /// Join call (type, id)
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
  ///
  /// * [String] connectionId:
  Future<Response> joinCallTypeId1WithHttpInfo(String type, String id, JoinCallRequest joinCallRequest, { String? connectionId, }) async {
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

  /// Join call (type, id)
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
  ///
  /// * [String] connectionId:
  Future<JoinCallResponse?> joinCallTypeId1(String type, String id, JoinCallRequest joinCallRequest, { String? connectionId, }) async {
    final response = await joinCallTypeId1WithHttpInfo(type, id, joinCallRequest,  connectionId: connectionId, );
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
  Future<Response> muteUsersWithHttpInfo(String type, String id, MuteUsersRequest muteUsersRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/mute_users'
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
  Future<MuteUsersResponse?> muteUsers(String type, String id, MuteUsersRequest muteUsersRequest,) async {
    final response = await muteUsersWithHttpInfo(type, id, muteUsersRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MuteUsersResponse',) as MuteUsersResponse;
    
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
  /// Query call members with filter query
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

  /// Set call as not live
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
  /// Removes the block for a user on a call. The user will be able to join the call again.
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
  /// Removes the block for a user on a call. The user will be able to join the call again.
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
}
