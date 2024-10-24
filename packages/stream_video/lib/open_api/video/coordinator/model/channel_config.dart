//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChannelConfig {
  /// Returns a new [ChannelConfig] instance.
  ChannelConfig({
    this.allowedFlagReasons = const [],
    required this.automod,
    required this.automodBehavior,
    this.automodThresholds,
    this.blocklist,
    this.blocklistBehavior,
    this.blocklists = const [],
    this.commands = const [],
    required this.connectEvents,
    required this.createdAt,
    required this.customEvents,
    required this.markMessagesPending,
    required this.maxMessageLength,
    required this.mutes,
    required this.name,
    this.partitionSize,
    this.partitionTtl,
    required this.polls,
    required this.pushNotifications,
    required this.quotes,
    required this.reactions,
    required this.readEvents,
    required this.reminders,
    required this.replies,
    required this.search,
    required this.typingEvents,
    required this.updatedAt,
    required this.uploads,
    required this.urlEnrichment,
  });

  List<String> allowedFlagReasons;

  ChannelConfigAutomodEnum automod;

  ChannelConfigAutomodBehaviorEnum automodBehavior;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Thresholds? automodThresholds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? blocklist;

  ChannelConfigBlocklistBehaviorEnum? blocklistBehavior;

  List<BlockListOptions> blocklists;

  /// List of commands that channel supports
  List<String> commands;

  bool connectEvents;

  DateTime createdAt;

  bool customEvents;

  bool markMessagesPending;

  /// Maximum value: 20000
  int maxMessageLength;

  bool mutes;

  String name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? partitionSize;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? partitionTtl;

  bool polls;

  bool pushNotifications;

  bool quotes;

  bool reactions;

  bool readEvents;

  bool reminders;

  bool replies;

  bool search;

  bool typingEvents;

  DateTime updatedAt;

  bool uploads;

  bool urlEnrichment;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChannelConfig &&
    _deepEquality.equals(other.allowedFlagReasons, allowedFlagReasons) &&
    other.automod == automod &&
    other.automodBehavior == automodBehavior &&
    other.automodThresholds == automodThresholds &&
    other.blocklist == blocklist &&
    other.blocklistBehavior == blocklistBehavior &&
    _deepEquality.equals(other.blocklists, blocklists) &&
    _deepEquality.equals(other.commands, commands) &&
    other.connectEvents == connectEvents &&
    other.createdAt == createdAt &&
    other.customEvents == customEvents &&
    other.markMessagesPending == markMessagesPending &&
    other.maxMessageLength == maxMessageLength &&
    other.mutes == mutes &&
    other.name == name &&
    other.partitionSize == partitionSize &&
    other.partitionTtl == partitionTtl &&
    other.polls == polls &&
    other.pushNotifications == pushNotifications &&
    other.quotes == quotes &&
    other.reactions == reactions &&
    other.readEvents == readEvents &&
    other.reminders == reminders &&
    other.replies == replies &&
    other.search == search &&
    other.typingEvents == typingEvents &&
    other.updatedAt == updatedAt &&
    other.uploads == uploads &&
    other.urlEnrichment == urlEnrichment;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (allowedFlagReasons.hashCode) +
    (automod.hashCode) +
    (automodBehavior.hashCode) +
    (automodThresholds == null ? 0 : automodThresholds!.hashCode) +
    (blocklist == null ? 0 : blocklist!.hashCode) +
    (blocklistBehavior == null ? 0 : blocklistBehavior!.hashCode) +
    (blocklists.hashCode) +
    (commands.hashCode) +
    (connectEvents.hashCode) +
    (createdAt.hashCode) +
    (customEvents.hashCode) +
    (markMessagesPending.hashCode) +
    (maxMessageLength.hashCode) +
    (mutes.hashCode) +
    (name.hashCode) +
    (partitionSize == null ? 0 : partitionSize!.hashCode) +
    (partitionTtl == null ? 0 : partitionTtl!.hashCode) +
    (polls.hashCode) +
    (pushNotifications.hashCode) +
    (quotes.hashCode) +
    (reactions.hashCode) +
    (readEvents.hashCode) +
    (reminders.hashCode) +
    (replies.hashCode) +
    (search.hashCode) +
    (typingEvents.hashCode) +
    (updatedAt.hashCode) +
    (uploads.hashCode) +
    (urlEnrichment.hashCode);

  @override
  String toString() => 'ChannelConfig[allowedFlagReasons=$allowedFlagReasons, automod=$automod, automodBehavior=$automodBehavior, automodThresholds=$automodThresholds, blocklist=$blocklist, blocklistBehavior=$blocklistBehavior, blocklists=$blocklists, commands=$commands, connectEvents=$connectEvents, createdAt=$createdAt, customEvents=$customEvents, markMessagesPending=$markMessagesPending, maxMessageLength=$maxMessageLength, mutes=$mutes, name=$name, partitionSize=$partitionSize, partitionTtl=$partitionTtl, polls=$polls, pushNotifications=$pushNotifications, quotes=$quotes, reactions=$reactions, readEvents=$readEvents, reminders=$reminders, replies=$replies, search=$search, typingEvents=$typingEvents, updatedAt=$updatedAt, uploads=$uploads, urlEnrichment=$urlEnrichment]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'allowed_flag_reasons'] = this.allowedFlagReasons;
      json[r'automod'] = this.automod;
      json[r'automod_behavior'] = this.automodBehavior;
    if (this.automodThresholds != null) {
      json[r'automod_thresholds'] = this.automodThresholds;
    } else {
      json[r'automod_thresholds'] = null;
    }
    if (this.blocklist != null) {
      json[r'blocklist'] = this.blocklist;
    } else {
      json[r'blocklist'] = null;
    }
    if (this.blocklistBehavior != null) {
      json[r'blocklist_behavior'] = this.blocklistBehavior;
    } else {
      json[r'blocklist_behavior'] = null;
    }
      json[r'blocklists'] = this.blocklists;
      json[r'commands'] = this.commands;
      json[r'connect_events'] = this.connectEvents;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'custom_events'] = this.customEvents;
      json[r'mark_messages_pending'] = this.markMessagesPending;
      json[r'max_message_length'] = this.maxMessageLength;
      json[r'mutes'] = this.mutes;
      json[r'name'] = this.name;
    if (this.partitionSize != null) {
      json[r'partition_size'] = this.partitionSize;
    } else {
      json[r'partition_size'] = null;
    }
    if (this.partitionTtl != null) {
      json[r'partition_ttl'] = this.partitionTtl;
    } else {
      json[r'partition_ttl'] = null;
    }
      json[r'polls'] = this.polls;
      json[r'push_notifications'] = this.pushNotifications;
      json[r'quotes'] = this.quotes;
      json[r'reactions'] = this.reactions;
      json[r'read_events'] = this.readEvents;
      json[r'reminders'] = this.reminders;
      json[r'replies'] = this.replies;
      json[r'search'] = this.search;
      json[r'typing_events'] = this.typingEvents;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
      json[r'uploads'] = this.uploads;
      json[r'url_enrichment'] = this.urlEnrichment;
    return json;
  }

  /// Returns a new [ChannelConfig] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChannelConfig? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ChannelConfig[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ChannelConfig[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ChannelConfig(
        allowedFlagReasons: json[r'allowed_flag_reasons'] is Iterable
            ? (json[r'allowed_flag_reasons'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        automod: ChannelConfigAutomodEnum.fromJson(json[r'automod'])!,
        automodBehavior: ChannelConfigAutomodBehaviorEnum.fromJson(json[r'automod_behavior'])!,
        automodThresholds: Thresholds.fromJson(json[r'automod_thresholds']),
        blocklist: mapValueOfType<String>(json, r'blocklist'),
        blocklistBehavior: ChannelConfigBlocklistBehaviorEnum.fromJson(json[r'blocklist_behavior']),
        blocklists: BlockListOptions.listFromJson(json[r'blocklists']),
        commands: json[r'commands'] is Iterable
            ? (json[r'commands'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        connectEvents: mapValueOfType<bool>(json, r'connect_events')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        customEvents: mapValueOfType<bool>(json, r'custom_events')!,
        markMessagesPending: mapValueOfType<bool>(json, r'mark_messages_pending')!,
        maxMessageLength: mapValueOfType<int>(json, r'max_message_length')!,
        mutes: mapValueOfType<bool>(json, r'mutes')!,
        name: mapValueOfType<String>(json, r'name')!,
        partitionSize: mapValueOfType<int>(json, r'partition_size'),
        partitionTtl: mapValueOfType<int>(json, r'partition_ttl'),
        polls: mapValueOfType<bool>(json, r'polls')!,
        pushNotifications: mapValueOfType<bool>(json, r'push_notifications')!,
        quotes: mapValueOfType<bool>(json, r'quotes')!,
        reactions: mapValueOfType<bool>(json, r'reactions')!,
        readEvents: mapValueOfType<bool>(json, r'read_events')!,
        reminders: mapValueOfType<bool>(json, r'reminders')!,
        replies: mapValueOfType<bool>(json, r'replies')!,
        search: mapValueOfType<bool>(json, r'search')!,
        typingEvents: mapValueOfType<bool>(json, r'typing_events')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        uploads: mapValueOfType<bool>(json, r'uploads')!,
        urlEnrichment: mapValueOfType<bool>(json, r'url_enrichment')!,
      );
    }
    return null;
  }

  static List<ChannelConfig> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelConfig>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelConfig.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChannelConfig> mapFromJson(dynamic json) {
    final map = <String, ChannelConfig>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChannelConfig.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChannelConfig-objects as value to a dart map
  static Map<String, List<ChannelConfig>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChannelConfig>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChannelConfig.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'automod',
    'automod_behavior',
    'commands',
    'connect_events',
    'created_at',
    'custom_events',
    'mark_messages_pending',
    'max_message_length',
    'mutes',
    'name',
    'polls',
    'push_notifications',
    'quotes',
    'reactions',
    'read_events',
    'reminders',
    'replies',
    'search',
    'typing_events',
    'updated_at',
    'uploads',
    'url_enrichment',
  };
}


