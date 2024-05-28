//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserStats {
  /// Returns a new [UserStats] instance.
  UserStats({
    required this.info,
    required this.minEventTs,
    this.rating,
    this.sessionStats = const [],
  });

  UserInfoResponse info;

  int minEventTs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? rating;

  List<UserSessionStats> sessionStats;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserStats &&
    other.info == info &&
    other.minEventTs == minEventTs &&
    other.rating == rating &&
    _deepEquality.equals(other.sessionStats, sessionStats);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (info.hashCode) +
    (minEventTs.hashCode) +
    (rating == null ? 0 : rating!.hashCode) +
    (sessionStats.hashCode);

  @override
  String toString() => 'UserStats[info=$info, minEventTs=$minEventTs, rating=$rating, sessionStats=$sessionStats]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'info'] = this.info;
      json[r'min_event_ts'] = this.minEventTs;
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
      json[r'session_stats'] = this.sessionStats;
    return json;
  }

  /// Returns a new [UserStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserStats[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserStats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserStats(
        info: UserInfoResponse.fromJson(json[r'info'])!,
        minEventTs: mapValueOfType<int>(json, r'min_event_ts')!,
        rating: mapValueOfType<int>(json, r'rating'),
        sessionStats: UserSessionStats.listFromJson(json[r'session_stats']),
      );
    }
    return null;
  }

  static List<UserStats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserStats> mapFromJson(dynamic json) {
    final map = <String, UserStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserStats-objects as value to a dart map
  static Map<String, List<UserStats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserStats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'info',
    'min_event_ts',
    'session_stats',
  };
}

