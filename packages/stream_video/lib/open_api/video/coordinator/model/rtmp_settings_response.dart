//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rtmp_settings_response.g.dart';

/// RTMPSettingsResponse is the payload for RTMP settings
///
/// Properties:
/// * [enabled]
/// * [quality]
@BuiltValue()
abstract class RTMPSettingsResponse
    implements Built<RTMPSettingsResponse, RTMPSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'quality')
  String get quality;

  RTMPSettingsResponse._();

  factory RTMPSettingsResponse([void updates(RTMPSettingsResponseBuilder b)]) =
      _$RTMPSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RTMPSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RTMPSettingsResponse> get serializer =>
      _$RTMPSettingsResponseSerializer();
}

class _$RTMPSettingsResponseSerializer
    implements PrimitiveSerializer<RTMPSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    RTMPSettingsResponse,
    _$RTMPSettingsResponse
  ];

  @override
  final String wireName = r'RTMPSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RTMPSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'quality';
    yield serializers.serialize(
      object.quality,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RTMPSettingsResponse object, {
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
    required RTMPSettingsResponseBuilder result,
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
  RTMPSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RTMPSettingsResponseBuilder();
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
