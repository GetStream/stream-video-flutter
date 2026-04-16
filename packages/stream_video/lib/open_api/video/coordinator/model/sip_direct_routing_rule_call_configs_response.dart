//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SIPDirectRoutingRuleCallConfigsResponse {
  /// Returns a new [SIPDirectRoutingRuleCallConfigsResponse] instance.
  SIPDirectRoutingRuleCallConfigsResponse({
    required this.callId,
    required this.callType,
  });

  /// ID of the call
  String callId;

  /// Type of the call
  String callType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SIPDirectRoutingRuleCallConfigsResponse &&
          other.callId == callId &&
          other.callType == callType;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callId.hashCode) + (callType.hashCode);

  @override
  String toString() =>
      'SIPDirectRoutingRuleCallConfigsResponse[callId=$callId, callType=$callType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_id'] = this.callId;
    json[r'call_type'] = this.callType;
    return json;
  }

  /// Returns a new [SIPDirectRoutingRuleCallConfigsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SIPDirectRoutingRuleCallConfigsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_id'),
            'Required key "SIPDirectRoutingRuleCallConfigsResponse[call_id]" is missing from JSON.');
        assert(json[r'call_id'] != null,
            'Required key "SIPDirectRoutingRuleCallConfigsResponse[call_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_type'),
            'Required key "SIPDirectRoutingRuleCallConfigsResponse[call_type]" is missing from JSON.');
        assert(json[r'call_type'] != null,
            'Required key "SIPDirectRoutingRuleCallConfigsResponse[call_type]" has a null value in JSON.');
        return true;
      }());

      return SIPDirectRoutingRuleCallConfigsResponse(
        callId: mapValueOfType<String>(json, r'call_id')!,
        callType: mapValueOfType<String>(json, r'call_type')!,
      );
    }
    return null;
  }

  static List<SIPDirectRoutingRuleCallConfigsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SIPDirectRoutingRuleCallConfigsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SIPDirectRoutingRuleCallConfigsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SIPDirectRoutingRuleCallConfigsResponse> mapFromJson(
      dynamic json) {
    final map = <String, SIPDirectRoutingRuleCallConfigsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            SIPDirectRoutingRuleCallConfigsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SIPDirectRoutingRuleCallConfigsResponse-objects as value to a dart map
  static Map<String, List<SIPDirectRoutingRuleCallConfigsResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SIPDirectRoutingRuleCallConfigsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SIPDirectRoutingRuleCallConfigsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_id',
    'call_type',
  };
}
