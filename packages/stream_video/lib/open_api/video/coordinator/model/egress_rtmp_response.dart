//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EgressRTMPResponse {
  /// Returns a new [EgressRTMPResponse] instance.
  EgressRTMPResponse({
    required this.name,
    required this.startedAt,
    this.streamKey,
    this.streamUrl,
  });

  String name;

  DateTime startedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? streamKey;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? streamUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EgressRTMPResponse &&
    other.name == name &&
    other.startedAt == startedAt &&
    other.streamKey == streamKey &&
    other.streamUrl == streamUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (startedAt.hashCode) +
    (streamKey == null ? 0 : streamKey!.hashCode) +
    (streamUrl == null ? 0 : streamUrl!.hashCode);

  @override
  String toString() => 'EgressRTMPResponse[name=$name, startedAt=$startedAt, streamKey=$streamKey, streamUrl=$streamUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'started_at'] = this.startedAt.toUtc().toIso8601String();
    if (this.streamKey != null) {
      json[r'stream_key'] = this.streamKey;
    } else {
      json[r'stream_key'] = null;
    }
    if (this.streamUrl != null) {
      json[r'stream_url'] = this.streamUrl;
    } else {
      json[r'stream_url'] = null;
    }
    return json;
  }

  /// Returns a new [EgressRTMPResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EgressRTMPResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EgressRTMPResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EgressRTMPResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EgressRTMPResponse(
        name: mapValueOfType<String>(json, r'name')!,
        startedAt: mapDateTime(json, r'started_at', r'')!,
        streamKey: mapValueOfType<String>(json, r'stream_key'),
        streamUrl: mapValueOfType<String>(json, r'stream_url'),
      );
    }
    return null;
  }

  static List<EgressRTMPResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EgressRTMPResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EgressRTMPResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EgressRTMPResponse> mapFromJson(dynamic json) {
    final map = <String, EgressRTMPResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EgressRTMPResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EgressRTMPResponse-objects as value to a dart map
  static Map<String, List<EgressRTMPResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EgressRTMPResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EgressRTMPResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'started_at',
  };
}

