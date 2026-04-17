//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RequestPermissionRequest {
  /// Returns a new [RequestPermissionRequest] instance.
  RequestPermissionRequest({
    this.permissions = const [],
  });

  List<RequestPermissionRequestPermissionsEnum> permissions;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestPermissionRequest &&
          _deepEquality.equals(other.permissions, permissions);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (permissions.hashCode);

  @override
  String toString() => 'RequestPermissionRequest[permissions=$permissions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'permissions'] = this.permissions;
    return json;
  }

  /// Returns a new [RequestPermissionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RequestPermissionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'permissions'),
            'Required key "RequestPermissionRequest[permissions]" is missing from JSON.');
        assert(json[r'permissions'] != null,
            'Required key "RequestPermissionRequest[permissions]" has a null value in JSON.');
        return true;
      }());

      return RequestPermissionRequest(
        permissions: RequestPermissionRequestPermissionsEnum.listFromJson(
            json[r'permissions']),
      );
    }
    return null;
  }

  static List<RequestPermissionRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <RequestPermissionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestPermissionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestPermissionRequest> mapFromJson(dynamic json) {
    final map = <String, RequestPermissionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RequestPermissionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestPermissionRequest-objects as value to a dart map
  static Map<String, List<RequestPermissionRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<RequestPermissionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestPermissionRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'permissions',
  };
}

class RequestPermissionRequestPermissionsEnum {
  /// Instantiate a new enum with the provided [value].
  const RequestPermissionRequestPermissionsEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const screenshare =
      RequestPermissionRequestPermissionsEnum._(r'screenshare');
  static const sendAudio =
      RequestPermissionRequestPermissionsEnum._(r'send-audio');
  static const sendVideo =
      RequestPermissionRequestPermissionsEnum._(r'send-video');

  /// List of all possible values in this [enum][RequestPermissionRequestPermissionsEnum].
  static const values = <RequestPermissionRequestPermissionsEnum>[
    screenshare,
    sendAudio,
    sendVideo,
  ];

  static RequestPermissionRequestPermissionsEnum? fromJson(dynamic value) =>
      RequestPermissionRequestPermissionsEnumTypeTransformer().decode(value);

  static List<RequestPermissionRequestPermissionsEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <RequestPermissionRequestPermissionsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestPermissionRequestPermissionsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RequestPermissionRequestPermissionsEnum] to String,
/// and [decode] dynamic data back to [RequestPermissionRequestPermissionsEnum].
class RequestPermissionRequestPermissionsEnumTypeTransformer {
  factory RequestPermissionRequestPermissionsEnumTypeTransformer() =>
      _instance ??=
          const RequestPermissionRequestPermissionsEnumTypeTransformer._();

  const RequestPermissionRequestPermissionsEnumTypeTransformer._();

  String encode(RequestPermissionRequestPermissionsEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RequestPermissionRequestPermissionsEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RequestPermissionRequestPermissionsEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'screenshare':
          return RequestPermissionRequestPermissionsEnum.screenshare;
        case r'send-audio':
          return RequestPermissionRequestPermissionsEnum.sendAudio;
        case r'send-video':
          return RequestPermissionRequestPermissionsEnum.sendVideo;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RequestPermissionRequestPermissionsEnumTypeTransformer] instance.
  static RequestPermissionRequestPermissionsEnumTypeTransformer? _instance;
}
