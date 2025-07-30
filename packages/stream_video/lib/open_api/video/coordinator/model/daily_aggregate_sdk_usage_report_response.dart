//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/sdk_usage_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_aggregate_sdk_usage_report_response.g.dart';

/// DailyAggregateSDKUsageReportResponse
///
/// Properties:
/// * [date]
/// * [report]
@BuiltValue()
abstract class DailyAggregateSDKUsageReportResponse
    implements
        Built<DailyAggregateSDKUsageReportResponse,
            DailyAggregateSDKUsageReportResponseBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'report')
  SDKUsageReport get report;

  DailyAggregateSDKUsageReportResponse._();

  factory DailyAggregateSDKUsageReportResponse(
          [void updates(DailyAggregateSDKUsageReportResponseBuilder b)]) =
      _$DailyAggregateSDKUsageReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DailyAggregateSDKUsageReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyAggregateSDKUsageReportResponse> get serializer =>
      _$DailyAggregateSDKUsageReportResponseSerializer();
}

class _$DailyAggregateSDKUsageReportResponseSerializer
    implements PrimitiveSerializer<DailyAggregateSDKUsageReportResponse> {
  @override
  final Iterable<Type> types = const [
    DailyAggregateSDKUsageReportResponse,
    _$DailyAggregateSDKUsageReportResponse
  ];

  @override
  final String wireName = r'DailyAggregateSDKUsageReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyAggregateSDKUsageReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'report';
    yield serializers.serialize(
      object.report,
      specifiedType: const FullType(SDKUsageReport),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyAggregateSDKUsageReportResponse object, {
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
    required DailyAggregateSDKUsageReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SDKUsageReport),
          ) as SDKUsageReport;
          result.report.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DailyAggregateSDKUsageReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyAggregateSDKUsageReportResponseBuilder();
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
