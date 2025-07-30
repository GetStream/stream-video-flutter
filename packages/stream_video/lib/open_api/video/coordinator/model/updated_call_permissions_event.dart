//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/own_capability.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'updated_call_permissions_event.g.dart';

/// This event is sent to notify about permission changes for a user, clients receiving this event should update their UI accordingly
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [ownCapabilities] - The capabilities of the current user
/// * [type] - The type of event: \"call.permissions_updated\" in this case
/// * [user]
@BuiltValue()
abstract class UpdatedCallPermissionsEvent
    implements
        Built<UpdatedCallPermissionsEvent, UpdatedCallPermissionsEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The capabilities of the current user
  @BuiltValueField(wireName: r'own_capabilities')
  BuiltList<OwnCapability> get ownCapabilities;

  /// The type of event: \"call.permissions_updated\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  UpdatedCallPermissionsEvent._();

  factory UpdatedCallPermissionsEvent(
          [void updates(UpdatedCallPermissionsEventBuilder b)]) =
      _$UpdatedCallPermissionsEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdatedCallPermissionsEventBuilder b) =>
      b..type = 'call.permissions_updated';

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdatedCallPermissionsEvent> get serializer =>
      _$UpdatedCallPermissionsEventSerializer();
}

class _$UpdatedCallPermissionsEventSerializer
    implements PrimitiveSerializer<UpdatedCallPermissionsEvent> {
  @override
  final Iterable<Type> types = const [
    UpdatedCallPermissionsEvent,
    _$UpdatedCallPermissionsEvent
  ];

  @override
  final String wireName = r'UpdatedCallPermissionsEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdatedCallPermissionsEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'own_capabilities';
    yield serializers.serialize(
      object.ownCapabilities,
      specifiedType: const FullType(BuiltList, [FullType(OwnCapability)]),
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
    UpdatedCallPermissionsEvent object, {
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
    required UpdatedCallPermissionsEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'own_capabilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OwnCapability)]),
          ) as BuiltList<OwnCapability>;
          result.ownCapabilities.replace(valueDes);
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
  UpdatedCallPermissionsEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdatedCallPermissionsEventBuilder();
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
