//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'frame_recording_settings_request.g.dart';

/// FrameRecordingSettingsRequest
///
/// Properties:
/// * [captureIntervalInSeconds]
/// * [mode]
/// * [quality]
@BuiltValue()
abstract class FrameRecordingSettingsRequest
    implements
        Built<FrameRecordingSettingsRequest,
            FrameRecordingSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'capture_interval_in_seconds')
  int get captureIntervalInSeconds;

  @BuiltValueField(wireName: r'mode')
  FrameRecordingSettingsRequestModeEnum get mode;
  // enum modeEnum {  available,  disabled,  auto-on,  };

  @BuiltValueField(wireName: r'quality')
  FrameRecordingSettingsRequestQualityEnum? get quality;
  // enum qualityEnum {  360p,  480p,  720p,  1080p,  1440p,  };

  FrameRecordingSettingsRequest._();

  factory FrameRecordingSettingsRequest(
          [void updates(FrameRecordingSettingsRequestBuilder b)]) =
      _$FrameRecordingSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FrameRecordingSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FrameRecordingSettingsRequest> get serializer =>
      _$FrameRecordingSettingsRequestSerializer();
}

class _$FrameRecordingSettingsRequestSerializer
    implements PrimitiveSerializer<FrameRecordingSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    FrameRecordingSettingsRequest,
    _$FrameRecordingSettingsRequest
  ];

  @override
  final String wireName = r'FrameRecordingSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FrameRecordingSettingsRequest object, {
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
      specifiedType: const FullType(FrameRecordingSettingsRequestModeEnum),
    );
    if (object.quality != null) {
      yield r'quality';
      yield serializers.serialize(
        object.quality,
        specifiedType: const FullType(FrameRecordingSettingsRequestQualityEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FrameRecordingSettingsRequest object, {
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
    required FrameRecordingSettingsRequestBuilder result,
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
                const FullType(FrameRecordingSettingsRequestModeEnum),
          ) as FrameRecordingSettingsRequestModeEnum;
          result.mode = valueDes;
          break;
        case r'quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(FrameRecordingSettingsRequestQualityEnum),
          ) as FrameRecordingSettingsRequestQualityEnum;
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
  FrameRecordingSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FrameRecordingSettingsRequestBuilder();
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

class FrameRecordingSettingsRequestModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'available')
  static const FrameRecordingSettingsRequestModeEnum available =
      _$frameRecordingSettingsRequestModeEnum_available;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const FrameRecordingSettingsRequestModeEnum disabled =
      _$frameRecordingSettingsRequestModeEnum_disabled;
  @BuiltValueEnumConst(wireName: r'auto-on')
  static const FrameRecordingSettingsRequestModeEnum autoOn =
      _$frameRecordingSettingsRequestModeEnum_autoOn;

  static Serializer<FrameRecordingSettingsRequestModeEnum> get serializer =>
      _$frameRecordingSettingsRequestModeEnumSerializer;

  const FrameRecordingSettingsRequestModeEnum._(String name) : super(name);

  static BuiltSet<FrameRecordingSettingsRequestModeEnum> get values =>
      _$frameRecordingSettingsRequestModeEnumValues;
  static FrameRecordingSettingsRequestModeEnum valueOf(String name) =>
      _$frameRecordingSettingsRequestModeEnumValueOf(name);
}

class FrameRecordingSettingsRequestQualityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'360p')
  static const FrameRecordingSettingsRequestQualityEnum n360p =
      _$frameRecordingSettingsRequestQualityEnum_n360p;
  @BuiltValueEnumConst(wireName: r'480p')
  static const FrameRecordingSettingsRequestQualityEnum n480p =
      _$frameRecordingSettingsRequestQualityEnum_n480p;
  @BuiltValueEnumConst(wireName: r'720p')
  static const FrameRecordingSettingsRequestQualityEnum n720p =
      _$frameRecordingSettingsRequestQualityEnum_n720p;
  @BuiltValueEnumConst(wireName: r'1080p')
  static const FrameRecordingSettingsRequestQualityEnum n1080p =
      _$frameRecordingSettingsRequestQualityEnum_n1080p;
  @BuiltValueEnumConst(wireName: r'1440p')
  static const FrameRecordingSettingsRequestQualityEnum n1440p =
      _$frameRecordingSettingsRequestQualityEnum_n1440p;

  static Serializer<FrameRecordingSettingsRequestQualityEnum> get serializer =>
      _$frameRecordingSettingsRequestQualityEnumSerializer;

  const FrameRecordingSettingsRequestQualityEnum._(String name) : super(name);

  static BuiltSet<FrameRecordingSettingsRequestQualityEnum> get values =>
      _$frameRecordingSettingsRequestQualityEnumValues;
  static FrameRecordingSettingsRequestQualityEnum valueOf(String name) =>
      _$frameRecordingSettingsRequestQualityEnumValueOf(name);
}
