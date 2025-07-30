//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'grouped_stats_response.g.dart';

/// GroupedStatsResponse
///
/// Properties:
/// * [name]
/// * [unique]
@BuiltValue()
abstract class GroupedStatsResponse
    implements Built<GroupedStatsResponse, GroupedStatsResponseBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'unique')
  int get unique;

  GroupedStatsResponse._();

  factory GroupedStatsResponse([void updates(GroupedStatsResponseBuilder b)]) =
      _$GroupedStatsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupedStatsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupedStatsResponse> get serializer =>
      _$GroupedStatsResponseSerializer();
}

class _$GroupedStatsResponseSerializer
    implements PrimitiveSerializer<GroupedStatsResponse> {
  @override
  final Iterable<Type> types = const [
    GroupedStatsResponse,
    _$GroupedStatsResponse
  ];

  @override
  final String wireName = r'GroupedStatsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupedStatsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'unique';
    yield serializers.serialize(
      object.unique,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupedStatsResponse object, {
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
    required GroupedStatsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'unique':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unique = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupedStatsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupedStatsResponseBuilder();
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
