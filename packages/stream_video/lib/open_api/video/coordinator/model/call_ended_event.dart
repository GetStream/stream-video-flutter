//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_ended_event.g.dart';

/// This event is sent when a call is mark as ended for all its participants. Clients receiving this event should leave the call screen
///
/// Properties:
/// * [call]
/// * [callCid]
/// * [createdAt]
/// * [reason] - The reason why the call ended, if available
/// * [type] - The type of event: \"call.ended\" in this case
/// * [user]
@BuiltValue()
abstract class CallEndedEvent
    implements Built<CallEndedEvent, CallEndedEventBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The reason why the call ended, if available
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// The type of event: \"call.ended\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  UserResponse? get user;

  CallEndedEvent._();

  factory CallEndedEvent([void updates(CallEndedEventBuilder b)]) =
      _$CallEndedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallEndedEventBuilder b) => b..type = 'call.ended';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallEndedEvent> get serializer =>
      _$CallEndedEventSerializer();
}

class _$CallEndedEventSerializer
    implements PrimitiveSerializer<CallEndedEvent> {
  @override
  final Iterable<Type> types = const [CallEndedEvent, _$CallEndedEvent];

  @override
  final String wireName = r'CallEndedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallEndedEvent object, {
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
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType(UserResponse),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CallEndedEvent object, {
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
    required CallEndedEventBuilder result,
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
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallEndedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallEndedEventBuilder();
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
