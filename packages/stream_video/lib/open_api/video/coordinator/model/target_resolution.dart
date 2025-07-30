//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'target_resolution.g.dart';

/// TargetResolution
///
/// Properties:
/// * [bitrate]
/// * [height]
/// * [width]
@BuiltValue()
abstract class TargetResolution
    implements Built<TargetResolution, TargetResolutionBuilder> {
  @BuiltValueField(wireName: r'bitrate')
  int? get bitrate;

  @BuiltValueField(wireName: r'height')
  int get height;

  @BuiltValueField(wireName: r'width')
  int get width;

  TargetResolution._();

  factory TargetResolution([void updates(TargetResolutionBuilder b)]) =
      _$TargetResolution;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TargetResolutionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TargetResolution> get serializer =>
      _$TargetResolutionSerializer();
}

class _$TargetResolutionSerializer
    implements PrimitiveSerializer<TargetResolution> {
  @override
  final Iterable<Type> types = const [TargetResolution, _$TargetResolution];

  @override
  final String wireName = r'TargetResolution';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TargetResolution object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.bitrate != null) {
      yield r'bitrate';
      yield serializers.serialize(
        object.bitrate,
        specifiedType: const FullType(int),
      );
    }
    yield r'height';
    yield serializers.serialize(
      object.height,
      specifiedType: const FullType(int),
    );
    yield r'width';
    yield serializers.serialize(
      object.width,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TargetResolution object, {
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
    required TargetResolutionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bitrate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bitrate = valueDes;
          break;
        case r'height':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.height = valueDes;
          break;
        case r'width':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.width = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TargetResolution deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TargetResolutionBuilder();
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
