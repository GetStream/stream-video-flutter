//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/noise_cancellation_settings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audio_settings_response.g.dart';

/// AudioSettingsResponse
///
/// Properties:
/// * [accessRequestEnabled]
/// * [defaultDevice]
/// * [micDefaultOn]
/// * [noiseCancellation]
/// * [opusDtxEnabled]
/// * [redundantCodingEnabled]
/// * [speakerDefaultOn]
@BuiltValue()
abstract class AudioSettingsResponse
    implements Built<AudioSettingsResponse, AudioSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'access_request_enabled')
  bool get accessRequestEnabled;

  @BuiltValueField(wireName: r'default_device')
  AudioSettingsResponseDefaultDeviceEnum get defaultDevice;
  // enum defaultDeviceEnum {  speaker,  earpiece,  };

  @BuiltValueField(wireName: r'mic_default_on')
  bool get micDefaultOn;

  @BuiltValueField(wireName: r'noise_cancellation')
  NoiseCancellationSettings? get noiseCancellation;

  @BuiltValueField(wireName: r'opus_dtx_enabled')
  bool get opusDtxEnabled;

  @BuiltValueField(wireName: r'redundant_coding_enabled')
  bool get redundantCodingEnabled;

  @BuiltValueField(wireName: r'speaker_default_on')
  bool get speakerDefaultOn;

  AudioSettingsResponse._();

  factory AudioSettingsResponse(
      [void updates(AudioSettingsResponseBuilder b)]) = _$AudioSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AudioSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AudioSettingsResponse> get serializer =>
      _$AudioSettingsResponseSerializer();
}

class _$AudioSettingsResponseSerializer
    implements PrimitiveSerializer<AudioSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    AudioSettingsResponse,
    _$AudioSettingsResponse
  ];

  @override
  final String wireName = r'AudioSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AudioSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'access_request_enabled';
    yield serializers.serialize(
      object.accessRequestEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'default_device';
    yield serializers.serialize(
      object.defaultDevice,
      specifiedType: const FullType(AudioSettingsResponseDefaultDeviceEnum),
    );
    yield r'mic_default_on';
    yield serializers.serialize(
      object.micDefaultOn,
      specifiedType: const FullType(bool),
    );
    if (object.noiseCancellation != null) {
      yield r'noise_cancellation';
      yield serializers.serialize(
        object.noiseCancellation,
        specifiedType: const FullType(NoiseCancellationSettings),
      );
    }
    yield r'opus_dtx_enabled';
    yield serializers.serialize(
      object.opusDtxEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'redundant_coding_enabled';
    yield serializers.serialize(
      object.redundantCodingEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'speaker_default_on';
    yield serializers.serialize(
      object.speakerDefaultOn,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AudioSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AudioSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'access_request_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accessRequestEnabled = valueDes;
          break;
        case r'default_device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(AudioSettingsResponseDefaultDeviceEnum),
          ) as AudioSettingsResponseDefaultDeviceEnum;
          result.defaultDevice = valueDes;
          break;
        case r'mic_default_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.micDefaultOn = valueDes;
          break;
        case r'noise_cancellation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NoiseCancellationSettings),
          ) as NoiseCancellationSettings;
          result.noiseCancellation.replace(valueDes);
          break;
        case r'opus_dtx_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.opusDtxEnabled = valueDes;
          break;
        case r'redundant_coding_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.redundantCodingEnabled = valueDes;
          break;
        case r'speaker_default_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.speakerDefaultOn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AudioSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AudioSettingsResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class AudioSettingsResponseDefaultDeviceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'speaker')
  static const AudioSettingsResponseDefaultDeviceEnum speaker =
      _$audioSettingsResponseDefaultDeviceEnum_speaker;
  @BuiltValueEnumConst(wireName: r'earpiece')
  static const AudioSettingsResponseDefaultDeviceEnum earpiece =
      _$audioSettingsResponseDefaultDeviceEnum_earpiece;

  static Serializer<AudioSettingsResponseDefaultDeviceEnum> get serializer =>
      _$audioSettingsResponseDefaultDeviceEnumSerializer;

  const AudioSettingsResponseDefaultDeviceEnum._(String name) : super(name);

  static BuiltSet<AudioSettingsResponseDefaultDeviceEnum> get values =>
      _$audioSettingsResponseDefaultDeviceEnumValues;
  static AudioSettingsResponseDefaultDeviceEnum valueOf(String name) =>
      _$audioSettingsResponseDefaultDeviceEnumValueOf(name);
}
