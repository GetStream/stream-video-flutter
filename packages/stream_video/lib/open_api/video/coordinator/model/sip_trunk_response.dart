//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SIPTrunkResponse {
  /// Returns a new [SIPTrunkResponse] instance.
  SIPTrunkResponse({
    this.allowedIps = const [],
    required this.createdAt,
    required this.id,
    required this.name,
    this.numbers = const [],
    required this.password,
    required this.updatedAt,
    required this.uri,
    required this.username,
  });

  /// Allowed IPv4/IPv6 addresses or CIDR blocks
  List<String> allowedIps;

  /// Creation timestamp
  DateTime createdAt;

  /// Unique identifier for the SIP trunk
  String id;

  /// Name of the SIP trunk
  String name;

  /// Phone numbers associated with this SIP trunk
  List<String> numbers;

  /// Password for SIP trunk authentication
  String password;

  /// Last update timestamp
  DateTime updatedAt;

  /// The URI for the SIP trunk
  String uri;

  /// Username for SIP trunk authentication
  String username;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SIPTrunkResponse &&
          _deepEquality.equals(other.allowedIps, allowedIps) &&
          other.createdAt == createdAt &&
          other.id == id &&
          other.name == name &&
          _deepEquality.equals(other.numbers, numbers) &&
          other.password == password &&
          other.updatedAt == updatedAt &&
          other.uri == uri &&
          other.username == username;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (allowedIps.hashCode) +
      (createdAt.hashCode) +
      (id.hashCode) +
      (name.hashCode) +
      (numbers.hashCode) +
      (password.hashCode) +
      (updatedAt.hashCode) +
      (uri.hashCode) +
      (username.hashCode);

  @override
  String toString() =>
      'SIPTrunkResponse[allowedIps=$allowedIps, createdAt=$createdAt, id=$id, name=$name, numbers=$numbers, password=$password, updatedAt=$updatedAt, uri=$uri, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'allowed_ips'] = this.allowedIps;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'id'] = this.id;
    json[r'name'] = this.name;
    json[r'numbers'] = this.numbers;
    json[r'password'] = this.password;
    json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    json[r'uri'] = this.uri;
    json[r'username'] = this.username;
    return json;
  }

  /// Returns a new [SIPTrunkResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SIPTrunkResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'allowed_ips'),
            'Required key "SIPTrunkResponse[allowed_ips]" is missing from JSON.');
        assert(json[r'allowed_ips'] != null,
            'Required key "SIPTrunkResponse[allowed_ips]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "SIPTrunkResponse[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "SIPTrunkResponse[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'id'),
            'Required key "SIPTrunkResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null,
            'Required key "SIPTrunkResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'),
            'Required key "SIPTrunkResponse[name]" is missing from JSON.');
        assert(json[r'name'] != null,
            'Required key "SIPTrunkResponse[name]" has a null value in JSON.');
        assert(json.containsKey(r'numbers'),
            'Required key "SIPTrunkResponse[numbers]" is missing from JSON.');
        assert(json[r'numbers'] != null,
            'Required key "SIPTrunkResponse[numbers]" has a null value in JSON.');
        assert(json.containsKey(r'password'),
            'Required key "SIPTrunkResponse[password]" is missing from JSON.');
        assert(json[r'password'] != null,
            'Required key "SIPTrunkResponse[password]" has a null value in JSON.');
        assert(json.containsKey(r'updated_at'),
            'Required key "SIPTrunkResponse[updated_at]" is missing from JSON.');
        assert(json[r'updated_at'] != null,
            'Required key "SIPTrunkResponse[updated_at]" has a null value in JSON.');
        assert(json.containsKey(r'uri'),
            'Required key "SIPTrunkResponse[uri]" is missing from JSON.');
        assert(json[r'uri'] != null,
            'Required key "SIPTrunkResponse[uri]" has a null value in JSON.');
        assert(json.containsKey(r'username'),
            'Required key "SIPTrunkResponse[username]" is missing from JSON.');
        assert(json[r'username'] != null,
            'Required key "SIPTrunkResponse[username]" has a null value in JSON.');
        return true;
      }());

      return SIPTrunkResponse(
        allowedIps: json[r'allowed_ips'] is Iterable
            ? (json[r'allowed_ips'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        createdAt: mapDateTime(json, r'created_at', r'')!,
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        numbers: json[r'numbers'] is Iterable
            ? (json[r'numbers'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        password: mapValueOfType<String>(json, r'password')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        uri: mapValueOfType<String>(json, r'uri')!,
        username: mapValueOfType<String>(json, r'username')!,
      );
    }
    return null;
  }

  static List<SIPTrunkResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SIPTrunkResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SIPTrunkResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SIPTrunkResponse> mapFromJson(dynamic json) {
    final map = <String, SIPTrunkResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SIPTrunkResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SIPTrunkResponse-objects as value to a dart map
  static Map<String, List<SIPTrunkResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SIPTrunkResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SIPTrunkResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'allowed_ips',
    'created_at',
    'id',
    'name',
    'numbers',
    'password',
    'updated_at',
    'uri',
    'username',
  };
}
