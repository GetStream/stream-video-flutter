//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response_privacy_fields.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_updated_event.g.dart';

/// This event is sent when a user gets updated. The event contains information about the updated user.
///
/// Properties:
/// * [createdAt] - Date/time of creation
/// * [custom]
/// * [receivedAt]
/// * [type] - The type of event: \"user.updated\" in this case
/// * [user]
@BuiltValue()
abstract class UserUpdatedEvent
    implements Built<UserUpdatedEvent, UserUpdatedEventBuilder> {
  /// Date/time of creation
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?> get custom;

  @BuiltValueField(wireName: r'received_at')
  DateTime? get receivedAt;

  /// The type of event: \"user.updated\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  UserResponsePrivacyFields get user;

  UserUpdatedEvent._();

  factory UserUpdatedEvent([void updates(UserUpdatedEventBuilder b)]) =
      _$UserUpdatedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserUpdatedEventBuilder b) => b..type = 'user.updated';

  @BuiltValueSerializer(custom: true)
  static Serializer<UserUpdatedEvent> get serializer =>
      _$UserUpdatedEventSerializer();
}

class _$UserUpdatedEventSerializer
    implements PrimitiveSerializer<UserUpdatedEvent> {
  @override
  final Iterable<Type> types = const [UserUpdatedEvent, _$UserUpdatedEvent];

  @override
  final String wireName = r'UserUpdatedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserUpdatedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'custom';
    yield serializers.serialize(
      object.custom,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.receivedAt != null) {
      yield r'received_at';
      yield serializers.serialize(
        object.receivedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponsePrivacyFields),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserUpdatedEvent object, {
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
    required UserUpdatedEventBuilder result,
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
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'received_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.receivedAt = valueDes;
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
            specifiedType: const FullType(UserResponsePrivacyFields),
          ) as UserResponsePrivacyFields;
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
  UserUpdatedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserUpdatedEventBuilder();
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
