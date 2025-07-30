//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_session_ended_event.g.dart';

/// This event is sent when a call session ends
///
/// Properties:
/// * [call]
/// * [callCid]
/// * [createdAt]
/// * [sessionId] - Call session ID
/// * [type] - The type of event: \"call.session_ended\" in this case
@BuiltValue()
abstract class CallSessionEndedEvent
    implements Built<CallSessionEndedEvent, CallSessionEndedEventBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// Call session ID
  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  /// The type of event: \"call.session_ended\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallSessionEndedEvent._();

  factory CallSessionEndedEvent(
      [void updates(CallSessionEndedEventBuilder b)]) = _$CallSessionEndedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallSessionEndedEventBuilder b) =>
      b..type = 'call.session_ended';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallSessionEndedEvent> get serializer =>
      _$CallSessionEndedEventSerializer();
}

class _$CallSessionEndedEventSerializer
    implements PrimitiveSerializer<CallSessionEndedEvent> {
  @override
  final Iterable<Type> types = const [
    CallSessionEndedEvent,
    _$CallSessionEndedEvent
  ];

  @override
  final String wireName = r'CallSessionEndedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallSessionEndedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call';
    yield serializers.serialize(
      object.call,
      specifiedType: const FullType(CallResponse),
    );
    yield r'call_cid';
    yield serializers.serialize(
      object.callCid,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'session_id';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallSessionEndedEvent object, {
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
    required CallSessionEndedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallResponse),
          ) as CallResponse;
          result.call.replace(valueDes);
          break;
        case r'call_cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callCid = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallSessionEndedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallSessionEndedEventBuilder();
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
