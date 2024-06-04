//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChannelResponse {
  /// Returns a new [ChannelResponse] instance.
  ChannelResponse({
    this.autoTranslationEnabled,
    this.autoTranslationLanguage,
    this.blocked,
    required this.cid,
    this.config,
    this.cooldown,
    required this.createdAt,
    this.createdBy,
    this.custom = const {},
    this.deletedAt,
    required this.disabled,
    required this.frozen,
    this.hidden,
    this.hideMessagesBefore,
    required this.id,
    this.lastMessageAt,
    this.memberCount,
    this.members = const [],
    this.muteExpiresAt,
    this.muted,
    this.ownCapabilities = const [],
    this.team,
    this.truncatedAt,
    this.truncatedBy,
    required this.type,
    required this.updatedAt,
  });

  /// Whether auto translation is enabled or not
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? autoTranslationEnabled;

  /// Language to translate to when auto translation is active
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? autoTranslationLanguage;

  /// Whether this channel is blocked by current user or not
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? blocked;

  /// Channel CID (<type>:<id>)
  String cid;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ChannelConfigWithInfo? config;

  /// Cooldown period after sending each message
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? cooldown;

  /// Date/time of creation
  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? createdBy;

  Map<String, Object> custom;

  /// Date/time of deletion
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deletedAt;

  bool disabled;

  /// Whether channel is frozen or not
  bool frozen;

  /// Whether this channel is hidden by current user or not
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? hidden;

  /// Date since when the message history is accessible
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? hideMessagesBefore;

  /// Channel unique ID
  String id;

  /// Date of the last message sent
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastMessageAt;

  /// Number of members in the channel
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? memberCount;

  /// List of channel members (max 100)
  List<ChannelMember> members;

  /// Date of mute expiration
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? muteExpiresAt;

  /// Whether this channel is muted or not
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? muted;

  /// List of channel capabilities of authenticated user
  List<String> ownCapabilities;

  /// Team the channel belongs to (multi-tenant only)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? team;

  /// Date of the latest truncation of the channel
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? truncatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? truncatedBy;

  /// Type of the channel
  String type;

  /// Date/time of the last update
  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChannelResponse &&
    other.autoTranslationEnabled == autoTranslationEnabled &&
    other.autoTranslationLanguage == autoTranslationLanguage &&
    other.blocked == blocked &&
    other.cid == cid &&
    other.config == config &&
    other.cooldown == cooldown &&
    other.createdAt == createdAt &&
    other.createdBy == createdBy &&
    _deepEquality.equals(other.custom, custom) &&
    other.deletedAt == deletedAt &&
    other.disabled == disabled &&
    other.frozen == frozen &&
    other.hidden == hidden &&
    other.hideMessagesBefore == hideMessagesBefore &&
    other.id == id &&
    other.lastMessageAt == lastMessageAt &&
    other.memberCount == memberCount &&
    _deepEquality.equals(other.members, members) &&
    other.muteExpiresAt == muteExpiresAt &&
    other.muted == muted &&
    _deepEquality.equals(other.ownCapabilities, ownCapabilities) &&
    other.team == team &&
    other.truncatedAt == truncatedAt &&
    other.truncatedBy == truncatedBy &&
    other.type == type &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (autoTranslationEnabled == null ? 0 : autoTranslationEnabled!.hashCode) +
    (autoTranslationLanguage == null ? 0 : autoTranslationLanguage!.hashCode) +
    (blocked == null ? 0 : blocked!.hashCode) +
    (cid.hashCode) +
    (config == null ? 0 : config!.hashCode) +
    (cooldown == null ? 0 : cooldown!.hashCode) +
    (createdAt.hashCode) +
    (createdBy == null ? 0 : createdBy!.hashCode) +
    (custom.hashCode) +
    (deletedAt == null ? 0 : deletedAt!.hashCode) +
    (disabled.hashCode) +
    (frozen.hashCode) +
    (hidden == null ? 0 : hidden!.hashCode) +
    (hideMessagesBefore == null ? 0 : hideMessagesBefore!.hashCode) +
    (id.hashCode) +
    (lastMessageAt == null ? 0 : lastMessageAt!.hashCode) +
    (memberCount == null ? 0 : memberCount!.hashCode) +
    (members.hashCode) +
    (muteExpiresAt == null ? 0 : muteExpiresAt!.hashCode) +
    (muted == null ? 0 : muted!.hashCode) +
    (ownCapabilities.hashCode) +
    (team == null ? 0 : team!.hashCode) +
    (truncatedAt == null ? 0 : truncatedAt!.hashCode) +
    (truncatedBy == null ? 0 : truncatedBy!.hashCode) +
    (type.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'ChannelResponse[autoTranslationEnabled=$autoTranslationEnabled, autoTranslationLanguage=$autoTranslationLanguage, blocked=$blocked, cid=$cid, config=$config, cooldown=$cooldown, createdAt=$createdAt, createdBy=$createdBy, custom=$custom, deletedAt=$deletedAt, disabled=$disabled, frozen=$frozen, hidden=$hidden, hideMessagesBefore=$hideMessagesBefore, id=$id, lastMessageAt=$lastMessageAt, memberCount=$memberCount, members=$members, muteExpiresAt=$muteExpiresAt, muted=$muted, ownCapabilities=$ownCapabilities, team=$team, truncatedAt=$truncatedAt, truncatedBy=$truncatedBy, type=$type, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.autoTranslationEnabled != null) {
      json[r'auto_translation_enabled'] = this.autoTranslationEnabled;
    } else {
      json[r'auto_translation_enabled'] = null;
    }
    if (this.autoTranslationLanguage != null) {
      json[r'auto_translation_language'] = this.autoTranslationLanguage;
    } else {
      json[r'auto_translation_language'] = null;
    }
    if (this.blocked != null) {
      json[r'blocked'] = this.blocked;
    } else {
      json[r'blocked'] = null;
    }
      json[r'cid'] = this.cid;
    if (this.config != null) {
      json[r'config'] = this.config;
    } else {
      json[r'config'] = null;
    }
    if (this.cooldown != null) {
      json[r'cooldown'] = this.cooldown;
    } else {
      json[r'cooldown'] = null;
    }
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.createdBy != null) {
      json[r'created_by'] = this.createdBy;
    } else {
      json[r'created_by'] = null;
    }
      json[r'custom'] = this.custom;
    if (this.deletedAt != null) {
      json[r'deleted_at'] = this.deletedAt!.toUtc().toIso8601String();
    } else {
      json[r'deleted_at'] = null;
    }
      json[r'disabled'] = this.disabled;
      json[r'frozen'] = this.frozen;
    if (this.hidden != null) {
      json[r'hidden'] = this.hidden;
    } else {
      json[r'hidden'] = null;
    }
    if (this.hideMessagesBefore != null) {
      json[r'hide_messages_before'] = this.hideMessagesBefore!.toUtc().toIso8601String();
    } else {
      json[r'hide_messages_before'] = null;
    }
      json[r'id'] = this.id;
    if (this.lastMessageAt != null) {
      json[r'last_message_at'] = this.lastMessageAt!.toUtc().toIso8601String();
    } else {
      json[r'last_message_at'] = null;
    }
    if (this.memberCount != null) {
      json[r'member_count'] = this.memberCount;
    } else {
      json[r'member_count'] = null;
    }
      json[r'members'] = this.members;
    if (this.muteExpiresAt != null) {
      json[r'mute_expires_at'] = this.muteExpiresAt!.toUtc().toIso8601String();
    } else {
      json[r'mute_expires_at'] = null;
    }
    if (this.muted != null) {
      json[r'muted'] = this.muted;
    } else {
      json[r'muted'] = null;
    }
      json[r'own_capabilities'] = this.ownCapabilities;
    if (this.team != null) {
      json[r'team'] = this.team;
    } else {
      json[r'team'] = null;
    }
    if (this.truncatedAt != null) {
      json[r'truncated_at'] = this.truncatedAt!.toUtc().toIso8601String();
    } else {
      json[r'truncated_at'] = null;
    }
    if (this.truncatedBy != null) {
      json[r'truncated_by'] = this.truncatedBy;
    } else {
      json[r'truncated_by'] = null;
    }
      json[r'type'] = this.type;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ChannelResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChannelResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ChannelResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ChannelResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ChannelResponse(
        autoTranslationEnabled: mapValueOfType<bool>(json, r'auto_translation_enabled'),
        autoTranslationLanguage: mapValueOfType<String>(json, r'auto_translation_language'),
        blocked: mapValueOfType<bool>(json, r'blocked'),
        cid: mapValueOfType<String>(json, r'cid')!,
        config: ChannelConfigWithInfo.fromJson(json[r'config']),
        cooldown: mapValueOfType<int>(json, r'cooldown'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        createdBy: UserObject.fromJson(json[r'created_by']),
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        disabled: mapValueOfType<bool>(json, r'disabled')!,
        frozen: mapValueOfType<bool>(json, r'frozen')!,
        hidden: mapValueOfType<bool>(json, r'hidden'),
        hideMessagesBefore: mapDateTime(json, r'hide_messages_before', r''),
        id: mapValueOfType<String>(json, r'id')!,
        lastMessageAt: mapDateTime(json, r'last_message_at', r''),
        memberCount: mapValueOfType<int>(json, r'member_count'),
        members: ChannelMember.listFromJson(json[r'members']),
        muteExpiresAt: mapDateTime(json, r'mute_expires_at', r''),
        muted: mapValueOfType<bool>(json, r'muted'),
        ownCapabilities: json[r'own_capabilities'] is Iterable
            ? (json[r'own_capabilities'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        team: mapValueOfType<String>(json, r'team'),
        truncatedAt: mapDateTime(json, r'truncated_at', r''),
        truncatedBy: UserObject.fromJson(json[r'truncated_by']),
        type: mapValueOfType<String>(json, r'type')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<ChannelResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChannelResponse> mapFromJson(dynamic json) {
    final map = <String, ChannelResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChannelResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChannelResponse-objects as value to a dart map
  static Map<String, List<ChannelResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChannelResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChannelResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'cid',
    'created_at',
    'custom',
    'disabled',
    'frozen',
    'id',
    'type',
    'updated_at',
  };
}

