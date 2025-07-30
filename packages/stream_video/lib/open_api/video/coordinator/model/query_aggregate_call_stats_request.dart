//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'query_aggregate_call_stats_request.g.dart';

/// QueryAggregateCallStatsRequest
///
/// Properties:
/// * [from]
/// * [reportTypes]
/// * [to]
@BuiltValue()
abstract class QueryAggregateCallStatsRequest
    implements
        Built<QueryAggregateCallStatsRequest,
            QueryAggregateCallStatsRequestBuilder> {
  @BuiltValueField(wireName: r'from')
  String? get from;

  @BuiltValueField(wireName: r'report_types')
  BuiltList<String>? get reportTypes;

  @BuiltValueField(wireName: r'to')
  String? get to;

  QueryAggregateCallStatsRequest._();

  factory QueryAggregateCallStatsRequest(
          [void updates(QueryAggregateCallStatsRequestBuilder b)]) =
      _$QueryAggregateCallStatsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueryAggregateCallStatsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueryAggregateCallStatsRequest> get serializer =>
      _$QueryAggregateCallStatsRequestSerializer();
}

class _$QueryAggregateCallStatsRequestSerializer
    implements PrimitiveSerializer<QueryAggregateCallStatsRequest> {
  @override
  final Iterable<Type> types = const [
    QueryAggregateCallStatsRequest,
    _$QueryAggregateCallStatsRequest
  ];

  @override
  final String wireName = r'QueryAggregateCallStatsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueryAggregateCallStatsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.from != null) {
      yield r'from';
      yield serializers.serialize(
        object.from,
        specifiedType: const FullType(String),
      );
    }
    if (object.reportTypes != null) {
      yield r'report_types';
      yield serializers.serialize(
        object.reportTypes,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.to != null) {
      yield r'to';
      yield serializers.serialize(
        object.to,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    QueryAggregateCallStatsRequest object, {
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
    required QueryAggregateCallStatsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.from = valueDes;
          break;
        case r'report_types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.reportTypes.replace(valueDes);
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.to = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueryAggregateCallStatsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueryAggregateCallStatsRequestBuilder();
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