class ChannelConfigAutomodEnum {
  /// Instantiate a new enum with the provided [value].
  const ChannelConfigAutomodEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const disabled = ChannelConfigAutomodEnum._(r'disabled');
  static const simple = ChannelConfigAutomodEnum._(r'simple');
  static const AI = ChannelConfigAutomodEnum._(r'AI');

  /// List of all possible values in this [enum][ChannelConfigAutomodEnum].
  static const values = <ChannelConfigAutomodEnum>[
    disabled,
    simple,
    AI,
  ];

  static ChannelConfigAutomodEnum? fromJson(dynamic value) => ChannelConfigAutomodEnumTypeTransformer().decode(value);

  static List<ChannelConfigAutomodEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelConfigAutomodEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelConfigAutomodEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChannelConfigAutomodEnum] to String,
/// and [decode] dynamic data back to [ChannelConfigAutomodEnum].
class ChannelConfigAutomodEnumTypeTransformer {
  factory ChannelConfigAutomodEnumTypeTransformer() => _instance ??= const ChannelConfigAutomodEnumTypeTransformer._();

  const ChannelConfigAutomodEnumTypeTransformer._();

  String encode(ChannelConfigAutomodEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ChannelConfigAutomodEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChannelConfigAutomodEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'disabled': return ChannelConfigAutomodEnum.disabled;
        case r'simple': return ChannelConfigAutomodEnum.simple;
        case r'AI': return ChannelConfigAutomodEnum.AI;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ChannelConfigAutomodEnumTypeTransformer] instance.
  static ChannelConfigAutomodEnumTypeTransformer? _instance;
}



