//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_user_permissions_request.g.dart';

/// UpdateUserPermissionsRequest
///
/// Properties:
/// * [grantPermissions]
/// * [revokePermissions]
/// * [userId]
@BuiltValue()
abstract class UpdateUserPermissionsRequest
    implements
        Built<UpdateUserPermissionsRequest,
            UpdateUserPermissionsRequestBuilder> {
  @BuiltValueField(wireName: r'grant_permissions')
  BuiltList<String>? get grantPermissions;

  @BuiltValueField(wireName: r'revoke_permissions')
  BuiltList<String>? get revokePermissions;

  @BuiltValueField(wireName: r'user_id')
  String get userId;

  UpdateUserPermissionsRequest._();

  factory UpdateUserPermissionsRequest(
          [void updates(UpdateUserPermissionsRequestBuilder b)]) =
      _$UpdateUserPermissionsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateUserPermissionsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateUserPermissionsRequest> get serializer =>
      _$UpdateUserPermissionsRequestSerializer();
}

class _$UpdateUserPermissionsRequestSerializer
    implements PrimitiveSerializer<UpdateUserPermissionsRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateUserPermissionsRequest,
    _$UpdateUserPermissionsRequest
  ];

  @override
  final String wireName = r'UpdateUserPermissionsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateUserPermissionsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.grantPermissions != null) {
      yield r'grant_permissions';
      yield serializers.serialize(
        object.grantPermissions,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.revokePermissions != null) {
      yield r'revoke_permissions';
      yield serializers.serialize(
        object.revokePermissions,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateUserPermissionsRequest object, {
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
    required UpdateUserPermissionsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'grant_permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.grantPermissions.replace(valueDes);
          break;
        case r'revoke_permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.revokePermissions.replace(valueDes);
          break;
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateUserPermissionsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateUserPermissionsRequestBuilder();
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
