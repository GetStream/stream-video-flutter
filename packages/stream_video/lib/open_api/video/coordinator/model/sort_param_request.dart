//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sort_param_request.g.dart';

/// SortParamRequest
///
/// Properties:
/// * [direction] - Direction of sorting, 1 for Ascending, -1 for Descending, default is 1
/// * [field] - Name of field to sort by
@BuiltValue()
abstract class SortParamRequest
    implements Built<SortParamRequest, SortParamRequestBuilder> {
  /// Direction of sorting, 1 for Ascending, -1 for Descending, default is 1
  @BuiltValueField(wireName: r'direction')
  int? get direction;

  /// Name of field to sort by
  @BuiltValueField(wireName: r'field')
  String? get field;

  SortParamRequest._();

  factory SortParamRequest([void updates(SortParamRequestBuilder b)]) =
      _$SortParamRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SortParamRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SortParamRequest> get serializer =>
      _$SortParamRequestSerializer();
}

class _$SortParamRequestSerializer
    implements PrimitiveSerializer<SortParamRequest> {
  @override
  final Iterable<Type> types = const [SortParamRequest, _$SortParamRequest];

  @override
  final String wireName = r'SortParamRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SortParamRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.direction != null) {
      yield r'direction';
      yield serializers.serialize(
        object.direction,
        specifiedType: const FullType(int),
      );
    }
    if (object.field != null) {
      yield r'field';
      yield serializers.serialize(
        object.field,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SortParamRequest object, {
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
    required SortParamRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.direction = valueDes;
          break;
        case r'field':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.field = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SortParamRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SortParamRequestBuilder();
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
