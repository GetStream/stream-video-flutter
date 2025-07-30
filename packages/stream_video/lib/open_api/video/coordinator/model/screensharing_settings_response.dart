//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/target_resolution.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'screensharing_settings_response.g.dart';

/// ScreensharingSettingsResponse
///
/// Properties:
/// * [accessRequestEnabled]
/// * [enabled]
/// * [targetResolution]
@BuiltValue()
abstract class ScreensharingSettingsResponse
    implements
        Built<ScreensharingSettingsResponse,
            ScreensharingSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'access_request_enabled')
  bool get accessRequestEnabled;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'target_resolution')
  TargetResolution? get targetResolution;

  ScreensharingSettingsResponse._();

  factory ScreensharingSettingsResponse(
          [void updates(ScreensharingSettingsResponseBuilder b)]) =
      _$ScreensharingSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScreensharingSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScreensharingSettingsResponse> get serializer =>
      _$ScreensharingSettingsResponseSerializer();
}

class _$ScreensharingSettingsResponseSerializer
    implements PrimitiveSerializer<ScreensharingSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    ScreensharingSettingsResponse,
    _$ScreensharingSettingsResponse
  ];

  @override
  final String wireName = r'ScreensharingSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScreensharingSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'access_request_enabled';
    yield serializers.serialize(
      object.accessRequestEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
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
    ScreensharingSettingsResponse object, {
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
    required ScreensharingSettingsResponseBuilder result,
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
  ScreensharingSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScreensharingSettingsResponseBuilder();
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
