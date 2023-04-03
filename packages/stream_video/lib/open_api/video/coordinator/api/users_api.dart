//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UsersApi {
  UsersApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

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
}
