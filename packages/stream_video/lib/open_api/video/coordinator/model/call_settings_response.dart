//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/broadcast_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/session_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/transcription_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/audio_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/geofence_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/record_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/video_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/limits_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/backstage_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/screensharing_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/thumbnails_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/ring_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/frame_recording_settings_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_settings_response.g.dart';

/// CallSettingsResponse
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
abstract class CallSettingsResponse
    implements Built<CallSettingsResponse, CallSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'audio')
  AudioSettingsResponse get audio;

  @BuiltValueField(wireName: r'backstage')
  BackstageSettingsResponse get backstage;

  @BuiltValueField(wireName: r'broadcasting')
  BroadcastSettingsResponse get broadcasting;

  @BuiltValueField(wireName: r'frame_recording')
  FrameRecordingSettingsResponse get frameRecording;

  @BuiltValueField(wireName: r'geofencing')
  GeofenceSettingsResponse get geofencing;

  @BuiltValueField(wireName: r'limits')
  LimitsSettingsResponse get limits;

  @BuiltValueField(wireName: r'recording')
  RecordSettingsResponse get recording;

  @BuiltValueField(wireName: r'ring')
  RingSettingsResponse get ring;

  @BuiltValueField(wireName: r'screensharing')
  ScreensharingSettingsResponse get screensharing;

  @BuiltValueField(wireName: r'session')
  SessionSettingsResponse get session;

  @BuiltValueField(wireName: r'thumbnails')
  ThumbnailsSettingsResponse get thumbnails;

  @BuiltValueField(wireName: r'transcription')
  TranscriptionSettingsResponse get transcription;

  @BuiltValueField(wireName: r'video')
  VideoSettingsResponse get video;

  CallSettingsResponse._();

  factory CallSettingsResponse([void updates(CallSettingsResponseBuilder b)]) =
      _$CallSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallSettingsResponse> get serializer =>
      _$CallSettingsResponseSerializer();
}

class _$CallSettingsResponseSerializer
    implements PrimitiveSerializer<CallSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    CallSettingsResponse,
    _$CallSettingsResponse
  ];

  @override
  final String wireName = r'CallSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audio';
    yield serializers.serialize(
      object.audio,
      specifiedType: const FullType(AudioSettingsResponse),
    );
    yield r'backstage';
    yield serializers.serialize(
      object.backstage,
      specifiedType: const FullType(BackstageSettingsResponse),
    );
    yield r'broadcasting';
    yield serializers.serialize(
      object.broadcasting,
      specifiedType: const FullType(BroadcastSettingsResponse),
    );
    yield r'frame_recording';
    yield serializers.serialize(
      object.frameRecording,
      specifiedType: const FullType(FrameRecordingSettingsResponse),
    );
    yield r'geofencing';
    yield serializers.serialize(
      object.geofencing,
      specifiedType: const FullType(GeofenceSettingsResponse),
    );
    yield r'limits';
    yield serializers.serialize(
      object.limits,
      specifiedType: const FullType(LimitsSettingsResponse),
    );
    yield r'recording';
    yield serializers.serialize(
      object.recording,
      specifiedType: const FullType(RecordSettingsResponse),
    );
    yield r'ring';
    yield serializers.serialize(
      object.ring,
      specifiedType: const FullType(RingSettingsResponse),
    );
    yield r'screensharing';
    yield serializers.serialize(
      object.screensharing,
      specifiedType: const FullType(ScreensharingSettingsResponse),
    );
    yield r'session';
    yield serializers.serialize(
      object.session,
      specifiedType: const FullType(SessionSettingsResponse),
    );
    yield r'thumbnails';
    yield serializers.serialize(
      object.thumbnails,
      specifiedType: const FullType(ThumbnailsSettingsResponse),
    );
    yield r'transcription';
    yield serializers.serialize(
      object.transcription,
      specifiedType: const FullType(TranscriptionSettingsResponse),
    );
    yield r'video';
    yield serializers.serialize(
      object.video,
      specifiedType: const FullType(VideoSettingsResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallSettingsResponse object, {
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
    required CallSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AudioSettingsResponse),
          ) as AudioSettingsResponse;
          result.audio.replace(valueDes);
          break;
        case r'backstage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BackstageSettingsResponse),
          ) as BackstageSettingsResponse;
          result.backstage.replace(valueDes);
          break;
        case r'broadcasting':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BroadcastSettingsResponse),
          ) as BroadcastSettingsResponse;
          result.broadcasting.replace(valueDes);
          break;
        case r'frame_recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FrameRecordingSettingsResponse),
          ) as FrameRecordingSettingsResponse;
          result.frameRecording.replace(valueDes);
          break;
        case r'geofencing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeofenceSettingsResponse),
          ) as GeofenceSettingsResponse;
          result.geofencing.replace(valueDes);
          break;
        case r'limits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LimitsSettingsResponse),
          ) as LimitsSettingsResponse;
          result.limits.replace(valueDes);
          break;
        case r'recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RecordSettingsResponse),
          ) as RecordSettingsResponse;
          result.recording.replace(valueDes);
          break;
        case r'ring':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RingSettingsResponse),
          ) as RingSettingsResponse;
          result.ring.replace(valueDes);
          break;
        case r'screensharing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScreensharingSettingsResponse),
          ) as ScreensharingSettingsResponse;
          result.screensharing.replace(valueDes);
          break;
        case r'session':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SessionSettingsResponse),
          ) as SessionSettingsResponse;
          result.session.replace(valueDes);
          break;
        case r'thumbnails':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ThumbnailsSettingsResponse),
          ) as ThumbnailsSettingsResponse;
          result.thumbnails.replace(valueDes);
          break;
        case r'transcription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TranscriptionSettingsResponse),
          ) as TranscriptionSettingsResponse;
          result.transcription.replace(valueDes);
          break;
        case r'video':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VideoSettingsResponse),
          ) as VideoSettingsResponse;
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
  CallSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallSettingsResponseBuilder();
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
