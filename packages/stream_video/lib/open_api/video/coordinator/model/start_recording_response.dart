//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_recording_response.g.dart';

/// StartRecordingResponse is the response payload for the start recording endpoint.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StartRecordingResponse
    implements Built<StartRecordingResponse, StartRecordingResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StartRecordingResponse._();

  factory StartRecordingResponse(
          [void updates(StartRecordingResponseBuilder b)]) =
      _$StartRecordingResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartRecordingResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartRecordingResponse> get serializer =>
      _$StartRecordingResponseSerializer();
}

class _$StartRecordingResponseSerializer
    implements PrimitiveSerializer<StartRecordingResponse> {
  @override
  final Iterable<Type> types = const [
    StartRecordingResponse,
    _$StartRecordingResponse
  ];

  @override
  final String wireName = r'StartRecordingResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartRecordingResponse object, {
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
    StartRecordingResponse object, {
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
    required StartRecordingResponseBuilder result,
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
  StartRecordingResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartRecordingResponseBuilder();
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
