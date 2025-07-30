//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/rtmp_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/hls_settings_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'broadcast_settings_request.g.dart';

/// BroadcastSettingsRequest
///
/// Properties:
/// * [enabled]
/// * [hls]
/// * [rtmp]
@BuiltValue()
abstract class BroadcastSettingsRequest
    implements
        Built<BroadcastSettingsRequest, BroadcastSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  @BuiltValueField(wireName: r'hls')
  HLSSettingsRequest? get hls;

  @BuiltValueField(wireName: r'rtmp')
  RTMPSettingsRequest? get rtmp;

  BroadcastSettingsRequest._();

  factory BroadcastSettingsRequest(
          [void updates(BroadcastSettingsRequestBuilder b)]) =
      _$BroadcastSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BroadcastSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BroadcastSettingsRequest> get serializer =>
      _$BroadcastSettingsRequestSerializer();
}

class _$BroadcastSettingsRequestSerializer
    implements PrimitiveSerializer<BroadcastSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    BroadcastSettingsRequest,
    _$BroadcastSettingsRequest
  ];

  @override
  final String wireName = r'BroadcastSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BroadcastSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.hls != null) {
      yield r'hls';
      yield serializers.serialize(
        object.hls,
        specifiedType: const FullType(HLSSettingsRequest),
      );
    }
    if (object.rtmp != null) {
      yield r'rtmp';
      yield serializers.serialize(
        object.rtmp,
        specifiedType: const FullType(RTMPSettingsRequest),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BroadcastSettingsRequest object, {
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
    required BroadcastSettingsRequestBuilder result,
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
            specifiedType: const FullType(HLSSettingsRequest),
          ) as HLSSettingsRequest;
          result.hls.replace(valueDes);
          break;
        case r'rtmp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RTMPSettingsRequest),
          ) as RTMPSettingsRequest;
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
  BroadcastSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BroadcastSettingsRequestBuilder();
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
