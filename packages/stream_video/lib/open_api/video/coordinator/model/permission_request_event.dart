//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_request_event.g.dart';

/// This event is sent when a user requests access to a feature on a call, clients receiving this event should display a permission request to the user
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [permissions] - The list of permissions requested by the user
/// * [type] - The type of event: \"call.permission_request\" in this case
/// * [user]
@BuiltValue()
abstract class PermissionRequestEvent
    implements Built<PermissionRequestEvent, PermissionRequestEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The list of permissions requested by the user
  @BuiltValueField(wireName: r'permissions')
  BuiltList<String> get permissions;

  /// The type of event: \"call.permission_request\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  PermissionRequestEvent._();

  factory PermissionRequestEvent(
          [void updates(PermissionRequestEventBuilder b)]) =
      _$PermissionRequestEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionRequestEventBuilder b) =>
      b..type = 'call.permission_request';

  @BuiltValueSerializer(custom: true)
  static Serializer<PermissionRequestEvent> get serializer =>
      _$PermissionRequestEventSerializer();
}

class _$PermissionRequestEventSerializer
    implements PrimitiveSerializer<PermissionRequestEvent> {
  @override
  final Iterable<Type> types = const [
    PermissionRequestEvent,
    _$PermissionRequestEvent
  ];

  @override
  final String wireName = r'PermissionRequestEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermissionRequestEvent object, {
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
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    PermissionRequestEvent object, {
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
    required PermissionRequestEventBuilder result,
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
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.permissions.replace(valueDes);
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
  PermissionRequestEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionRequestEventBuilder();
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
