//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RingSettingsRequest {
  /// Returns a new [RingSettingsRequest] instance.
  RingSettingsRequest({
    this.autoCancelTimeoutMs,
    this.autoRejectTimeoutMs,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? autoCancelTimeoutMs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? autoRejectTimeoutMs;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RingSettingsRequest &&
     other.autoCancelTimeoutMs == autoCancelTimeoutMs &&
     other.autoRejectTimeoutMs == autoRejectTimeoutMs;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (autoCancelTimeoutMs == null ? 0 : autoCancelTimeoutMs!.hashCode) +
    (autoRejectTimeoutMs == null ? 0 : autoRejectTimeoutMs!.hashCode);

  @override
  String toString() => 'RingSettingsRequest[autoCancelTimeoutMs=$autoCancelTimeoutMs, autoRejectTimeoutMs=$autoRejectTimeoutMs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.autoCancelTimeoutMs != null) {
      json[r'auto_cancel_timeout_ms'] = this.autoCancelTimeoutMs;
    } else {
      json[r'auto_cancel_timeout_ms'] = null;
    }
    if (this.autoRejectTimeoutMs != null) {
      json[r'auto_reject_timeout_ms'] = this.autoRejectTimeoutMs;
    } else {
      json[r'auto_reject_timeout_ms'] = null;
    }
    return json;
  }

  /// Returns a new [RingSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RingSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RingSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RingSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RingSettingsRequest(
        autoCancelTimeoutMs: mapValueOfType<int>(json, r'auto_cancel_timeout_ms'),
        autoRejectTimeoutMs: mapValueOfType<int>(json, r'auto_reject_timeout_ms'),
      );
    }
    return null;
  }

  static List<RingSettingsRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RingSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RingSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RingSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, RingSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RingSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RingSettingsRequest-objects as value to a dart map
  static Map<String, List<RingSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RingSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RingSettingsRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

