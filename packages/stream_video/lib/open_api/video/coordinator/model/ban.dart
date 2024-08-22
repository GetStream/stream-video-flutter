//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Ban {
  /// Returns a new [Ban] instance.
  Ban({
    this.channel,
    required this.createdAt,
    this.createdBy,
    this.expires,
    this.reason,
    required this.shadow,
    this.target,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Channel? channel;

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? createdBy;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expires;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  bool shadow;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? target;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Ban &&
    other.channel == channel &&
    other.createdAt == createdAt &&
    other.createdBy == createdBy &&
    other.expires == expires &&
    other.reason == reason &&
    other.shadow == shadow &&
    other.target == target;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (channel == null ? 0 : channel!.hashCode) +
    (createdAt.hashCode) +
    (createdBy == null ? 0 : createdBy!.hashCode) +
    (expires == null ? 0 : expires!.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (shadow.hashCode) +
    (target == null ? 0 : target!.hashCode);

  @override
  String toString() => 'Ban[channel=$channel, createdAt=$createdAt, createdBy=$createdBy, expires=$expires, reason=$reason, shadow=$shadow, target=$target]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.channel != null) {
      json[r'channel'] = this.channel;
    } else {
      json[r'channel'] = null;
    }
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.createdBy != null) {
      json[r'created_by'] = this.createdBy;
    } else {
      json[r'created_by'] = null;
    }
    if (this.expires != null) {
      json[r'expires'] = this.expires!.toUtc().toIso8601String();
    } else {
      json[r'expires'] = null;
    }
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
      json[r'shadow'] = this.shadow;
    if (this.target != null) {
      json[r'target'] = this.target;
    } else {
      json[r'target'] = null;
    }
    return json;
  }

  /// Returns a new [Ban] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Ban? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Ban[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Ban[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Ban(
        channel: Channel.fromJson(json[r'channel']),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        createdBy: UserObject.fromJson(json[r'created_by']),
        expires: mapDateTime(json, r'expires', r''),
        reason: mapValueOfType<String>(json, r'reason'),
        shadow: mapValueOfType<bool>(json, r'shadow')!,
        target: UserObject.fromJson(json[r'target']),
      );
    }
    return null;
  }

  static List<Ban> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Ban>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Ban.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Ban> mapFromJson(dynamic json) {
    final map = <String, Ban>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Ban.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Ban-objects as value to a dart map
  static Map<String, List<Ban>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Ban>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Ban.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'shadow',
  };
}

