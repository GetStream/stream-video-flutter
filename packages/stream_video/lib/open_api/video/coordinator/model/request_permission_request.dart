//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'request_permission_request.g.dart';

/// RequestPermissionRequest
///
/// Properties:
/// * [permissions]
@BuiltValue()
abstract class RequestPermissionRequest
    implements
        Built<RequestPermissionRequest, RequestPermissionRequestBuilder> {
  @BuiltValueField(wireName: r'permissions')
  BuiltList<String> get permissions;

  RequestPermissionRequest._();

  factory RequestPermissionRequest(
          [void updates(RequestPermissionRequestBuilder b)]) =
      _$RequestPermissionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RequestPermissionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RequestPermissionRequest> get serializer =>
      _$RequestPermissionRequestSerializer();
}

class _$RequestPermissionRequestSerializer
    implements PrimitiveSerializer<RequestPermissionRequest> {
  @override
  final Iterable<Type> types = const [
    RequestPermissionRequest,
    _$RequestPermissionRequest
  ];

  @override
  final String wireName = r'RequestPermissionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RequestPermissionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RequestPermissionRequest object, {
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
    required RequestPermissionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.permissions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RequestPermissionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RequestPermissionRequestBuilder();
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
