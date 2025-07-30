//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_participant_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_session_participant_joined_event.g.dart';

/// This event is sent when a participant joins a call session
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [participant]
/// * [sessionId] - Call session ID
/// * [type] - The type of event: \"call.session_participant_joined\" in this case
@BuiltValue()
abstract class CallSessionParticipantJoinedEvent
    implements
        Built<CallSessionParticipantJoinedEvent,
            CallSessionParticipantJoinedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'participant')
  CallParticipantResponse get participant;

  /// Call session ID
  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  /// The type of event: \"call.session_participant_joined\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallSessionParticipantJoinedEvent._();

  factory CallSessionParticipantJoinedEvent(
          [void updates(CallSessionParticipantJoinedEventBuilder b)]) =
      _$CallSessionParticipantJoinedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallSessionParticipantJoinedEventBuilder b) =>
      b..type = 'call.session_participant_joined';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallSessionParticipantJoinedEvent> get serializer =>
      _$CallSessionParticipantJoinedEventSerializer();
}

class _$CallSessionParticipantJoinedEventSerializer
    implements PrimitiveSerializer<CallSessionParticipantJoinedEvent> {
  @override
  final Iterable<Type> types = const [
    CallSessionParticipantJoinedEvent,
    _$CallSessionParticipantJoinedEvent
  ];

  @override
  final String wireName = r'CallSessionParticipantJoinedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallSessionParticipantJoinedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'participant';
    yield serializers.serialize(
      object.participant,
      specifiedType: const FullType(CallParticipantResponse),
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
    CallSessionParticipantJoinedEvent object, {
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
    required CallSessionParticipantJoinedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'participant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallParticipantResponse),
          ) as CallParticipantResponse;
          result.participant.replace(valueDes);
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
  CallSessionParticipantJoinedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallSessionParticipantJoinedEventBuilder();
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
