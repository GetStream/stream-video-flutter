//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Subsession {
  /// Returns a new [Subsession] instance.
  Subsession({
    required this.endedAt,
    required this.joinedAt,
    this.pubSubHint,
    required this.sfuId,
  });

  int endedAt;

  int joinedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MediaPubSubHint? pubSubHint;

  String sfuId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Subsession &&
    other.endedAt == endedAt &&
    other.joinedAt == joinedAt &&
    other.pubSubHint == pubSubHint &&
    other.sfuId == sfuId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (endedAt.hashCode) +
    (joinedAt.hashCode) +
    (pubSubHint == null ? 0 : pubSubHint!.hashCode) +
    (sfuId.hashCode);

  @override
  String toString() => 'Subsession[endedAt=$endedAt, joinedAt=$joinedAt, pubSubHint=$pubSubHint, sfuId=$sfuId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ended_at'] = this.endedAt;
      json[r'joined_at'] = this.joinedAt;
    if (this.pubSubHint != null) {
      json[r'pub_sub_hint'] = this.pubSubHint;
    } else {
      json[r'pub_sub_hint'] = null;
    }
      json[r'sfu_id'] = this.sfuId;
    return json;
  }

  /// Returns a new [Subsession] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Subsession? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Subsession[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Subsession[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Subsession(
        endedAt: mapValueOfType<int>(json, r'ended_at')!,
        joinedAt: mapValueOfType<int>(json, r'joined_at')!,
        pubSubHint: MediaPubSubHint.fromJson(json[r'pub_sub_hint']),
        sfuId: mapValueOfType<String>(json, r'sfu_id')!,
      );
    }
    return null;
  }

  static List<Subsession> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Subsession>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Subsession.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Subsession> mapFromJson(dynamic json) {
    final map = <String, Subsession>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Subsession.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Subsession-objects as value to a dart map
  static Map<String, List<Subsession>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Subsession>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Subsession.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'ended_at',
    'joined_at',
    'sfu_id',
  };
}

