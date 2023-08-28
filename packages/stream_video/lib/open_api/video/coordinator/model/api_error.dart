//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class APIError {
  /// Returns a new [APIError] instance.
  APIError({
    required this.statusCode,
    required this.code,
    this.details = const [],
    required this.duration,
    this.exceptionFields = const {},
    required this.message,
    required this.moreInfo,
  });

  /// Response HTTP status code
  int statusCode;

  /// API error code
  int code;

  /// Additional error-specific information
  List<int> details;

  /// Request duration
  String duration;

  /// Additional error info
  Map<String, String> exceptionFields;

  /// Message describing an error
  String message;

  /// URL with additional information
  String moreInfo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is APIError &&
     other.statusCode == statusCode &&
     other.code == code &&
     other.details == details &&
     other.duration == duration &&
     other.exceptionFields == exceptionFields &&
     other.message == message &&
     other.moreInfo == moreInfo;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (statusCode.hashCode) +
    (code.hashCode) +
    (details.hashCode) +
    (duration.hashCode) +
    (exceptionFields.hashCode) +
    (message.hashCode) +
    (moreInfo.hashCode);

  @override
  String toString() => 'APIError[statusCode=$statusCode, code=$code, details=$details, duration=$duration, exceptionFields=$exceptionFields, message=$message, moreInfo=$moreInfo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'StatusCode'] = this.statusCode;
      json[r'code'] = this.code;
      json[r'details'] = this.details;
      json[r'duration'] = this.duration;
      json[r'exception_fields'] = this.exceptionFields;
      json[r'message'] = this.message;
      json[r'more_info'] = this.moreInfo;
    return json;
  }

  /// Returns a new [APIError] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static APIError? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "APIError[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "APIError[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return APIError(
        statusCode: mapValueOfType<int>(json, r'StatusCode')!,
        code: mapValueOfType<int>(json, r'code')!,
        details: json[r'details'] is List
            ? (json[r'details'] as List).cast<int>()
            : const [],
        duration: mapValueOfType<String>(json, r'duration')!,
        exceptionFields: mapCastOfType<String, String>(json, r'exception_fields') ?? const {},
        message: mapValueOfType<String>(json, r'message')!,
        moreInfo: mapValueOfType<String>(json, r'more_info')!,
      );
    }
    return null;
  }

  static List<APIError> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <APIError>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = APIError.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, APIError> mapFromJson(dynamic json) {
    final map = <String, APIError>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = APIError.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of APIError-objects as value to a dart map
  static Map<String, List<APIError>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<APIError>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = APIError.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'StatusCode',
    'code',
    'details',
    'duration',
    'message',
    'more_info',
  };
}

