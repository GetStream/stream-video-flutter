//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class JoinCallRequest {
  /// Returns a new [JoinCallRequest] instance.
  JoinCallRequest({
    this.create,
    this.data,
    this.datacenterHintedId,
    this.membersLimit,
    this.ring,
  });

  /// if true the call will be created if it doesn't exist
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? create;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallRequest? data;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? datacenterHintedId;

  /// Maximum value: 100
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? membersLimit;

  /// if true and the call is created, the notification will include ring=true
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? ring;

  @override
  bool operator ==(Object other) => identical(this, other) || other is JoinCallRequest &&
     other.create == create &&
     other.data == data &&
     other.datacenterHintedId == datacenterHintedId &&
     other.membersLimit == membersLimit &&
     other.ring == ring;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (create == null ? 0 : create!.hashCode) +
    (data == null ? 0 : data!.hashCode) +
    (datacenterHintedId == null ? 0 : datacenterHintedId!.hashCode) +
    (membersLimit == null ? 0 : membersLimit!.hashCode) +
    (ring == null ? 0 : ring!.hashCode);

  @override
  String toString() => 'JoinCallRequest[create=$create, data=$data, datacenterHintedId=$datacenterHintedId, membersLimit=$membersLimit, ring=$ring]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.create != null) {
      json[r'create'] = this.create;
    } else {
      json[r'create'] = null;
    }
    if (this.data != null) {
      json[r'data'] = this.data;
    } else {
      json[r'data'] = null;
    }
    if (this.datacenterHintedId != null) {
      json[r'datacenter_hinted_id'] = this.datacenterHintedId;
    } else {
      json[r'datacenter_hinted_id'] = null;
    }
    if (this.membersLimit != null) {
      json[r'members_limit'] = this.membersLimit;
    } else {
      json[r'members_limit'] = null;
    }
    if (this.ring != null) {
      json[r'ring'] = this.ring;
    } else {
      json[r'ring'] = null;
    }
    return json;
  }

  /// Returns a new [JoinCallRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static JoinCallRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "JoinCallRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "JoinCallRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return JoinCallRequest(
        create: mapValueOfType<bool>(json, r'create'),
        data: CallRequest.fromJson(json[r'data']),
        datacenterHintedId: mapValueOfType<String>(json, r'datacenter_hinted_id'),
        membersLimit: mapValueOfType<int>(json, r'members_limit'),
        ring: mapValueOfType<bool>(json, r'ring'),
      );
    }
    return null;
  }

  static List<JoinCallRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <JoinCallRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = JoinCallRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, JoinCallRequest> mapFromJson(dynamic json) {
    final map = <String, JoinCallRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = JoinCallRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of JoinCallRequest-objects as value to a dart map
  static Map<String, List<JoinCallRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<JoinCallRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = JoinCallRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

