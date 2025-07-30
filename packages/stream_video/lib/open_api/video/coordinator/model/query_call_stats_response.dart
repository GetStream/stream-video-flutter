//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_stats_report_summary_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'query_call_stats_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
/// * [next]
/// * [prev]
/// * [reports]
@BuiltValue()
abstract class QueryCallStatsResponse
    implements Built<QueryCallStatsResponse, QueryCallStatsResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'next')
  String? get next;

  @BuiltValueField(wireName: r'prev')
  String? get prev;

  @BuiltValueField(wireName: r'reports')
  BuiltList<CallStatsReportSummaryResponse> get reports;

  QueryCallStatsResponse._();

  factory QueryCallStatsResponse(
          [void updates(QueryCallStatsResponseBuilder b)]) =
      _$QueryCallStatsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueryCallStatsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueryCallStatsResponse> get serializer =>
      _$QueryCallStatsResponseSerializer();
}

class _$QueryCallStatsResponseSerializer
    implements PrimitiveSerializer<QueryCallStatsResponse> {
  @override
  final Iterable<Type> types = const [
    QueryCallStatsResponse,
    _$QueryCallStatsResponse
  ];

  @override
  final String wireName = r'QueryCallStatsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueryCallStatsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
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
    yield r'reports';
    yield serializers.serialize(
      object.reports,
      specifiedType:
          const FullType(BuiltList, [FullType(CallStatsReportSummaryResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueryCallStatsResponse object, {
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
    required QueryCallStatsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
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
        case r'reports':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(CallStatsReportSummaryResponse)]),
          ) as BuiltList<CallStatsReportSummaryResponse>;
          result.reports.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueryCallStatsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueryCallStatsResponseBuilder();
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
