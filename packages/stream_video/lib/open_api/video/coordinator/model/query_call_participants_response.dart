//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/own_capability.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_participant_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'query_call_participants_response.g.dart';

/// QueryCallParticipantsResponse
///
/// Properties:
/// * [call]
/// * [duration]
/// * [members]
/// * [membership]
/// * [ownCapabilities]
/// * [participants] - List of call participants
/// * [totalParticipants]
@BuiltValue()
abstract class QueryCallParticipantsResponse
    implements
        Built<QueryCallParticipantsResponse,
            QueryCallParticipantsResponseBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'members')
  BuiltList<MemberResponse> get members;

  @BuiltValueField(wireName: r'membership')
  MemberResponse? get membership;

  @BuiltValueField(wireName: r'own_capabilities')
  BuiltList<OwnCapability> get ownCapabilities;

  /// List of call participants
  @BuiltValueField(wireName: r'participants')
  BuiltList<CallParticipantResponse> get participants;

  @BuiltValueField(wireName: r'total_participants')
  int get totalParticipants;

  QueryCallParticipantsResponse._();

  factory QueryCallParticipantsResponse(
          [void updates(QueryCallParticipantsResponseBuilder b)]) =
      _$QueryCallParticipantsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueryCallParticipantsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueryCallParticipantsResponse> get serializer =>
      _$QueryCallParticipantsResponseSerializer();
}

class _$QueryCallParticipantsResponseSerializer
    implements PrimitiveSerializer<QueryCallParticipantsResponse> {
  @override
  final Iterable<Type> types = const [
    QueryCallParticipantsResponse,
    _$QueryCallParticipantsResponse
  ];

  @override
  final String wireName = r'QueryCallParticipantsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueryCallParticipantsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call';
    yield serializers.serialize(
      object.call,
      specifiedType: const FullType(CallResponse),
    );
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'members';
    yield serializers.serialize(
      object.members,
      specifiedType: const FullType(BuiltList, [FullType(MemberResponse)]),
    );
    if (object.membership != null) {
      yield r'membership';
      yield serializers.serialize(
        object.membership,
        specifiedType: const FullType(MemberResponse),
      );
    }
    yield r'own_capabilities';
    yield serializers.serialize(
      object.ownCapabilities,
      specifiedType: const FullType(BuiltList, [FullType(OwnCapability)]),
    );
    yield r'participants';
    yield serializers.serialize(
      object.participants,
      specifiedType:
          const FullType(BuiltList, [FullType(CallParticipantResponse)]),
    );
    yield r'total_participants';
    yield serializers.serialize(
      object.totalParticipants,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueryCallParticipantsResponse object, {
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
    required QueryCallParticipantsResponseBuilder result,
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
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(MemberResponse)]),
          ) as BuiltList<MemberResponse>;
          result.members.replace(valueDes);
          break;
        case r'membership':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemberResponse),
          ) as MemberResponse;
          result.membership.replace(valueDes);
          break;
        case r'own_capabilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OwnCapability)]),
          ) as BuiltList<OwnCapability>;
          result.ownCapabilities.replace(valueDes);
          break;
        case r'participants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(CallParticipantResponse)]),
          ) as BuiltList<CallParticipantResponse>;
          result.participants.replace(valueDes);
          break;
        case r'total_participants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalParticipants = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueryCallParticipantsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueryCallParticipantsResponseBuilder();
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
