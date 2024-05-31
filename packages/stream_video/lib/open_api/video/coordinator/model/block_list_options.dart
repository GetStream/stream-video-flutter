//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BlockListOptions {
  /// Returns a new [BlockListOptions] instance.
  BlockListOptions({
    required this.behavior,
    required this.blocklist,
  });

  BlockListOptionsBehaviorEnum behavior;

  String blocklist;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BlockListOptions &&
    other.behavior == behavior &&
    other.blocklist == blocklist;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (behavior.hashCode) +
    (blocklist.hashCode);

  @override
  String toString() => 'BlockListOptions[behavior=$behavior, blocklist=$blocklist]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'behavior'] = this.behavior;
      json[r'blocklist'] = this.blocklist;
    return json;
  }

  /// Returns a new [BlockListOptions] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BlockListOptions? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BlockListOptions[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BlockListOptions[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BlockListOptions(
        behavior: BlockListOptionsBehaviorEnum.fromJson(json[r'behavior'])!,
        blocklist: mapValueOfType<String>(json, r'blocklist')!,
      );
    }
    return null;
  }

  static List<BlockListOptions> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BlockListOptions>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BlockListOptions.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BlockListOptions> mapFromJson(dynamic json) {
    final map = <String, BlockListOptions>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BlockListOptions.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BlockListOptions-objects as value to a dart map
  static Map<String, List<BlockListOptions>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BlockListOptions>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BlockListOptions.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'behavior',
    'blocklist',
  };
}


class BlockListOptionsBehaviorEnum {
  /// Instantiate a new enum with the provided [value].
  const BlockListOptionsBehaviorEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const flag = BlockListOptionsBehaviorEnum._(r'flag');
  static const block = BlockListOptionsBehaviorEnum._(r'block');
  static const shadowBlock = BlockListOptionsBehaviorEnum._(r'shadow_block');

  /// List of all possible values in this [enum][BlockListOptionsBehaviorEnum].
  static const values = <BlockListOptionsBehaviorEnum>[
    flag,
    block,
    shadowBlock,
  ];

  static BlockListOptionsBehaviorEnum? fromJson(dynamic value) => BlockListOptionsBehaviorEnumTypeTransformer().decode(value);

  static List<BlockListOptionsBehaviorEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BlockListOptionsBehaviorEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BlockListOptionsBehaviorEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BlockListOptionsBehaviorEnum] to String,
/// and [decode] dynamic data back to [BlockListOptionsBehaviorEnum].
class BlockListOptionsBehaviorEnumTypeTransformer {
  factory BlockListOptionsBehaviorEnumTypeTransformer() => _instance ??= const BlockListOptionsBehaviorEnumTypeTransformer._();

  const BlockListOptionsBehaviorEnumTypeTransformer._();

  String encode(BlockListOptionsBehaviorEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a BlockListOptionsBehaviorEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BlockListOptionsBehaviorEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'flag': return BlockListOptionsBehaviorEnum.flag;
        case r'block': return BlockListOptionsBehaviorEnum.block;
        case r'shadow_block': return BlockListOptionsBehaviorEnum.shadowBlock;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [BlockListOptionsBehaviorEnumTypeTransformer] instance.
  static BlockListOptionsBehaviorEnumTypeTransformer? _instance;
}


