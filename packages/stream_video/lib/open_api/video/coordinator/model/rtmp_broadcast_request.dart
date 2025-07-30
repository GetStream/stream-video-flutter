//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/layout_settings_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rtmp_broadcast_request.g.dart';

/// RTMPBroadcastRequest is the payload for starting an RTMP broadcast.
///
/// Properties:
/// * [layout]
/// * [name] - Name identifier for RTMP broadcast, must be unique in call
/// * [quality] - If provided, will override the call's RTMP settings quality
/// * [streamKey] - If provided, will be appended at the end of stream_url
/// * [streamUrl] - URL for the RTMP server to send the call to
@BuiltValue()
abstract class RTMPBroadcastRequest
    implements Built<RTMPBroadcastRequest, RTMPBroadcastRequestBuilder> {
  @BuiltValueField(wireName: r'layout')
  LayoutSettingsRequest? get layout;

  /// Name identifier for RTMP broadcast, must be unique in call
  @BuiltValueField(wireName: r'name')
  String get name;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueField(wireName: r'quality')
  RTMPBroadcastRequestQualityEnum? get quality;
  // enum qualityEnum {  360p,  480p,  720p,  1080p,  1440p,  portrait-360x640,  portrait-480x854,  portrait-720x1280,  portrait-1080x1920,  portrait-1440x2560,  };

  /// If provided, will be appended at the end of stream_url
  @BuiltValueField(wireName: r'stream_key')
  String? get streamKey;

  /// URL for the RTMP server to send the call to
  @BuiltValueField(wireName: r'stream_url')
  String get streamUrl;

  RTMPBroadcastRequest._();

  factory RTMPBroadcastRequest([void updates(RTMPBroadcastRequestBuilder b)]) =
      _$RTMPBroadcastRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RTMPBroadcastRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RTMPBroadcastRequest> get serializer =>
      _$RTMPBroadcastRequestSerializer();
}

class _$RTMPBroadcastRequestSerializer
    implements PrimitiveSerializer<RTMPBroadcastRequest> {
  @override
  final Iterable<Type> types = const [
    RTMPBroadcastRequest,
    _$RTMPBroadcastRequest
  ];

  @override
  final String wireName = r'RTMPBroadcastRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RTMPBroadcastRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.layout != null) {
      yield r'layout';
      yield serializers.serialize(
        object.layout,
        specifiedType: const FullType(LayoutSettingsRequest),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.quality != null) {
      yield r'quality';
      yield serializers.serialize(
        object.quality,
        specifiedType: const FullType(RTMPBroadcastRequestQualityEnum),
      );
    }
    if (object.streamKey != null) {
      yield r'stream_key';
      yield serializers.serialize(
        object.streamKey,
        specifiedType: const FullType(String),
      );
    }
    yield r'stream_url';
    yield serializers.serialize(
      object.streamUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RTMPBroadcastRequest object, {
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
    required RTMPBroadcastRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'layout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LayoutSettingsRequest),
          ) as LayoutSettingsRequest;
          result.layout.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RTMPBroadcastRequestQualityEnum),
          ) as RTMPBroadcastRequestQualityEnum;
          result.quality = valueDes;
          break;
        case r'stream_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.streamKey = valueDes;
          break;
        case r'stream_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.streamUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RTMPBroadcastRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RTMPBroadcastRequestBuilder();
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

class RTMPBroadcastRequestQualityEnum extends EnumClass {
  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'360p')
  static const RTMPBroadcastRequestQualityEnum n360p =
      _$rTMPBroadcastRequestQualityEnum_n360p;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'480p')
  static const RTMPBroadcastRequestQualityEnum n480p =
      _$rTMPBroadcastRequestQualityEnum_n480p;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'720p')
  static const RTMPBroadcastRequestQualityEnum n720p =
      _$rTMPBroadcastRequestQualityEnum_n720p;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'1080p')
  static const RTMPBroadcastRequestQualityEnum n1080p =
      _$rTMPBroadcastRequestQualityEnum_n1080p;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'1440p')
  static const RTMPBroadcastRequestQualityEnum n1440p =
      _$rTMPBroadcastRequestQualityEnum_n1440p;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'portrait-360x640')
  static const RTMPBroadcastRequestQualityEnum portrait360x640 =
      _$rTMPBroadcastRequestQualityEnum_portrait360x640;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'portrait-480x854')
  static const RTMPBroadcastRequestQualityEnum portrait480x854 =
      _$rTMPBroadcastRequestQualityEnum_portrait480x854;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'portrait-720x1280')
  static const RTMPBroadcastRequestQualityEnum portrait720x1280 =
      _$rTMPBroadcastRequestQualityEnum_portrait720x1280;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'portrait-1080x1920')
  static const RTMPBroadcastRequestQualityEnum portrait1080x1920 =
      _$rTMPBroadcastRequestQualityEnum_portrait1080x1920;

  /// If provided, will override the call's RTMP settings quality
  @BuiltValueEnumConst(wireName: r'portrait-1440x2560')
  static const RTMPBroadcastRequestQualityEnum portrait1440x2560 =
      _$rTMPBroadcastRequestQualityEnum_portrait1440x2560;

  static Serializer<RTMPBroadcastRequestQualityEnum> get serializer =>
      _$rTMPBroadcastRequestQualityEnumSerializer;

  const RTMPBroadcastRequestQualityEnum._(String name) : super(name);

  static BuiltSet<RTMPBroadcastRequestQualityEnum> get values =>
      _$rTMPBroadcastRequestQualityEnumValues;
  static RTMPBroadcastRequestQualityEnum valueOf(String name) =>
      _$rTMPBroadcastRequestQualityEnumValueOf(name);
}
