//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'frame_recording_settings_response.g.dart';

/// FrameRecordingSettingsResponse
///
/// Properties:
/// * [captureIntervalInSeconds]
/// * [mode]
/// * [quality]
@BuiltValue()
abstract class FrameRecordingSettingsResponse
    implements
        Built<FrameRecordingSettingsResponse,
            FrameRecordingSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'capture_interval_in_seconds')
  int get captureIntervalInSeconds;

  @BuiltValueField(wireName: r'mode')
  FrameRecordingSettingsResponseModeEnum get mode;
  // enum modeEnum {  available,  disabled,  auto-on,  };

  @BuiltValueField(wireName: r'quality')
  String? get quality;

  FrameRecordingSettingsResponse._();

  factory FrameRecordingSettingsResponse(
          [void updates(FrameRecordingSettingsResponseBuilder b)]) =
      _$FrameRecordingSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FrameRecordingSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FrameRecordingSettingsResponse> get serializer =>
      _$FrameRecordingSettingsResponseSerializer();
}

class _$FrameRecordingSettingsResponseSerializer
    implements PrimitiveSerializer<FrameRecordingSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    FrameRecordingSettingsResponse,
    _$FrameRecordingSettingsResponse
  ];

  @override
  final String wireName = r'FrameRecordingSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FrameRecordingSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'capture_interval_in_seconds';
    yield serializers.serialize(
      object.captureIntervalInSeconds,
      specifiedType: const FullType(int),
    );
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(FrameRecordingSettingsResponseModeEnum),
    );
    if (object.quality != null) {
      yield r'quality';
      yield serializers.serialize(
        object.quality,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FrameRecordingSettingsResponse object, {
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
    required FrameRecordingSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'capture_interval_in_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.captureIntervalInSeconds = valueDes;
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(FrameRecordingSettingsResponseModeEnum),
          ) as FrameRecordingSettingsResponseModeEnum;
          result.mode = valueDes;
          break;
        case r'quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quality = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FrameRecordingSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FrameRecordingSettingsResponseBuilder();
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

class FrameRecordingSettingsResponseModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'available')
  static const FrameRecordingSettingsResponseModeEnum available =
      _$frameRecordingSettingsResponseModeEnum_available;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const FrameRecordingSettingsResponseModeEnum disabled =
      _$frameRecordingSettingsResponseModeEnum_disabled;
  @BuiltValueEnumConst(wireName: r'auto-on')
  static const FrameRecordingSettingsResponseModeEnum autoOn =
      _$frameRecordingSettingsResponseModeEnum_autoOn;

  static Serializer<FrameRecordingSettingsResponseModeEnum> get serializer =>
      _$frameRecordingSettingsResponseModeEnumSerializer;

  const FrameRecordingSettingsResponseModeEnum._(String name) : super(name);

  static BuiltSet<FrameRecordingSettingsResponseModeEnum> get values =>
      _$frameRecordingSettingsResponseModeEnumValues;
  static FrameRecordingSettingsResponseModeEnum valueOf(String name) =>
      _$frameRecordingSettingsResponseModeEnumValueOf(name);
}
