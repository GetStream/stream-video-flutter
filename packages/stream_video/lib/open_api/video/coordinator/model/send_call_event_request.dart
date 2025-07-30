//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'send_call_event_request.g.dart';

/// Send a call event to the other user
///
/// Properties:
/// * [custom]
@BuiltValue()
abstract class SendCallEventRequest
    implements Built<SendCallEventRequest, SendCallEventRequestBuilder> {
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?>? get custom;

  SendCallEventRequest._();

  factory SendCallEventRequest([void updates(SendCallEventRequestBuilder b)]) =
      _$SendCallEventRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SendCallEventRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SendCallEventRequest> get serializer =>
      _$SendCallEventRequestSerializer();
}

class _$SendCallEventRequestSerializer
    implements PrimitiveSerializer<SendCallEventRequest> {
  @override
  final Iterable<Type> types = const [
    SendCallEventRequest,
    _$SendCallEventRequest
  ];

  @override
  final String wireName = r'SendCallEventRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SendCallEventRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.custom != null) {
      yield r'custom';
      yield serializers.serialize(
        object.custom,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SendCallEventRequest object, {
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
    required SendCallEventRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SendCallEventRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SendCallEventRequestBuilder();
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