class ChannelConfigAutomodBehaviorEnum {
  /// Instantiate a new enum with the provided [value].
  const ChannelConfigAutomodBehaviorEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const flag = ChannelConfigAutomodBehaviorEnum._(r'flag');
  static const block = ChannelConfigAutomodBehaviorEnum._(r'block');
  static const shadowBlock = ChannelConfigAutomodBehaviorEnum._(r'shadow_block');

  /// List of all possible values in this [enum][ChannelConfigAutomodBehaviorEnum].
  static const values = <ChannelConfigAutomodBehaviorEnum>[
    flag,
    block,
    shadowBlock,
  ];

  static ChannelConfigAutomodBehaviorEnum? fromJson(dynamic value) => ChannelConfigAutomodBehaviorEnumTypeTransformer().decode(value);

  static List<ChannelConfigAutomodBehaviorEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelConfigAutomodBehaviorEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelConfigAutomodBehaviorEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChannelConfigAutomodBehaviorEnum] to String,
/// and [decode] dynamic data back to [ChannelConfigAutomodBehaviorEnum].
class ChannelConfigAutomodBehaviorEnumTypeTransformer {
  factory ChannelConfigAutomodBehaviorEnumTypeTransformer() => _instance ??= const ChannelConfigAutomodBehaviorEnumTypeTransformer._();

