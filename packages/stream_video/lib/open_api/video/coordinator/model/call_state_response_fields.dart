//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStateResponseFields {
  /// Returns a new [CallStateResponseFields] instance.
  CallStateResponseFields({
    required this.call,
    this.members = const [],
    this.membership,
    this.ownCapabilities = const [],
  });

  CallResponse call;

  /// List of call members
  List<MemberResponse> members;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MemberResponse? membership;

  List<OwnCapability> ownCapabilities;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallStateResponseFields &&
     other.call == call &&
     other.members == members &&
     other.membership == membership &&
     other.ownCapabilities == ownCapabilities;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (call.hashCode) +
    (members.hashCode) +
    (membership == null ? 0 : membership!.hashCode) +
    (ownCapabilities.hashCode);

  @override
  String toString() => 'CallStateResponseFields[call=$call, members=$members, membership=$membership, ownCapabilities=$ownCapabilities]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call'] = this.call;
      json[r'members'] = this.members;
    if (this.membership != null) {
      json[r'membership'] = this.membership;
    } else {
      json[r'membership'] = null;
    }
      json[r'own_capabilities'] = this.ownCapabilities;
    return json;
  }

  /// Returns a new [CallStateResponseFields] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStateResponseFields? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallStateResponseFields[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallStateResponseFields[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallStateResponseFields(
        call: CallResponse.fromJson(json[r'call'])!,
        members: MemberResponse.listFromJson(json[r'members']),
        membership: MemberResponse.fromJson(json[r'membership']),
        ownCapabilities: OwnCapability.listFromJson(json[r'own_capabilities']),
      );
    }
    return null;
  }

  static List<CallStateResponseFields> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallStateResponseFields>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStateResponseFields.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStateResponseFields> mapFromJson(dynamic json) {
    final map = <String, CallStateResponseFields>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStateResponseFields.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStateResponseFields-objects as value to a dart map
  static Map<String, List<CallStateResponseFields>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallStateResponseFields>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStateResponseFields.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call',
    'members',
    'own_capabilities',
  };
}

