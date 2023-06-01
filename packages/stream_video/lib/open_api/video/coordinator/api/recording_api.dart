//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class RecordingApi {
  RecordingApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

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
}
