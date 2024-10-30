//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Flag2 {
  /// Returns a new [Flag2] instance.
  Flag2({
    required this.createdAt,
    this.custom = const {},
    this.entityCreatorId,
    required this.entityId,
    required this.entityType,
    this.labels = const [],
    this.moderationPayload,
    this.moderationPayloadHash,
    this.reason,
    this.result = const [],
    this.reviewQueueItemId,
    this.type,
    required this.updatedAt,
    this.user,
  });

  DateTime createdAt;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? entityCreatorId;

  String entityId;

  String entityType;

  List<String> labels;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ModerationPayload? moderationPayload;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? moderationPayloadHash;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  List<Map<String, Object>> result;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reviewQueueItemId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? type;

  DateTime updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Flag2 &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.custom, custom) &&
    other.entityCreatorId == entityCreatorId &&
    other.entityId == entityId &&
    other.entityType == entityType &&
    _deepEquality.equals(other.labels, labels) &&
    other.moderationPayload == moderationPayload &&
    other.moderationPayloadHash == moderationPayloadHash &&
    other.reason == reason &&
    _deepEquality.equals(other.result, result) &&
    other.reviewQueueItemId == reviewQueueItemId &&
    other.type == type &&
    other.updatedAt == updatedAt &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (custom.hashCode) +
    (entityCreatorId == null ? 0 : entityCreatorId!.hashCode) +
    (entityId.hashCode) +
    (entityType.hashCode) +
    (labels.hashCode) +
    (moderationPayload == null ? 0 : moderationPayload!.hashCode) +
    (moderationPayloadHash == null ? 0 : moderationPayloadHash!.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (result.hashCode) +
    (reviewQueueItemId == null ? 0 : reviewQueueItemId!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (updatedAt.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'Flag2[createdAt=$createdAt, custom=$custom, entityCreatorId=$entityCreatorId, entityId=$entityId, entityType=$entityType, labels=$labels, moderationPayload=$moderationPayload, moderationPayloadHash=$moderationPayloadHash, reason=$reason, result=$result, reviewQueueItemId=$reviewQueueItemId, type=$type, updatedAt=$updatedAt, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'custom'] = this.custom;
    if (this.entityCreatorId != null) {
      json[r'entity_creator_id'] = this.entityCreatorId;
    } else {
      json[r'entity_creator_id'] = null;
    }
      json[r'entity_id'] = this.entityId;
      json[r'entity_type'] = this.entityType;
      json[r'labels'] = this.labels;
    if (this.moderationPayload != null) {
      json[r'moderation_payload'] = this.moderationPayload;
    } else {
      json[r'moderation_payload'] = null;
    }
    if (this.moderationPayloadHash != null) {
      json[r'moderation_payload_hash'] = this.moderationPayloadHash;
    } else {
      json[r'moderation_payload_hash'] = null;
    }
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
      json[r'result'] = this.result;
    if (this.reviewQueueItemId != null) {
      json[r'review_queue_item_id'] = this.reviewQueueItemId;
    } else {
      json[r'review_queue_item_id'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [Flag2] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Flag2? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Flag2[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Flag2[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Flag2(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        entityCreatorId: mapValueOfType<String>(json, r'entity_creator_id'),
        entityId: mapValueOfType<String>(json, r'entity_id')!,
        entityType: mapValueOfType<String>(json, r'entity_type')!,
        labels: json[r'labels'] is Iterable
            ? (json[r'labels'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        moderationPayload: ModerationPayload.fromJson(json[r'moderation_payload']),
        moderationPayloadHash: mapValueOfType<String>(json, r'moderation_payload_hash'),
        reason: mapValueOfType<String>(json, r'reason'),
        // MANUAL_EDIT: mapListOfMapFromJson() instead of mapFromJson()
        result: mapListOfMapFromJson(json[r'result']),
        reviewQueueItemId: mapValueOfType<String>(json, r'review_queue_item_id'),
        type: mapValueOfType<String>(json, r'type'),
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        user: UserObject.fromJson(json[r'user']),
      );
    }
    return null;
  }

    static List<Map<String, Object>> mapListOfMapFromJson(dynamic json) {
    if (json is! List) {
      return [];
    }

    List<Map<String, Object>> result = [];

    for (var item in json) {
      if (item is Map<String, Object>) {
        result.add(item);
      }
    }

    return result;
  }

  static List<Flag2> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Flag2>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Flag2.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Flag2> mapFromJson(dynamic json) {
    final map = <String, Flag2>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Flag2.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Flag2-objects as value to a dart map
  static Map<String, List<Flag2>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Flag2>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Flag2.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'entity_id',
    'entity_type',
    'result',
    'updated_at',
  };
}

