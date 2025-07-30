//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_transcription_response.g.dart';

/// StartTranscriptionResponse
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StartTranscriptionResponse
    implements
        Built<StartTranscriptionResponse, StartTranscriptionResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StartTranscriptionResponse._();

  factory StartTranscriptionResponse(
          [void updates(StartTranscriptionResponseBuilder b)]) =
      _$StartTranscriptionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartTranscriptionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartTranscriptionResponse> get serializer =>
      _$StartTranscriptionResponseSerializer();
}

class _$StartTranscriptionResponseSerializer
    implements PrimitiveSerializer<StartTranscriptionResponse> {
  @override
  final Iterable<Type> types = const [
    StartTranscriptionResponse,
    _$StartTranscriptionResponse
  ];

  @override
  final String wireName = r'StartTranscriptionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartTranscriptionResponse object, {
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
    StartTranscriptionResponse object, {
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
    required StartTranscriptionResponseBuilder result,
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
  StartTranscriptionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartTranscriptionResponseBuilder();
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
