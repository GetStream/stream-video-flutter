//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateDeviceRequest {
  /// Returns a new [CreateDeviceRequest] instance.
  CreateDeviceRequest({
    this.id,
    this.pushProvider,
    this.pushProviderName,
    this.user,
    this.userId,
    this.voipToken,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  CreateDeviceRequestPushProviderEnum? pushProvider;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pushProviderName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserRequest? user;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? voipToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateDeviceRequest &&
     other.id == id &&
     other.pushProvider == pushProvider &&
     other.pushProviderName == pushProviderName &&
     other.user == user &&
     other.userId == userId &&
     other.voipToken == voipToken;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (pushProvider == null ? 0 : pushProvider!.hashCode) +
    (pushProviderName == null ? 0 : pushProviderName!.hashCode) +
    (user == null ? 0 : user!.hashCode) +
    (userId == null ? 0 : userId!.hashCode) +
    (voipToken == null ? 0 : voipToken!.hashCode);

  @override
  String toString() => 'CreateDeviceRequest[id=$id, pushProvider=$pushProvider, pushProviderName=$pushProviderName, user=$user, userId=$userId, voipToken=$voipToken]';

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
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    if (this.userId != null) {
      json[r'user_id'] = this.userId;
    } else {
      json[r'user_id'] = null;
    }
    if (this.voipToken != null) {
      json[r'voip_token'] = this.voipToken;
    } else {
      json[r'voip_token'] = null;
    }
    return json;
  }

  /// Returns a new [CreateDeviceRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateDeviceRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateDeviceRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateDeviceRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateDeviceRequest(
        id: mapValueOfType<String>(json, r'id'),
        pushProvider: CreateDeviceRequestPushProviderEnum.fromJson(json[r'push_provider']),
        pushProviderName: mapValueOfType<String>(json, r'push_provider_name'),
        user: UserRequest.fromJson(json[r'user']),
        userId: mapValueOfType<String>(json, r'user_id'),
        voipToken: mapValueOfType<bool>(json, r'voip_token'),
      );
    }
    return null;
  }

  static List<CreateDeviceRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateDeviceRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateDeviceRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateDeviceRequest> mapFromJson(dynamic json) {
    final map = <String, CreateDeviceRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateDeviceRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateDeviceRequest-objects as value to a dart map
  static Map<String, List<CreateDeviceRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateDeviceRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateDeviceRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class CreateDeviceRequestPushProviderEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateDeviceRequestPushProviderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const firebase = CreateDeviceRequestPushProviderEnum._(r'firebase');
  static const apn = CreateDeviceRequestPushProviderEnum._(r'apn');
  static const huawei = CreateDeviceRequestPushProviderEnum._(r'huawei');
  static const xiaomi = CreateDeviceRequestPushProviderEnum._(r'xiaomi');

  /// List of all possible values in this [enum][CreateDeviceRequestPushProviderEnum].
  static const values = <CreateDeviceRequestPushProviderEnum>[
    firebase,
    apn,
    huawei,
    xiaomi,
  ];

  static CreateDeviceRequestPushProviderEnum? fromJson(dynamic value) => CreateDeviceRequestPushProviderEnumTypeTransformer().decode(value);

  static List<CreateDeviceRequestPushProviderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateDeviceRequestPushProviderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateDeviceRequestPushProviderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateDeviceRequestPushProviderEnum] to String,
/// and [decode] dynamic data back to [CreateDeviceRequestPushProviderEnum].
class CreateDeviceRequestPushProviderEnumTypeTransformer {
  factory CreateDeviceRequestPushProviderEnumTypeTransformer() => _instance ??= const CreateDeviceRequestPushProviderEnumTypeTransformer._();

  const CreateDeviceRequestPushProviderEnumTypeTransformer._();

  String encode(CreateDeviceRequestPushProviderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateDeviceRequestPushProviderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateDeviceRequestPushProviderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'firebase': return CreateDeviceRequestPushProviderEnum.firebase;
        case r'apn': return CreateDeviceRequestPushProviderEnum.apn;
        case r'huawei': return CreateDeviceRequestPushProviderEnum.huawei;
        case r'xiaomi': return CreateDeviceRequestPushProviderEnum.xiaomi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateDeviceRequestPushProviderEnumTypeTransformer] instance.
  static CreateDeviceRequestPushProviderEnumTypeTransformer? _instance;
}


