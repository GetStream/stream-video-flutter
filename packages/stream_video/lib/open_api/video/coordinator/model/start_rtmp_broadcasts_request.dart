//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StartRTMPBroadcastsRequest {
  /// Returns a new [StartRTMPBroadcastsRequest] instance.
  StartRTMPBroadcastsRequest({
    this.layout,
    required this.name,
    this.password,
    this.quality,
    this.streamKey,
    required this.streamUrl,
    this.username,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  LayoutSettings? layout;

  String name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? password;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? quality;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? streamKey;

  String streamUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? username;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StartRTMPBroadcastsRequest &&
    other.layout == layout &&
    other.name == name &&
    other.password == password &&
    other.quality == quality &&
    other.streamKey == streamKey &&
    other.streamUrl == streamUrl &&
    other.username == username;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (layout == null ? 0 : layout!.hashCode) +
    (name.hashCode) +
    (password == null ? 0 : password!.hashCode) +
    (quality == null ? 0 : quality!.hashCode) +
    (streamKey == null ? 0 : streamKey!.hashCode) +
    (streamUrl.hashCode) +
    (username == null ? 0 : username!.hashCode);

  @override
  String toString() => 'StartRTMPBroadcastsRequest[layout=$layout, name=$name, password=$password, quality=$quality, streamKey=$streamKey, streamUrl=$streamUrl, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.layout != null) {
      json[r'layout'] = this.layout;
    } else {
      json[r'layout'] = null;
    }
      json[r'name'] = this.name;
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
    }
    if (this.quality != null) {
      json[r'quality'] = this.quality;
    } else {
      json[r'quality'] = null;
    }
    if (this.streamKey != null) {
      json[r'stream_key'] = this.streamKey;
    } else {
      json[r'stream_key'] = null;
    }
      json[r'stream_url'] = this.streamUrl;
    if (this.username != null) {
      json[r'username'] = this.username;
    } else {
      json[r'username'] = null;
    }
    return json;
  }

  /// Returns a new [StartRTMPBroadcastsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StartRTMPBroadcastsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StartRTMPBroadcastsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StartRTMPBroadcastsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StartRTMPBroadcastsRequest(
        layout: LayoutSettings.fromJson(json[r'layout']),
        name: mapValueOfType<String>(json, r'name')!,
        password: mapValueOfType<String>(json, r'password'),
        quality: mapValueOfType<String>(json, r'quality'),
        streamKey: mapValueOfType<String>(json, r'stream_key'),
        streamUrl: mapValueOfType<String>(json, r'stream_url')!,
        username: mapValueOfType<String>(json, r'username'),
      );
    }
    return null;
  }

  static List<StartRTMPBroadcastsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StartRTMPBroadcastsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartRTMPBroadcastsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StartRTMPBroadcastsRequest> mapFromJson(dynamic json) {
    final map = <String, StartRTMPBroadcastsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StartRTMPBroadcastsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StartRTMPBroadcastsRequest-objects as value to a dart map
  static Map<String, List<StartRTMPBroadcastsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StartRTMPBroadcastsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StartRTMPBroadcastsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'stream_url',
  };
}

