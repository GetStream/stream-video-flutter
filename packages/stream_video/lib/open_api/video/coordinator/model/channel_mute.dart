//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChannelMute {
  /// Returns a new [ChannelMute] instance.
  ChannelMute({
    this.channel,
    required this.createdAt,
    this.expires,
    required this.updatedAt,
    this.user,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ChannelResponse? channel;

  /// Date/time of creation
  DateTime createdAt;

  /// Date/time of mute expiration
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expires;

  /// Date/time of the last update
  DateTime updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChannelMute &&
    other.channel == channel &&
    other.createdAt == createdAt &&
    other.expires == expires &&
    other.updatedAt == updatedAt &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (channel == null ? 0 : channel!.hashCode) +
    (createdAt.hashCode) +
    (expires == null ? 0 : expires!.hashCode) +
    (updatedAt.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'ChannelMute[channel=$channel, createdAt=$createdAt, expires=$expires, updatedAt=$updatedAt, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.channel != null) {
      json[r'channel'] = this.channel;
    } else {
      json[r'channel'] = null;
    }
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.expires != null) {
      json[r'expires'] = this.expires!.toUtc().toIso8601String();
    } else {
      json[r'expires'] = null;
    }
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [ChannelMute] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChannelMute? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ChannelMute[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ChannelMute[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ChannelMute(
        channel: ChannelResponse.fromJson(json[r'channel']),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        expires: mapDateTime(json, r'expires', r''),
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        user: UserObject.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<ChannelMute> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelMute>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelMute.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChannelMute> mapFromJson(dynamic json) {
    final map = <String, ChannelMute>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChannelMute.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChannelMute-objects as value to a dart map
  static Map<String, List<ChannelMute>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChannelMute>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChannelMute.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'updated_at',
  };
}

