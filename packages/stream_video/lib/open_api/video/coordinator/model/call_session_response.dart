//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_participant_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_session_response.g.dart';

/// CallSessionResponse
///
/// Properties:
/// * [acceptedBy]
/// * [anonymousParticipantCount]
/// * [endedAt]
/// * [id]
/// * [liveEndedAt]
/// * [liveStartedAt]
/// * [missedBy]
/// * [participants]
/// * [participantsCountByRole]
/// * [rejectedBy]
/// * [startedAt]
/// * [timerEndsAt]
@BuiltValue()
abstract class CallSessionResponse
    implements Built<CallSessionResponse, CallSessionResponseBuilder> {
  @BuiltValueField(wireName: r'accepted_by')
  BuiltMap<String, DateTime> get acceptedBy;

  @BuiltValueField(wireName: r'anonymous_participant_count')
  int get anonymousParticipantCount;

  @BuiltValueField(wireName: r'ended_at')
  DateTime? get endedAt;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'live_ended_at')
  DateTime? get liveEndedAt;

  @BuiltValueField(wireName: r'live_started_at')
  DateTime? get liveStartedAt;

  @BuiltValueField(wireName: r'missed_by')
  BuiltMap<String, DateTime> get missedBy;

  @BuiltValueField(wireName: r'participants')
  BuiltList<CallParticipantResponse> get participants;

  @BuiltValueField(wireName: r'participants_count_by_role')
  BuiltMap<String, int> get participantsCountByRole;

  @BuiltValueField(wireName: r'rejected_by')
  BuiltMap<String, DateTime> get rejectedBy;

  @BuiltValueField(wireName: r'started_at')
  DateTime? get startedAt;

  @BuiltValueField(wireName: r'timer_ends_at')
  DateTime? get timerEndsAt;

  CallSessionResponse._();

  factory CallSessionResponse([void updates(CallSessionResponseBuilder b)]) =
      _$CallSessionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallSessionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallSessionResponse> get serializer =>
      _$CallSessionResponseSerializer();
}

class _$CallSessionResponseSerializer
    implements PrimitiveSerializer<CallSessionResponse> {
  @override
  final Iterable<Type> types = const [
    CallSessionResponse,
    _$CallSessionResponse
  ];

  @override
  final String wireName = r'CallSessionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accepted_by';
    yield serializers.serialize(
      object.acceptedBy,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(DateTime)]),
    );
    yield r'anonymous_participant_count';
    yield serializers.serialize(
      object.anonymousParticipantCount,
      specifiedType: const FullType(int),
    );
    if (object.endedAt != null) {
      yield r'ended_at';
      yield serializers.serialize(
        object.endedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.liveEndedAt != null) {
      yield r'live_ended_at';
      yield serializers.serialize(
        object.liveEndedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.liveStartedAt != null) {
      yield r'live_started_at';
      yield serializers.serialize(
        object.liveStartedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'missed_by';
    yield serializers.serialize(
      object.missedBy,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(DateTime)]),
    );
    yield r'participants';
    yield serializers.serialize(
      object.participants,
      specifiedType:
          const FullType(BuiltList, [FullType(CallParticipantResponse)]),
    );
    yield r'participants_count_by_role';
    yield serializers.serialize(
      object.participantsCountByRole,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
    yield r'rejected_by';
    yield serializers.serialize(
      object.rejectedBy,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(DateTime)]),
    );
    if (object.startedAt != null) {
      yield r'started_at';
      yield serializers.serialize(
        object.startedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.timerEndsAt != null) {
      yield r'timer_ends_at';
      yield serializers.serialize(
        object.timerEndsAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CallSessionResponse object, {
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
    required CallSessionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType(DateTime)]),
          ) as BuiltMap<String, DateTime>;
          result.acceptedBy.replace(valueDes);
          break;
        case r'anonymous_participant_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.anonymousParticipantCount = valueDes;
          break;
        case r'ended_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endedAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'live_ended_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.liveEndedAt = valueDes;
          break;
        case r'live_started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.liveStartedAt = valueDes;
          break;
        case r'missed_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType(DateTime)]),
          ) as BuiltMap<String, DateTime>;
          result.missedBy.replace(valueDes);
          break;
        case r'participants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(CallParticipantResponse)]),
          ) as BuiltList<CallParticipantResponse>;
          result.participants.replace(valueDes);
          break;
        case r'participants_count_by_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.participantsCountByRole.replace(valueDes);
          break;
        case r'rejected_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType(DateTime)]),
          ) as BuiltMap<String, DateTime>;
          result.rejectedBy.replace(valueDes);
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'timer_ends_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timerEndsAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallSessionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallSessionResponseBuilder();
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
