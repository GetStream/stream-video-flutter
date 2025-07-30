//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_transcription_response.g.dart';

/// DeleteTranscriptionResponse is the payload for deleting a transcription.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class DeleteTranscriptionResponse
    implements
        Built<DeleteTranscriptionResponse, DeleteTranscriptionResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  DeleteTranscriptionResponse._();

  factory DeleteTranscriptionResponse(
          [void updates(DeleteTranscriptionResponseBuilder b)]) =
      _$DeleteTranscriptionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteTranscriptionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteTranscriptionResponse> get serializer =>
      _$DeleteTranscriptionResponseSerializer();
}

class _$DeleteTranscriptionResponseSerializer
    implements PrimitiveSerializer<DeleteTranscriptionResponse> {
  @override
  final Iterable<Type> types = const [
    DeleteTranscriptionResponse,
    _$DeleteTranscriptionResponse
  ];

  @override
  final String wireName = r'DeleteTranscriptionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteTranscriptionResponse object, {
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
    DeleteTranscriptionResponse object, {
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
    required DeleteTranscriptionResponseBuilder result,
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
  DeleteTranscriptionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteTranscriptionResponseBuilder();
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
