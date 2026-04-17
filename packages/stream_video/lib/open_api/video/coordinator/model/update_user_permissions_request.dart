//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateUserPermissionsRequest {
  /// Returns a new [UpdateUserPermissionsRequest] instance.
  UpdateUserPermissionsRequest({
    this.grantPermissions = const [],
    this.revokePermissions = const [],
    required this.userId,
  });

  List<UpdateUserPermissionsRequestGrantPermissionsEnum> grantPermissions;

  List<UpdateUserPermissionsRequestRevokePermissionsEnum> revokePermissions;

  String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateUserPermissionsRequest &&
          _deepEquality.equals(other.grantPermissions, grantPermissions) &&
          _deepEquality.equals(other.revokePermissions, revokePermissions) &&
          other.userId == userId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (grantPermissions.hashCode) +
      (revokePermissions.hashCode) +
      (userId.hashCode);

  @override
  String toString() =>
      'UpdateUserPermissionsRequest[grantPermissions=$grantPermissions, revokePermissions=$revokePermissions, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'grant_permissions'] = this.grantPermissions;
    json[r'revoke_permissions'] = this.revokePermissions;
    json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [UpdateUserPermissionsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateUserPermissionsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'user_id'),
            'Required key "UpdateUserPermissionsRequest[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "UpdateUserPermissionsRequest[user_id]" has a null value in JSON.');
        return true;
      }());

      return UpdateUserPermissionsRequest(
        grantPermissions:
            UpdateUserPermissionsRequestGrantPermissionsEnum.listFromJson(
                json[r'grant_permissions']),
        revokePermissions:
            UpdateUserPermissionsRequestRevokePermissionsEnum.listFromJson(
                json[r'revoke_permissions']),
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<UpdateUserPermissionsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UpdateUserPermissionsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateUserPermissionsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateUserPermissionsRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateUserPermissionsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateUserPermissionsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateUserPermissionsRequest-objects as value to a dart map
  static Map<String, List<UpdateUserPermissionsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UpdateUserPermissionsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateUserPermissionsRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'user_id',
  };
}

class UpdateUserPermissionsRequestGrantPermissionsEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateUserPermissionsRequestGrantPermissionsEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const screenshare =
      UpdateUserPermissionsRequestGrantPermissionsEnum._(r'screenshare');
  static const sendAudio =
      UpdateUserPermissionsRequestGrantPermissionsEnum._(r'send-audio');
  static const sendVideo =
      UpdateUserPermissionsRequestGrantPermissionsEnum._(r'send-video');

  /// List of all possible values in this [enum][UpdateUserPermissionsRequestGrantPermissionsEnum].
  static const values = <UpdateUserPermissionsRequestGrantPermissionsEnum>[
    screenshare,
    sendAudio,
    sendVideo,
  ];

  static UpdateUserPermissionsRequestGrantPermissionsEnum? fromJson(
          dynamic value) =>
      UpdateUserPermissionsRequestGrantPermissionsEnumTypeTransformer()
          .decode(value);

  static List<UpdateUserPermissionsRequestGrantPermissionsEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UpdateUserPermissionsRequestGrantPermissionsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value =
            UpdateUserPermissionsRequestGrantPermissionsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateUserPermissionsRequestGrantPermissionsEnum] to String,
/// and [decode] dynamic data back to [UpdateUserPermissionsRequestGrantPermissionsEnum].
class UpdateUserPermissionsRequestGrantPermissionsEnumTypeTransformer {
  factory UpdateUserPermissionsRequestGrantPermissionsEnumTypeTransformer() =>
      _instance ??=
          const UpdateUserPermissionsRequestGrantPermissionsEnumTypeTransformer
              ._();

  const UpdateUserPermissionsRequestGrantPermissionsEnumTypeTransformer._();

  String encode(UpdateUserPermissionsRequestGrantPermissionsEnum data) =>
      data.value;

  /// Decodes a [dynamic value][data] to a UpdateUserPermissionsRequestGrantPermissionsEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateUserPermissionsRequestGrantPermissionsEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'screenshare':
          return UpdateUserPermissionsRequestGrantPermissionsEnum.screenshare;
        case r'send-audio':
          return UpdateUserPermissionsRequestGrantPermissionsEnum.sendAudio;
        case r'send-video':
          return UpdateUserPermissionsRequestGrantPermissionsEnum.sendVideo;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateUserPermissionsRequestGrantPermissionsEnumTypeTransformer] instance.
  static UpdateUserPermissionsRequestGrantPermissionsEnumTypeTransformer?
      _instance;
}

class UpdateUserPermissionsRequestRevokePermissionsEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateUserPermissionsRequestRevokePermissionsEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const screenshare =
      UpdateUserPermissionsRequestRevokePermissionsEnum._(r'screenshare');
  static const sendAudio =
      UpdateUserPermissionsRequestRevokePermissionsEnum._(r'send-audio');
  static const sendVideo =
      UpdateUserPermissionsRequestRevokePermissionsEnum._(r'send-video');

  /// List of all possible values in this [enum][UpdateUserPermissionsRequestRevokePermissionsEnum].
  static const values = <UpdateUserPermissionsRequestRevokePermissionsEnum>[
    screenshare,
    sendAudio,
    sendVideo,
  ];

  static UpdateUserPermissionsRequestRevokePermissionsEnum? fromJson(
          dynamic value) =>
      UpdateUserPermissionsRequestRevokePermissionsEnumTypeTransformer()
          .decode(value);

  static List<UpdateUserPermissionsRequestRevokePermissionsEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UpdateUserPermissionsRequestRevokePermissionsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value =
            UpdateUserPermissionsRequestRevokePermissionsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateUserPermissionsRequestRevokePermissionsEnum] to String,
/// and [decode] dynamic data back to [UpdateUserPermissionsRequestRevokePermissionsEnum].
class UpdateUserPermissionsRequestRevokePermissionsEnumTypeTransformer {
  factory UpdateUserPermissionsRequestRevokePermissionsEnumTypeTransformer() =>
      _instance ??=
          const UpdateUserPermissionsRequestRevokePermissionsEnumTypeTransformer
              ._();

  const UpdateUserPermissionsRequestRevokePermissionsEnumTypeTransformer._();

  String encode(UpdateUserPermissionsRequestRevokePermissionsEnum data) =>
      data.value;

  /// Decodes a [dynamic value][data] to a UpdateUserPermissionsRequestRevokePermissionsEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateUserPermissionsRequestRevokePermissionsEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'screenshare':
          return UpdateUserPermissionsRequestRevokePermissionsEnum.screenshare;
        case r'send-audio':
          return UpdateUserPermissionsRequestRevokePermissionsEnum.sendAudio;
        case r'send-video':
          return UpdateUserPermissionsRequestRevokePermissionsEnum.sendVideo;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateUserPermissionsRequestRevokePermissionsEnumTypeTransformer] instance.
  static UpdateUserPermissionsRequestRevokePermissionsEnumTypeTransformer?
      _instance;
}
