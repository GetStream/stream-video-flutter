//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'thumbnail_response.g.dart';

/// ThumbnailResponse
///
/// Properties:
/// * [imageUrl]
@BuiltValue()
abstract class ThumbnailResponse
    implements Built<ThumbnailResponse, ThumbnailResponseBuilder> {
  @BuiltValueField(wireName: r'image_url')
  String get imageUrl;

  ThumbnailResponse._();

  factory ThumbnailResponse([void updates(ThumbnailResponseBuilder b)]) =
      _$ThumbnailResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ThumbnailResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ThumbnailResponse> get serializer =>
      _$ThumbnailResponseSerializer();
}

class _$ThumbnailResponseSerializer
    implements PrimitiveSerializer<ThumbnailResponse> {
  @override
  final Iterable<Type> types = const [ThumbnailResponse, _$ThumbnailResponse];

  @override
  final String wireName = r'ThumbnailResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ThumbnailResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'image_url';
    yield serializers.serialize(
      object.imageUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ThumbnailResponse object, {
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
    required ThumbnailResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imageUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ThumbnailResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ThumbnailResponseBuilder();
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
