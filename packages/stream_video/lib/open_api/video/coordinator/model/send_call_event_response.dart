//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'send_call_event_response.g.dart';

/// SendCallEventResponse
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class SendCallEventResponse
    implements Built<SendCallEventResponse, SendCallEventResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  SendCallEventResponse._();

  factory SendCallEventResponse(
      [void updates(SendCallEventResponseBuilder b)]) = _$SendCallEventResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SendCallEventResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SendCallEventResponse> get serializer =>
      _$SendCallEventResponseSerializer();
}

class _$SendCallEventResponseSerializer
    implements PrimitiveSerializer<SendCallEventResponse> {
  @override
  final Iterable<Type> types = const [
    SendCallEventResponse,
    _$SendCallEventResponse
  ];

  @override
  final String wireName = r'SendCallEventResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SendCallEventResponse object, {
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
    SendCallEventResponse object, {
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
    required SendCallEventResponseBuilder result,
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
  SendCallEventResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SendCallEventResponseBuilder();
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
