//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Channel {
  /// Returns a new [Channel] instance.
  Channel({
    this.autoTranslationEnabled,
    required this.autoTranslationLanguage,
    required this.cid,
    this.config,
    this.configOverrides,
    this.cooldown,
    required this.createdAt,
    this.createdBy,
    this.custom = const {},
    this.deletedAt,
    required this.disabled,
    required this.frozen,
    required this.id,
    this.invites = const [],
    this.lastMessageAt,
    this.memberCount,
    this.members = const [],
    this.team,
    this.truncatedBy,
    required this.type,
    required this.updatedAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? autoTranslationEnabled;

  String autoTranslationLanguage;

  String cid;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ChannelConfig? config;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ChannelConfig? configOverrides;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? cooldown;

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? createdBy;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deletedAt;

  bool disabled;

  bool frozen;

  String id;

  List<ChannelMember> invites;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastMessageAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? memberCount;

  List<ChannelMember> members;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? team;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? truncatedBy;

  String type;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Channel &&
    other.autoTranslationEnabled == autoTranslationEnabled &&
    other.autoTranslationLanguage == autoTranslationLanguage &&
    other.cid == cid &&
    other.config == config &&
    other.configOverrides == configOverrides &&
    other.cooldown == cooldown &&
    other.createdAt == createdAt &&
    other.createdBy == createdBy &&
    _deepEquality.equals(other.custom, custom) &&
    other.deletedAt == deletedAt &&
    other.disabled == disabled &&
    other.frozen == frozen &&
    other.id == id &&
    _deepEquality.equals(other.invites, invites) &&
    other.lastMessageAt == lastMessageAt &&
    other.memberCount == memberCount &&
    _deepEquality.equals(other.members, members) &&
    other.team == team &&
    other.truncatedBy == truncatedBy &&
    other.type == type &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (autoTranslationEnabled == null ? 0 : autoTranslationEnabled!.hashCode) +
    (autoTranslationLanguage.hashCode) +
    (cid.hashCode) +
    (config == null ? 0 : config!.hashCode) +
    (configOverrides == null ? 0 : configOverrides!.hashCode) +
    (cooldown == null ? 0 : cooldown!.hashCode) +
    (createdAt.hashCode) +
    (createdBy == null ? 0 : createdBy!.hashCode) +
    (custom.hashCode) +
    (deletedAt == null ? 0 : deletedAt!.hashCode) +
    (disabled.hashCode) +
    (frozen.hashCode) +
    (id.hashCode) +
    (invites.hashCode) +
    (lastMessageAt == null ? 0 : lastMessageAt!.hashCode) +
    (memberCount == null ? 0 : memberCount!.hashCode) +
    (members.hashCode) +
    (team == null ? 0 : team!.hashCode) +
    (truncatedBy == null ? 0 : truncatedBy!.hashCode) +
    (type.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'Channel[autoTranslationEnabled=$autoTranslationEnabled, autoTranslationLanguage=$autoTranslationLanguage, cid=$cid, config=$config, configOverrides=$configOverrides, cooldown=$cooldown, createdAt=$createdAt, createdBy=$createdBy, custom=$custom, deletedAt=$deletedAt, disabled=$disabled, frozen=$frozen, id=$id, invites=$invites, lastMessageAt=$lastMessageAt, memberCount=$memberCount, members=$members, team=$team, truncatedBy=$truncatedBy, type=$type, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.autoTranslationEnabled != null) {
      json[r'auto_translation_enabled'] = this.autoTranslationEnabled;
    } else {
      json[r'auto_translation_enabled'] = null;
    }
      json[r'auto_translation_language'] = this.autoTranslationLanguage;
      json[r'cid'] = this.cid;
    if (this.config != null) {
      json[r'config'] = this.config;
    } else {
      json[r'config'] = null;
    }
    if (this.configOverrides != null) {
      json[r'config_overrides'] = this.configOverrides;
    } else {
      json[r'config_overrides'] = null;
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
      json[r'id'] = this.id;
      json[r'invites'] = this.invites;
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
    if (this.team != null) {
      json[r'team'] = this.team;
    } else {
      json[r'team'] = null;
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

  /// Returns a new [Channel] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Channel? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Channel[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Channel[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Channel(
        autoTranslationEnabled: mapValueOfType<bool>(json, r'auto_translation_enabled'),
        autoTranslationLanguage: mapValueOfType<String>(json, r'auto_translation_language')!,
        cid: mapValueOfType<String>(json, r'cid')!,
        config: ChannelConfig.fromJson(json[r'config']),
        configOverrides: ChannelConfig.fromJson(json[r'config_overrides']),
        cooldown: mapValueOfType<int>(json, r'cooldown'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        createdBy: UserObject.fromJson(json[r'created_by']),
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        disabled: mapValueOfType<bool>(json, r'disabled')!,
        frozen: mapValueOfType<bool>(json, r'frozen')!,
        id: mapValueOfType<String>(json, r'id')!,
        invites: ChannelMember.listFromJson(json[r'invites']),
        lastMessageAt: mapDateTime(json, r'last_message_at', r''),
        memberCount: mapValueOfType<int>(json, r'member_count'),
        members: ChannelMember.listFromJson(json[r'members']),
        team: mapValueOfType<String>(json, r'team'),
        truncatedBy: UserObject.fromJson(json[r'truncated_by']),
        type: mapValueOfType<String>(json, r'type')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<Channel> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Channel>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Channel.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Channel> mapFromJson(dynamic json) {
    final map = <String, Channel>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Channel.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Channel-objects as value to a dart map
  static Map<String, List<Channel>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Channel>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Channel.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'auto_translation_language',
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

