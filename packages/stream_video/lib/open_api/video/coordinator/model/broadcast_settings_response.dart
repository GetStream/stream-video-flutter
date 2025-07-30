//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/rtmp_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/hls_settings_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'broadcast_settings_response.g.dart';

/// BroadcastSettingsResponse is the payload for broadcasting settings
///
/// Properties:
/// * [enabled]
/// * [hls]
/// * [rtmp]
@BuiltValue()
abstract class BroadcastSettingsResponse
    implements
        Built<BroadcastSettingsResponse, BroadcastSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'hls')
  HLSSettingsResponse get hls;

  @BuiltValueField(wireName: r'rtmp')
  RTMPSettingsResponse get rtmp;

  BroadcastSettingsResponse._();

  factory BroadcastSettingsResponse(
          [void updates(BroadcastSettingsResponseBuilder b)]) =
      _$BroadcastSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BroadcastSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BroadcastSettingsResponse> get serializer =>
      _$BroadcastSettingsResponseSerializer();
}

class _$BroadcastSettingsResponseSerializer
    implements PrimitiveSerializer<BroadcastSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    BroadcastSettingsResponse,
    _$BroadcastSettingsResponse
  ];

  @override
  final String wireName = r'BroadcastSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BroadcastSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'hls';
    yield serializers.serialize(
      object.hls,
      specifiedType: const FullType(HLSSettingsResponse),
    );
    yield r'rtmp';
    yield serializers.serialize(
      object.rtmp,
      specifiedType: const FullType(RTMPSettingsResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BroadcastSettingsResponse object, {
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
    required BroadcastSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'hls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HLSSettingsResponse),
          ) as HLSSettingsResponse;
          result.hls.replace(valueDes);
          break;
        case r'rtmp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RTMPSettingsResponse),
          ) as RTMPSettingsResponse;
          result.rtmp.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BroadcastSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BroadcastSettingsResponseBuilder();
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
