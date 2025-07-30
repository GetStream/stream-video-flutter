//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unblock_user_response.g.dart';

/// UnblockUserResponse is the payload for unblocking a user.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class UnblockUserResponse
    implements Built<UnblockUserResponse, UnblockUserResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  UnblockUserResponse._();

  factory UnblockUserResponse([void updates(UnblockUserResponseBuilder b)]) =
      _$UnblockUserResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnblockUserResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnblockUserResponse> get serializer =>
      _$UnblockUserResponseSerializer();
}

class _$UnblockUserResponseSerializer
    implements PrimitiveSerializer<UnblockUserResponse> {
  @override
  final Iterable<Type> types = const [
    UnblockUserResponse,
    _$UnblockUserResponse
  ];

  @override
  final String wireName = r'UnblockUserResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnblockUserResponse object, {
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
    UnblockUserResponse object, {
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
    required UnblockUserResponseBuilder result,
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
  UnblockUserResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnblockUserResponseBuilder();
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
