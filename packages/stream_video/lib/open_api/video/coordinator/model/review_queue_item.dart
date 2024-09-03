//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReviewQueueItem {
  /// Returns a new [ReviewQueueItem] instance.
  ReviewQueueItem({
    this.actions = const [],
    this.assignedTo,
    this.bans = const [],
    required this.completedAt,
    required this.contentChanged,
    required this.createdAt,
    this.entityCreator,
    required this.entityId,
    required this.entityType,
    this.feedsV2Activity,
    this.feedsV2Reaction,
    this.flags = const [],
    required this.hasImage,
    required this.hasText,
    required this.hasVideo,
    required this.id,
    this.languages = const [],
    this.message,
    this.moderationPayload,
    required this.moderationPayloadHash,
    required this.recommendedAction,
    required this.reviewedAt,
    required this.reviewedBy,
    required this.severity,
    required this.status,
    required this.updatedAt,
  });

  List<ActionLog> actions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? assignedTo;

  List<Ban> bans;

  NullTime completedAt;

  bool contentChanged;

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? entityCreator;

  String entityId;

  String entityType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  EnrichedActivity? feedsV2Activity;

  Reaction? feedsV2Reaction;

  List<Flag2> flags;

  bool hasImage;

  bool hasText;

  bool hasVideo;

  String id;

  List<String> languages;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Message? message;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ModerationPayload? moderationPayload;

  String moderationPayloadHash;

  String recommendedAction;

  NullTime reviewedAt;

  String reviewedBy;

  int severity;

  String status;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewQueueItem &&
    _deepEquality.equals(other.actions, actions) &&
    other.assignedTo == assignedTo &&
    _deepEquality.equals(other.bans, bans) &&
    other.completedAt == completedAt &&
    other.contentChanged == contentChanged &&
    other.createdAt == createdAt &&
    other.entityCreator == entityCreator &&
    other.entityId == entityId &&
    other.entityType == entityType &&
    other.feedsV2Activity == feedsV2Activity &&
    other.feedsV2Reaction == feedsV2Reaction &&
    _deepEquality.equals(other.flags, flags) &&
    other.hasImage == hasImage &&
    other.hasText == hasText &&
    other.hasVideo == hasVideo &&
    other.id == id &&
    _deepEquality.equals(other.languages, languages) &&
    other.message == message &&
    other.moderationPayload == moderationPayload &&
    other.moderationPayloadHash == moderationPayloadHash &&
    other.recommendedAction == recommendedAction &&
    other.reviewedAt == reviewedAt &&
    other.reviewedBy == reviewedBy &&
    other.severity == severity &&
    other.status == status &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (actions.hashCode) +
    (assignedTo == null ? 0 : assignedTo!.hashCode) +
    (bans.hashCode) +
    (completedAt.hashCode) +
    (contentChanged.hashCode) +
    (createdAt.hashCode) +
    (entityCreator == null ? 0 : entityCreator!.hashCode) +
    (entityId.hashCode) +
    (entityType.hashCode) +
    (feedsV2Activity == null ? 0 : feedsV2Activity!.hashCode) +
    (feedsV2Reaction == null ? 0 : feedsV2Reaction!.hashCode) +
    (flags.hashCode) +
    (hasImage.hashCode) +
    (hasText.hashCode) +
    (hasVideo.hashCode) +
    (id.hashCode) +
    (languages.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (moderationPayload == null ? 0 : moderationPayload!.hashCode) +
    (moderationPayloadHash.hashCode) +
    (recommendedAction.hashCode) +
    (reviewedAt.hashCode) +
    (reviewedBy.hashCode) +
    (severity.hashCode) +
    (status.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'ReviewQueueItem[actions=$actions, assignedTo=$assignedTo, bans=$bans, completedAt=$completedAt, contentChanged=$contentChanged, createdAt=$createdAt, entityCreator=$entityCreator, entityId=$entityId, entityType=$entityType, feedsV2Activity=$feedsV2Activity, feedsV2Reaction=$feedsV2Reaction, flags=$flags, hasImage=$hasImage, hasText=$hasText, hasVideo=$hasVideo, id=$id, languages=$languages, message=$message, moderationPayload=$moderationPayload, moderationPayloadHash=$moderationPayloadHash, recommendedAction=$recommendedAction, reviewedAt=$reviewedAt, reviewedBy=$reviewedBy, severity=$severity, status=$status, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'actions'] = this.actions;
    if (this.assignedTo != null) {
      json[r'assigned_to'] = this.assignedTo;
    } else {
      json[r'assigned_to'] = null;
    }
      json[r'bans'] = this.bans;
      json[r'completed_at'] = this.completedAt;
      json[r'content_changed'] = this.contentChanged;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.entityCreator != null) {
      json[r'entity_creator'] = this.entityCreator;
    } else {
      json[r'entity_creator'] = null;
    }
      json[r'entity_id'] = this.entityId;
      json[r'entity_type'] = this.entityType;
    if (this.feedsV2Activity != null) {
      json[r'feeds_v2_activity'] = this.feedsV2Activity;
    } else {
      json[r'feeds_v2_activity'] = null;
    }
    if (this.feedsV2Reaction != null) {
      json[r'feeds_v2_reaction'] = this.feedsV2Reaction;
    } else {
      json[r'feeds_v2_reaction'] = null;
    }
      json[r'flags'] = this.flags;
      json[r'has_image'] = this.hasImage;
      json[r'has_text'] = this.hasText;
      json[r'has_video'] = this.hasVideo;
      json[r'id'] = this.id;
      json[r'languages'] = this.languages;
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.moderationPayload != null) {
      json[r'moderation_payload'] = this.moderationPayload;
    } else {
      json[r'moderation_payload'] = null;
    }
      json[r'moderation_payload_hash'] = this.moderationPayloadHash;
      json[r'recommended_action'] = this.recommendedAction;
      json[r'reviewed_at'] = this.reviewedAt;
      json[r'reviewed_by'] = this.reviewedBy;
      json[r'severity'] = this.severity;
      json[r'status'] = this.status;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ReviewQueueItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReviewQueueItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReviewQueueItem[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReviewQueueItem[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReviewQueueItem(
        actions: ActionLog.listFromJson(json[r'actions']),
        assignedTo: UserObject.fromJson(json[r'assigned_to']),
        bans: Ban.listFromJson(json[r'bans']),
        completedAt: NullTime.fromJson(json[r'completed_at'])!,
        contentChanged: mapValueOfType<bool>(json, r'content_changed')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        entityCreator: UserObject.fromJson(json[r'entity_creator']),
        entityId: mapValueOfType<String>(json, r'entity_id')!,
        entityType: mapValueOfType<String>(json, r'entity_type')!,
        feedsV2Activity: EnrichedActivity.fromJson(json[r'feeds_v2_activity']),
        feedsV2Reaction: Reaction.fromJson(json[r'feeds_v2_reaction']),
        flags: Flag2.listFromJson(json[r'flags']),
        hasImage: mapValueOfType<bool>(json, r'has_image')!,
        hasText: mapValueOfType<bool>(json, r'has_text')!,
        hasVideo: mapValueOfType<bool>(json, r'has_video')!,
        id: mapValueOfType<String>(json, r'id')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        message: Message.fromJson(json[r'message']),
        moderationPayload: ModerationPayload.fromJson(json[r'moderation_payload']),
        moderationPayloadHash: mapValueOfType<String>(json, r'moderation_payload_hash')!,
        recommendedAction: mapValueOfType<String>(json, r'recommended_action')!,
        reviewedAt: NullTime.fromJson(json[r'reviewed_at'])!,
        reviewedBy: mapValueOfType<String>(json, r'reviewed_by')!,
        severity: mapValueOfType<int>(json, r'severity')!,
        status: mapValueOfType<String>(json, r'status')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<ReviewQueueItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewQueueItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewQueueItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewQueueItem> mapFromJson(dynamic json) {
    final map = <String, ReviewQueueItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReviewQueueItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewQueueItem-objects as value to a dart map
  static Map<String, List<ReviewQueueItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewQueueItem>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewQueueItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'actions',
    'bans',
    'completed_at',
    'content_changed',
    'created_at',
    'entity_id',
    'entity_type',
    'flags',
    'has_image',
    'has_text',
    'has_video',
    'id',
    'languages',
    'moderation_payload_hash',
    'recommended_action',
    'reviewed_at',
    'reviewed_by',
    'severity',
    'status',
    'updated_at',
  };
}

