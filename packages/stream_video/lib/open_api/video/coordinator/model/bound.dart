//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bound.g.dart';

/// Bound
///
/// Properties:
/// * [inclusive]
/// * [value]
@BuiltValue()
abstract class Bound implements Built<Bound, BoundBuilder> {
  @BuiltValueField(wireName: r'inclusive')
  bool get inclusive;

  @BuiltValueField(wireName: r'value')
  double get value;

  Bound._();

  factory Bound([void updates(BoundBuilder b)]) = _$Bound;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BoundBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Bound> get serializer => _$BoundSerializer();
}

class _$BoundSerializer implements PrimitiveSerializer<Bound> {
  @override
  final Iterable<Type> types = const [Bound, _$Bound];

  @override
  final String wireName = r'Bound';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Bound object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inclusive';
    yield serializers.serialize(
      object.inclusive,
      specifiedType: const FullType(bool),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Bound object, {
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
    required BoundBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inclusive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inclusive = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Bound deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BoundBuilder();
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
