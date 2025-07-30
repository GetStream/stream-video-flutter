//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_response.g.dart';

/// User response object
///
/// Properties:
/// * [blockedUserIds]
/// * [createdAt] - Date/time of creation
/// * [custom] - Custom data for this object
/// * [deactivatedAt] - Date of deactivation
/// * [deletedAt] - Date/time of deletion
/// * [id] - Unique user identifier
/// * [image]
/// * [language] - Preferred language of a user
/// * [lastActive] - Date of last activity
/// * [name] - Optional name of user
/// * [revokeTokensIssuedBefore] - Revocation date for tokens
/// * [role] - Determines the set of user permissions
/// * [teams] - List of teams user is a part of
/// * [teamsRole]
/// * [updatedAt] - Date/time of the last update
@BuiltValue()
abstract class UserResponse
    implements Built<UserResponse, UserResponseBuilder> {
  @BuiltValueField(wireName: r'blocked_user_ids')
  BuiltList<String> get blockedUserIds;

  /// Date/time of creation
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// Custom data for this object
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?> get custom;

  /// Date of deactivation
  @BuiltValueField(wireName: r'deactivated_at')
  DateTime? get deactivatedAt;

  /// Date/time of deletion
  @BuiltValueField(wireName: r'deleted_at')
  DateTime? get deletedAt;

  /// Unique user identifier
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'image')
  String? get image;

  /// Preferred language of a user
  @BuiltValueField(wireName: r'language')
  String get language;

  /// Date of last activity
  @BuiltValueField(wireName: r'last_active')
  DateTime? get lastActive;

  /// Optional name of user
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Revocation date for tokens
  @BuiltValueField(wireName: r'revoke_tokens_issued_before')
  DateTime? get revokeTokensIssuedBefore;

  /// Determines the set of user permissions
  @BuiltValueField(wireName: r'role')
  String get role;

  /// List of teams user is a part of
  @BuiltValueField(wireName: r'teams')
  BuiltList<String> get teams;

  @BuiltValueField(wireName: r'teams_role')
  BuiltMap<String, String>? get teamsRole;

  /// Date/time of the last update
  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  UserResponse._();

  factory UserResponse([void updates(UserResponseBuilder b)]) = _$UserResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserResponse> get serializer => _$UserResponseSerializer();
}

class _$UserResponseSerializer implements PrimitiveSerializer<UserResponse> {
  @override
  final Iterable<Type> types = const [UserResponse, _$UserResponse];

  @override
  final String wireName = r'UserResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserResponse object, {
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
    UserResponse object, {
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
    required UserResponseBuilder result,
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
  UserResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserResponseBuilder();
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
