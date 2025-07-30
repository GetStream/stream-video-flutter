//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'typing_indicators.g.dart';

/// TypingIndicators
///
/// Properties:
/// * [enabled]
@BuiltValue()
abstract class TypingIndicators
    implements Built<TypingIndicators, TypingIndicatorsBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  TypingIndicators._();

  factory TypingIndicators([void updates(TypingIndicatorsBuilder b)]) =
      _$TypingIndicators;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TypingIndicatorsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TypingIndicators> get serializer =>
      _$TypingIndicatorsSerializer();
}

class _$TypingIndicatorsSerializer
    implements PrimitiveSerializer<TypingIndicators> {
  @override
  final Iterable<Type> types = const [TypingIndicators, _$TypingIndicators];

  @override
  final String wireName = r'TypingIndicators';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TypingIndicators object, {
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
    TypingIndicators object, {
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
    required TypingIndicatorsBuilder result,
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
  TypingIndicators deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TypingIndicatorsBuilder();
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
