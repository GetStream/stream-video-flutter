//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallRequest {
  /// Returns a new [CallRequest] instance.
  CallRequest({
    this.channelCid,
    this.custom = const {},
    this.members = const [],
    this.settingsOverride,
    this.startsAt,
    this.team,
    this.video,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? channelCid;

  Map<String, Object> custom;

  List<MemberRequest> members;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallSettingsRequest? settingsOverride;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? startsAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? team;

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
      other is CallRequest &&
          other.channelCid == channelCid &&
          _deepEquality.equals(other.custom, custom) &&
          _deepEquality.equals(other.members, members) &&
          other.settingsOverride == settingsOverride &&
          other.startsAt == startsAt &&
          other.team == team &&
          other.video == video;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (channelCid == null ? 0 : channelCid!.hashCode) +
      (custom.hashCode) +
      (members.hashCode) +
      (settingsOverride == null ? 0 : settingsOverride!.hashCode) +
      (startsAt == null ? 0 : startsAt!.hashCode) +
      (team == null ? 0 : team!.hashCode) +
      (video == null ? 0 : video!.hashCode);

  @override
  String toString() =>
      'CallRequest[channelCid=$channelCid, custom=$custom, members=$members, settingsOverride=$settingsOverride, startsAt=$startsAt, team=$team, video=$video]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.channelCid != null) {
      json[r'channel_cid'] = this.channelCid;
    } else {
      json[r'channel_cid'] = null;
    }
    json[r'custom'] = this.custom;
    json[r'members'] = this.members;
    if (this.settingsOverride != null) {
      json[r'settings_override'] = this.settingsOverride;
    } else {
      json[r'settings_override'] = null;
    }
    if (this.startsAt != null) {
      json[r'starts_at'] = this.startsAt!.toUtc().toIso8601String();
    } else {
      json[r'starts_at'] = null;
    }
    if (this.team != null) {
      json[r'team'] = this.team;
    } else {
      json[r'team'] = null;
    }
    if (this.video != null) {
      json[r'video'] = this.video;
    } else {
      json[r'video'] = null;
    }
    return json;
  }

  /// Returns a new [CallRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallRequest(
        channelCid: mapValueOfType<String>(json, r'channel_cid'),
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        members: MemberRequest.listFromJson(json[r'members']),
        settingsOverride:
            CallSettingsRequest.fromJson(json[r'settings_override']),
        startsAt: mapDateTime(json, r'starts_at', r''),
        team: mapValueOfType<String>(json, r'team'),
        video: mapValueOfType<bool>(json, r'video'),
      );
    }
    return null;
  }

  static List<CallRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallRequest> mapFromJson(dynamic json) {
    final map = <String, CallRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallRequest-objects as value to a dart map
  static Map<String, List<CallRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallRequest.listFromJson(
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
