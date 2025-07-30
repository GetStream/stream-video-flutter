//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_recording_response.g.dart';

/// Response for DeleteRecording
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class DeleteRecordingResponse
    implements Built<DeleteRecordingResponse, DeleteRecordingResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  DeleteRecordingResponse._();

  factory DeleteRecordingResponse(
          [void updates(DeleteRecordingResponseBuilder b)]) =
      _$DeleteRecordingResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteRecordingResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteRecordingResponse> get serializer =>
      _$DeleteRecordingResponseSerializer();
}

class _$DeleteRecordingResponseSerializer
    implements PrimitiveSerializer<DeleteRecordingResponse> {
  @override
  final Iterable<Type> types = const [
    DeleteRecordingResponse,
    _$DeleteRecordingResponse
  ];

  @override
  final String wireName = r'DeleteRecordingResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteRecordingResponse object, {
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
    DeleteRecordingResponse object, {
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
    required DeleteRecordingResponseBuilder result,
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
  DeleteRecordingResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteRecordingResponseBuilder();
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
