//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_closed_captions_request.g.dart';

/// StopClosedCaptionsRequest
///
/// Properties:
/// * [stopTranscription]
@BuiltValue()
abstract class StopClosedCaptionsRequest
    implements
        Built<StopClosedCaptionsRequest, StopClosedCaptionsRequestBuilder> {
  @BuiltValueField(wireName: r'stop_transcription')
  bool? get stopTranscription;

  StopClosedCaptionsRequest._();

  factory StopClosedCaptionsRequest(
          [void updates(StopClosedCaptionsRequestBuilder b)]) =
      _$StopClosedCaptionsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopClosedCaptionsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopClosedCaptionsRequest> get serializer =>
      _$StopClosedCaptionsRequestSerializer();
}

class _$StopClosedCaptionsRequestSerializer
    implements PrimitiveSerializer<StopClosedCaptionsRequest> {
  @override
  final Iterable<Type> types = const [
    StopClosedCaptionsRequest,
    _$StopClosedCaptionsRequest
  ];

  @override
  final String wireName = r'StopClosedCaptionsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopClosedCaptionsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.stopTranscription != null) {
      yield r'stop_transcription';
      yield serializers.serialize(
        object.stopTranscription,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StopClosedCaptionsRequest object, {
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
    required StopClosedCaptionsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stop_transcription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.stopTranscription = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StopClosedCaptionsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopClosedCaptionsRequestBuilder();
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
