//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EnrichedReaction {
  /// Returns a new [EnrichedReaction] instance.
  EnrichedReaction({
    required this.activityId,
    this.childrenCounts = const {},
    this.createdAt,
    this.data = const {},
    this.id,
    required this.kind,
    this.latestChildren = const {},
    this.ownChildren = const {},
    this.parent,
    this.targetFeeds = const [],
    this.updatedAt,
    this.user,
    required this.userId,
  });

  String activityId;

  Map<String, int> childrenCounts;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? createdAt;

  Map<String, Object> data;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  String kind;

  Map<String, List<EnrichedReaction>> latestChildren;

  Map<String, List<EnrichedReaction>> ownChildren;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? parent;

  List<String> targetFeeds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Data? user;

  String userId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EnrichedReaction &&
    other.activityId == activityId &&
    _deepEquality.equals(other.childrenCounts, childrenCounts) &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.data, data) &&
    other.id == id &&
    other.kind == kind &&
    _deepEquality.equals(other.latestChildren, latestChildren) &&
    _deepEquality.equals(other.ownChildren, ownChildren) &&
    other.parent == parent &&
    _deepEquality.equals(other.targetFeeds, targetFeeds) &&
    other.updatedAt == updatedAt &&
    other.user == user &&
    other.userId == userId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (activityId.hashCode) +
    (childrenCounts.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (data.hashCode) +
    (id == null ? 0 : id!.hashCode) +
    (kind.hashCode) +
    (latestChildren.hashCode) +
    (ownChildren.hashCode) +
    (parent == null ? 0 : parent!.hashCode) +
    (targetFeeds.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode) +
    (user == null ? 0 : user!.hashCode) +
    (userId.hashCode);

  @override
  String toString() => 'EnrichedReaction[activityId=$activityId, childrenCounts=$childrenCounts, createdAt=$createdAt, data=$data, id=$id, kind=$kind, latestChildren=$latestChildren, ownChildren=$ownChildren, parent=$parent, targetFeeds=$targetFeeds, updatedAt=$updatedAt, user=$user, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'activity_id'] = this.activityId;
      json[r'children_counts'] = this.childrenCounts;
    if (this.createdAt != null) {
      json[r'created_at'] = this.createdAt;
    } else {
      json[r'created_at'] = null;
    }
      json[r'data'] = this.data;
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
      json[r'kind'] = this.kind;
      json[r'latest_children'] = this.latestChildren;
      json[r'own_children'] = this.ownChildren;
    if (this.parent != null) {
      json[r'parent'] = this.parent;
    } else {
      json[r'parent'] = null;
    }
      json[r'target_feeds'] = this.targetFeeds;
    if (this.updatedAt != null) {
      json[r'updated_at'] = this.updatedAt;
    } else {
      json[r'updated_at'] = null;
    }
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
      json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [EnrichedReaction] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EnrichedReaction? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EnrichedReaction[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EnrichedReaction[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EnrichedReaction(
        activityId: mapValueOfType<String>(json, r'activity_id')!,
        childrenCounts: mapCastOfType<String, int>(json, r'children_counts') ?? const {},
        createdAt: mapValueOfType<Object>(json, r'created_at'),
        data: mapCastOfType<String, Object>(json, r'data') ?? const {},
        id: mapValueOfType<String>(json, r'id'),
        kind: mapValueOfType<String>(json, r'kind')!,
        latestChildren: json[r'latest_children'] == null
          ? const {}
            : EnrichedReaction.mapListFromJson(json[r'latest_children']),
        ownChildren: json[r'own_children'] == null
          ? const {}
            : EnrichedReaction.mapListFromJson(json[r'own_children']),
        parent: mapValueOfType<String>(json, r'parent'),
        targetFeeds: json[r'target_feeds'] is Iterable
            ? (json[r'target_feeds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        updatedAt: mapValueOfType<Object>(json, r'updated_at'),
        user: Data.fromJson(json[r'user']),
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<EnrichedReaction> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EnrichedReaction>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EnrichedReaction.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EnrichedReaction> mapFromJson(dynamic json) {
    final map = <String, EnrichedReaction>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EnrichedReaction.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EnrichedReaction-objects as value to a dart map
  static Map<String, List<EnrichedReaction>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EnrichedReaction>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EnrichedReaction.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'activity_id',
    'kind',
    'user_id',
  };
}

