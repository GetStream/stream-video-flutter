import 'dart:convert';

import '../../../../open_api/video/coordinator/api.dart';

class OpenApiError {
  const OpenApiError(this.apiError);

  static OpenApiError? fromRawJson(String rawJson) {
    return OpenApiError.fromJson(json.decode(rawJson));
  }

  static OpenApiError? fromJson(Map<String, dynamic> jsonObj) {
    final errorObj = jsonObj['error'];
    if (errorObj is! Map<String, dynamic>) {
      return null;
    }
    try {
      return OpenApiError(StreamApiError.fromJson(errorObj));
    } catch (_) {
      return null;
    }
  }

  final StreamApiError apiError;
}

class NoErrorException implements Exception {
  const NoErrorException(this.jsonObj);

  final dynamic jsonObj;

  @override
  String toString() {
    return 'NoEventTypeException{jsonObj: $jsonObj}';
  }
}
