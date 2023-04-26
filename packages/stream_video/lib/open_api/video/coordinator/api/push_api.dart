//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PushApi {
  PushApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

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
  Future<void> createDevice(CreateDeviceRequest createDeviceRequest,) async {
    final response = await createDeviceWithHttpInfo(createDeviceRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
