//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ModerationApi {
  ModerationApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

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
}
