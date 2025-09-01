//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressAudioEncodingResponse {
  /// Returns a new [IngressAudioEncodingResponse] instance.
  IngressAudioEncodingResponse({
    required this.bitrate,
    required this.channels,
    required this.enableDtx,
  });

  int bitrate;

  int channels;

  bool enableDtx;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressAudioEncodingResponse &&
          other.bitrate == bitrate &&
          other.channels == channels &&
          other.enableDtx == enableDtx;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (bitrate.hashCode) + (channels.hashCode) + (enableDtx.hashCode);

  @override
  String toString() =>
      'IngressAudioEncodingResponse[bitrate=$bitrate, channels=$channels, enableDtx=$enableDtx]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'bitrate'] = this.bitrate;
    json[r'channels'] = this.channels;
    json[r'enable_dtx'] = this.enableDtx;
    return json;
  }

  /// Returns a new [IngressAudioEncodingResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressAudioEncodingResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "IngressAudioEncodingResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "IngressAudioEncodingResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IngressAudioEncodingResponse(
        bitrate: mapValueOfType<int>(json, r'bitrate')!,
        channels: mapValueOfType<int>(json, r'channels')!,
        enableDtx: mapValueOfType<bool>(json, r'enable_dtx')!,
      );
    }
    return null;
  }

  static List<IngressAudioEncodingResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressAudioEncodingResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressAudioEncodingResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressAudioEncodingResponse> mapFromJson(dynamic json) {
    final map = <String, IngressAudioEncodingResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressAudioEncodingResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressAudioEncodingResponse-objects as value to a dart map
  static Map<String, List<IngressAudioEncodingResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressAudioEncodingResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressAudioEncodingResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'bitrate',
    'channels',
    'enable_dtx',
  };
}
