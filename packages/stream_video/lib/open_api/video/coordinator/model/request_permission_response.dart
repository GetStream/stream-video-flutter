//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'request_permission_response.g.dart';

/// RequestPermissionResponse
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class RequestPermissionResponse
    implements
        Built<RequestPermissionResponse, RequestPermissionResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  RequestPermissionResponse._();

  factory RequestPermissionResponse(
          [void updates(RequestPermissionResponseBuilder b)]) =
      _$RequestPermissionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RequestPermissionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RequestPermissionResponse> get serializer =>
      _$RequestPermissionResponseSerializer();
}

class _$RequestPermissionResponseSerializer
    implements PrimitiveSerializer<RequestPermissionResponse> {
  @override
  final Iterable<Type> types = const [
    RequestPermissionResponse,
    _$RequestPermissionResponse
  ];

  @override
  final String wireName = r'RequestPermissionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RequestPermissionResponse object, {
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
    RequestPermissionResponse object, {
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
    required RequestPermissionResponseBuilder result,
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
  RequestPermissionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RequestPermissionResponseBuilder();
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
