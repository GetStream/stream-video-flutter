//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'thumbnails_settings_response.g.dart';

/// ThumbnailsSettingsResponse
///
/// Properties:
/// * [enabled]
@BuiltValue()
abstract class ThumbnailsSettingsResponse
    implements
        Built<ThumbnailsSettingsResponse, ThumbnailsSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  ThumbnailsSettingsResponse._();

  factory ThumbnailsSettingsResponse(
          [void updates(ThumbnailsSettingsResponseBuilder b)]) =
      _$ThumbnailsSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ThumbnailsSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ThumbnailsSettingsResponse> get serializer =>
      _$ThumbnailsSettingsResponseSerializer();
}

class _$ThumbnailsSettingsResponseSerializer
    implements PrimitiveSerializer<ThumbnailsSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    ThumbnailsSettingsResponse,
    _$ThumbnailsSettingsResponse
  ];

  @override
  final String wireName = r'ThumbnailsSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ThumbnailsSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ThumbnailsSettingsResponse object, {
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
    required ThumbnailsSettingsResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ThumbnailsSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ThumbnailsSettingsResponseBuilder();
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
