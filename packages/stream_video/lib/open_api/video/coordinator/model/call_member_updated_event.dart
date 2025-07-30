//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_member_updated_event.g.dart';

/// This event is sent when one or more members are updated
///
/// Properties:
/// * [call]
/// * [callCid]
/// * [createdAt]
/// * [members] - The list of members that were updated
/// * [type] - The type of event: \"call.member_updated\" in this case
@BuiltValue()
abstract class CallMemberUpdatedEvent
    implements Built<CallMemberUpdatedEvent, CallMemberUpdatedEventBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The list of members that were updated
  @BuiltValueField(wireName: r'members')
  BuiltList<MemberResponse> get members;

  /// The type of event: \"call.member_updated\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallMemberUpdatedEvent._();

  factory CallMemberUpdatedEvent(
          [void updates(CallMemberUpdatedEventBuilder b)]) =
      _$CallMemberUpdatedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallMemberUpdatedEventBuilder b) =>
      b..type = 'call.member_updated';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallMemberUpdatedEvent> get serializer =>
      _$CallMemberUpdatedEventSerializer();
}

class _$CallMemberUpdatedEventSerializer
    implements PrimitiveSerializer<CallMemberUpdatedEvent> {
  @override
  final Iterable<Type> types = const [
    CallMemberUpdatedEvent,
    _$CallMemberUpdatedEvent
  ];

  @override
  final String wireName = r'CallMemberUpdatedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallMemberUpdatedEvent object, {
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
    yield r'members';
    yield serializers.serialize(
      object.members,
      specifiedType: const FullType(BuiltList, [FullType(MemberResponse)]),
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
    CallMemberUpdatedEvent object, {
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
    required CallMemberUpdatedEventBuilder result,
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
        case r'members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(MemberResponse)]),
          ) as BuiltList<MemberResponse>;
          result.members.replace(valueDes);
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
  CallMemberUpdatedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallMemberUpdatedEventBuilder();
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
