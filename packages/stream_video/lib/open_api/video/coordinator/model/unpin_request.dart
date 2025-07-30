//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unpin_request.g.dart';

/// UnpinRequest is the payload for unpinning a message.
///
/// Properties:
/// * [sessionId] - the session ID of the user who pinned the message
/// * [userId] - the user ID of the user who pinned the message
@BuiltValue()
abstract class UnpinRequest
    implements Built<UnpinRequest, UnpinRequestBuilder> {
  /// the session ID of the user who pinned the message
  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  /// the user ID of the user who pinned the message
  @BuiltValueField(wireName: r'user_id')
  String get userId;

  UnpinRequest._();

  factory UnpinRequest([void updates(UnpinRequestBuilder b)]) = _$UnpinRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnpinRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnpinRequest> get serializer => _$UnpinRequestSerializer();
}

class _$UnpinRequestSerializer implements PrimitiveSerializer<UnpinRequest> {
  @override
  final Iterable<Type> types = const [UnpinRequest, _$UnpinRequest];

  @override
  final String wireName = r'UnpinRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnpinRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'session_id';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UnpinRequest object, {
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
    required UnpinRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
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
  UnpinRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnpinRequestBuilder();
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
