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

  /// Query call
  ///
  /// Query calls with filter query
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [QueryCallRequest] queryCallRequest (required):
  Future<Response> queryCallsWithHttpInfo(QueryCallRequest queryCallRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/calls';

    // ignore: prefer_final_locals
    Object? postBody = queryCallRequest;

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

  /// Query call
  ///
  /// Query calls with filter query
  ///
  /// Parameters:
  ///
  /// * [QueryCallRequest] queryCallRequest (required):
  Future<QueryCallsResponse?> queryCalls(QueryCallRequest queryCallRequest,) async {
    final response = await queryCallsWithHttpInfo(queryCallRequest,);
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

  /// Request permission
  ///
  /// Request permission to perform an action
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
  /// Request permission to perform an action
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

  /// Start broadcasting
  ///
  /// Starts broadcasting
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
  /// Starts broadcasting
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<void> startBroadcasting(String type, String id,) async {
    final response = await startBroadcastingWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Start recording
  ///
  /// Starts recording
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
  /// Starts recording
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<void> startRecording(String type, String id,) async {
    final response = await startRecordingWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Stop broadcasting
  ///
  /// Stops broadcasting
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
  /// Stops broadcasting
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<void> stopBroadcasting(String type, String id,) async {
    final response = await stopBroadcastingWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Stop recording
  ///
  /// Stops recording
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
  /// Stops recording
  ///
  /// Parameters:
  ///
  /// * [String] type (required):
  ///
  /// * [String] id (required):
  Future<void> stopRecording(String type, String id,) async {
    final response = await stopRecordingWithHttpInfo(type, id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update user permissions
  ///
  /// Updates user permissions
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
  /// Updates user permissions
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
}
