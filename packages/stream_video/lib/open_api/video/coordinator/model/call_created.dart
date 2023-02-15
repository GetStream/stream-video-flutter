//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallCreated {
  /// Returns a new [CallCreated] instance.
  CallCreated({
    required this.call,
    required this.createdAt,
    this.members = const [],
    required this.ringing,
    required this.type,
  });

  CallResponse call;

  DateTime createdAt;

  List<MemberResponse> members;

  bool ringing;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallCreated &&
     other.call == call &&
     other.createdAt == createdAt &&
     other.members == members &&
     other.ringing == ringing &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (call.hashCode) +
    (createdAt.hashCode) +
    (members.hashCode) +
    (ringing.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'CallCreated[call=$call, createdAt=$createdAt, members=$members, ringing=$ringing, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call'] = this.call;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'members'] = this.members;
      json[r'ringing'] = this.ringing;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallCreated] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallCreated? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallCreated[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallCreated[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallCreated(
        call: CallResponse.fromJson(json[r'call'])!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        members: MemberResponse.listFromJson(json[r'members'])!,
        ringing: mapValueOfType<bool>(json, r'ringing')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallCreated>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallCreated>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallCreated.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallCreated> mapFromJson(dynamic json) {
    final map = <String, CallCreated>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallCreated.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallCreated-objects as value to a dart map
  static Map<String, List<CallCreated>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallCreated>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallCreated.listFromJson(entry.value, growable: growable,);
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
    'created_at',
    'members',
    'ringing',
    'type',
  };
}

