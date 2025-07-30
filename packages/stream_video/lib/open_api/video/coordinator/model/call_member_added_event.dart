//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_member_added_event.g.dart';

/// This event is sent when one or more members are added to a call
///
/// Properties:
/// * [call]
/// * [callCid]
/// * [createdAt]
/// * [members] - the members added to this call
/// * [type] - The type of event: \"call.member_added\" in this case
@BuiltValue()
abstract class CallMemberAddedEvent
    implements Built<CallMemberAddedEvent, CallMemberAddedEventBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// the members added to this call
  @BuiltValueField(wireName: r'members')
  BuiltList<MemberResponse> get members;

  /// The type of event: \"call.member_added\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallMemberAddedEvent._();

  factory CallMemberAddedEvent([void updates(CallMemberAddedEventBuilder b)]) =
      _$CallMemberAddedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallMemberAddedEventBuilder b) =>
      b..type = 'call.member_added';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallMemberAddedEvent> get serializer =>
      _$CallMemberAddedEventSerializer();
}

class _$CallMemberAddedEventSerializer
    implements PrimitiveSerializer<CallMemberAddedEvent> {
  @override
  final Iterable<Type> types = const [
    CallMemberAddedEvent,
    _$CallMemberAddedEvent
  ];

  @override
  final String wireName = r'CallMemberAddedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallMemberAddedEvent object, {
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
    CallMemberAddedEvent object, {
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
    required CallMemberAddedEventBuilder result,
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
  CallMemberAddedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallMemberAddedEventBuilder();
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
