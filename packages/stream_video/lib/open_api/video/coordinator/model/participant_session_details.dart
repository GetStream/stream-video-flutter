//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantSessionDetails {
  /// Returns a new [ParticipantSessionDetails] instance.
  ParticipantSessionDetails({
    this.durationInSeconds,
    this.joinedAt,
    this.leftAt,
    required this.publisherType,
    this.roles = const [],
    required this.userId,
    required this.userSessionId,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? durationInSeconds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? joinedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? leftAt;

  String publisherType;

  List<String> roles;

  String userId;

  String userSessionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantSessionDetails &&
          other.durationInSeconds == durationInSeconds &&
          other.joinedAt == joinedAt &&
          other.leftAt == leftAt &&
          other.publisherType == publisherType &&
          _deepEquality.equals(other.roles, roles) &&
          other.userId == userId &&
          other.userSessionId == userSessionId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (durationInSeconds == null ? 0 : durationInSeconds!.hashCode) +
      (joinedAt == null ? 0 : joinedAt!.hashCode) +
      (leftAt == null ? 0 : leftAt!.hashCode) +
      (publisherType.hashCode) +
      (roles.hashCode) +
      (userId.hashCode) +
      (userSessionId.hashCode);

  @override
  String toString() =>
      'ParticipantSessionDetails[durationInSeconds=$durationInSeconds, joinedAt=$joinedAt, leftAt=$leftAt, publisherType=$publisherType, roles=$roles, userId=$userId, userSessionId=$userSessionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.durationInSeconds != null) {
      json[r'duration_in_seconds'] = this.durationInSeconds;
    } else {
      json[r'duration_in_seconds'] = null;
    }
    if (this.joinedAt != null) {
      json[r'joined_at'] = this.joinedAt!.toUtc().toIso8601String();
    } else {
      json[r'joined_at'] = null;
    }
    if (this.leftAt != null) {
      json[r'left_at'] = this.leftAt!.toUtc().toIso8601String();
    } else {
      json[r'left_at'] = null;
    }
    json[r'publisher_type'] = this.publisherType;
    json[r'roles'] = this.roles;
    json[r'user_id'] = this.userId;
    json[r'user_session_id'] = this.userSessionId;
    return json;
  }

  /// Returns a new [ParticipantSessionDetails] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantSessionDetails? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'publisher_type'),
            'Required key "ParticipantSessionDetails[publisher_type]" is missing from JSON.');
        assert(json[r'publisher_type'] != null,
            'Required key "ParticipantSessionDetails[publisher_type]" has a null value in JSON.');
        assert(json.containsKey(r'roles'),
            'Required key "ParticipantSessionDetails[roles]" is missing from JSON.');
        assert(json[r'roles'] != null,
            'Required key "ParticipantSessionDetails[roles]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "ParticipantSessionDetails[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "ParticipantSessionDetails[user_id]" has a null value in JSON.');
        assert(json.containsKey(r'user_session_id'),
            'Required key "ParticipantSessionDetails[user_session_id]" is missing from JSON.');
        assert(json[r'user_session_id'] != null,
            'Required key "ParticipantSessionDetails[user_session_id]" has a null value in JSON.');
        return true;
      }());

      return ParticipantSessionDetails(
        durationInSeconds: mapValueOfType<int>(json, r'duration_in_seconds'),
        joinedAt: mapDateTime(json, r'joined_at', r''),
        leftAt: mapDateTime(json, r'left_at', r''),
        publisherType: mapValueOfType<String>(json, r'publisher_type')!,
        roles: json[r'roles'] is Iterable
            ? (json[r'roles'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        userId: mapValueOfType<String>(json, r'user_id')!,
        userSessionId: mapValueOfType<String>(json, r'user_session_id')!,
      );
    }
    return null;
  }

  static List<ParticipantSessionDetails> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ParticipantSessionDetails>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantSessionDetails.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantSessionDetails> mapFromJson(dynamic json) {
    final map = <String, ParticipantSessionDetails>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ParticipantSessionDetails.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantSessionDetails-objects as value to a dart map
  static Map<String, List<ParticipantSessionDetails>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ParticipantSessionDetails>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantSessionDetails.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'publisher_type',
    'roles',
    'user_id',
    'user_session_id',
  };
}
