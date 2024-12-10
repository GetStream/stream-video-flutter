//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConfigOverrides {
  /// Returns a new [ConfigOverrides] instance.
  ConfigOverrides({
    this.blocklist,
    this.blocklistBehavior,
    this.commands = const [],
    this.grants = const {},
    this.maxMessageLength,
    this.quotes,
    this.reactions,
    this.replies,
    this.typingEvents,
    this.uploads,
    this.urlEnrichment,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? blocklist;

  ConfigOverridesBlocklistBehaviorEnum? blocklistBehavior;

  List<String> commands;

  Map<String, List<String>> grants;

  /// Maximum value: 20000
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? maxMessageLength;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? quotes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? reactions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? replies;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? typingEvents;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? uploads;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? urlEnrichment;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConfigOverrides &&
    other.blocklist == blocklist &&
    other.blocklistBehavior == blocklistBehavior &&
    _deepEquality.equals(other.commands, commands) &&
    _deepEquality.equals(other.grants, grants) &&
    other.maxMessageLength == maxMessageLength &&
    other.quotes == quotes &&
    other.reactions == reactions &&
    other.replies == replies &&
    other.typingEvents == typingEvents &&
    other.uploads == uploads &&
    other.urlEnrichment == urlEnrichment;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (blocklist == null ? 0 : blocklist!.hashCode) +
    (blocklistBehavior == null ? 0 : blocklistBehavior!.hashCode) +
    (commands.hashCode) +
    (grants.hashCode) +
    (maxMessageLength == null ? 0 : maxMessageLength!.hashCode) +
    (quotes == null ? 0 : quotes!.hashCode) +
    (reactions == null ? 0 : reactions!.hashCode) +
    (replies == null ? 0 : replies!.hashCode) +
    (typingEvents == null ? 0 : typingEvents!.hashCode) +
    (uploads == null ? 0 : uploads!.hashCode) +
    (urlEnrichment == null ? 0 : urlEnrichment!.hashCode);

  @override
  String toString() => 'ConfigOverrides[blocklist=$blocklist, blocklistBehavior=$blocklistBehavior, commands=$commands, grants=$grants, maxMessageLength=$maxMessageLength, quotes=$quotes, reactions=$reactions, replies=$replies, typingEvents=$typingEvents, uploads=$uploads, urlEnrichment=$urlEnrichment]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
      json[r'commands'] = this.commands;
      json[r'grants'] = this.grants;
    if (this.maxMessageLength != null) {
      json[r'max_message_length'] = this.maxMessageLength;
    } else {
      json[r'max_message_length'] = null;
    }
    if (this.quotes != null) {
      json[r'quotes'] = this.quotes;
    } else {
      json[r'quotes'] = null;
    }
    if (this.reactions != null) {
      json[r'reactions'] = this.reactions;
    } else {
      json[r'reactions'] = null;
    }
    if (this.replies != null) {
      json[r'replies'] = this.replies;
    } else {
      json[r'replies'] = null;
    }
    if (this.typingEvents != null) {
      json[r'typing_events'] = this.typingEvents;
    } else {
      json[r'typing_events'] = null;
    }
    if (this.uploads != null) {
      json[r'uploads'] = this.uploads;
    } else {
      json[r'uploads'] = null;
    }
    if (this.urlEnrichment != null) {
      json[r'url_enrichment'] = this.urlEnrichment;
    } else {
      json[r'url_enrichment'] = null;
    }
    return json;
  }

  /// Returns a new [ConfigOverrides] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConfigOverrides? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConfigOverrides[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConfigOverrides[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConfigOverrides(
        blocklist: mapValueOfType<String>(json, r'blocklist'),
        blocklistBehavior: ConfigOverridesBlocklistBehaviorEnum.fromJson(json[r'blocklist_behavior']),
        commands: json[r'commands'] is Iterable
            ? (json[r'commands'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        // MANUAL_EDIT: null check first
        grants: mapCastOfType<String, List<String>>(json, r'grants') ?? const {},
        maxMessageLength: mapValueOfType<int>(json, r'max_message_length'),
        quotes: mapValueOfType<bool>(json, r'quotes'),
        reactions: mapValueOfType<bool>(json, r'reactions'),
        replies: mapValueOfType<bool>(json, r'replies'),
        typingEvents: mapValueOfType<bool>(json, r'typing_events'),
        uploads: mapValueOfType<bool>(json, r'uploads'),
        urlEnrichment: mapValueOfType<bool>(json, r'url_enrichment'),
      );
    }
    return null;
  }

  static List<ConfigOverrides> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConfigOverrides>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConfigOverrides.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConfigOverrides> mapFromJson(dynamic json) {
    final map = <String, ConfigOverrides>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConfigOverrides.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConfigOverrides-objects as value to a dart map
  static Map<String, List<ConfigOverrides>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConfigOverrides>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConfigOverrides.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'commands',
    'grants',
  };
}


class ConfigOverridesBlocklistBehaviorEnum {
  /// Instantiate a new enum with the provided [value].
  const ConfigOverridesBlocklistBehaviorEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const flag = ConfigOverridesBlocklistBehaviorEnum._(r'flag');
  static const block = ConfigOverridesBlocklistBehaviorEnum._(r'block');

  /// List of all possible values in this [enum][ConfigOverridesBlocklistBehaviorEnum].
  static const values = <ConfigOverridesBlocklistBehaviorEnum>[
    flag,
    block,
  ];

  static ConfigOverridesBlocklistBehaviorEnum? fromJson(dynamic value) => ConfigOverridesBlocklistBehaviorEnumTypeTransformer().decode(value);

  static List<ConfigOverridesBlocklistBehaviorEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConfigOverridesBlocklistBehaviorEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConfigOverridesBlocklistBehaviorEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConfigOverridesBlocklistBehaviorEnum] to String,
/// and [decode] dynamic data back to [ConfigOverridesBlocklistBehaviorEnum].
class ConfigOverridesBlocklistBehaviorEnumTypeTransformer {
  factory ConfigOverridesBlocklistBehaviorEnumTypeTransformer() => _instance ??= const ConfigOverridesBlocklistBehaviorEnumTypeTransformer._();

  const ConfigOverridesBlocklistBehaviorEnumTypeTransformer._();

  String encode(ConfigOverridesBlocklistBehaviorEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ConfigOverridesBlocklistBehaviorEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConfigOverridesBlocklistBehaviorEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'flag': return ConfigOverridesBlocklistBehaviorEnum.flag;
        case r'block': return ConfigOverridesBlocklistBehaviorEnum.block;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ConfigOverridesBlocklistBehaviorEnumTypeTransformer] instance.
  static ConfigOverridesBlocklistBehaviorEnumTypeTransformer? _instance;
}


