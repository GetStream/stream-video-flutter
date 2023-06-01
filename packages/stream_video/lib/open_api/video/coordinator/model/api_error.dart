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
  APIErrorCodeEnum code;

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
        code: APIErrorCodeEnum.fromJson(json[r'code'])!,
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

/// API error code
class APIErrorCodeEnum {
  /// Instantiate a new enum with the provided [value].
  const APIErrorCodeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const internalError = APIErrorCodeEnum._(r'internal-error');
  static const accessKeyError = APIErrorCodeEnum._(r'access-key-error');
  static const inputError = APIErrorCodeEnum._(r'input-error');
  static const authFailed = APIErrorCodeEnum._(r'auth-failed');
  static const duplicateUsername = APIErrorCodeEnum._(r'duplicate-username');
  static const rateLimited = APIErrorCodeEnum._(r'rate-limited');
  static const notFound = APIErrorCodeEnum._(r'not-found');
  static const notAllowed = APIErrorCodeEnum._(r'not-allowed');
  static const eventNotSupported = APIErrorCodeEnum._(r'event-not-supported');
  static const channelFeatureNotSupported = APIErrorCodeEnum._(r'channel-feature-not-supported');
  static const messageTooLong = APIErrorCodeEnum._(r'message-too-long');
  static const multipleNestingLevel = APIErrorCodeEnum._(r'multiple-nesting-level');
  static const payloadTooBig = APIErrorCodeEnum._(r'payload-too-big');
  static const expiredToken = APIErrorCodeEnum._(r'expired-token');
  static const tokenNotValidYet = APIErrorCodeEnum._(r'token-not-valid-yet');
  static const tokenUsedBeforeIat = APIErrorCodeEnum._(r'token-used-before-iat');
  static const invalidTokenSignature = APIErrorCodeEnum._(r'invalid-token-signature');
  static const customCommandEndpointMissing = APIErrorCodeEnum._(r'custom-command-endpoint-missing');
  static const customCommandEndpointEqualCallError = APIErrorCodeEnum._(r'custom-command-endpoint=call-error');
  static const connectionIdNotFound = APIErrorCodeEnum._(r'connection-id-not-found');
  static const coolDown = APIErrorCodeEnum._(r'cool-down');
  static const queryChannelPermissionsMismatch = APIErrorCodeEnum._(r'query-channel-permissions-mismatch');
  static const tooManyConnections = APIErrorCodeEnum._(r'too-many-connections');
  static const notSupportedInPushV1 = APIErrorCodeEnum._(r'not-supported-in-push-v1');
  static const moderationFailed = APIErrorCodeEnum._(r'moderation-failed');
  static const videoProviderNotConfigured = APIErrorCodeEnum._(r'video-provider-not-configured');
  static const videoInvalidCallId = APIErrorCodeEnum._(r'video-invalid-call-id');
  static const videoCreateCallFailed = APIErrorCodeEnum._(r'video-create-call-failed');
  static const appSuspended = APIErrorCodeEnum._(r'app-suspended');
  static const videoNoDatacentersAvailable = APIErrorCodeEnum._(r'video-no-datacenters-available');
  static const videoJoinCallFailure = APIErrorCodeEnum._(r'video-join-call-failure');
  static const queryCallsPermissionsMismatch = APIErrorCodeEnum._(r'query-calls-permissions-mismatch');

  /// List of all possible values in this [enum][APIErrorCodeEnum].
  static const values = <APIErrorCodeEnum>[
    internalError,
    accessKeyError,
    inputError,
    authFailed,
    duplicateUsername,
    rateLimited,
    notFound,
    notAllowed,
    eventNotSupported,
    channelFeatureNotSupported,
    messageTooLong,
    multipleNestingLevel,
    payloadTooBig,
    expiredToken,
    tokenNotValidYet,
    tokenUsedBeforeIat,
    invalidTokenSignature,
    customCommandEndpointMissing,
    customCommandEndpointEqualCallError,
    connectionIdNotFound,
    coolDown,
    queryChannelPermissionsMismatch,
    tooManyConnections,
    notSupportedInPushV1,
    moderationFailed,
    videoProviderNotConfigured,
    videoInvalidCallId,
    videoCreateCallFailed,
    appSuspended,
    videoNoDatacentersAvailable,
    videoJoinCallFailure,
    queryCallsPermissionsMismatch,
  ];