  const ChannelConfigAutomodBehaviorEnumTypeTransformer._();

  String encode(ChannelConfigAutomodBehaviorEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ChannelConfigAutomodBehaviorEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChannelConfigAutomodBehaviorEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'flag': return ChannelConfigAutomodBehaviorEnum.flag;
        case r'block': return ChannelConfigAutomodBehaviorEnum.block;
        case r'shadow_block': return ChannelConfigAutomodBehaviorEnum.shadowBlock;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ChannelConfigAutomodBehaviorEnumTypeTransformer] instance.
  static ChannelConfigAutomodBehaviorEnumTypeTransformer? _instance;
}



class ChannelConfigBlocklistBehaviorEnum {
  /// Instantiate a new enum with the provided [value].
  const ChannelConfigBlocklistBehaviorEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const flag = ChannelConfigBlocklistBehaviorEnum._(r'flag');
  static const block = ChannelConfigBlocklistBehaviorEnum._(r'block');
  static const shadowBlock = ChannelConfigBlocklistBehaviorEnum._(r'shadow_block');

  /// List of all possible values in this [enum][ChannelConfigBlocklistBehaviorEnum].
  static const values = <ChannelConfigBlocklistBehaviorEnum>[
    flag,
    block,
    shadowBlock,
  ];

  static ChannelConfigBlocklistBehaviorEnum? fromJson(dynamic value) => ChannelConfigBlocklistBehaviorEnumTypeTransformer().decode(value);

  static List<ChannelConfigBlocklistBehaviorEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelConfigBlocklistBehaviorEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelConfigBlocklistBehaviorEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChannelConfigBlocklistBehaviorEnum] to String,
/// and [decode] dynamic data back to [ChannelConfigBlocklistBehaviorEnum].
class ChannelConfigBlocklistBehaviorEnumTypeTransformer {
  factory ChannelConfigBlocklistBehaviorEnumTypeTransformer() => _instance ??= const ChannelConfigBlocklistBehaviorEnumTypeTransformer._();

  const ChannelConfigBlocklistBehaviorEnumTypeTransformer._();

  String encode(ChannelConfigBlocklistBehaviorEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ChannelConfigBlocklistBehaviorEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChannelConfigBlocklistBehaviorEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'flag': return ChannelConfigBlocklistBehaviorEnum.flag;
        case r'block': return ChannelConfigBlocklistBehaviorEnum.block;
        case r'shadow_block': return ChannelConfigBlocklistBehaviorEnum.shadowBlock;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ChannelConfigBlocklistBehaviorEnumTypeTransformer] instance.
  static ChannelConfigBlocklistBehaviorEnumTypeTransformer? _instance;
}


