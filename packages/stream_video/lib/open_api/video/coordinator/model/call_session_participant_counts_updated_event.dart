//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_session_participant_counts_updated_event.g.dart';

/// This event is sent when the participant counts in a call session are updated
///
/// Properties:
/// * [anonymousParticipantCount]
/// * [callCid]
/// * [createdAt]
/// * [participantsCountByRole]
/// * [sessionId] - Call session ID
/// * [type] - The type of event: \"call.session_participant_count_updated\" in this case
@BuiltValue()
abstract class CallSessionParticipantCountsUpdatedEvent
    implements
        Built<CallSessionParticipantCountsUpdatedEvent,
            CallSessionParticipantCountsUpdatedEventBuilder> {
  @BuiltValueField(wireName: r'anonymous_participant_count')
  int get anonymousParticipantCount;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'participants_count_by_role')
  BuiltMap<String, int> get participantsCountByRole;

  /// Call session ID
  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  /// The type of event: \"call.session_participant_count_updated\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallSessionParticipantCountsUpdatedEvent._();

  factory CallSessionParticipantCountsUpdatedEvent(
          [void updates(CallSessionParticipantCountsUpdatedEventBuilder b)]) =
      _$CallSessionParticipantCountsUpdatedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallSessionParticipantCountsUpdatedEventBuilder b) =>
      b..type = 'call.session_participant_count_updated';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallSessionParticipantCountsUpdatedEvent> get serializer =>
      _$CallSessionParticipantCountsUpdatedEventSerializer();
}

class _$CallSessionParticipantCountsUpdatedEventSerializer
    implements PrimitiveSerializer<CallSessionParticipantCountsUpdatedEvent> {
  @override
  final Iterable<Type> types = const [
    CallSessionParticipantCountsUpdatedEvent,
    _$CallSessionParticipantCountsUpdatedEvent
  ];

  @override
  final String wireName = r'CallSessionParticipantCountsUpdatedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallSessionParticipantCountsUpdatedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'anonymous_participant_count';
    yield serializers.serialize(
      object.anonymousParticipantCount,
      specifiedType: const FullType(int),
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
    yield r'participants_count_by_role';
    yield serializers.serialize(
      object.participantsCountByRole,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(int)]),
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
    CallSessionParticipantCountsUpdatedEvent object, {
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
    required CallSessionParticipantCountsUpdatedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'anonymous_participant_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.anonymousParticipantCount = valueDes;
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
        case r'participants_count_by_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.participantsCountByRole.replace(valueDes);
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
  CallSessionParticipantCountsUpdatedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallSessionParticipantCountsUpdatedEventBuilder();
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
