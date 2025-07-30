//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'collect_user_feedback_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class CollectUserFeedbackResponse
    implements
        Built<CollectUserFeedbackResponse, CollectUserFeedbackResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  CollectUserFeedbackResponse._();

  factory CollectUserFeedbackResponse(
          [void updates(CollectUserFeedbackResponseBuilder b)]) =
      _$CollectUserFeedbackResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CollectUserFeedbackResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CollectUserFeedbackResponse> get serializer =>
      _$CollectUserFeedbackResponseSerializer();
}

class _$CollectUserFeedbackResponseSerializer
    implements PrimitiveSerializer<CollectUserFeedbackResponse> {
  @override
  final Iterable<Type> types = const [
    CollectUserFeedbackResponse,
    _$CollectUserFeedbackResponse
  ];

  @override
  final String wireName = r'CollectUserFeedbackResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CollectUserFeedbackResponse object, {
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
    CollectUserFeedbackResponse object, {
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
    required CollectUserFeedbackResponseBuilder result,
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
  CollectUserFeedbackResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CollectUserFeedbackResponseBuilder();
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
