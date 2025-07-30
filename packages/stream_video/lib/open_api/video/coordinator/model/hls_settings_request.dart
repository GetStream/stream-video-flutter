//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'hls_settings_request.g.dart';

/// HLSSettingsRequest
///
/// Properties:
/// * [autoOn]
/// * [enabled]
/// * [qualityTracks]
@BuiltValue()
abstract class HLSSettingsRequest
    implements Built<HLSSettingsRequest, HLSSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'auto_on')
  bool? get autoOn;

  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  @BuiltValueField(wireName: r'quality_tracks')
  BuiltList<String> get qualityTracks;

  HLSSettingsRequest._();

  factory HLSSettingsRequest([void updates(HLSSettingsRequestBuilder b)]) =
      _$HLSSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HLSSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HLSSettingsRequest> get serializer =>
      _$HLSSettingsRequestSerializer();
}

class _$HLSSettingsRequestSerializer
    implements PrimitiveSerializer<HLSSettingsRequest> {
  @override
  final Iterable<Type> types = const [HLSSettingsRequest, _$HLSSettingsRequest];

  @override
  final String wireName = r'HLSSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HLSSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.autoOn != null) {
      yield r'auto_on';
      yield serializers.serialize(
        object.autoOn,
        specifiedType: const FullType(bool),
      );
    }
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    yield r'quality_tracks';
    yield serializers.serialize(
      object.qualityTracks,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HLSSettingsRequest object, {
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
    required HLSSettingsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'auto_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.autoOn = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'quality_tracks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.qualityTracks.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HLSSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HLSSettingsRequestBuilder();
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
