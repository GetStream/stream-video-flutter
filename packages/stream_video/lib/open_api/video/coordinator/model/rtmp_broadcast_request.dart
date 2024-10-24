//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RTMPBroadcastRequest {
  /// Returns a new [RTMPBroadcastRequest] instance.
  RTMPBroadcastRequest({
    this.layout,
    required this.name,
    this.quality,
    this.streamKey,
    required this.streamUrl,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  LayoutSettingsRequest? layout;

  /// Name identifier for RTMP broadcast, must be unique in call
  String name;

  /// If provided, will override the call's RTMP settings quality
  RTMPBroadcastRequestQualityEnum? quality;

  /// If provided, will be appended at the end of stream_url
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? streamKey;

  /// URL for the RTMP server to send the call to
  String streamUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RTMPBroadcastRequest &&
    other.layout == layout &&
    other.name == name &&
    other.quality == quality &&
    other.streamKey == streamKey &&
    other.streamUrl == streamUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (layout == null ? 0 : layout!.hashCode) +
    (name.hashCode) +
    (quality == null ? 0 : quality!.hashCode) +
    (streamKey == null ? 0 : streamKey!.hashCode) +
    (streamUrl.hashCode);

  @override
  String toString() => 'RTMPBroadcastRequest[layout=$layout, name=$name, quality=$quality, streamKey=$streamKey, streamUrl=$streamUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.layout != null) {
      json[r'layout'] = this.layout;
    } else {
      json[r'layout'] = null;
    }
      json[r'name'] = this.name;
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
    return json;
  }

  /// Returns a new [RTMPBroadcastRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RTMPBroadcastRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RTMPBroadcastRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RTMPBroadcastRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RTMPBroadcastRequest(
        layout: LayoutSettingsRequest.fromJson(json[r'layout']),
        name: mapValueOfType<String>(json, r'name')!,
        quality: RTMPBroadcastRequestQualityEnum.fromJson(json[r'quality']),
        streamKey: mapValueOfType<String>(json, r'stream_key'),
        streamUrl: mapValueOfType<String>(json, r'stream_url')!,
      );
    }
    return null;
  }

  static List<RTMPBroadcastRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RTMPBroadcastRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RTMPBroadcastRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RTMPBroadcastRequest> mapFromJson(dynamic json) {
    final map = <String, RTMPBroadcastRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RTMPBroadcastRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RTMPBroadcastRequest-objects as value to a dart map
  static Map<String, List<RTMPBroadcastRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RTMPBroadcastRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RTMPBroadcastRequest.listFromJson(entry.value, growable: growable,);
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

/// If provided, will override the call's RTMP settings quality
class RTMPBroadcastRequestQualityEnum {
  /// Instantiate a new enum with the provided [value].
  const RTMPBroadcastRequestQualityEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const n360p = RTMPBroadcastRequestQualityEnum._(r'360p');
  static const n480p = RTMPBroadcastRequestQualityEnum._(r'480p');
  static const n720p = RTMPBroadcastRequestQualityEnum._(r'720p');
  static const n1080p = RTMPBroadcastRequestQualityEnum._(r'1080p');
  static const n1440p = RTMPBroadcastRequestQualityEnum._(r'1440p');
  static const portrait360x640 = RTMPBroadcastRequestQualityEnum._(r'portrait-360x640');
  static const portrait480x854 = RTMPBroadcastRequestQualityEnum._(r'portrait-480x854');
  static const portrait720x1280 = RTMPBroadcastRequestQualityEnum._(r'portrait-720x1280');
  static const portrait1080x1920 = RTMPBroadcastRequestQualityEnum._(r'portrait-1080x1920');
  static const portrait1440x2560 = RTMPBroadcastRequestQualityEnum._(r'portrait-1440x2560');

  /// List of all possible values in this [enum][RTMPBroadcastRequestQualityEnum].
  static const values = <RTMPBroadcastRequestQualityEnum>[
    n360p,
    n480p,
    n720p,
    n1080p,
    n1440p,
    portrait360x640,
    portrait480x854,
    portrait720x1280,
    portrait1080x1920,
    portrait1440x2560,
  ];

  static RTMPBroadcastRequestQualityEnum? fromJson(dynamic value) => RTMPBroadcastRequestQualityEnumTypeTransformer().decode(value);

  static List<RTMPBroadcastRequestQualityEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RTMPBroadcastRequestQualityEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RTMPBroadcastRequestQualityEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RTMPBroadcastRequestQualityEnum] to String,
/// and [decode] dynamic data back to [RTMPBroadcastRequestQualityEnum].
class RTMPBroadcastRequestQualityEnumTypeTransformer {
  factory RTMPBroadcastRequestQualityEnumTypeTransformer() => _instance ??= const RTMPBroadcastRequestQualityEnumTypeTransformer._();

  const RTMPBroadcastRequestQualityEnumTypeTransformer._();

  String encode(RTMPBroadcastRequestQualityEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RTMPBroadcastRequestQualityEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RTMPBroadcastRequestQualityEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'360p': return RTMPBroadcastRequestQualityEnum.n360p;
        case r'480p': return RTMPBroadcastRequestQualityEnum.n480p;
        case r'720p': return RTMPBroadcastRequestQualityEnum.n720p;
        case r'1080p': return RTMPBroadcastRequestQualityEnum.n1080p;
        case r'1440p': return RTMPBroadcastRequestQualityEnum.n1440p;
        case r'portrait-360x640': return RTMPBroadcastRequestQualityEnum.portrait360x640;
        case r'portrait-480x854': return RTMPBroadcastRequestQualityEnum.portrait480x854;
        case r'portrait-720x1280': return RTMPBroadcastRequestQualityEnum.portrait720x1280;
        case r'portrait-1080x1920': return RTMPBroadcastRequestQualityEnum.portrait1080x1920;
        case r'portrait-1440x2560': return RTMPBroadcastRequestQualityEnum.portrait1440x2560;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RTMPBroadcastRequestQualityEnumTypeTransformer] instance.
  static RTMPBroadcastRequestQualityEnumTypeTransformer? _instance;
}


