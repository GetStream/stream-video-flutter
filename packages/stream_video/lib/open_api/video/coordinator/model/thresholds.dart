//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Thresholds {
  /// Returns a new [Thresholds] instance.
  Thresholds({
    this.explicit,
    this.spam,
    this.toxic,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  LabelThresholds? explicit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  LabelThresholds? spam;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  LabelThresholds? toxic;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Thresholds &&
    other.explicit == explicit &&
    other.spam == spam &&
    other.toxic == toxic;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (explicit == null ? 0 : explicit!.hashCode) +
    (spam == null ? 0 : spam!.hashCode) +
    (toxic == null ? 0 : toxic!.hashCode);

  @override
  String toString() => 'Thresholds[explicit=$explicit, spam=$spam, toxic=$toxic]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.explicit != null) {
      json[r'explicit'] = this.explicit;
    } else {
      json[r'explicit'] = null;
    }
    if (this.spam != null) {
      json[r'spam'] = this.spam;
    } else {
      json[r'spam'] = null;
    }
    if (this.toxic != null) {
      json[r'toxic'] = this.toxic;
    } else {
      json[r'toxic'] = null;
    }
    return json;
  }

  /// Returns a new [Thresholds] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Thresholds? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Thresholds[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Thresholds[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Thresholds(
        explicit: LabelThresholds.fromJson(json[r'explicit']),
        spam: LabelThresholds.fromJson(json[r'spam']),
        toxic: LabelThresholds.fromJson(json[r'toxic']),
      );
    }
    return null;
  }

  static List<Thresholds> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Thresholds>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Thresholds.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Thresholds> mapFromJson(dynamic json) {
    final map = <String, Thresholds>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Thresholds.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Thresholds-objects as value to a dart map
  static Map<String, List<Thresholds>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Thresholds>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Thresholds.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

