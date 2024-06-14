//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RingSettingsResponse {
  /// Returns a new [RingSettingsResponse] instance.
  RingSettingsResponse({
    required this.autoCancelTimeoutMs,
    required this.incomingCallTimeoutMs,
    required this.missedCallTimeoutMs,
  });

  int autoCancelTimeoutMs;

  int incomingCallTimeoutMs;

  int missedCallTimeoutMs;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RingSettingsResponse &&
    other.autoCancelTimeoutMs == autoCancelTimeoutMs &&
    other.incomingCallTimeoutMs == incomingCallTimeoutMs &&
    other.missedCallTimeoutMs == missedCallTimeoutMs;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (autoCancelTimeoutMs.hashCode) +
    (incomingCallTimeoutMs.hashCode) +
    (missedCallTimeoutMs.hashCode);

  @override
  String toString() => 'RingSettingsResponse[autoCancelTimeoutMs=$autoCancelTimeoutMs, incomingCallTimeoutMs=$incomingCallTimeoutMs, missedCallTimeoutMs=$missedCallTimeoutMs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'auto_cancel_timeout_ms'] = this.autoCancelTimeoutMs;
      json[r'incoming_call_timeout_ms'] = this.incomingCallTimeoutMs;
      json[r'missed_call_timeout_ms'] = this.missedCallTimeoutMs;
    return json;
  }

  /// Returns a new [RingSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RingSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RingSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RingSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RingSettingsResponse(
        autoCancelTimeoutMs: mapValueOfType<int>(json, r'auto_cancel_timeout_ms')!,
        incomingCallTimeoutMs: mapValueOfType<int>(json, r'incoming_call_timeout_ms')!,
        missedCallTimeoutMs: mapValueOfType<int>(json, r'missed_call_timeout_ms')!,
      );
    }
    return null;
  }

  static List<RingSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RingSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RingSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RingSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, RingSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RingSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RingSettingsResponse-objects as value to a dart map
  static Map<String, List<RingSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RingSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RingSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'auto_cancel_timeout_ms',
    'incoming_call_timeout_ms',
    'missed_call_timeout_ms',
  };
}

