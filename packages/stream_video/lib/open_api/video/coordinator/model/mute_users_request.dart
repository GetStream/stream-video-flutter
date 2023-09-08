//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MuteUsersRequest {
  /// Returns a new [MuteUsersRequest] instance.
  MuteUsersRequest({
    this.audio,
    this.muteAllUsers,
    this.screenshare,
    this.userIds = const [],
    this.video,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? audio;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? muteAllUsers;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? screenshare;

  List<String> userIds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? video;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MuteUsersRequest &&
     other.audio == audio &&
     other.muteAllUsers == muteAllUsers &&
     other.screenshare == screenshare &&
     other.userIds == userIds &&
     other.video == video;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audio == null ? 0 : audio!.hashCode) +
    (muteAllUsers == null ? 0 : muteAllUsers!.hashCode) +
    (screenshare == null ? 0 : screenshare!.hashCode) +
    (userIds.hashCode) +
    (video == null ? 0 : video!.hashCode);

  @override
  String toString() => 'MuteUsersRequest[audio=$audio, muteAllUsers=$muteAllUsers, screenshare=$screenshare, userIds=$userIds, video=$video]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.audio != null) {
      json[r'audio'] = this.audio;
    } else {
      json[r'audio'] = null;
    }
    if (this.muteAllUsers != null) {
      json[r'mute_all_users'] = this.muteAllUsers;
    } else {
      json[r'mute_all_users'] = null;
    }
    if (this.screenshare != null) {
      json[r'screenshare'] = this.screenshare;
    } else {
      json[r'screenshare'] = null;
    }
      json[r'user_ids'] = this.userIds;
    if (this.video != null) {
      json[r'video'] = this.video;
    } else {
      json[r'video'] = null;
    }
    return json;
  }

  /// Returns a new [MuteUsersRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MuteUsersRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MuteUsersRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MuteUsersRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MuteUsersRequest(
        audio: mapValueOfType<bool>(json, r'audio'),
        muteAllUsers: mapValueOfType<bool>(json, r'mute_all_users'),
        screenshare: mapValueOfType<bool>(json, r'screenshare'),
        userIds: json[r'user_ids'] is List
            ? (json[r'user_ids'] as List).cast<String>()
            : const [],
        video: mapValueOfType<bool>(json, r'video'),
      );
    }
    return null;
  }

  static List<MuteUsersRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MuteUsersRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MuteUsersRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MuteUsersRequest> mapFromJson(dynamic json) {
    final map = <String, MuteUsersRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MuteUsersRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MuteUsersRequest-objects as value to a dart map
  static Map<String, List<MuteUsersRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MuteUsersRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MuteUsersRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

