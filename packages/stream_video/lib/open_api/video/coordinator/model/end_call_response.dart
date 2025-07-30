//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'end_call_response.g.dart';

/// Response for ending a call
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class EndCallResponse
    implements Built<EndCallResponse, EndCallResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  EndCallResponse._();

  factory EndCallResponse([void updates(EndCallResponseBuilder b)]) =
      _$EndCallResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EndCallResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EndCallResponse> get serializer =>
      _$EndCallResponseSerializer();
}

class _$EndCallResponseSerializer
    implements PrimitiveSerializer<EndCallResponse> {
  @override
  final Iterable<Type> types = const [EndCallResponse, _$EndCallResponse];

  @override
  final String wireName = r'EndCallResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EndCallResponse object, {
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
    EndCallResponse object, {
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
    required EndCallResponseBuilder result,
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
  EndCallResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EndCallResponseBuilder();
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
