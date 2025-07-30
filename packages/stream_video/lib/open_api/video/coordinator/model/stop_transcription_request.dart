//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_transcription_request.g.dart';

/// StopTranscriptionRequest
///
/// Properties:
/// * [stopClosedCaptions]
@BuiltValue()
abstract class StopTranscriptionRequest
    implements
        Built<StopTranscriptionRequest, StopTranscriptionRequestBuilder> {
  @BuiltValueField(wireName: r'stop_closed_captions')
  bool? get stopClosedCaptions;

  StopTranscriptionRequest._();

  factory StopTranscriptionRequest(
          [void updates(StopTranscriptionRequestBuilder b)]) =
      _$StopTranscriptionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopTranscriptionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopTranscriptionRequest> get serializer =>
      _$StopTranscriptionRequestSerializer();
}

class _$StopTranscriptionRequestSerializer
    implements PrimitiveSerializer<StopTranscriptionRequest> {
  @override
  final Iterable<Type> types = const [
    StopTranscriptionRequest,
    _$StopTranscriptionRequest
  ];

  @override
  final String wireName = r'StopTranscriptionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopTranscriptionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.stopClosedCaptions != null) {
      yield r'stop_closed_captions';
      yield serializers.serialize(
        object.stopClosedCaptions,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StopTranscriptionRequest object, {
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
    required StopTranscriptionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stop_closed_captions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.stopClosedCaptions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StopTranscriptionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopTranscriptionRequestBuilder();
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
