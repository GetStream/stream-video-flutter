//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ResolveSipAuthRequest {
  /// Returns a new [ResolveSipAuthRequest] instance.
  ResolveSipAuthRequest({
    this.fromHost,
    required this.sipCallerNumber,
    required this.sipTrunkNumber,
    this.sourceIp,
  });

  /// Host from the SIP From header
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fromHost;

  /// SIP caller number
  String sipCallerNumber;

  /// SIP trunk number to look up
  String sipTrunkNumber;

  /// Transport-layer source IP address of the SIP request
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sourceIp;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolveSipAuthRequest &&
          other.fromHost == fromHost &&
          other.sipCallerNumber == sipCallerNumber &&
          other.sipTrunkNumber == sipTrunkNumber &&
          other.sourceIp == sourceIp;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (fromHost == null ? 0 : fromHost!.hashCode) +
      (sipCallerNumber.hashCode) +
      (sipTrunkNumber.hashCode) +
      (sourceIp == null ? 0 : sourceIp!.hashCode);

  @override
  String toString() =>
      'ResolveSipAuthRequest[fromHost=$fromHost, sipCallerNumber=$sipCallerNumber, sipTrunkNumber=$sipTrunkNumber, sourceIp=$sourceIp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.fromHost != null) {
      json[r'from_host'] = this.fromHost;
    } else {
      json[r'from_host'] = null;
    }
    json[r'sip_caller_number'] = this.sipCallerNumber;
    json[r'sip_trunk_number'] = this.sipTrunkNumber;
    if (this.sourceIp != null) {
      json[r'source_ip'] = this.sourceIp;
    } else {
      json[r'source_ip'] = null;
    }
    return json;
  }

  /// Returns a new [ResolveSipAuthRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ResolveSipAuthRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sip_caller_number'),
            'Required key "ResolveSipAuthRequest[sip_caller_number]" is missing from JSON.');
        assert(json[r'sip_caller_number'] != null,
            'Required key "ResolveSipAuthRequest[sip_caller_number]" has a null value in JSON.');
        assert(json.containsKey(r'sip_trunk_number'),
            'Required key "ResolveSipAuthRequest[sip_trunk_number]" is missing from JSON.');
        assert(json[r'sip_trunk_number'] != null,
            'Required key "ResolveSipAuthRequest[sip_trunk_number]" has a null value in JSON.');
        return true;
      }());

      return ResolveSipAuthRequest(
        fromHost: mapValueOfType<String>(json, r'from_host'),
        sipCallerNumber: mapValueOfType<String>(json, r'sip_caller_number')!,
        sipTrunkNumber: mapValueOfType<String>(json, r'sip_trunk_number')!,
        sourceIp: mapValueOfType<String>(json, r'source_ip'),
      );
    }
    return null;
  }

  static List<ResolveSipAuthRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ResolveSipAuthRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ResolveSipAuthRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ResolveSipAuthRequest> mapFromJson(dynamic json) {
    final map = <String, ResolveSipAuthRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ResolveSipAuthRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ResolveSipAuthRequest-objects as value to a dart map
  static Map<String, List<ResolveSipAuthRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ResolveSipAuthRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ResolveSipAuthRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sip_caller_number',
    'sip_trunk_number',
  };
}
