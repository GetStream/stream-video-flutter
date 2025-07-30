//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reject_call_response.g.dart';

/// RejectCallResponse
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class RejectCallResponse
    implements Built<RejectCallResponse, RejectCallResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  RejectCallResponse._();

  factory RejectCallResponse([void updates(RejectCallResponseBuilder b)]) =
      _$RejectCallResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RejectCallResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RejectCallResponse> get serializer =>
      _$RejectCallResponseSerializer();
}

class _$RejectCallResponseSerializer
    implements PrimitiveSerializer<RejectCallResponse> {
  @override
  final Iterable<Type> types = const [RejectCallResponse, _$RejectCallResponse];

  @override
  final String wireName = r'RejectCallResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RejectCallResponse object, {
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
    RejectCallResponse object, {
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
    required RejectCallResponseBuilder result,
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
  RejectCallResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RejectCallResponseBuilder();
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
