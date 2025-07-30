//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_transcription_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StopTranscriptionResponse
    implements
        Built<StopTranscriptionResponse, StopTranscriptionResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StopTranscriptionResponse._();

  factory StopTranscriptionResponse(
          [void updates(StopTranscriptionResponseBuilder b)]) =
      _$StopTranscriptionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopTranscriptionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopTranscriptionResponse> get serializer =>
      _$StopTranscriptionResponseSerializer();
}

class _$StopTranscriptionResponseSerializer
    implements PrimitiveSerializer<StopTranscriptionResponse> {
  @override
  final Iterable<Type> types = const [
    StopTranscriptionResponse,
    _$StopTranscriptionResponse
  ];

  @override
  final String wireName = r'StopTranscriptionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopTranscriptionResponse object, {
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
    StopTranscriptionResponse object, {
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
    required StopTranscriptionResponseBuilder result,
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
  StopTranscriptionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopTranscriptionResponseBuilder();
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
