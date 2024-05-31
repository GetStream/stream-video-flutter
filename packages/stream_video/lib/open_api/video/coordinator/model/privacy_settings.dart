//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PrivacySettings {
  /// Returns a new [PrivacySettings] instance.
  PrivacySettings({
    this.readReceipts,
    this.typingIndicators,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ReadReceipts? readReceipts;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TypingIndicators? typingIndicators;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PrivacySettings &&
    other.readReceipts == readReceipts &&
    other.typingIndicators == typingIndicators;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (readReceipts == null ? 0 : readReceipts!.hashCode) +
    (typingIndicators == null ? 0 : typingIndicators!.hashCode);

  @override
  String toString() => 'PrivacySettings[readReceipts=$readReceipts, typingIndicators=$typingIndicators]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.readReceipts != null) {
      json[r'read_receipts'] = this.readReceipts;
    } else {
      json[r'read_receipts'] = null;
    }
    if (this.typingIndicators != null) {
      json[r'typing_indicators'] = this.typingIndicators;
    } else {
      json[r'typing_indicators'] = null;
    }
    return json;
  }

  /// Returns a new [PrivacySettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PrivacySettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PrivacySettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PrivacySettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PrivacySettings(
        readReceipts: ReadReceipts.fromJson(json[r'read_receipts']),
        typingIndicators: TypingIndicators.fromJson(json[r'typing_indicators']),
      );
    }
    return null;
  }

  static List<PrivacySettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PrivacySettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PrivacySettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PrivacySettings> mapFromJson(dynamic json) {
    final map = <String, PrivacySettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PrivacySettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PrivacySettings-objects as value to a dart map
  static Map<String, List<PrivacySettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PrivacySettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PrivacySettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

