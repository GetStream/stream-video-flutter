//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallUpdated {
  /// Returns a new [CallUpdated] instance.
  CallUpdated({
    required this.call,
    this.capabilitiesByRole = const {},
    required this.createdAt,
    required this.type,
  });

  CallResponse call;

  Map<String, List<String>> capabilitiesByRole;

  DateTime createdAt;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallUpdated &&
     other.call == call &&
     other.capabilitiesByRole == capabilitiesByRole &&
     other.createdAt == createdAt &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (call.hashCode) +
    (capabilitiesByRole.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'CallUpdated[call=$call, capabilitiesByRole=$capabilitiesByRole, createdAt=$createdAt, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call'] = this.call;
      json[r'capabilities_by_role'] = this.capabilitiesByRole;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallUpdated] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallUpdated? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallUpdated[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallUpdated[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallUpdated(
        call: CallResponse.fromJson(json[r'call'])!,
        capabilitiesByRole: json[r'capabilities_by_role'] == null
          ? const {}
            : mapCastOfType<String, List>(json, r'capabilities_by_role'),
        createdAt: mapDateTime(json, r'created_at', '')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallUpdated>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallUpdated>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallUpdated.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallUpdated> mapFromJson(dynamic json) {
    final map = <String, CallUpdated>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallUpdated.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallUpdated-objects as value to a dart map
  static Map<String, List<CallUpdated>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallUpdated>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallUpdated.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call',
    'capabilities_by_role',
    'created_at',
    'type',
  };
}

