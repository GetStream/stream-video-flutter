//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Command {
  /// Returns a new [Command] instance.
  Command({
    required this.args,
    this.createdAt,
    required this.description,
    required this.name,
    required this.set_,
    this.updatedAt,
  });

  /// Arguments help text, shown in commands auto-completion
  String args;

  /// Date/time of creation
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  /// Description, shown in commands auto-completion
  String description;

  /// Unique command name
  String name;

  /// Set name used for grouping commands
  String set_;

  /// Date/time of the last update
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Command &&
    other.args == args &&
    other.createdAt == createdAt &&
    other.description == description &&
    other.name == name &&
    other.set_ == set_ &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (args.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (description.hashCode) +
    (name.hashCode) +
    (set_.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode);

  @override
  String toString() => 'Command[args=$args, createdAt=$createdAt, description=$description, name=$name, set_=$set_, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'args'] = this.args;
    if (this.createdAt != null) {
      json[r'created_at'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'created_at'] = null;
    }
      json[r'description'] = this.description;
      json[r'name'] = this.name;
      json[r'set'] = this.set_;
    if (this.updatedAt != null) {
      json[r'updated_at'] = this.updatedAt!.toUtc().toIso8601String();
    } else {
      json[r'updated_at'] = null;
    }
    return json;
  }

  /// Returns a new [Command] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Command? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Command[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Command[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Command(
        args: mapValueOfType<String>(json, r'args')!,
        createdAt: mapDateTime(json, r'created_at', r''),
        description: mapValueOfType<String>(json, r'description')!,
        name: mapValueOfType<String>(json, r'name')!,
        set_: mapValueOfType<String>(json, r'set')!,
        updatedAt: mapDateTime(json, r'updated_at', r''),
      );
    }
    return null;
  }

  static List<Command> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Command>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Command.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Command> mapFromJson(dynamic json) {
    final map = <String, Command>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Command.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Command-objects as value to a dart map
  static Map<String, List<Command>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Command>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Command.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'args',
    'description',
    'name',
    'set',
  };
}

