//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AppUpdatedEvent {
  /// Returns a new [AppUpdatedEvent] instance.
  AppUpdatedEvent({
    required this.app,
    required this.createdAt,
    this.custom = const {},
    this.receivedAt,
    this.type = 'app.updated',
  });

  AppEventResponse app;

  /// Date/time of creation
  DateTime createdAt;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? receivedAt;

  /// The type of event: \"app.updated\" in this case
  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUpdatedEvent &&
          other.app == app &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.receivedAt == receivedAt &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (app.hashCode) +
      (createdAt.hashCode) +
      (custom.hashCode) +
      (receivedAt == null ? 0 : receivedAt!.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'AppUpdatedEvent[app=$app, createdAt=$createdAt, custom=$custom, receivedAt=$receivedAt, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'app'] = this.app;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'custom'] = this.custom;
    if (this.receivedAt != null) {
      json[r'received_at'] = this.receivedAt!.toUtc().toIso8601String();
    } else {
      json[r'received_at'] = null;
    }
    json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [AppUpdatedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AppUpdatedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "AppUpdatedEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "AppUpdatedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AppUpdatedEvent(
        app: AppEventResponse.fromJson(json[r'app'])!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        receivedAt: mapDateTime(json, r'received_at', r''),
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<AppUpdatedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <AppUpdatedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppUpdatedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AppUpdatedEvent> mapFromJson(dynamic json) {
    final map = <String, AppUpdatedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AppUpdatedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AppUpdatedEvent-objects as value to a dart map
  static Map<String, List<AppUpdatedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<AppUpdatedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AppUpdatedEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'app',
    'created_at',
    'custom',
    'type',
  };
}
