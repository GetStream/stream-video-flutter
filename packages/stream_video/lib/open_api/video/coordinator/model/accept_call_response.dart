//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'accept_call_response.g.dart';

/// AcceptCallResponse is the payload for accepting a call.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class AcceptCallResponse
    implements Built<AcceptCallResponse, AcceptCallResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  AcceptCallResponse._();

  factory AcceptCallResponse([void updates(AcceptCallResponseBuilder b)]) =
      _$AcceptCallResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AcceptCallResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AcceptCallResponse> get serializer =>
      _$AcceptCallResponseSerializer();
}

class _$AcceptCallResponseSerializer
    implements PrimitiveSerializer<AcceptCallResponse> {
  @override
  final Iterable<Type> types = const [AcceptCallResponse, _$AcceptCallResponse];

  @override
  final String wireName = r'AcceptCallResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AcceptCallResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AcceptCallResponse object, {
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
    required AcceptCallResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AcceptCallResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AcceptCallResponseBuilder();
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
