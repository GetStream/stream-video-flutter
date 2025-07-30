//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unpin_response.g.dart';

/// UnpinResponse is the payload for unpinning a message.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class UnpinResponse
    implements Built<UnpinResponse, UnpinResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  UnpinResponse._();

  factory UnpinResponse([void updates(UnpinResponseBuilder b)]) =
      _$UnpinResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnpinResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnpinResponse> get serializer =>
      _$UnpinResponseSerializer();
}

class _$UnpinResponseSerializer implements PrimitiveSerializer<UnpinResponse> {
  @override
  final Iterable<Type> types = const [UnpinResponse, _$UnpinResponse];

  @override
  final String wireName = r'UnpinResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnpinResponse object, {
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
    UnpinResponse object, {
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
    required UnpinResponseBuilder result,
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
  UnpinResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnpinResponseBuilder();
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
