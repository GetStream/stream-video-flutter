//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'read_receipts.g.dart';

/// ReadReceipts
///
/// Properties:
/// * [enabled]
@BuiltValue()
abstract class ReadReceipts
    implements Built<ReadReceipts, ReadReceiptsBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  ReadReceipts._();

  factory ReadReceipts([void updates(ReadReceiptsBuilder b)]) = _$ReadReceipts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadReceiptsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadReceipts> get serializer => _$ReadReceiptsSerializer();
}

class _$ReadReceiptsSerializer implements PrimitiveSerializer<ReadReceipts> {
  @override
  final Iterable<Type> types = const [ReadReceipts, _$ReadReceipts];

  @override
  final String wireName = r'ReadReceipts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadReceipts object, {
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
    ReadReceipts object, {
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
    required ReadReceiptsBuilder result,
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
  ReadReceipts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadReceiptsBuilder();
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
