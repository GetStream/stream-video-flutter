//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'record_settings_request.g.dart';

/// RecordSettingsRequest
///
/// Properties:
/// * [audioOnly]
/// * [mode]
/// * [quality]
@BuiltValue()
abstract class RecordSettingsRequest
    implements Built<RecordSettingsRequest, RecordSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'audio_only')
  bool? get audioOnly;

  @BuiltValueField(wireName: r'mode')
  RecordSettingsRequestModeEnum get mode;
  // enum modeEnum {  available,  disabled,  auto-on,  };

  @BuiltValueField(wireName: r'quality')
  RecordSettingsRequestQualityEnum? get quality;
  // enum qualityEnum {  360p,  480p,  720p,  1080p,  1440p,  portrait-360x640,  portrait-480x854,  portrait-720x1280,  portrait-1080x1920,  portrait-1440x2560,  };

  RecordSettingsRequest._();

  factory RecordSettingsRequest(
      [void updates(RecordSettingsRequestBuilder b)]) = _$RecordSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecordSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecordSettingsRequest> get serializer =>
      _$RecordSettingsRequestSerializer();
}

class _$RecordSettingsRequestSerializer
    implements PrimitiveSerializer<RecordSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    RecordSettingsRequest,
    _$RecordSettingsRequest
  ];

  @override
  final String wireName = r'RecordSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecordSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.audioOnly != null) {
      yield r'audio_only';
      yield serializers.serialize(
        object.audioOnly,
        specifiedType: const FullType(bool),
      );
    }
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(RecordSettingsRequestModeEnum),
    );
    if (object.quality != null) {
      yield r'quality';
      yield serializers.serialize(
        object.quality,
        specifiedType: const FullType(RecordSettingsRequestQualityEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecordSettingsRequest object, {
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
    required RecordSettingsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audio_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.audioOnly = valueDes;
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RecordSettingsRequestModeEnum),
          ) as RecordSettingsRequestModeEnum;
          result.mode = valueDes;
          break;
        case r'quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RecordSettingsRequestQualityEnum),
          ) as RecordSettingsRequestQualityEnum;
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
  RecordSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecordSettingsRequestBuilder();
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

class RecordSettingsRequestModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'available')
  static const RecordSettingsRequestModeEnum available =
      _$recordSettingsRequestModeEnum_available;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const RecordSettingsRequestModeEnum disabled =
      _$recordSettingsRequestModeEnum_disabled;
  @BuiltValueEnumConst(wireName: r'auto-on')
  static const RecordSettingsRequestModeEnum autoOn =
      _$recordSettingsRequestModeEnum_autoOn;

  static Serializer<RecordSettingsRequestModeEnum> get serializer =>
      _$recordSettingsRequestModeEnumSerializer;

  const RecordSettingsRequestModeEnum._(String name) : super(name);

  static BuiltSet<RecordSettingsRequestModeEnum> get values =>
      _$recordSettingsRequestModeEnumValues;
  static RecordSettingsRequestModeEnum valueOf(String name) =>
      _$recordSettingsRequestModeEnumValueOf(name);
}

class RecordSettingsRequestQualityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'360p')
  static const RecordSettingsRequestQualityEnum n360p =
      _$recordSettingsRequestQualityEnum_n360p;
  @BuiltValueEnumConst(wireName: r'480p')
  static const RecordSettingsRequestQualityEnum n480p =
      _$recordSettingsRequestQualityEnum_n480p;
  @BuiltValueEnumConst(wireName: r'720p')
  static const RecordSettingsRequestQualityEnum n720p =
      _$recordSettingsRequestQualityEnum_n720p;
  @BuiltValueEnumConst(wireName: r'1080p')
  static const RecordSettingsRequestQualityEnum n1080p =
      _$recordSettingsRequestQualityEnum_n1080p;
  @BuiltValueEnumConst(wireName: r'1440p')
  static const RecordSettingsRequestQualityEnum n1440p =
      _$recordSettingsRequestQualityEnum_n1440p;
  @BuiltValueEnumConst(wireName: r'portrait-360x640')
  static const RecordSettingsRequestQualityEnum portrait360x640 =
      _$recordSettingsRequestQualityEnum_portrait360x640;
  @BuiltValueEnumConst(wireName: r'portrait-480x854')
  static const RecordSettingsRequestQualityEnum portrait480x854 =
      _$recordSettingsRequestQualityEnum_portrait480x854;
  @BuiltValueEnumConst(wireName: r'portrait-720x1280')
  static const RecordSettingsRequestQualityEnum portrait720x1280 =
      _$recordSettingsRequestQualityEnum_portrait720x1280;
  @BuiltValueEnumConst(wireName: r'portrait-1080x1920')
  static const RecordSettingsRequestQualityEnum portrait1080x1920 =
      _$recordSettingsRequestQualityEnum_portrait1080x1920;
  @BuiltValueEnumConst(wireName: r'portrait-1440x2560')
  static const RecordSettingsRequestQualityEnum portrait1440x2560 =
      _$recordSettingsRequestQualityEnum_portrait1440x2560;

  static Serializer<RecordSettingsRequestQualityEnum> get serializer =>
      _$recordSettingsRequestQualityEnumSerializer;

  const RecordSettingsRequestQualityEnum._(String name) : super(name);

  static BuiltSet<RecordSettingsRequestQualityEnum> get values =>
      _$recordSettingsRequestQualityEnumValues;
  static RecordSettingsRequestQualityEnum valueOf(String name) =>
      _$recordSettingsRequestQualityEnumValueOf(name);
}
