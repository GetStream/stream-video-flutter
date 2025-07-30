//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'thumbnails_settings_request.g.dart';

/// ThumbnailsSettingsRequest
///
/// Properties:
/// * [enabled]
@BuiltValue()
abstract class ThumbnailsSettingsRequest
    implements
        Built<ThumbnailsSettingsRequest, ThumbnailsSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  ThumbnailsSettingsRequest._();

  factory ThumbnailsSettingsRequest(
          [void updates(ThumbnailsSettingsRequestBuilder b)]) =
      _$ThumbnailsSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ThumbnailsSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ThumbnailsSettingsRequest> get serializer =>
      _$ThumbnailsSettingsRequestSerializer();
}

class _$ThumbnailsSettingsRequestSerializer
    implements PrimitiveSerializer<ThumbnailsSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    ThumbnailsSettingsRequest,
    _$ThumbnailsSettingsRequest
  ];

  @override
  final String wireName = r'ThumbnailsSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ThumbnailsSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ThumbnailsSettingsRequest object, {
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
    required ThumbnailsSettingsRequestBuilder result,
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
  ThumbnailsSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ThumbnailsSettingsRequestBuilder();
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
