//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChannelConfigWithInfo {
  /// Returns a new [ChannelConfigWithInfo] instance.
  ChannelConfigWithInfo({
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
    this.grants = const {},
    required this.markMessagesPending,
    required this.maxMessageLength,
    required this.mutes,
    required this.name,
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

  ChannelConfigWithInfoAutomodEnum automod;

  ChannelConfigWithInfoAutomodBehaviorEnum automodBehavior;

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

  ChannelConfigWithInfoBlocklistBehaviorEnum? blocklistBehavior;

  List<BlockListOptions> blocklists;

  List<Command> commands;

  bool connectEvents;

  DateTime createdAt;

  bool customEvents;

  Map<String, List<String>> grants;

  bool markMessagesPending;

  /// Maximum value: 20000
  int maxMessageLength;

  bool mutes;

  String name;

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
  bool operator ==(Object other) => identical(this, other) || other is ChannelConfigWithInfo &&
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
    _deepEquality.equals(other.grants, grants) &&
    other.markMessagesPending == markMessagesPending &&
    other.maxMessageLength == maxMessageLength &&
    other.mutes == mutes &&
    other.name == name &&
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
    (grants.hashCode) +
    (markMessagesPending.hashCode) +
    (maxMessageLength.hashCode) +
    (mutes.hashCode) +
    (name.hashCode) +
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
  String toString() => 'ChannelConfigWithInfo[allowedFlagReasons=$allowedFlagReasons, automod=$automod, automodBehavior=$automodBehavior, automodThresholds=$automodThresholds, blocklist=$blocklist, blocklistBehavior=$blocklistBehavior, blocklists=$blocklists, commands=$commands, connectEvents=$connectEvents, createdAt=$createdAt, customEvents=$customEvents, grants=$grants, markMessagesPending=$markMessagesPending, maxMessageLength=$maxMessageLength, mutes=$mutes, name=$name, polls=$polls, pushNotifications=$pushNotifications, quotes=$quotes, reactions=$reactions, readEvents=$readEvents, reminders=$reminders, replies=$replies, search=$search, typingEvents=$typingEvents, updatedAt=$updatedAt, uploads=$uploads, urlEnrichment=$urlEnrichment]';

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
      json[r'grants'] = this.grants;
      json[r'mark_messages_pending'] = this.markMessagesPending;
      json[r'max_message_length'] = this.maxMessageLength;
      json[r'mutes'] = this.mutes;
      json[r'name'] = this.name;
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

  /// Returns a new [ChannelConfigWithInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChannelConfigWithInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ChannelConfigWithInfo[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ChannelConfigWithInfo[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ChannelConfigWithInfo(
        allowedFlagReasons: json[r'allowed_flag_reasons'] is Iterable
            ? (json[r'allowed_flag_reasons'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        automod: ChannelConfigWithInfoAutomodEnum.fromJson(json[r'automod'])!,
        automodBehavior: ChannelConfigWithInfoAutomodBehaviorEnum.fromJson(json[r'automod_behavior'])!,
        automodThresholds: Thresholds.fromJson(json[r'automod_thresholds']),
        blocklist: mapValueOfType<String>(json, r'blocklist'),
        blocklistBehavior: ChannelConfigWithInfoBlocklistBehaviorEnum.fromJson(json[r'blocklist_behavior']),
        blocklists: BlockListOptions.listFromJson(json[r'blocklists']),
        commands: Command.listFromJson(json[r'commands']),
        connectEvents: mapValueOfType<bool>(json, r'connect_events')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        customEvents: mapValueOfType<bool>(json, r'custom_events')!,
        grants: mapCastOfType<String, List<String>>(json, r'grants') ?? const {},
        markMessagesPending: mapValueOfType<bool>(json, r'mark_messages_pending')!,
        maxMessageLength: mapValueOfType<int>(json, r'max_message_length')!,
        mutes: mapValueOfType<bool>(json, r'mutes')!,
        name: mapValueOfType<String>(json, r'name')!,
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

  static List<ChannelConfigWithInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelConfigWithInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelConfigWithInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChannelConfigWithInfo> mapFromJson(dynamic json) {
    final map = <String, ChannelConfigWithInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChannelConfigWithInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChannelConfigWithInfo-objects as value to a dart map
  static Map<String, List<ChannelConfigWithInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChannelConfigWithInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChannelConfigWithInfo.listFromJson(entry.value, growable: growable,);
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


class ChannelConfigWithInfoAutomodEnum {
  /// Instantiate a new enum with the provided [value].
  const ChannelConfigWithInfoAutomodEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const disabled = ChannelConfigWithInfoAutomodEnum._(r'disabled');
  static const simple = ChannelConfigWithInfoAutomodEnum._(r'simple');
  static const AI = ChannelConfigWithInfoAutomodEnum._(r'AI');

  /// List of all possible values in this [enum][ChannelConfigWithInfoAutomodEnum].
  static const values = <ChannelConfigWithInfoAutomodEnum>[
    disabled,
    simple,
    AI,
  ];

  static ChannelConfigWithInfoAutomodEnum? fromJson(dynamic value) => ChannelConfigWithInfoAutomodEnumTypeTransformer().decode(value);

  static List<ChannelConfigWithInfoAutomodEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelConfigWithInfoAutomodEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelConfigWithInfoAutomodEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChannelConfigWithInfoAutomodEnum] to String,
/// and [decode] dynamic data back to [ChannelConfigWithInfoAutomodEnum].
class ChannelConfigWithInfoAutomodEnumTypeTransformer {
  factory ChannelConfigWithInfoAutomodEnumTypeTransformer() => _instance ??= const ChannelConfigWithInfoAutomodEnumTypeTransformer._();

  const ChannelConfigWithInfoAutomodEnumTypeTransformer._();

  String encode(ChannelConfigWithInfoAutomodEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ChannelConfigWithInfoAutomodEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChannelConfigWithInfoAutomodEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'disabled': return ChannelConfigWithInfoAutomodEnum.disabled;
        case r'simple': return ChannelConfigWithInfoAutomodEnum.simple;
        case r'AI': return ChannelConfigWithInfoAutomodEnum.AI;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ChannelConfigWithInfoAutomodEnumTypeTransformer] instance.
  static ChannelConfigWithInfoAutomodEnumTypeTransformer? _instance;
}



class ChannelConfigWithInfoAutomodBehaviorEnum {
  /// Instantiate a new enum with the provided [value].
  const ChannelConfigWithInfoAutomodBehaviorEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const flag = ChannelConfigWithInfoAutomodBehaviorEnum._(r'flag');
  static const block = ChannelConfigWithInfoAutomodBehaviorEnum._(r'block');
  static const shadowBlock = ChannelConfigWithInfoAutomodBehaviorEnum._(r'shadow_block');

  /// List of all possible values in this [enum][ChannelConfigWithInfoAutomodBehaviorEnum].
  static const values = <ChannelConfigWithInfoAutomodBehaviorEnum>[
    flag,
    block,
    shadowBlock,
  ];

  static ChannelConfigWithInfoAutomodBehaviorEnum? fromJson(dynamic value) => ChannelConfigWithInfoAutomodBehaviorEnumTypeTransformer().decode(value);

  static List<ChannelConfigWithInfoAutomodBehaviorEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelConfigWithInfoAutomodBehaviorEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelConfigWithInfoAutomodBehaviorEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChannelConfigWithInfoAutomodBehaviorEnum] to String,
/// and [decode] dynamic data back to [ChannelConfigWithInfoAutomodBehaviorEnum].
class ChannelConfigWithInfoAutomodBehaviorEnumTypeTransformer {
  factory ChannelConfigWithInfoAutomodBehaviorEnumTypeTransformer() => _instance ??= const ChannelConfigWithInfoAutomodBehaviorEnumTypeTransformer._();

  const ChannelConfigWithInfoAutomodBehaviorEnumTypeTransformer._();

  String encode(ChannelConfigWithInfoAutomodBehaviorEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ChannelConfigWithInfoAutomodBehaviorEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChannelConfigWithInfoAutomodBehaviorEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'flag': return ChannelConfigWithInfoAutomodBehaviorEnum.flag;
        case r'block': return ChannelConfigWithInfoAutomodBehaviorEnum.block;
        case r'shadow_block': return ChannelConfigWithInfoAutomodBehaviorEnum.shadowBlock;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ChannelConfigWithInfoAutomodBehaviorEnumTypeTransformer] instance.
  static ChannelConfigWithInfoAutomodBehaviorEnumTypeTransformer? _instance;
}



class ChannelConfigWithInfoBlocklistBehaviorEnum {
  /// Instantiate a new enum with the provided [value].
  const ChannelConfigWithInfoBlocklistBehaviorEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const flag = ChannelConfigWithInfoBlocklistBehaviorEnum._(r'flag');
  static const block = ChannelConfigWithInfoBlocklistBehaviorEnum._(r'block');
  static const shadowBlock = ChannelConfigWithInfoBlocklistBehaviorEnum._(r'shadow_block');

  /// List of all possible values in this [enum][ChannelConfigWithInfoBlocklistBehaviorEnum].
  static const values = <ChannelConfigWithInfoBlocklistBehaviorEnum>[
    flag,
    block,
    shadowBlock,
  ];

  static ChannelConfigWithInfoBlocklistBehaviorEnum? fromJson(dynamic value) => ChannelConfigWithInfoBlocklistBehaviorEnumTypeTransformer().decode(value);

  static List<ChannelConfigWithInfoBlocklistBehaviorEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelConfigWithInfoBlocklistBehaviorEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelConfigWithInfoBlocklistBehaviorEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChannelConfigWithInfoBlocklistBehaviorEnum] to String,
/// and [decode] dynamic data back to [ChannelConfigWithInfoBlocklistBehaviorEnum].
class ChannelConfigWithInfoBlocklistBehaviorEnumTypeTransformer {
  factory ChannelConfigWithInfoBlocklistBehaviorEnumTypeTransformer() => _instance ??= const ChannelConfigWithInfoBlocklistBehaviorEnumTypeTransformer._();

  const ChannelConfigWithInfoBlocklistBehaviorEnumTypeTransformer._();

  String encode(ChannelConfigWithInfoBlocklistBehaviorEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ChannelConfigWithInfoBlocklistBehaviorEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChannelConfigWithInfoBlocklistBehaviorEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'flag': return ChannelConfigWithInfoBlocklistBehaviorEnum.flag;
        case r'block': return ChannelConfigWithInfoBlocklistBehaviorEnum.block;
        case r'shadow_block': return ChannelConfigWithInfoBlocklistBehaviorEnum.shadowBlock;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ChannelConfigWithInfoBlocklistBehaviorEnumTypeTransformer] instance.
  static ChannelConfigWithInfoBlocklistBehaviorEnumTypeTransformer? _instance;
}


