//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_user_permissions_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class UpdateUserPermissionsResponse
    implements
        Built<UpdateUserPermissionsResponse,
            UpdateUserPermissionsResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  UpdateUserPermissionsResponse._();

  factory UpdateUserPermissionsResponse(
          [void updates(UpdateUserPermissionsResponseBuilder b)]) =
      _$UpdateUserPermissionsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateUserPermissionsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateUserPermissionsResponse> get serializer =>
      _$UpdateUserPermissionsResponseSerializer();
}

class _$UpdateUserPermissionsResponseSerializer
    implements PrimitiveSerializer<UpdateUserPermissionsResponse> {
  @override
  final Iterable<Type> types = const [
    UpdateUserPermissionsResponse,
    _$UpdateUserPermissionsResponse
  ];

  @override
  final String wireName = r'UpdateUserPermissionsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateUserPermissionsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateUserPermissionsResponse object, {
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
    required UpdateUserPermissionsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateUserPermissionsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateUserPermissionsResponseBuilder();
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
