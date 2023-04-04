//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DeviceFieldsRequest {
  /// Returns a new [DeviceFieldsRequest] instance.
  DeviceFieldsRequest({
    this.id,
    this.pushProvider,
    this.pushProviderName,
  });

  /// Device ID
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  DeviceFieldsRequestPushProviderEnum? pushProvider;

  /// Name of the push provider configuration
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pushProviderName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeviceFieldsRequest &&
     other.id == id &&
     other.pushProvider == pushProvider &&
     other.pushProviderName == pushProviderName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (pushProvider == null ? 0 : pushProvider!.hashCode) +
    (pushProviderName == null ? 0 : pushProviderName!.hashCode);

  @override
  String toString() => 'DeviceFieldsRequest[id=$id, pushProvider=$pushProvider, pushProviderName=$pushProviderName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.pushProvider != null) {
      json[r'push_provider'] = this.pushProvider;
    } else {
      json[r'push_provider'] = null;
    }
    if (this.pushProviderName != null) {
      json[r'push_provider_name'] = this.pushProviderName;
    } else {
      json[r'push_provider_name'] = null;
    }
    return json;
  }

  /// Returns a new [DeviceFieldsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DeviceFieldsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DeviceFieldsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DeviceFieldsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DeviceFieldsRequest(
        id: mapValueOfType<String>(json, r'id'),
        pushProvider: DeviceFieldsRequestPushProviderEnum.fromJson(json[r'push_provider']),
        pushProviderName: mapValueOfType<String>(json, r'push_provider_name'),
      );
    }
    return null;
  }

  static List<DeviceFieldsRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DeviceFieldsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DeviceFieldsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DeviceFieldsRequest> mapFromJson(dynamic json) {
    final map = <String, DeviceFieldsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DeviceFieldsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DeviceFieldsRequest-objects as value to a dart map
  static Map<String, List<DeviceFieldsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DeviceFieldsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DeviceFieldsRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class DeviceFieldsRequestPushProviderEnum {
  /// Instantiate a new enum with the provided [value].
  const DeviceFieldsRequestPushProviderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const firebase = DeviceFieldsRequestPushProviderEnum._(r'firebase');
  static const apn = DeviceFieldsRequestPushProviderEnum._(r'apn');
  static const huawei = DeviceFieldsRequestPushProviderEnum._(r'huawei');
  static const xiaomi = DeviceFieldsRequestPushProviderEnum._(r'xiaomi');

  /// List of all possible values in this [enum][DeviceFieldsRequestPushProviderEnum].
  static const values = <DeviceFieldsRequestPushProviderEnum>[
    firebase,
    apn,
    huawei,
    xiaomi,
  ];

  static DeviceFieldsRequestPushProviderEnum? fromJson(dynamic value) => DeviceFieldsRequestPushProviderEnumTypeTransformer().decode(value);

  static List<DeviceFieldsRequestPushProviderEnum>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DeviceFieldsRequestPushProviderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DeviceFieldsRequestPushProviderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [DeviceFieldsRequestPushProviderEnum] to String,
/// and [decode] dynamic data back to [DeviceFieldsRequestPushProviderEnum].
class DeviceFieldsRequestPushProviderEnumTypeTransformer {
  factory DeviceFieldsRequestPushProviderEnumTypeTransformer() => _instance ??= const DeviceFieldsRequestPushProviderEnumTypeTransformer._();

  const DeviceFieldsRequestPushProviderEnumTypeTransformer._();

  String encode(DeviceFieldsRequestPushProviderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a DeviceFieldsRequestPushProviderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  DeviceFieldsRequestPushProviderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'firebase': return DeviceFieldsRequestPushProviderEnum.firebase;
        case r'apn': return DeviceFieldsRequestPushProviderEnum.apn;
        case r'huawei': return DeviceFieldsRequestPushProviderEnum.huawei;
        case r'xiaomi': return DeviceFieldsRequestPushProviderEnum.xiaomi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [DeviceFieldsRequestPushProviderEnumTypeTransformer] instance.
  static DeviceFieldsRequestPushProviderEnumTypeTransformer? _instance;
}


