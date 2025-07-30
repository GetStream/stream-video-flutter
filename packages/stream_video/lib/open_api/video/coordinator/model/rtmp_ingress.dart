//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rtmp_ingress.g.dart';

/// RTMP input settings
///
/// Properties:
/// * [address]
@BuiltValue()
abstract class RTMPIngress implements Built<RTMPIngress, RTMPIngressBuilder> {
  @BuiltValueField(wireName: r'address')
  String get address;

  RTMPIngress._();

  factory RTMPIngress([void updates(RTMPIngressBuilder b)]) = _$RTMPIngress;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RTMPIngressBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RTMPIngress> get serializer => _$RTMPIngressSerializer();
}

class _$RTMPIngressSerializer implements PrimitiveSerializer<RTMPIngress> {
  @override
  final Iterable<Type> types = const [RTMPIngress, _$RTMPIngress];

  @override
  final String wireName = r'RTMPIngress';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RTMPIngress object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RTMPIngress object, {
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
    required RTMPIngressBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RTMPIngress deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RTMPIngressBuilder();
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
