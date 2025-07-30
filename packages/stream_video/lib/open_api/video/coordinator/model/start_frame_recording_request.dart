//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_frame_recording_request.g.dart';

/// StartFrameRecordingRequest
///
/// Properties:
/// * [recordingExternalStorage]
@BuiltValue()
abstract class StartFrameRecordingRequest
    implements
        Built<StartFrameRecordingRequest, StartFrameRecordingRequestBuilder> {
  @BuiltValueField(wireName: r'recording_external_storage')
  String? get recordingExternalStorage;

  StartFrameRecordingRequest._();

  factory StartFrameRecordingRequest(
          [void updates(StartFrameRecordingRequestBuilder b)]) =
      _$StartFrameRecordingRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartFrameRecordingRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartFrameRecordingRequest> get serializer =>
      _$StartFrameRecordingRequestSerializer();
}

class _$StartFrameRecordingRequestSerializer
    implements PrimitiveSerializer<StartFrameRecordingRequest> {
  @override
  final Iterable<Type> types = const [
    StartFrameRecordingRequest,
    _$StartFrameRecordingRequest
  ];

  @override
  final String wireName = r'StartFrameRecordingRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartFrameRecordingRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.recordingExternalStorage != null) {
      yield r'recording_external_storage';
      yield serializers.serialize(
        object.recordingExternalStorage,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StartFrameRecordingRequest object, {
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
    required StartFrameRecordingRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recording_external_storage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recordingExternalStorage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StartFrameRecordingRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartFrameRecordingRequestBuilder();
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
