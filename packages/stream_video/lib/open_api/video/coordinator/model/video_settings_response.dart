//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/target_resolution.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_settings_response.g.dart';

/// VideoSettingsResponse
///
/// Properties:
/// * [accessRequestEnabled]
/// * [cameraDefaultOn]
/// * [cameraFacing]
/// * [enabled]
/// * [targetResolution]
@BuiltValue()
abstract class VideoSettingsResponse
    implements Built<VideoSettingsResponse, VideoSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'access_request_enabled')
  bool get accessRequestEnabled;

  @BuiltValueField(wireName: r'camera_default_on')
  bool get cameraDefaultOn;

  @BuiltValueField(wireName: r'camera_facing')
  VideoSettingsResponseCameraFacingEnum get cameraFacing;
  // enum cameraFacingEnum {  front,  back,  external,  };

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'target_resolution')
  TargetResolution get targetResolution;

  VideoSettingsResponse._();

  factory VideoSettingsResponse(
      [void updates(VideoSettingsResponseBuilder b)]) = _$VideoSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoSettingsResponse> get serializer =>
      _$VideoSettingsResponseSerializer();
}

class _$VideoSettingsResponseSerializer
    implements PrimitiveSerializer<VideoSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    VideoSettingsResponse,
    _$VideoSettingsResponse
  ];

  @override
  final String wireName = r'VideoSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'access_request_enabled';
    yield serializers.serialize(
      object.accessRequestEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'camera_default_on';
    yield serializers.serialize(
      object.cameraDefaultOn,
      specifiedType: const FullType(bool),
    );
    yield r'camera_facing';
    yield serializers.serialize(
      object.cameraFacing,
      specifiedType: const FullType(VideoSettingsResponseCameraFacingEnum),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'target_resolution';
    yield serializers.serialize(
      object.targetResolution,
      specifiedType: const FullType(TargetResolution),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoSettingsResponse object, {
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
    required VideoSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'access_request_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accessRequestEnabled = valueDes;
          break;
        case r'camera_default_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cameraDefaultOn = valueDes;
          break;
        case r'camera_facing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(VideoSettingsResponseCameraFacingEnum),
          ) as VideoSettingsResponseCameraFacingEnum;
          result.cameraFacing = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'target_resolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TargetResolution),
          ) as TargetResolution;
          result.targetResolution.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VideoSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoSettingsResponseBuilder();
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

class VideoSettingsResponseCameraFacingEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'front')
  static const VideoSettingsResponseCameraFacingEnum front =
      _$videoSettingsResponseCameraFacingEnum_front;
  @BuiltValueEnumConst(wireName: r'back')
  static const VideoSettingsResponseCameraFacingEnum back =
      _$videoSettingsResponseCameraFacingEnum_back;
  @BuiltValueEnumConst(wireName: r'external')
  static const VideoSettingsResponseCameraFacingEnum external_ =
      _$videoSettingsResponseCameraFacingEnum_external_;

  static Serializer<VideoSettingsResponseCameraFacingEnum> get serializer =>
      _$videoSettingsResponseCameraFacingEnumSerializer;

  const VideoSettingsResponseCameraFacingEnum._(String name) : super(name);

  static BuiltSet<VideoSettingsResponseCameraFacingEnum> get values =>
      _$videoSettingsResponseCameraFacingEnumValues;
  static VideoSettingsResponseCameraFacingEnum valueOf(String name) =>
      _$videoSettingsResponseCameraFacingEnumValueOf(name);
}
