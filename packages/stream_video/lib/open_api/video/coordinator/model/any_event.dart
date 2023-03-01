//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnyEvent {
  /// Returns a new [AnyEvent] instance.
  AnyEvent({
    required this.createdAt,
    required this.type,
  });

  DateTime createdAt;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnyEvent &&
     other.createdAt == createdAt &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'AnyEvent[createdAt=$createdAt, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [AnyEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnyEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AnyEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AnyEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AnyEvent(
        createdAt: mapDateTime(json, r'created_at', '')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<AnyEvent>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnyEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnyEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnyEvent> mapFromJson(dynamic json) {
    final map = <String, AnyEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnyEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnyEvent-objects as value to a dart map
  static Map<String, List<AnyEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnyEvent>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnyEvent.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'type',
  };
}

