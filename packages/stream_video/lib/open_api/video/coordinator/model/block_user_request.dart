//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'block_user_request.g.dart';

/// BlockUserRequest is the payload for blocking a user.
///
/// Properties:
/// * [userId] - the user to block
@BuiltValue()
abstract class BlockUserRequest
    implements Built<BlockUserRequest, BlockUserRequestBuilder> {
  /// the user to block
  @BuiltValueField(wireName: r'user_id')
  String get userId;

  BlockUserRequest._();

  factory BlockUserRequest([void updates(BlockUserRequestBuilder b)]) =
      _$BlockUserRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlockUserRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlockUserRequest> get serializer =>
      _$BlockUserRequestSerializer();
}

class _$BlockUserRequestSerializer
    implements PrimitiveSerializer<BlockUserRequest> {
  @override
  final Iterable<Type> types = const [BlockUserRequest, _$BlockUserRequest];

  @override
  final String wireName = r'BlockUserRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlockUserRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BlockUserRequest object, {
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
    required BlockUserRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  BlockUserRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlockUserRequestBuilder();
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
