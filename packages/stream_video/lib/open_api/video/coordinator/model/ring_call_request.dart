//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RingCallRequest {
  /// Returns a new [RingCallRequest] instance.
  RingCallRequest({
    this.membersIds = const [],
    this.video,
  });

  /// Members that should receive the ring. If no ids are provided, all call members who are not already in the call will receive ring notifications.
  List<String> membersIds;

  /// Indicate if call should be video
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? video;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RingCallRequest &&
          _deepEquality.equals(other.membersIds, membersIds) &&
          other.video == video;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (membersIds.hashCode) + (video == null ? 0 : video!.hashCode);

  @override
  String toString() => 'RingCallRequest[membersIds=$membersIds, video=$video]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'members_ids'] = this.membersIds;
    if (this.video != null) {
      json[r'video'] = this.video;
    } else {
      json[r'video'] = null;
    }
    return json;
  }

  /// Returns a new [RingCallRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RingCallRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "RingCallRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "RingCallRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RingCallRequest(
        membersIds: json[r'members_ids'] is Iterable
            ? (json[r'members_ids'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        video: mapValueOfType<bool>(json, r'video'),
      );
    }
    return null;
  }

  static List<RingCallRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <RingCallRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RingCallRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RingCallRequest> mapFromJson(dynamic json) {
    final map = <String, RingCallRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RingCallRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RingCallRequest-objects as value to a dart map
  static Map<String, List<RingCallRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<RingCallRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RingCallRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
