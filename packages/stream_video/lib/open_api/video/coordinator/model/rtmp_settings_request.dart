//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rtmp_settings_request.g.dart';

/// RTMPSettingsRequest
///
/// Properties:
/// * [enabled]
/// * [quality] - Resolution to set for the RTMP stream
@BuiltValue()
abstract class RTMPSettingsRequest
    implements Built<RTMPSettingsRequest, RTMPSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  /// Resolution to set for the RTMP stream
  @BuiltValueField(wireName: r'quality')
  RTMPSettingsRequestQualityEnum? get quality;
  // enum qualityEnum {  360p,  480p,  720p,  1080p,  1440p,  portrait-360x640,  portrait-480x854,  portrait-720x1280,  portrait-1080x1920,  portrait-1440x2560,  };

  RTMPSettingsRequest._();

  factory RTMPSettingsRequest([void updates(RTMPSettingsRequestBuilder b)]) =
      _$RTMPSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RTMPSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RTMPSettingsRequest> get serializer =>
      _$RTMPSettingsRequestSerializer();
}

class _$RTMPSettingsRequestSerializer
    implements PrimitiveSerializer<RTMPSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    RTMPSettingsRequest,
    _$RTMPSettingsRequest
  ];

  @override
  final String wireName = r'RTMPSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RTMPSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.quality != null) {
      yield r'quality';
      yield serializers.serialize(
        object.quality,
        specifiedType: const FullType(RTMPSettingsRequestQualityEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RTMPSettingsRequest object, {
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
    required RTMPSettingsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RTMPSettingsRequestQualityEnum),
          ) as RTMPSettingsRequestQualityEnum;
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
  RTMPSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RTMPSettingsRequestBuilder();
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

class RTMPSettingsRequestQualityEnum extends EnumClass {
  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'360p')
  static const RTMPSettingsRequestQualityEnum n360p =
      _$rTMPSettingsRequestQualityEnum_n360p;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'480p')
  static const RTMPSettingsRequestQualityEnum n480p =
      _$rTMPSettingsRequestQualityEnum_n480p;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'720p')
  static const RTMPSettingsRequestQualityEnum n720p =
      _$rTMPSettingsRequestQualityEnum_n720p;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'1080p')
  static const RTMPSettingsRequestQualityEnum n1080p =
      _$rTMPSettingsRequestQualityEnum_n1080p;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'1440p')
  static const RTMPSettingsRequestQualityEnum n1440p =
      _$rTMPSettingsRequestQualityEnum_n1440p;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'portrait-360x640')
  static const RTMPSettingsRequestQualityEnum portrait360x640 =
      _$rTMPSettingsRequestQualityEnum_portrait360x640;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'portrait-480x854')
  static const RTMPSettingsRequestQualityEnum portrait480x854 =
      _$rTMPSettingsRequestQualityEnum_portrait480x854;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'portrait-720x1280')
  static const RTMPSettingsRequestQualityEnum portrait720x1280 =
      _$rTMPSettingsRequestQualityEnum_portrait720x1280;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'portrait-1080x1920')
  static const RTMPSettingsRequestQualityEnum portrait1080x1920 =
      _$rTMPSettingsRequestQualityEnum_portrait1080x1920;

  /// Resolution to set for the RTMP stream
  @BuiltValueEnumConst(wireName: r'portrait-1440x2560')
  static const RTMPSettingsRequestQualityEnum portrait1440x2560 =
      _$rTMPSettingsRequestQualityEnum_portrait1440x2560;

  static Serializer<RTMPSettingsRequestQualityEnum> get serializer =>
      _$rTMPSettingsRequestQualityEnumSerializer;

  const RTMPSettingsRequestQualityEnum._(String name) : super(name);

  static BuiltSet<RTMPSettingsRequestQualityEnum> get values =>
      _$rTMPSettingsRequestQualityEnumValues;
  static RTMPSettingsRequestQualityEnum valueOf(String name) =>
      _$rTMPSettingsRequestQualityEnumValueOf(name);
}
