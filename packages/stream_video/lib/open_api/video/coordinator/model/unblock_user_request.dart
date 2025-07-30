//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unblock_user_request.g.dart';

/// UnblockUserRequest is the payload for unblocking a user.
///
/// Properties:
/// * [userId] - the user to unblock
@BuiltValue()
abstract class UnblockUserRequest
    implements Built<UnblockUserRequest, UnblockUserRequestBuilder> {
  /// the user to unblock
  @BuiltValueField(wireName: r'user_id')
  String get userId;

  UnblockUserRequest._();

  factory UnblockUserRequest([void updates(UnblockUserRequestBuilder b)]) =
      _$UnblockUserRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnblockUserRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnblockUserRequest> get serializer =>
      _$UnblockUserRequestSerializer();
}

class _$UnblockUserRequestSerializer
    implements PrimitiveSerializer<UnblockUserRequest> {
  @override
  final Iterable<Type> types = const [UnblockUserRequest, _$UnblockUserRequest];

  @override
  final String wireName = r'UnblockUserRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnblockUserRequest object, {
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
    UnblockUserRequest object, {
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
    required UnblockUserRequestBuilder result,
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
  UnblockUserRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnblockUserRequestBuilder();
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
