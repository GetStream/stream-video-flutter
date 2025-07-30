//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/target_resolution.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_settings_request.g.dart';

/// VideoSettingsRequest
///
/// Properties:
/// * [accessRequestEnabled]
/// * [cameraDefaultOn]
/// * [cameraFacing]
/// * [enabled]
/// * [targetResolution]
@BuiltValue()
abstract class VideoSettingsRequest
    implements Built<VideoSettingsRequest, VideoSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'access_request_enabled')
  bool? get accessRequestEnabled;

  @BuiltValueField(wireName: r'camera_default_on')
  bool? get cameraDefaultOn;

  @BuiltValueField(wireName: r'camera_facing')
  VideoSettingsRequestCameraFacingEnum? get cameraFacing;
  // enum cameraFacingEnum {  front,  back,  external,  };

  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  @BuiltValueField(wireName: r'target_resolution')
  TargetResolution? get targetResolution;

  VideoSettingsRequest._();

  factory VideoSettingsRequest([void updates(VideoSettingsRequestBuilder b)]) =
      _$VideoSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoSettingsRequest> get serializer =>
      _$VideoSettingsRequestSerializer();
}

class _$VideoSettingsRequestSerializer
    implements PrimitiveSerializer<VideoSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    VideoSettingsRequest,
    _$VideoSettingsRequest
  ];

  @override
  final String wireName = r'VideoSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.accessRequestEnabled != null) {
      yield r'access_request_enabled';
      yield serializers.serialize(
        object.accessRequestEnabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.cameraDefaultOn != null) {
      yield r'camera_default_on';
      yield serializers.serialize(
        object.cameraDefaultOn,
        specifiedType: const FullType(bool),
      );
    }
    if (object.cameraFacing != null) {
      yield r'camera_facing';
      yield serializers.serialize(
        object.cameraFacing,
        specifiedType: const FullType(VideoSettingsRequestCameraFacingEnum),
      );
    }
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.targetResolution != null) {
      yield r'target_resolution';
      yield serializers.serialize(
        object.targetResolution,
        specifiedType: const FullType(TargetResolution),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoSettingsRequest object, {
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
    required VideoSettingsRequestBuilder result,
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
            specifiedType: const FullType(VideoSettingsRequestCameraFacingEnum),
          ) as VideoSettingsRequestCameraFacingEnum;
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
  VideoSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoSettingsRequestBuilder();
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

class VideoSettingsRequestCameraFacingEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'front')
  static const VideoSettingsRequestCameraFacingEnum front =
      _$videoSettingsRequestCameraFacingEnum_front;
  @BuiltValueEnumConst(wireName: r'back')
  static const VideoSettingsRequestCameraFacingEnum back =
      _$videoSettingsRequestCameraFacingEnum_back;
  @BuiltValueEnumConst(wireName: r'external')
  static const VideoSettingsRequestCameraFacingEnum external_ =
      _$videoSettingsRequestCameraFacingEnum_external_;

  static Serializer<VideoSettingsRequestCameraFacingEnum> get serializer =>
      _$videoSettingsRequestCameraFacingEnumSerializer;

  const VideoSettingsRequestCameraFacingEnum._(String name) : super(name);

  static BuiltSet<VideoSettingsRequestCameraFacingEnum> get values =>
      _$videoSettingsRequestCameraFacingEnumValues;
  static VideoSettingsRequestCameraFacingEnum valueOf(String name) =>
      _$videoSettingsRequestCameraFacingEnumValueOf(name);
}
