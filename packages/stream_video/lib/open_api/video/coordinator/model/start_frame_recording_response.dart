//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_frame_recording_response.g.dart';

/// StartFrameRecordingResponse is the response payload for the start frame recording endpoint.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StartFrameRecordingResponse
    implements
        Built<StartFrameRecordingResponse, StartFrameRecordingResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StartFrameRecordingResponse._();

  factory StartFrameRecordingResponse(
          [void updates(StartFrameRecordingResponseBuilder b)]) =
      _$StartFrameRecordingResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartFrameRecordingResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartFrameRecordingResponse> get serializer =>
      _$StartFrameRecordingResponseSerializer();
}

class _$StartFrameRecordingResponseSerializer
    implements PrimitiveSerializer<StartFrameRecordingResponse> {
  @override
  final Iterable<Type> types = const [
    StartFrameRecordingResponse,
    _$StartFrameRecordingResponse
  ];

  @override
  final String wireName = r'StartFrameRecordingResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartFrameRecordingResponse object, {
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
    StartFrameRecordingResponse object, {
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
    required StartFrameRecordingResponseBuilder result,
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
  StartFrameRecordingResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartFrameRecordingResponseBuilder();
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
