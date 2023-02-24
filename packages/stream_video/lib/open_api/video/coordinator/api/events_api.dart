//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class EventsApi {
  EventsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Send event
  ///
  /// Sends event to the call
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

  /// Send event
  ///
  /// Sends event to the call
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
}
