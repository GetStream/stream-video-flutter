//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'blocked_user_event.g.dart';

/// This event is sent to call participants to notify when a user is blocked on a call, clients can use this event to show a notification. If the user is the current user, the client should leave the call screen as well
///
/// Properties:
/// * [blockedByUser]
/// * [callCid]
/// * [createdAt]
/// * [type] - The type of event: \"call.blocked_user\" in this case
/// * [user]
@BuiltValue()
abstract class BlockedUserEvent
    implements Built<BlockedUserEvent, BlockedUserEventBuilder> {
  @BuiltValueField(wireName: r'blocked_by_user')
  UserResponse? get blockedByUser;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The type of event: \"call.blocked_user\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  BlockedUserEvent._();

  factory BlockedUserEvent([void updates(BlockedUserEventBuilder b)]) =
      _$BlockedUserEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlockedUserEventBuilder b) =>
      b..type = 'call.blocked_user';

  @BuiltValueSerializer(custom: true)
  static Serializer<BlockedUserEvent> get serializer =>
      _$BlockedUserEventSerializer();
}

class _$BlockedUserEventSerializer
    implements PrimitiveSerializer<BlockedUserEvent> {
  @override
  final Iterable<Type> types = const [BlockedUserEvent, _$BlockedUserEvent];

  @override
  final String wireName = r'BlockedUserEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlockedUserEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.blockedByUser != null) {
      yield r'blocked_by_user';
      yield serializers.serialize(
        object.blockedByUser,
        specifiedType: const FullType(UserResponse),
      );
    }
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
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BlockedUserEvent object, {
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
    required BlockedUserEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'blocked_by_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.blockedByUser.replace(valueDes);
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
  BlockedUserEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlockedUserEventBuilder();
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
