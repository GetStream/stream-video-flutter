//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallRecordingReadyEvent {
  /// Returns a new [CallRecordingReadyEvent] instance.
  CallRecordingReadyEvent({
    required this.callCid,
    required this.callRecording,
    required this.createdAt,
    required this.egressId,
    required this.recordingType,
    this.type = 'call.recording_ready',
  });

  String callCid;

  CallRecording callRecording;

  DateTime createdAt;

  String egressId;

  /// The type of recording
  CallRecordingReadyEventRecordingTypeEnum recordingType;

  /// The type of event: \"call.recording_ready\" in this case
  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallRecordingReadyEvent &&
          other.callCid == callCid &&
          other.callRecording == callRecording &&
          other.createdAt == createdAt &&
          other.egressId == egressId &&
          other.recordingType == recordingType &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (callRecording.hashCode) +
      (createdAt.hashCode) +
      (egressId.hashCode) +
      (recordingType.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'CallRecordingReadyEvent[callCid=$callCid, callRecording=$callRecording, createdAt=$createdAt, egressId=$egressId, recordingType=$recordingType, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'call_recording'] = this.callRecording;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'egress_id'] = this.egressId;
    json[r'recording_type'] = this.recordingType;
    json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallRecordingReadyEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallRecordingReadyEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallRecordingReadyEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallRecordingReadyEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallRecordingReadyEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        callRecording: CallRecording.fromJson(json[r'call_recording'])!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        egressId: mapValueOfType<String>(json, r'egress_id')!,
        recordingType: CallRecordingReadyEventRecordingTypeEnum.fromJson(
            json[r'recording_type'])!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallRecordingReadyEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallRecordingReadyEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallRecordingReadyEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallRecordingReadyEvent> mapFromJson(dynamic json) {
    final map = <String, CallRecordingReadyEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallRecordingReadyEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallRecordingReadyEvent-objects as value to a dart map
  static Map<String, List<CallRecordingReadyEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallRecordingReadyEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallRecordingReadyEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'call_recording',
    'created_at',
    'egress_id',
    'recording_type',
    'type',
  };
}

/// The type of recording
class CallRecordingReadyEventRecordingTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const CallRecordingReadyEventRecordingTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const composite =
      CallRecordingReadyEventRecordingTypeEnum._(r'composite');
  static const individual =
      CallRecordingReadyEventRecordingTypeEnum._(r'individual');
  static const raw = CallRecordingReadyEventRecordingTypeEnum._(r'raw');

  /// List of all possible values in this [enum][CallRecordingReadyEventRecordingTypeEnum].
  static const values = <CallRecordingReadyEventRecordingTypeEnum>[
    composite,
    individual,
    raw,
  ];

  static CallRecordingReadyEventRecordingTypeEnum? fromJson(dynamic value) =>
      CallRecordingReadyEventRecordingTypeEnumTypeTransformer().decode(value);

  static List<CallRecordingReadyEventRecordingTypeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallRecordingReadyEventRecordingTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallRecordingReadyEventRecordingTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallRecordingReadyEventRecordingTypeEnum] to String,
/// and [decode] dynamic data back to [CallRecordingReadyEventRecordingTypeEnum].
class CallRecordingReadyEventRecordingTypeEnumTypeTransformer {
  factory CallRecordingReadyEventRecordingTypeEnumTypeTransformer() =>
      _instance ??=
          const CallRecordingReadyEventRecordingTypeEnumTypeTransformer._();

  const CallRecordingReadyEventRecordingTypeEnumTypeTransformer._();

  String encode(CallRecordingReadyEventRecordingTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CallRecordingReadyEventRecordingTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallRecordingReadyEventRecordingTypeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'composite':
          return CallRecordingReadyEventRecordingTypeEnum.composite;
        case r'individual':
          return CallRecordingReadyEventRecordingTypeEnum.individual;
        case r'raw':
          return CallRecordingReadyEventRecordingTypeEnum.raw;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CallRecordingReadyEventRecordingTypeEnumTypeTransformer] instance.
  static CallRecordingReadyEventRecordingTypeEnumTypeTransformer? _instance;
}
