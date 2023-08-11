//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class DefaultApi {
  DefaultApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Accept Call
  ///
  ///   Sends events: - call.accepted  Required permissions: - JoinCall 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> acceptCallWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/accept'
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
  ///   Sends events: - call.accepted  Required permissions: - JoinCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<AcceptCallResponse?> acceptCall(String type, String id,) async {
    final response = await acceptCallWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AcceptCallResponse',) as AcceptCallResponse;
    
    }
    return null;
  }

  /// Block user on a call
  ///
  /// Block a user, preventing them from joining the call until they are unblocked.  Sends events: - call.blocked_user  Required permissions: - BlockUser 
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
  /// Block a user, preventing them from joining the call until they are unblocked.  Sends events: - call.blocked_user  Required permissions: - BlockUser 
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

  /// Create device
  ///
  /// Adds a new device to a user, if the same device already exists the call will have no effect 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateDeviceRequest] createDeviceRequest (required):
  Future<Response> createDeviceWithHttpInfo(CreateDeviceRequest createDeviceRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/devices';

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
  Future<DurationResponse?> createDevice(CreateDeviceRequest createDeviceRequest,) async {
    final response = await createDeviceWithHttpInfo(createDeviceRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DurationResponse',) as DurationResponse;
    
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
  Future<Response> createGuestWithHttpInfo(CreateGuestRequest createGuestRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/guest';

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
  Future<CreateGuestResponse?> createGuest(CreateGuestRequest createGuestRequest,) async {
    final response = await createGuestWithHttpInfo(createGuestRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CreateGuestResponse',) as CreateGuestResponse;
    
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
  /// * [String] id:
  ///
  /// * [String] userId:
  Future<Response> deleteDeviceWithHttpInfo({ String? id, String? userId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/devices';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_queryParams('', 'id', id));
    }
    if (userId != null) {
      queryParams.addAll(_queryParams('', 'user_id', userId));
    }

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
  /// * [String] id:
  ///
  /// * [String] userId:
  Future<DurationResponse?> deleteDevice({ String? id, String? userId, }) async {
    final response = await deleteDeviceWithHttpInfo( id: id, userId: userId, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DurationResponse',) as DurationResponse;
    
    }
    return null;
  }

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
  ///
  /// * [int] membersLimit:
  ///
  /// * [bool] ring:
  ///
  /// * [bool] notify:
  Future<Response> getCallWithHttpInfo(String type, String id, { String? connectionId, int? membersLimit, bool? ring, bool? notify, }) async {
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
    if (membersLimit != null) {
      queryParams.addAll(_queryParams('', 'members_limit', membersLimit));
    }
    if (ring != null) {
      queryParams.addAll(_queryParams('', 'ring', ring));
    }
    if (notify != null) {
      queryParams.addAll(_queryParams('', 'notify', notify));
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
  ///
  /// * [int] membersLimit:
  ///
  /// * [bool] ring:
  ///
  /// * [bool] notify:
  Future<GetCallResponse?> getCall(String type, String id, { String? connectionId, int? membersLimit, bool? ring, bool? notify, }) async {
    final response = await getCallWithHttpInfo(type, id,  connectionId: connectionId, membersLimit: membersLimit, ring: ring, notify: notify, );
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
  /// Gets or creates a new call  Sends events: - call.created - call.notification - call.ring  Required permissions: - CreateCall - ReadCall - UpdateCallSettings 
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
  /// Gets or creates a new call  Sends events: - call.created - call.notification - call.ring  Required permissions: - CreateCall - ReadCall - UpdateCallSettings 
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
  ///
  /// * [GoLiveRequest] goLiveRequest (required):
  Future<Response> goLiveWithHttpInfo(String type, String id, GoLiveRequest goLiveRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/go_live'
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
  ///   Sends events: - call.live_started  Required permissions: - UpdateCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [GoLiveRequest] goLiveRequest (required):
  Future<GoLiveResponse?> goLive(String type, String id, GoLiveRequest goLiveRequest,) async {
    final response = await goLiveWithHttpInfo(type, id, goLiveRequest,);
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

  /// List devices
  ///
  /// Returns all available devices 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId:
  Future<Response> listDevicesWithHttpInfo({ String? userId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/devices';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (userId != null) {
      queryParams.addAll(_queryParams('', 'user_id', userId));
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

  /// List devices
  ///
  /// Returns all available devices 
  ///
  /// Parameters:
  ///
  /// * [String] userId:
  Future<ListDevicesResponse?> listDevices({ String? userId, }) async {
    final response = await listDevicesWithHttpInfo( userId: userId, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListDevicesResponse',) as ListDevicesResponse;
    
    }
    return null;
  }

  /// List recordings (type, id)
  ///
  /// Lists recordings  Required permissions: - ListRecordings 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> listRecordingsTypeId0WithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/recordings'
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

  /// List recordings (type, id)
  ///
  /// Lists recordings  Required permissions: - ListRecordings 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<ListRecordingsResponse?> listRecordingsTypeId0(String type, String id,) async {
    final response = await listRecordingsTypeId0WithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListRecordingsResponse',) as ListRecordingsResponse;
    
    }
    return null;
  }

  /// List recordings (type, id, session)
  ///
  /// Lists recordings  Required permissions: - ListRecordings 
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
  Future<Response> listRecordingsTypeIdSession1WithHttpInfo(String type, String id, String session,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/{session}/recordings'
      .replaceAll('{type}', type)
      .replaceAll('{id}', id)
      .replaceAll('{session}', session);

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

  /// List recordings (type, id, session)
  ///
  /// Lists recordings  Required permissions: - ListRecordings 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [String] session (required):
  Future<ListRecordingsResponse?> listRecordingsTypeIdSession1(String type, String id, String session,) async {
    final response = await listRecordingsTypeIdSession1WithHttpInfo(type, id, session,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListRecordingsResponse',) as ListRecordingsResponse;
    
    }
    return null;
  }

  /// Mute users
  ///
  /// Mutes users in a call  Required permissions: - MuteUsers 
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
  /// Mutes users in a call  Required permissions: - MuteUsers 
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

  /// Reject Call
  ///
  ///   Sends events: - call.rejected  Required permissions: - JoinCall 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> rejectCallWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/reject'
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

  /// Reject Call
  ///
  ///   Sends events: - call.rejected  Required permissions: - JoinCall 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<RejectCallResponse?> rejectCall(String type, String id,) async {
    final response = await rejectCallWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RejectCallResponse',) as RejectCallResponse;
    
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
  Future<Response> requestPermissionWithHttpInfo(String type, String id, RequestPermissionRequest requestPermissionRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/request_permission'
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
  Future<RequestPermissionResponse?> requestPermission(String type, String id, RequestPermissionRequest requestPermissionRequest,) async {
    final response = await requestPermissionWithHttpInfo(type, id, requestPermissionRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RequestPermissionResponse',) as RequestPermissionResponse;
    
    }
    return null;
  }

  /// Send custom event
  ///
  /// Sends custom event to the call  Sends events: - custom  Required permissions: - SendEvent 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [SendEventRequest] sendEventRequest (required):
  Future<Response> sendEventWithHttpInfo(String type, String id, SendEventRequest sendEventRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/event'
      .replaceAll('{type}', type)
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = sendEventRequest;

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
  /// Sends custom event to the call  Sends events: - custom  Required permissions: - SendEvent 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [SendEventRequest] sendEventRequest (required):
  Future<SendEventResponse?> sendEvent(String type, String id, SendEventRequest sendEventRequest,) async {
    final response = await sendEventWithHttpInfo(type, id, sendEventRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SendEventResponse',) as SendEventResponse;
    
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

  /// Start broadcasting
  ///
  /// Starts broadcasting  Required permissions: - StartBroadcasting 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> startBroadcastingWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/start_broadcasting'
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

  /// Start broadcasting
  ///
  /// Starts broadcasting  Required permissions: - StartBroadcasting 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StartBroadcastingResponse?> startBroadcasting(String type, String id,) async {
    final response = await startBroadcastingWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StartBroadcastingResponse',) as StartBroadcastingResponse;
    
    }
    return null;
  }

  /// Start recording
  ///
  /// Starts recording  Sends events: - call.recording_started  Required permissions: - StopRecording 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> startRecordingWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/start_recording'
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

  /// Start recording
  ///
  /// Starts recording  Sends events: - call.recording_started  Required permissions: - StopRecording 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StartRecordingResponse?> startRecording(String type, String id,) async {
    final response = await startRecordingWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StartRecordingResponse',) as StartRecordingResponse;
    
    }
    return null;
  }

  /// Start transcription
  ///
  /// Starts transcription  Required permissions: - StartTranscription 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> startTranscriptionWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/start_transcription'
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

  /// Start transcription
  ///
  /// Starts transcription  Required permissions: - StartTranscription 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StartTranscriptionResponse?> startTranscription(String type, String id,) async {
    final response = await startTranscriptionWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StartTranscriptionResponse',) as StartTranscriptionResponse;
    
    }
    return null;
  }

  /// Stop broadcasting
  ///
  /// Stops broadcasting  Required permissions: - StopBroadcasting 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> stopBroadcastingWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/stop_broadcasting'
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

  /// Stop broadcasting
  ///
  /// Stops broadcasting  Required permissions: - StopBroadcasting 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StopBroadcastingResponse?> stopBroadcasting(String type, String id,) async {
    final response = await stopBroadcastingWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StopBroadcastingResponse',) as StopBroadcastingResponse;
    
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

  /// Stop recording
  ///
  /// Stops recording  Sends events: - call.recording_stopped  Required permissions: - StopRecording 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> stopRecordingWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/stop_recording'
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
  /// Stops recording  Sends events: - call.recording_stopped  Required permissions: - StopRecording 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StopRecordingResponse?> stopRecording(String type, String id,) async {
    final response = await stopRecordingWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StopRecordingResponse',) as StopRecordingResponse;
    
    }
    return null;
  }

  /// Stop transcription
  ///
  /// Stops transcription  Required permissions: - StopTranscription 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<Response> stopTranscriptionWithHttpInfo(String type, String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/stop_transcription'
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

  /// Stop transcription
  ///
  /// Stops transcription  Required permissions: - StopTranscription 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<StopTranscriptionResponse?> stopTranscription(String type, String id,) async {
    final response = await stopTranscriptionWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StopTranscriptionResponse',) as StopTranscriptionResponse;
    
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

  /// Update user permissions
  ///
  /// Updates user permissions  Sends events: - call.permissions_updated  Required permissions: - UpdateCallPermissions 
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
  Future<Response> updateUserPermissionsWithHttpInfo(String type, String id, UpdateUserPermissionsRequest updateUserPermissionsRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/user_permissions'
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
  /// Updates user permissions  Sends events: - call.permissions_updated  Required permissions: - UpdateCallPermissions 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateUserPermissionsRequest] updateUserPermissionsRequest (required):
  Future<UpdateUserPermissionsResponse?> updateUserPermissions(String type, String id, UpdateUserPermissionsRequest updateUserPermissionsRequest,) async {
    final response = await updateUserPermissionsWithHttpInfo(type, id, updateUserPermissionsRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UpdateUserPermissionsResponse',) as UpdateUserPermissionsResponse;
    
    }
    return null;
  }

  /// Video Connect (WebSocket)
  ///
  /// Establishes WebSocket connection for user to video  Sends events: - connection.ok - health.check 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [WSAuthMessageRequest] wSAuthMessageRequest (required):
  Future<Response> videoConnectWithHttpInfo(WSAuthMessageRequest wSAuthMessageRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/video/connect';

    // ignore: prefer_final_locals
    Object? postBody = wSAuthMessageRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


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
  /// Establishes WebSocket connection for user to video  Sends events: - connection.ok - health.check 
  ///
  /// Parameters:
  ///
  /// * [WSAuthMessageRequest] wSAuthMessageRequest (required):
  Future<void> videoConnect(WSAuthMessageRequest wSAuthMessageRequest,) async {
    final response = await videoConnectWithHttpInfo(wSAuthMessageRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Pin
  ///
  /// Pins a track for all users in the call.  Required permissions: - PinCallTrack 
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
  Future<Response> videoPinWithHttpInfo(String type, String id, PinRequest pinRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/pin'
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
  /// Pins a track for all users in the call.  Required permissions: - PinCallTrack 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [PinRequest] pinRequest (required):
  Future<PinResponse?> videoPin(String type, String id, PinRequest pinRequest,) async {
    final response = await videoPinWithHttpInfo(type, id, pinRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PinResponse',) as PinResponse;
    
    }
    return null;
  }

  /// Unpin
  ///
  /// Unpins a track for all users in the call.  Required permissions: - PinCallTrack 
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
  Future<Response> videoUnpinWithHttpInfo(String type, String id, UnpinRequest unpinRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/call/{type}/{id}/unpin'
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
  /// Unpins a track for all users in the call.  Required permissions: - PinCallTrack 
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  ///
  /// * [UnpinRequest] unpinRequest (required):
  Future<UnpinResponse?> videoUnpin(String type, String id, UnpinRequest unpinRequest,) async {
    final response = await videoUnpinWithHttpInfo(type, id, unpinRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UnpinResponse',) as UnpinResponse;
    
    }
    return null;
  }
}
