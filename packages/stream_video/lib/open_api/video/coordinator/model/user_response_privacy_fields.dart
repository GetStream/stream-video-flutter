//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_response_privacy_fields.g.dart';

/// UserResponsePrivacyFields
///
/// Properties:
/// * [blockedUserIds]
/// * [createdAt]
/// * [custom]
/// * [deactivatedAt]
/// * [deletedAt]
/// * [id]
/// * [image]
/// * [invisible]
/// * [language]
/// * [lastActive]
/// * [name]
/// * [privacySettings]
/// * [revokeTokensIssuedBefore]
/// * [role]
/// * [teams]
/// * [teamsRole]
/// * [updatedAt]
@BuiltValue()
abstract class UserResponsePrivacyFields
    implements
        Built<UserResponsePrivacyFields, UserResponsePrivacyFieldsBuilder> {
  @BuiltValueField(wireName: r'blocked_user_ids')
  BuiltList<String> get blockedUserIds;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?> get custom;

  @BuiltValueField(wireName: r'deactivated_at')
  DateTime? get deactivatedAt;

  @BuiltValueField(wireName: r'deleted_at')
  DateTime? get deletedAt;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'image')
  String? get image;

  @BuiltValueField(wireName: r'invisible')
  bool? get invisible;

  @BuiltValueField(wireName: r'language')
  String get language;

  @BuiltValueField(wireName: r'last_active')
  DateTime? get lastActive;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'privacy_settings')
  JsonObject? get privacySettings;

  @BuiltValueField(wireName: r'revoke_tokens_issued_before')
  DateTime? get revokeTokensIssuedBefore;

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'teams')
  BuiltList<String> get teams;

  @BuiltValueField(wireName: r'teams_role')
  BuiltMap<String, String>? get teamsRole;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  UserResponsePrivacyFields._();

  factory UserResponsePrivacyFields(
          [void updates(UserResponsePrivacyFieldsBuilder b)]) =
      _$UserResponsePrivacyFields;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserResponsePrivacyFieldsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserResponsePrivacyFields> get serializer =>
      _$UserResponsePrivacyFieldsSerializer();
}

class _$UserResponsePrivacyFieldsSerializer
    implements PrimitiveSerializer<UserResponsePrivacyFields> {
  @override
  final Iterable<Type> types = const [
    UserResponsePrivacyFields,
    _$UserResponsePrivacyFields
  ];

  @override
  final String wireName = r'UserResponsePrivacyFields';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserResponsePrivacyFields object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'blocked_user_ids';
    yield serializers.serialize(
      object.blockedUserIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
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
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType(String),
      );
    }
    if (object.invisible != null) {
      yield r'invisible';
      yield serializers.serialize(
        object.invisible,
        specifiedType: const FullType(bool),
      );
    }
    yield r'language';
    yield serializers.serialize(
      object.language,
      specifiedType: const FullType(String),
    );
    if (object.lastActive != null) {
      yield r'last_active';
      yield serializers.serialize(
        object.lastActive,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.privacySettings != null) {
      yield r'privacy_settings';
      yield serializers.serialize(
        object.privacySettings,
        specifiedType: const FullType(JsonObject),
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
    yield r'teams';
    yield serializers.serialize(
      object.teams,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.teamsRole != null) {
      yield r'teams_role';
      yield serializers.serialize(
        object.teamsRole,
        specifiedType:
            const FullType(BuiltMap, [FullType(String), FullType(String)]),
      );
    }
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserResponsePrivacyFields object, {
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
    required UserResponsePrivacyFieldsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'blocked_user_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.blockedUserIds.replace(valueDes);
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
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.image = valueDes;
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'privacy_settings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.privacySettings = valueDes;
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
  UserResponsePrivacyFields deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserResponsePrivacyFieldsBuilder();
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
