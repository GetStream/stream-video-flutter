//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_live_request.g.dart';

/// StopLiveRequest
///
/// Properties:
/// * [continueClosedCaption]
/// * [continueHls]
/// * [continueRecording]
/// * [continueRtmpBroadcasts]
/// * [continueTranscription]
@BuiltValue()
abstract class StopLiveRequest
    implements Built<StopLiveRequest, StopLiveRequestBuilder> {
  @BuiltValueField(wireName: r'continue_closed_caption')
  bool? get continueClosedCaption;

  @BuiltValueField(wireName: r'continue_hls')
  bool? get continueHls;

  @BuiltValueField(wireName: r'continue_recording')
  bool? get continueRecording;

  @BuiltValueField(wireName: r'continue_rtmp_broadcasts')
  bool? get continueRtmpBroadcasts;

  @BuiltValueField(wireName: r'continue_transcription')
  bool? get continueTranscription;

  StopLiveRequest._();

  factory StopLiveRequest([void updates(StopLiveRequestBuilder b)]) =
      _$StopLiveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopLiveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopLiveRequest> get serializer =>
      _$StopLiveRequestSerializer();
}

class _$StopLiveRequestSerializer
    implements PrimitiveSerializer<StopLiveRequest> {
  @override
  final Iterable<Type> types = const [StopLiveRequest, _$StopLiveRequest];

  @override
  final String wireName = r'StopLiveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopLiveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.continueClosedCaption != null) {
      yield r'continue_closed_caption';
      yield serializers.serialize(
        object.continueClosedCaption,
        specifiedType: const FullType(bool),
      );
    }
    if (object.continueHls != null) {
      yield r'continue_hls';
      yield serializers.serialize(
        object.continueHls,
        specifiedType: const FullType(bool),
      );
    }
    if (object.continueRecording != null) {
      yield r'continue_recording';
      yield serializers.serialize(
        object.continueRecording,
        specifiedType: const FullType(bool),
      );
    }
    if (object.continueRtmpBroadcasts != null) {
      yield r'continue_rtmp_broadcasts';
      yield serializers.serialize(
        object.continueRtmpBroadcasts,
        specifiedType: const FullType(bool),
      );
    }
    if (object.continueTranscription != null) {
      yield r'continue_transcription';
      yield serializers.serialize(
        object.continueTranscription,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StopLiveRequest object, {
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
    required StopLiveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'continue_closed_caption':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.continueClosedCaption = valueDes;
          break;
        case r'continue_hls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.continueHls = valueDes;
          break;
        case r'continue_recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.continueRecording = valueDes;
          break;
        case r'continue_rtmp_broadcasts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.continueRtmpBroadcasts = valueDes;
          break;
        case r'continue_transcription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.continueTranscription = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StopLiveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopLiveRequestBuilder();
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
