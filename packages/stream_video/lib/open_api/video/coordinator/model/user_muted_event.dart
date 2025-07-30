//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_muted_event.g.dart';

/// UserMutedEvent
///
/// Properties:
/// * [createdAt]
/// * [targetUser]
/// * [targetUsers]
/// * [type]
/// * [user]
@BuiltValue()
abstract class UserMutedEvent
    implements Built<UserMutedEvent, UserMutedEventBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'target_user')
  String? get targetUser;

  @BuiltValueField(wireName: r'target_users')
  BuiltList<String>? get targetUsers;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  User? get user;

  UserMutedEvent._();

  factory UserMutedEvent([void updates(UserMutedEventBuilder b)]) =
      _$UserMutedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserMutedEventBuilder b) => b..type = 'user.muted';

  @BuiltValueSerializer(custom: true)
  static Serializer<UserMutedEvent> get serializer =>
      _$UserMutedEventSerializer();
}

class _$UserMutedEventSerializer
    implements PrimitiveSerializer<UserMutedEvent> {
  @override
  final Iterable<Type> types = const [UserMutedEvent, _$UserMutedEvent];

  @override
  final String wireName = r'UserMutedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserMutedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.targetUser != null) {
      yield r'target_user';
      yield serializers.serialize(
        object.targetUser,
        specifiedType: const FullType(String),
      );
    }
    if (object.targetUsers != null) {
      yield r'target_users';
      yield serializers.serialize(
        object.targetUsers,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
        specifiedType: const FullType(User),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserMutedEvent object, {
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
    required UserMutedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'target_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetUser = valueDes;
          break;
        case r'target_users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.targetUsers.replace(valueDes);
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
            specifiedType: const FullType(User),
          ) as User;
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
  UserMutedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserMutedEventBuilder();
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
