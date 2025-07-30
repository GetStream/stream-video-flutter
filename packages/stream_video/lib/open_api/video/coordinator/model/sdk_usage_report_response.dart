//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_sdk_usage_report_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sdk_usage_report_response.g.dart';

/// SDKUsageReportResponse
///
/// Properties:
/// * [daily]
@BuiltValue()
abstract class SDKUsageReportResponse
    implements Built<SDKUsageReportResponse, SDKUsageReportResponseBuilder> {
  @BuiltValueField(wireName: r'daily')
  BuiltList<DailyAggregateSDKUsageReportResponse> get daily;

  SDKUsageReportResponse._();

  factory SDKUsageReportResponse(
          [void updates(SDKUsageReportResponseBuilder b)]) =
      _$SDKUsageReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SDKUsageReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SDKUsageReportResponse> get serializer =>
      _$SDKUsageReportResponseSerializer();
}

class _$SDKUsageReportResponseSerializer
    implements PrimitiveSerializer<SDKUsageReportResponse> {
  @override
  final Iterable<Type> types = const [
    SDKUsageReportResponse,
    _$SDKUsageReportResponse
  ];

  @override
  final String wireName = r'SDKUsageReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SDKUsageReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'daily';
    yield serializers.serialize(
      object.daily,
      specifiedType: const FullType(
          BuiltList, [FullType(DailyAggregateSDKUsageReportResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SDKUsageReportResponse object, {
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
    required SDKUsageReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'daily':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(DailyAggregateSDKUsageReportResponse)]),
          ) as BuiltList<DailyAggregateSDKUsageReportResponse>;
          result.daily.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SDKUsageReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SDKUsageReportResponseBuilder();
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
