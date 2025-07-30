//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_frame_recording_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StopFrameRecordingResponse
    implements
        Built<StopFrameRecordingResponse, StopFrameRecordingResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StopFrameRecordingResponse._();

  factory StopFrameRecordingResponse(
          [void updates(StopFrameRecordingResponseBuilder b)]) =
      _$StopFrameRecordingResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopFrameRecordingResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopFrameRecordingResponse> get serializer =>
      _$StopFrameRecordingResponseSerializer();
}

class _$StopFrameRecordingResponseSerializer
    implements PrimitiveSerializer<StopFrameRecordingResponse> {
  @override
  final Iterable<Type> types = const [
    StopFrameRecordingResponse,
    _$StopFrameRecordingResponse
  ];

  @override
  final String wireName = r'StopFrameRecordingResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopFrameRecordingResponse object, {
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
    StopFrameRecordingResponse object, {
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
    required StopFrameRecordingResponseBuilder result,
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
  StopFrameRecordingResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopFrameRecordingResponseBuilder();
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
