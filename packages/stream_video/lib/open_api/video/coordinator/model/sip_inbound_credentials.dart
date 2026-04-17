//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SipInboundCredentials {
  /// Returns a new [SipInboundCredentials] instance.
  SipInboundCredentials({
    required this.apiKey,
    this.callCustomData = const {},
    required this.callId,
    required this.callType,
    required this.token,
    this.userCustomData = const {},
    required this.userId,
  });

  /// API key for the application
  String apiKey;

  /// Custom data associated with the call
  Map<String, Object> callCustomData;

  /// ID of the call
  String callId;

  /// Type of the call
  String callType;

  /// Authentication token for the call
  String token;

  /// Custom data associated with the user
  Map<String, Object> userCustomData;

  /// User ID for the call
  String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SipInboundCredentials &&
          other.apiKey == apiKey &&
          _deepEquality.equals(other.callCustomData, callCustomData) &&
          other.callId == callId &&
          other.callType == callType &&
          other.token == token &&
          _deepEquality.equals(other.userCustomData, userCustomData) &&
          other.userId == userId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (apiKey.hashCode) +
      (callCustomData.hashCode) +
      (callId.hashCode) +
      (callType.hashCode) +
      (token.hashCode) +
      (userCustomData.hashCode) +
      (userId.hashCode);

  @override
  String toString() =>
      'SipInboundCredentials[apiKey=$apiKey, callCustomData=$callCustomData, callId=$callId, callType=$callType, token=$token, userCustomData=$userCustomData, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'api_key'] = this.apiKey;
    json[r'call_custom_data'] = this.callCustomData;
    json[r'call_id'] = this.callId;
    json[r'call_type'] = this.callType;
    json[r'token'] = this.token;
    json[r'user_custom_data'] = this.userCustomData;
    json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [SipInboundCredentials] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SipInboundCredentials? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'api_key'),
            'Required key "SipInboundCredentials[api_key]" is missing from JSON.');
        assert(json[r'api_key'] != null,
            'Required key "SipInboundCredentials[api_key]" has a null value in JSON.');
        assert(json.containsKey(r'call_custom_data'),
            'Required key "SipInboundCredentials[call_custom_data]" is missing from JSON.');
        assert(json[r'call_custom_data'] != null,
            'Required key "SipInboundCredentials[call_custom_data]" has a null value in JSON.');
        assert(json.containsKey(r'call_id'),
            'Required key "SipInboundCredentials[call_id]" is missing from JSON.');
        assert(json[r'call_id'] != null,
            'Required key "SipInboundCredentials[call_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_type'),
            'Required key "SipInboundCredentials[call_type]" is missing from JSON.');
        assert(json[r'call_type'] != null,
            'Required key "SipInboundCredentials[call_type]" has a null value in JSON.');
        assert(json.containsKey(r'token'),
            'Required key "SipInboundCredentials[token]" is missing from JSON.');
        assert(json[r'token'] != null,
            'Required key "SipInboundCredentials[token]" has a null value in JSON.');
        assert(json.containsKey(r'user_custom_data'),
            'Required key "SipInboundCredentials[user_custom_data]" is missing from JSON.');
        assert(json[r'user_custom_data'] != null,
            'Required key "SipInboundCredentials[user_custom_data]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "SipInboundCredentials[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "SipInboundCredentials[user_id]" has a null value in JSON.');
        return true;
      }());

      return SipInboundCredentials(
        apiKey: mapValueOfType<String>(json, r'api_key')!,
        callCustomData:
            mapCastOfType<String, Object>(json, r'call_custom_data')!,
        callId: mapValueOfType<String>(json, r'call_id')!,
        callType: mapValueOfType<String>(json, r'call_type')!,
        token: mapValueOfType<String>(json, r'token')!,
        userCustomData:
            mapCastOfType<String, Object>(json, r'user_custom_data')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<SipInboundCredentials> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SipInboundCredentials>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SipInboundCredentials.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SipInboundCredentials> mapFromJson(dynamic json) {
    final map = <String, SipInboundCredentials>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SipInboundCredentials.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SipInboundCredentials-objects as value to a dart map
  static Map<String, List<SipInboundCredentials>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SipInboundCredentials>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SipInboundCredentials.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'api_key',
    'call_custom_data',
    'call_id',
    'call_type',
    'token',
    'user_custom_data',
    'user_id',
  };
}
