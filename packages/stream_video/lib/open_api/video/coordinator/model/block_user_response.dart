//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'block_user_response.g.dart';

/// BlockUserResponse is the payload for blocking a user.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class BlockUserResponse
    implements Built<BlockUserResponse, BlockUserResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  BlockUserResponse._();

  factory BlockUserResponse([void updates(BlockUserResponseBuilder b)]) =
      _$BlockUserResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlockUserResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlockUserResponse> get serializer =>
      _$BlockUserResponseSerializer();
}

class _$BlockUserResponseSerializer
    implements PrimitiveSerializer<BlockUserResponse> {
  @override
  final Iterable<Type> types = const [BlockUserResponse, _$BlockUserResponse];

  @override
  final String wireName = r'BlockUserResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlockUserResponse object, {
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
    BlockUserResponse object, {
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
    required BlockUserResponseBuilder result,
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
  BlockUserResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlockUserResponseBuilder();
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
