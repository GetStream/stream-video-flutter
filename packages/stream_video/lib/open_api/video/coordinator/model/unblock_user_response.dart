//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UnblockUserResponse {
  /// Returns a new [UnblockUserResponse] instance.
  UnblockUserResponse({
    required this.duration,
  });

  /// Duration of the request in human-readable format
  String duration;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UnblockUserResponse &&
     other.duration == duration;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (duration.hashCode);

  @override
  String toString() => 'UnblockUserResponse[duration=$duration]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'duration'] = this.duration;
    return json;
  }

  /// Returns a new [UnblockUserResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UnblockUserResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UnblockUserResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UnblockUserResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UnblockUserResponse(
        duration: mapValueOfType<String>(json, r'duration')!,
      );
    }
    return null;
  }

  static List<UnblockUserResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UnblockUserResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UnblockUserResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UnblockUserResponse> mapFromJson(dynamic json) {
    final map = <String, UnblockUserResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UnblockUserResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UnblockUserResponse-objects as value to a dart map
  static Map<String, List<UnblockUserResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UnblockUserResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UnblockUserResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'duration',
  };
}

