//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_participant_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_session_participant_left_event.g.dart';

/// This event is sent when a participant leaves a call session
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [durationSeconds] - The duration participant was in the session in seconds
/// * [participant]
/// * [sessionId] - Call session ID
/// * [type] - The type of event: \"call.session_participant_left\" in this case
@BuiltValue()
abstract class CallSessionParticipantLeftEvent
    implements
        Built<CallSessionParticipantLeftEvent,
            CallSessionParticipantLeftEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The duration participant was in the session in seconds
  @BuiltValueField(wireName: r'duration_seconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'participant')
  CallParticipantResponse get participant;

  /// Call session ID
  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  /// The type of event: \"call.session_participant_left\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallSessionParticipantLeftEvent._();

  factory CallSessionParticipantLeftEvent(
          [void updates(CallSessionParticipantLeftEventBuilder b)]) =
      _$CallSessionParticipantLeftEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallSessionParticipantLeftEventBuilder b) =>
      b..type = 'call.session_participant_left';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallSessionParticipantLeftEvent> get serializer =>
      _$CallSessionParticipantLeftEventSerializer();
}

class _$CallSessionParticipantLeftEventSerializer
    implements PrimitiveSerializer<CallSessionParticipantLeftEvent> {
  @override
  final Iterable<Type> types = const [
    CallSessionParticipantLeftEvent,
    _$CallSessionParticipantLeftEvent
  ];

  @override
  final String wireName = r'CallSessionParticipantLeftEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallSessionParticipantLeftEvent object, {
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
    yield r'duration_seconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(int),
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
    CallSessionParticipantLeftEvent object, {
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
    required CallSessionParticipantLeftEventBuilder result,
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
        case r'duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSeconds = valueDes;
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
  CallSessionParticipantLeftEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallSessionParticipantLeftEventBuilder();
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
