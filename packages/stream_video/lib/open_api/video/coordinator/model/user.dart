//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/privacy_settings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user.g.dart';

/// User
///
/// Properties:
/// * [banExpires]
/// * [banned]
/// * [createdAt]
/// * [custom]
/// * [deactivatedAt]
/// * [deletedAt]
/// * [id]
/// * [invisible]
/// * [language]
/// * [lastActive]
/// * [lastEngagedAt]
/// * [online]
/// * [privacySettings]
/// * [revokeTokensIssuedBefore]
/// * [role]
/// * [teams]
/// * [teamsRole]
/// * [updatedAt]
@BuiltValue()
abstract class User implements Built<User, UserBuilder> {
  @BuiltValueField(wireName: r'ban_expires')
  DateTime? get banExpires;

  @BuiltValueField(wireName: r'banned')
  bool get banned;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?> get custom;

  @BuiltValueField(wireName: r'deactivated_at')
  DateTime? get deactivatedAt;

  @BuiltValueField(wireName: r'deleted_at')
  DateTime? get deletedAt;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'invisible')
  bool? get invisible;

  @BuiltValueField(wireName: r'language')
  String? get language;

  @BuiltValueField(wireName: r'last_active')
  DateTime? get lastActive;

  @BuiltValueField(wireName: r'last_engaged_at')
  DateTime? get lastEngagedAt;

  @BuiltValueField(wireName: r'online')
  bool get online;

  @BuiltValueField(wireName: r'privacy_settings')
  PrivacySettings? get privacySettings;

  @BuiltValueField(wireName: r'revoke_tokens_issued_before')
  DateTime? get revokeTokensIssuedBefore;

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'teams')
  BuiltList<String>? get teams;

  @BuiltValueField(wireName: r'teams_role')
  BuiltMap<String, String> get teamsRole;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  User._();

  factory User([void updates(UserBuilder b)]) = _$User;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<User> get serializer => _$UserSerializer();
}

class _$UserSerializer implements PrimitiveSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];

  @override
  final String wireName = r'User';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    User object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.banExpires != null) {
      yield r'ban_expires';
      yield serializers.serialize(
        object.banExpires,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'banned';
    yield serializers.serialize(
      object.banned,
      specifiedType: const FullType(bool),
    );
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'custom';
    yield serializers.serialize(
      object.custom,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.deactivatedAt != null) {
      yield r'deactivated_at';
      yield serializers.serialize(
        object.deactivatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.deletedAt != null) {
      yield r'deleted_at';
      yield serializers.serialize(
        object.deletedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.invisible != null) {
      yield r'invisible';
      yield serializers.serialize(
        object.invisible,
        specifiedType: const FullType(bool),
      );
    }
    if (object.language != null) {
      yield r'language';
      yield serializers.serialize(
        object.language,
        specifiedType: const FullType(String),
      );
    }
    if (object.lastActive != null) {
      yield r'last_active';
      yield serializers.serialize(
        object.lastActive,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.lastEngagedAt != null) {
      yield r'last_engaged_at';
      yield serializers.serialize(
        object.lastEngagedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'online';
    yield serializers.serialize(
      object.online,
      specifiedType: const FullType(bool),
    );
    if (object.privacySettings != null) {
      yield r'privacy_settings';
      yield serializers.serialize(
        object.privacySettings,
        specifiedType: const FullType(PrivacySettings),
      );
    }
    if (object.revokeTokensIssuedBefore != null) {
      yield r'revoke_tokens_issued_before';
      yield serializers.serialize(
        object.revokeTokensIssuedBefore,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    if (object.teams != null) {
      yield r'teams';
      yield serializers.serialize(
        object.teams,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'teams_role';
    yield serializers.serialize(
      object.teamsRole,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    User object, {
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
    required UserBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ban_expires':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.banExpires = valueDes;
          break;
        case r'banned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.banned = valueDes;
          break;
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
        case r'deactivated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.deactivatedAt = valueDes;
          break;
        case r'deleted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.deletedAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'invisible':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.invisible = valueDes;
          break;
        case r'language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.language = valueDes;
          break;
        case r'last_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.lastActive = valueDes;
          break;
        case r'last_engaged_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.lastEngagedAt = valueDes;
          break;
        case r'online':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.online = valueDes;
          break;
        case r'privacy_settings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PrivacySettings),
          ) as PrivacySettings;
          result.privacySettings.replace(valueDes);
          break;
        case r'revoke_tokens_issued_before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.revokeTokensIssuedBefore = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'teams':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.teams.replace(valueDes);
          break;
        case r'teams_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.teamsRole.replace(valueDes);
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  User deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserBuilder();
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
