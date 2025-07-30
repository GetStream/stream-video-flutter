//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_banned_event.g.dart';

/// UserBannedEvent
///
/// Properties:
/// * [channelId]
/// * [channelType]
/// * [cid]
/// * [createdAt]
/// * [createdBy]
/// * [expiration]
/// * [reason]
/// * [shadow]
/// * [team]
/// * [type]
/// * [user]
@BuiltValue()
abstract class UserBannedEvent
    implements Built<UserBannedEvent, UserBannedEventBuilder> {
  @BuiltValueField(wireName: r'channel_id')
  String get channelId;

  @BuiltValueField(wireName: r'channel_type')
  String get channelType;

  @BuiltValueField(wireName: r'cid')
  String get cid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  User get createdBy;

  @BuiltValueField(wireName: r'expiration')
  DateTime? get expiration;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'shadow')
  bool get shadow;

  @BuiltValueField(wireName: r'team')
  String? get team;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  User? get user;

  UserBannedEvent._();

  factory UserBannedEvent([void updates(UserBannedEventBuilder b)]) =
      _$UserBannedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserBannedEventBuilder b) => b..type = 'user.banned';

  @BuiltValueSerializer(custom: true)
  static Serializer<UserBannedEvent> get serializer =>
      _$UserBannedEventSerializer();
}

class _$UserBannedEventSerializer
    implements PrimitiveSerializer<UserBannedEvent> {
  @override
  final Iterable<Type> types = const [UserBannedEvent, _$UserBannedEvent];

  @override
  final String wireName = r'UserBannedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserBannedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel_id';
    yield serializers.serialize(
      object.channelId,
      specifiedType: const FullType(String),
    );
    yield r'channel_type';
    yield serializers.serialize(
      object.channelType,
      specifiedType: const FullType(String),
    );
    yield r'cid';
    yield serializers.serialize(
      object.cid,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'created_by';
    yield serializers.serialize(
      object.createdBy,
      specifiedType: const FullType(User),
    );
    if (object.expiration != null) {
      yield r'expiration';
      yield serializers.serialize(
        object.expiration,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    yield r'shadow';
    yield serializers.serialize(
      object.shadow,
      specifiedType: const FullType(bool),
    );
    if (object.team != null) {
      yield r'team';
      yield serializers.serialize(
        object.team,
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
        specifiedType: const FullType(User),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserBannedEvent object, {
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
    required UserBannedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelId = valueDes;
          break;
        case r'channel_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelType = valueDes;
          break;
        case r'cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cid = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(User),
          ) as User;
          result.createdBy.replace(valueDes);
          break;
        case r'expiration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiration = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'shadow':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shadow = valueDes;
          break;
        case r'team':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.team = valueDes;
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
  UserBannedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserBannedEventBuilder();
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
