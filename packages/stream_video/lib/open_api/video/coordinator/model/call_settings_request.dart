//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/record_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/audio_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/limits_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/session_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/screensharing_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/video_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/broadcast_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/geofence_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/backstage_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/frame_recording_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/ring_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/thumbnails_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/transcription_settings_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_settings_request.g.dart';

/// CallSettingsRequest
///
/// Properties:
/// * [audio]
/// * [backstage]
/// * [broadcasting]
/// * [frameRecording]
/// * [geofencing]
/// * [limits]
/// * [recording]
/// * [ring]
/// * [screensharing]
/// * [session]
/// * [thumbnails]
/// * [transcription]
/// * [video]
@BuiltValue()
abstract class CallSettingsRequest
    implements Built<CallSettingsRequest, CallSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'audio')
  AudioSettingsRequest? get audio;

  @BuiltValueField(wireName: r'backstage')
  BackstageSettingsRequest? get backstage;

  @BuiltValueField(wireName: r'broadcasting')
  BroadcastSettingsRequest? get broadcasting;

  @BuiltValueField(wireName: r'frame_recording')
  FrameRecordingSettingsRequest? get frameRecording;

  @BuiltValueField(wireName: r'geofencing')
  GeofenceSettingsRequest? get geofencing;

  @BuiltValueField(wireName: r'limits')
  LimitsSettingsRequest? get limits;

  @BuiltValueField(wireName: r'recording')
  RecordSettingsRequest? get recording;

  @BuiltValueField(wireName: r'ring')
  RingSettingsRequest? get ring;

  @BuiltValueField(wireName: r'screensharing')
  ScreensharingSettingsRequest? get screensharing;

  @BuiltValueField(wireName: r'session')
  SessionSettingsRequest? get session;

  @BuiltValueField(wireName: r'thumbnails')
  ThumbnailsSettingsRequest? get thumbnails;

  @BuiltValueField(wireName: r'transcription')
  TranscriptionSettingsRequest? get transcription;

  @BuiltValueField(wireName: r'video')
  VideoSettingsRequest? get video;

  CallSettingsRequest._();

  factory CallSettingsRequest([void updates(CallSettingsRequestBuilder b)]) =
      _$CallSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallSettingsRequest> get serializer =>
      _$CallSettingsRequestSerializer();
}

class _$CallSettingsRequestSerializer
    implements PrimitiveSerializer<CallSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    CallSettingsRequest,
    _$CallSettingsRequest
  ];

  @override
  final String wireName = r'CallSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.audio != null) {
      yield r'audio';
      yield serializers.serialize(
        object.audio,
        specifiedType: const FullType(AudioSettingsRequest),
      );
    }
    if (object.backstage != null) {
      yield r'backstage';
      yield serializers.serialize(
        object.backstage,
        specifiedType: const FullType(BackstageSettingsRequest),
      );
    }
    if (object.broadcasting != null) {
      yield r'broadcasting';
      yield serializers.serialize(
        object.broadcasting,
        specifiedType: const FullType(BroadcastSettingsRequest),
      );
    }
    if (object.frameRecording != null) {
      yield r'frame_recording';
      yield serializers.serialize(
        object.frameRecording,
        specifiedType: const FullType(FrameRecordingSettingsRequest),
      );
    }
    if (object.geofencing != null) {
      yield r'geofencing';
      yield serializers.serialize(
        object.geofencing,
        specifiedType: const FullType(GeofenceSettingsRequest),
      );
    }
    if (object.limits != null) {
      yield r'limits';
      yield serializers.serialize(
        object.limits,
        specifiedType: const FullType(LimitsSettingsRequest),
      );
    }
    if (object.recording != null) {
      yield r'recording';
      yield serializers.serialize(
        object.recording,
        specifiedType: const FullType(RecordSettingsRequest),
      );
    }
    if (object.ring != null) {
      yield r'ring';
      yield serializers.serialize(
        object.ring,
        specifiedType: const FullType(RingSettingsRequest),
      );
    }
    if (object.screensharing != null) {
      yield r'screensharing';
      yield serializers.serialize(
        object.screensharing,
        specifiedType: const FullType(ScreensharingSettingsRequest),
      );
    }
    if (object.session != null) {
      yield r'session';
      yield serializers.serialize(
        object.session,
        specifiedType: const FullType(SessionSettingsRequest),
      );
    }
    if (object.thumbnails != null) {
      yield r'thumbnails';
      yield serializers.serialize(
        object.thumbnails,
        specifiedType: const FullType(ThumbnailsSettingsRequest),
      );
    }
    if (object.transcription != null) {
      yield r'transcription';
      yield serializers.serialize(
        object.transcription,
        specifiedType: const FullType(TranscriptionSettingsRequest),
      );
    }
    if (object.video != null) {
      yield r'video';
      yield serializers.serialize(
        object.video,
        specifiedType: const FullType(VideoSettingsRequest),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CallSettingsRequest object, {
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
    required CallSettingsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AudioSettingsRequest),
          ) as AudioSettingsRequest;
          result.audio.replace(valueDes);
          break;
        case r'backstage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BackstageSettingsRequest),
          ) as BackstageSettingsRequest;
          result.backstage.replace(valueDes);
          break;
        case r'broadcasting':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BroadcastSettingsRequest),
          ) as BroadcastSettingsRequest;
          result.broadcasting.replace(valueDes);
          break;
        case r'frame_recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FrameRecordingSettingsRequest),
          ) as FrameRecordingSettingsRequest;
          result.frameRecording.replace(valueDes);
          break;
        case r'geofencing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeofenceSettingsRequest),
          ) as GeofenceSettingsRequest;
          result.geofencing.replace(valueDes);
          break;
        case r'limits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LimitsSettingsRequest),
          ) as LimitsSettingsRequest;
          result.limits.replace(valueDes);
          break;
        case r'recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RecordSettingsRequest),
          ) as RecordSettingsRequest;
          result.recording.replace(valueDes);
          break;
        case r'ring':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RingSettingsRequest),
          ) as RingSettingsRequest;
          result.ring.replace(valueDes);
          break;
        case r'screensharing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScreensharingSettingsRequest),
          ) as ScreensharingSettingsRequest;
          result.screensharing.replace(valueDes);
          break;
        case r'session':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SessionSettingsRequest),
          ) as SessionSettingsRequest;
          result.session.replace(valueDes);
          break;
        case r'thumbnails':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ThumbnailsSettingsRequest),
          ) as ThumbnailsSettingsRequest;
          result.thumbnails.replace(valueDes);
          break;
        case r'transcription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TranscriptionSettingsRequest),
          ) as TranscriptionSettingsRequest;
          result.transcription.replace(valueDes);
          break;
        case r'video':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VideoSettingsRequest),
          ) as VideoSettingsRequest;
          result.video.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallSettingsRequestBuilder();
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
