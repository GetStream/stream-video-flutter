//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/rtmp_ingress.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_ingress_response.g.dart';

/// CallIngressResponse is the payload for ingress settings
///
/// Properties:
/// * [rtmp]
@BuiltValue()
abstract class CallIngressResponse
    implements Built<CallIngressResponse, CallIngressResponseBuilder> {
  @BuiltValueField(wireName: r'rtmp')
  RTMPIngress get rtmp;

  CallIngressResponse._();

  factory CallIngressResponse([void updates(CallIngressResponseBuilder b)]) =
      _$CallIngressResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallIngressResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallIngressResponse> get serializer =>
      _$CallIngressResponseSerializer();
}

class _$CallIngressResponseSerializer
    implements PrimitiveSerializer<CallIngressResponse> {
  @override
  final Iterable<Type> types = const [
    CallIngressResponse,
    _$CallIngressResponse
  ];

  @override
  final String wireName = r'CallIngressResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallIngressResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rtmp';
    yield serializers.serialize(
      object.rtmp,
      specifiedType: const FullType(RTMPIngress),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallIngressResponse object, {
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
    required CallIngressResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rtmp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RTMPIngress),
          ) as RTMPIngress;
          result.rtmp.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallIngressResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallIngressResponseBuilder();
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
