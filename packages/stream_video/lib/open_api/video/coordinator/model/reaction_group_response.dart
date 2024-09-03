//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReactionGroupResponse {
  /// Returns a new [ReactionGroupResponse] instance.
  ReactionGroupResponse({
    required this.count,
    required this.firstReactionAt,
    required this.lastReactionAt,
    required this.sumScores,
  });

  int count;

  DateTime firstReactionAt;

  DateTime lastReactionAt;

  int sumScores;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReactionGroupResponse &&
    other.count == count &&
    other.firstReactionAt == firstReactionAt &&
    other.lastReactionAt == lastReactionAt &&
    other.sumScores == sumScores;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (count.hashCode) +
    (firstReactionAt.hashCode) +
    (lastReactionAt.hashCode) +
    (sumScores.hashCode);

  @override
  String toString() => 'ReactionGroupResponse[count=$count, firstReactionAt=$firstReactionAt, lastReactionAt=$lastReactionAt, sumScores=$sumScores]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'count'] = this.count;
      json[r'first_reaction_at'] = this.firstReactionAt.toUtc().toIso8601String();
      json[r'last_reaction_at'] = this.lastReactionAt.toUtc().toIso8601String();
      json[r'sum_scores'] = this.sumScores;
    return json;
  }

  /// Returns a new [ReactionGroupResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReactionGroupResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReactionGroupResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReactionGroupResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReactionGroupResponse(
        count: mapValueOfType<int>(json, r'count')!,
        firstReactionAt: mapDateTime(json, r'first_reaction_at', r'')!,
        lastReactionAt: mapDateTime(json, r'last_reaction_at', r'')!,
        sumScores: mapValueOfType<int>(json, r'sum_scores')!,
      );
    }
    return null;
  }

  static List<ReactionGroupResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReactionGroupResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReactionGroupResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReactionGroupResponse> mapFromJson(dynamic json) {
    final map = <String, ReactionGroupResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReactionGroupResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReactionGroupResponse-objects as value to a dart map
  static Map<String, List<ReactionGroupResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReactionGroupResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReactionGroupResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'count',
    'first_reaction_at',
    'last_reaction_at',
    'sum_scores',
  };
}

