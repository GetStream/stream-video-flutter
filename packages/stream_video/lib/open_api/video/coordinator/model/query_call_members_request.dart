//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/sort_param_request.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'query_call_members_request.g.dart';

/// QueryCallMembersRequest
///
/// Properties:
/// * [filterConditions]
/// * [id]
/// * [limit]
/// * [next]
/// * [prev]
/// * [sort]
/// * [type]
@BuiltValue()
abstract class QueryCallMembersRequest
    implements Built<QueryCallMembersRequest, QueryCallMembersRequestBuilder> {
  @BuiltValueField(wireName: r'filter_conditions')
  BuiltMap<String, JsonObject?>? get filterConditions;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'limit')
  int? get limit;

  @BuiltValueField(wireName: r'next')
  String? get next;

  @BuiltValueField(wireName: r'prev')
  String? get prev;

  @BuiltValueField(wireName: r'sort')
  BuiltList<SortParamRequest?>? get sort;

  @BuiltValueField(wireName: r'type')
  String get type;

  QueryCallMembersRequest._();

  factory QueryCallMembersRequest(
          [void updates(QueryCallMembersRequestBuilder b)]) =
      _$QueryCallMembersRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueryCallMembersRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueryCallMembersRequest> get serializer =>
      _$QueryCallMembersRequestSerializer();
}

class _$QueryCallMembersRequestSerializer
    implements PrimitiveSerializer<QueryCallMembersRequest> {
  @override
  final Iterable<Type> types = const [
    QueryCallMembersRequest,
    _$QueryCallMembersRequest
  ];

  @override
  final String wireName = r'QueryCallMembersRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueryCallMembersRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.filterConditions != null) {
      yield r'filter_conditions';
      yield serializers.serialize(
        object.filterConditions,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.limit != null) {
      yield r'limit';
      yield serializers.serialize(
        object.limit,
        specifiedType: const FullType(int),
      );
    }
    if (object.next != null) {
      yield r'next';
      yield serializers.serialize(
        object.next,
        specifiedType: const FullType(String),
      );
    }
    if (object.prev != null) {
      yield r'prev';
      yield serializers.serialize(
        object.prev,
        specifiedType: const FullType(String),
      );
    }
    if (object.sort != null) {
      yield r'sort';
      yield serializers.serialize(
        object.sort,
        specifiedType:
            const FullType(BuiltList, [FullType.nullable(SortParamRequest)]),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueryCallMembersRequest object, {
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
    required QueryCallMembersRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'filter_conditions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.filterConditions.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limit = valueDes;
          break;
        case r'next':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.next = valueDes;
          break;
        case r'prev':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prev = valueDes;
          break;
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(SortParamRequest)]),
          ) as BuiltList<SortParamRequest?>;
          result.sort.replace(valueDes);
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueryCallMembersRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueryCallMembersRequestBuilder();
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
