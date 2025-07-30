//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_recording_request.g.dart';

/// StartRecordingRequest
///
/// Properties:
/// * [recordingExternalStorage]
@BuiltValue()
abstract class StartRecordingRequest
    implements Built<StartRecordingRequest, StartRecordingRequestBuilder> {
  @BuiltValueField(wireName: r'recording_external_storage')
  String? get recordingExternalStorage;

  StartRecordingRequest._();

  factory StartRecordingRequest(
      [void updates(StartRecordingRequestBuilder b)]) = _$StartRecordingRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartRecordingRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartRecordingRequest> get serializer =>
      _$StartRecordingRequestSerializer();
}

class _$StartRecordingRequestSerializer
    implements PrimitiveSerializer<StartRecordingRequest> {
  @override
  final Iterable<Type> types = const [
    StartRecordingRequest,
    _$StartRecordingRequest
  ];

  @override
  final String wireName = r'StartRecordingRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartRecordingRequest object, {
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
    StartRecordingRequest object, {
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
    required StartRecordingRequestBuilder result,
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
  StartRecordingRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartRecordingRequestBuilder();
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
