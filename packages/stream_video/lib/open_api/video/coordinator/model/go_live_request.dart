//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'go_live_request.g.dart';

/// GoLiveRequest
///
/// Properties:
/// * [recordingStorageName]
/// * [startClosedCaption]
/// * [startHls]
/// * [startRecording]
/// * [startTranscription]
/// * [transcriptionStorageName]
@BuiltValue()
abstract class GoLiveRequest
    implements Built<GoLiveRequest, GoLiveRequestBuilder> {
  @BuiltValueField(wireName: r'recording_storage_name')
  String? get recordingStorageName;

  @BuiltValueField(wireName: r'start_closed_caption')
  bool? get startClosedCaption;

  @BuiltValueField(wireName: r'start_hls')
  bool? get startHls;

  @BuiltValueField(wireName: r'start_recording')
  bool? get startRecording;

  @BuiltValueField(wireName: r'start_transcription')
  bool? get startTranscription;

  @BuiltValueField(wireName: r'transcription_storage_name')
  String? get transcriptionStorageName;

  GoLiveRequest._();

  factory GoLiveRequest([void updates(GoLiveRequestBuilder b)]) =
      _$GoLiveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoLiveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoLiveRequest> get serializer =>
      _$GoLiveRequestSerializer();
}

class _$GoLiveRequestSerializer implements PrimitiveSerializer<GoLiveRequest> {
  @override
  final Iterable<Type> types = const [GoLiveRequest, _$GoLiveRequest];

  @override
  final String wireName = r'GoLiveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoLiveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.recordingStorageName != null) {
      yield r'recording_storage_name';
      yield serializers.serialize(
        object.recordingStorageName,
        specifiedType: const FullType(String),
      );
    }
    if (object.startClosedCaption != null) {
      yield r'start_closed_caption';
      yield serializers.serialize(
        object.startClosedCaption,
        specifiedType: const FullType(bool),
      );
    }
    if (object.startHls != null) {
      yield r'start_hls';
      yield serializers.serialize(
        object.startHls,
        specifiedType: const FullType(bool),
      );
    }
    if (object.startRecording != null) {
      yield r'start_recording';
      yield serializers.serialize(
        object.startRecording,
        specifiedType: const FullType(bool),
      );
    }
    if (object.startTranscription != null) {
      yield r'start_transcription';
      yield serializers.serialize(
        object.startTranscription,
        specifiedType: const FullType(bool),
      );
    }
    if (object.transcriptionStorageName != null) {
      yield r'transcription_storage_name';
      yield serializers.serialize(
        object.transcriptionStorageName,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoLiveRequest object, {
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
    required GoLiveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recording_storage_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recordingStorageName = valueDes;
          break;
        case r'start_closed_caption':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.startClosedCaption = valueDes;
          break;
        case r'start_hls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.startHls = valueDes;
          break;
        case r'start_recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.startRecording = valueDes;
          break;
        case r'start_transcription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.startTranscription = valueDes;
          break;
        case r'transcription_storage_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.transcriptionStorageName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoLiveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoLiveRequestBuilder();
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
