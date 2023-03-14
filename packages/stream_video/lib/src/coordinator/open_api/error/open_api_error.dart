import 'dart:convert';

import '../../../../open_api/video/coordinator/api.dart';

class OpenApiError {
  const OpenApiError(this.apiError);

  static OpenApiError? fromRawJson(String rawJson) {
    return OpenApiError.fromJson(json.decode(rawJson));
  }

  static OpenApiError? fromJson(dynamic jsonObj) {
    final errorObj = jsonObj['error'];
    if (errorObj == null) {
      return null;
    }
    final parsed = APIError.fromJson(errorObj);
    if (parsed == null) {
      return null;
    }
    return OpenApiError(parsed);
  }

  final APIError apiError;
}

class NoErrorException implements Exception {
  const NoErrorException(this.jsonObj);

  final dynamic jsonObj;

  @override
  String toString() {
    return 'NoEventTypeException{jsonObj: $jsonObj}';
  }
}
