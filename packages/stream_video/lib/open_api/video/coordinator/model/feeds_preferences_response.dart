//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FeedsPreferencesResponse {
  /// Returns a new [FeedsPreferencesResponse] instance.
  FeedsPreferencesResponse({
    this.comment,
    this.commentReaction,
    this.customActivityTypes = const {},
    this.follow,
    this.mention,
    this.reaction,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? comment;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? commentReaction;

  Map<String, String> customActivityTypes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? follow;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? mention;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reaction;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedsPreferencesResponse &&
          other.comment == comment &&
          other.commentReaction == commentReaction &&
          _deepEquality.equals(
              other.customActivityTypes, customActivityTypes) &&
          other.follow == follow &&
          other.mention == mention &&
          other.reaction == reaction;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (comment == null ? 0 : comment!.hashCode) +
      (commentReaction == null ? 0 : commentReaction!.hashCode) +
      (customActivityTypes.hashCode) +
      (follow == null ? 0 : follow!.hashCode) +
      (mention == null ? 0 : mention!.hashCode) +
      (reaction == null ? 0 : reaction!.hashCode);

  @override
  String toString() =>
      'FeedsPreferencesResponse[comment=$comment, commentReaction=$commentReaction, customActivityTypes=$customActivityTypes, follow=$follow, mention=$mention, reaction=$reaction]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.comment != null) {
      json[r'comment'] = this.comment;
    } else {
      json[r'comment'] = null;
    }
    if (this.commentReaction != null) {
      json[r'comment_reaction'] = this.commentReaction;
    } else {
      json[r'comment_reaction'] = null;
    }
    json[r'custom_activity_types'] = this.customActivityTypes;
    if (this.follow != null) {
      json[r'follow'] = this.follow;
    } else {
      json[r'follow'] = null;
    }
    if (this.mention != null) {
      json[r'mention'] = this.mention;
    } else {
      json[r'mention'] = null;
    }
    if (this.reaction != null) {
      json[r'reaction'] = this.reaction;
    } else {
      json[r'reaction'] = null;
    }
    return json;
  }

  /// Returns a new [FeedsPreferencesResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FeedsPreferencesResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FeedsPreferencesResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FeedsPreferencesResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FeedsPreferencesResponse(
        comment: mapValueOfType<String>(json, r'comment'),
        commentReaction: mapValueOfType<String>(json, r'comment_reaction'),
        customActivityTypes:
            mapCastOfType<String, String>(json, r'custom_activity_types') ??
                const {},
        follow: mapValueOfType<String>(json, r'follow'),
        mention: mapValueOfType<String>(json, r'mention'),
        reaction: mapValueOfType<String>(json, r'reaction'),
      );
    }
    return null;
  }

  static List<FeedsPreferencesResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FeedsPreferencesResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FeedsPreferencesResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FeedsPreferencesResponse> mapFromJson(dynamic json) {
    final map = <String, FeedsPreferencesResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FeedsPreferencesResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FeedsPreferencesResponse-objects as value to a dart map
  static Map<String, List<FeedsPreferencesResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FeedsPreferencesResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FeedsPreferencesResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
