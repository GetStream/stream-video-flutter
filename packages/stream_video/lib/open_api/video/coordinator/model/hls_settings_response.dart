//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'hls_settings_response.g.dart';

/// HLSSettings is the payload for HLS settings
///
/// Properties:
/// * [autoOn]
/// * [enabled]
/// * [qualityTracks]
@BuiltValue()
abstract class HLSSettingsResponse
    implements Built<HLSSettingsResponse, HLSSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'auto_on')
  bool get autoOn;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'quality_tracks')
  BuiltList<String> get qualityTracks;

  HLSSettingsResponse._();

  factory HLSSettingsResponse([void updates(HLSSettingsResponseBuilder b)]) =
      _$HLSSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HLSSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HLSSettingsResponse> get serializer =>
      _$HLSSettingsResponseSerializer();
}

class _$HLSSettingsResponseSerializer
    implements PrimitiveSerializer<HLSSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    HLSSettingsResponse,
    _$HLSSettingsResponse
  ];

  @override
  final String wireName = r'HLSSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HLSSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'auto_on';
    yield serializers.serialize(
      object.autoOn,
      specifiedType: const FullType(bool),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'quality_tracks';
    yield serializers.serialize(
      object.qualityTracks,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HLSSettingsResponse object, {
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
    required HLSSettingsResponseBuilder result,
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
  HLSSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HLSSettingsResponseBuilder();
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
