//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_reactivated_event.g.dart';

/// UserReactivatedEvent
///
/// Properties:
/// * [createdAt]
/// * [type]
/// * [user]
@BuiltValue()
abstract class UserReactivatedEvent
    implements Built<UserReactivatedEvent, UserReactivatedEventBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  User? get user;

  UserReactivatedEvent._();

  factory UserReactivatedEvent([void updates(UserReactivatedEventBuilder b)]) =
      _$UserReactivatedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserReactivatedEventBuilder b) =>
      b..type = 'user.reactivated';

  @BuiltValueSerializer(custom: true)
  static Serializer<UserReactivatedEvent> get serializer =>
      _$UserReactivatedEventSerializer();
}

class _$UserReactivatedEventSerializer
    implements PrimitiveSerializer<UserReactivatedEvent> {
  @override
  final Iterable<Type> types = const [
    UserReactivatedEvent,
    _$UserReactivatedEvent
  ];

  @override
  final String wireName = r'UserReactivatedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserReactivatedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    UserReactivatedEvent object, {
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
    required UserReactivatedEventBuilder result,
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
  UserReactivatedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserReactivatedEventBuilder();
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
