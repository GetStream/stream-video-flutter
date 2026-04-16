//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ResolveSipInboundResponse {
  /// Returns a new [ResolveSipInboundResponse] instance.
  ResolveSipInboundResponse({
    required this.credentials,
    required this.duration,
    this.sipRoutingRule,
    this.sipTrunk,
  });

  SipInboundCredentials credentials;

  String duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SIPInboundRoutingRuleResponse? sipRoutingRule;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SIPTrunkResponse? sipTrunk;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolveSipInboundResponse &&
          other.credentials == credentials &&
          other.duration == duration &&
          other.sipRoutingRule == sipRoutingRule &&
          other.sipTrunk == sipTrunk;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (credentials.hashCode) +
      (duration.hashCode) +
      (sipRoutingRule == null ? 0 : sipRoutingRule!.hashCode) +
      (sipTrunk == null ? 0 : sipTrunk!.hashCode);

  @override
  String toString() =>
      'ResolveSipInboundResponse[credentials=$credentials, duration=$duration, sipRoutingRule=$sipRoutingRule, sipTrunk=$sipTrunk]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'credentials'] = this.credentials;
    json[r'duration'] = this.duration;
    if (this.sipRoutingRule != null) {
      json[r'sip_routing_rule'] = this.sipRoutingRule;
    } else {
      json[r'sip_routing_rule'] = null;
    }
    if (this.sipTrunk != null) {
      json[r'sip_trunk'] = this.sipTrunk;
    } else {
      json[r'sip_trunk'] = null;
    }
    return json;
  }

  /// Returns a new [ResolveSipInboundResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ResolveSipInboundResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'credentials'),
            'Required key "ResolveSipInboundResponse[credentials]" is missing from JSON.');
        assert(json[r'credentials'] != null,
            'Required key "ResolveSipInboundResponse[credentials]" has a null value in JSON.');
        assert(json.containsKey(r'duration'),
            'Required key "ResolveSipInboundResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "ResolveSipInboundResponse[duration]" has a null value in JSON.');
        return true;
      }());

      return ResolveSipInboundResponse(
        credentials: SipInboundCredentials.fromJson(json[r'credentials'])!,
        duration: mapValueOfType<String>(json, r'duration')!,
        sipRoutingRule:
            SIPInboundRoutingRuleResponse.fromJson(json[r'sip_routing_rule']),
        sipTrunk: SIPTrunkResponse.fromJson(json[r'sip_trunk']),
      );
    }
    return null;
  }

  static List<ResolveSipInboundResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ResolveSipInboundResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ResolveSipInboundResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ResolveSipInboundResponse> mapFromJson(dynamic json) {
    final map = <String, ResolveSipInboundResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ResolveSipInboundResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ResolveSipInboundResponse-objects as value to a dart map
  static Map<String, List<ResolveSipInboundResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ResolveSipInboundResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ResolveSipInboundResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'credentials',
    'duration',
  };
}
