//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ServerSideApi {
  ServerSideApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Call Type
  ///
  ///  
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateCallTypeRequest] createCallTypeRequest (required):
  Future<Response> createCallTypeWithHttpInfo(CreateCallTypeRequest createCallTypeRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/calltypes';

    // ignore: prefer_final_locals
    Object? postBody = createCallTypeRequest;

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

  /// Create Call Type
  ///
  ///  
  ///
  /// Parameters:
  ///
  /// * [CreateCallTypeRequest] createCallTypeRequest (required):
  Future<CreateCallTypeResponse?> createCallType(CreateCallTypeRequest createCallTypeRequest,) async {
    final response = await createCallTypeWithHttpInfo(createCallTypeRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CreateCallTypeResponse',) as CreateCallTypeResponse;
    
    }
    return null;
  }

  /// Delete Call Type
  ///
  ///  
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] name (required):
  Future<Response> deleteCallTypeWithHttpInfo(String name,) async {
    // ignore: prefer_const_declarations
    final path = r'/calltypes/{name}'
      .replaceAll('{name}', name);

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

  /// Delete Call Type
  ///
  ///  
  ///
  /// Parameters:
  ///
  /// * [String] name (required):
  Future<DurationResponse?> deleteCallType(String name,) async {
    final response = await deleteCallTypeWithHttpInfo(name,);
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

  /// Get Call Type
  ///
  ///  
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] name (required):
  Future<Response> getCallTypeWithHttpInfo(String name,) async {
    // ignore: prefer_const_declarations
    final path = r'/calltypes/{name}'
      .replaceAll('{name}', name);

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

  /// Get Call Type
  ///
  ///  
  ///
  /// Parameters:
  ///
  /// * [String] name (required):
  Future<GetCallTypeResponse?> getCallType(String name,) async {
    final response = await getCallTypeWithHttpInfo(name,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetCallTypeResponse',) as GetCallTypeResponse;
    
    }
    return null;
  }

  /// List Call Type
  ///
  ///  
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listCallTypesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/calltypes';

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

  /// List Call Type
  ///
  ///  
  Future<ListCallTypeResponse?> listCallTypes() async {
    final response = await listCallTypesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListCallTypeResponse',) as ListCallTypeResponse;
    
    }
    return null;
  }

  /// Update Call Type
  ///
  ///  
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] name (required):
  ///
  /// * [UpdateCallTypeRequest] updateCallTypeRequest (required):
  Future<Response> updateCallTypeWithHttpInfo(String name, UpdateCallTypeRequest updateCallTypeRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/calltypes/{name}'
      .replaceAll('{name}', name);

    // ignore: prefer_final_locals
    Object? postBody = updateCallTypeRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update Call Type
  ///
  ///  
  ///
  /// Parameters:
  ///
  /// * [String] name (required):
  ///
  /// * [UpdateCallTypeRequest] updateCallTypeRequest (required):
  Future<UpdateCallTypeResponse?> updateCallType(String name, UpdateCallTypeRequest updateCallTypeRequest,) async {
    final response = await updateCallTypeWithHttpInfo(name, updateCallTypeRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UpdateCallTypeResponse',) as UpdateCallTypeResponse;
    
    }
    return null;
  }
}
