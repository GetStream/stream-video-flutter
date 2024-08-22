//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Reaction {
  /// Returns a new [Reaction] instance.
  Reaction({
    required this.createdAt,
    this.custom = const {},
    required this.messageId,
    required this.score,
    required this.type,
    required this.updatedAt,
    this.user,
    this.userId,
  });

  /// Date/time of creation
  DateTime createdAt;

  Map<String, Object> custom;

  /// ID of a message user reacted to
  String messageId;

  /// Reaction score. If not specified reaction has score of 1
  int score;

  /// The type of reaction (e.g. 'like', 'laugh', 'wow')
  String type;

  /// Date/time of the last update
  DateTime updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  /// ID of a user who reacted to a message
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Reaction &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.custom, custom) &&
    other.messageId == messageId &&
    other.score == score &&
    other.type == type &&
    other.updatedAt == updatedAt &&
    other.user == user &&
    other.userId == userId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (custom.hashCode) +
    (messageId.hashCode) +
    (score.hashCode) +
    (type.hashCode) +
    (updatedAt.hashCode) +
    (user == null ? 0 : user!.hashCode) +
    (userId == null ? 0 : userId!.hashCode);

  @override
  String toString() => 'Reaction[createdAt=$createdAt, custom=$custom, messageId=$messageId, score=$score, type=$type, updatedAt=$updatedAt, user=$user, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'custom'] = this.custom;
      json[r'message_id'] = this.messageId;
      json[r'score'] = this.score;
      json[r'type'] = this.type;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    if (this.userId != null) {
      json[r'user_id'] = this.userId;
    } else {
      json[r'user_id'] = null;
    }
    return json;
  }

  /// Returns a new [Reaction] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Reaction? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Reaction[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Reaction[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Reaction(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        messageId: mapValueOfType<String>(json, r'message_id')!,
        score: mapValueOfType<int>(json, r'score')!,
        type: mapValueOfType<String>(json, r'type')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        user: UserObject.fromJson(json[r'user']),
        userId: mapValueOfType<String>(json, r'user_id'),
      );
    }
    return null;
  }

  static List<Reaction> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Reaction>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Reaction.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Reaction> mapFromJson(dynamic json) {
    final map = <String, Reaction>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Reaction.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Reaction-objects as value to a dart map
  static Map<String, List<Reaction>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Reaction>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Reaction.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'custom',
    'message_id',
    'score',
    'type',
    'updated_at',
  };
}