  static APIErrorCodeEnum? fromJson(dynamic value) => APIErrorCodeEnumTypeTransformer().decode(value);

  static List<APIErrorCodeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <APIErrorCodeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = APIErrorCodeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [APIErrorCodeEnum] to String,
/// and [decode] dynamic data back to [APIErrorCodeEnum].
class APIErrorCodeEnumTypeTransformer {
  factory APIErrorCodeEnumTypeTransformer() => _instance ??= const APIErrorCodeEnumTypeTransformer._();

  const APIErrorCodeEnumTypeTransformer._();

  String encode(APIErrorCodeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a APIErrorCodeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  APIErrorCodeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'internal-error': return APIErrorCodeEnum.internalError;
        case r'access-key-error': return APIErrorCodeEnum.accessKeyError;
        case r'input-error': return APIErrorCodeEnum.inputError;
        case r'auth-failed': return APIErrorCodeEnum.authFailed;
        case r'duplicate-username': return APIErrorCodeEnum.duplicateUsername;
        case r'rate-limited': return APIErrorCodeEnum.rateLimited;
        case r'not-found': return APIErrorCodeEnum.notFound;
        case r'not-allowed': return APIErrorCodeEnum.notAllowed;
        case r'event-not-supported': return APIErrorCodeEnum.eventNotSupported;
        case r'channel-feature-not-supported': return APIErrorCodeEnum.channelFeatureNotSupported;
        case r'message-too-long': return APIErrorCodeEnum.messageTooLong;
        case r'multiple-nesting-level': return APIErrorCodeEnum.multipleNestingLevel;
        case r'payload-too-big': return APIErrorCodeEnum.payloadTooBig;
        case r'expired-token': return APIErrorCodeEnum.expiredToken;
        case r'token-not-valid-yet': return APIErrorCodeEnum.tokenNotValidYet;
        case r'token-used-before-iat': return APIErrorCodeEnum.tokenUsedBeforeIat;
        case r'invalid-token-signature': return APIErrorCodeEnum.invalidTokenSignature;
        case r'custom-command-endpoint-missing': return APIErrorCodeEnum.customCommandEndpointMissing;
        case r'custom-command-endpoint=call-error': return APIErrorCodeEnum.customCommandEndpointEqualCallError;
        case r'connection-id-not-found': return APIErrorCodeEnum.connectionIdNotFound;
        case r'cool-down': return APIErrorCodeEnum.coolDown;
        case r'query-channel-permissions-mismatch': return APIErrorCodeEnum.queryChannelPermissionsMismatch;
        case r'too-many-connections': return APIErrorCodeEnum.tooManyConnections;
        case r'not-supported-in-push-v1': return APIErrorCodeEnum.notSupportedInPushV1;
        case r'moderation-failed': return APIErrorCodeEnum.moderationFailed;
        case r'video-provider-not-configured': return APIErrorCodeEnum.videoProviderNotConfigured;
        case r'video-invalid-call-id': return APIErrorCodeEnum.videoInvalidCallId;
        case r'video-create-call-failed': return APIErrorCodeEnum.videoCreateCallFailed;
        case r'app-suspended': return APIErrorCodeEnum.appSuspended;
        case r'video-no-datacenters-available': return APIErrorCodeEnum.videoNoDatacentersAvailable;
        case r'video-join-call-failure': return APIErrorCodeEnum.videoJoinCallFailure;
        case r'query-calls-permissions-mismatch': return APIErrorCodeEnum.queryCallsPermissionsMismatch;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [APIErrorCodeEnumTypeTransformer] instance.
  static APIErrorCodeEnumTypeTransformer? _instance;
}


