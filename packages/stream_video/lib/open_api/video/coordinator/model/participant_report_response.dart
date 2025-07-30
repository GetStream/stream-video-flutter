//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/participant_count_over_time_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/subscriber_stats_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/publisher_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/grouped_stats_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'participant_report_response.g.dart';

/// ParticipantReportResponse
///
/// Properties:
/// * [byBrowser]
/// * [byCountry]
/// * [byDevice]
/// * [byOperatingSystem]
/// * [countOverTime]
/// * [maxConcurrent]
/// * [publishers]
/// * [subscribers]
/// * [sum]
/// * [unique]
@BuiltValue()
abstract class ParticipantReportResponse
    implements
        Built<ParticipantReportResponse, ParticipantReportResponseBuilder> {
  @BuiltValueField(wireName: r'by_browser')
  BuiltList<GroupedStatsResponse?>? get byBrowser;

  @BuiltValueField(wireName: r'by_country')
  BuiltList<GroupedStatsResponse?>? get byCountry;

  @BuiltValueField(wireName: r'by_device')
  BuiltList<GroupedStatsResponse?>? get byDevice;

  @BuiltValueField(wireName: r'by_operating_system')
  BuiltList<GroupedStatsResponse?>? get byOperatingSystem;

  @BuiltValueField(wireName: r'count_over_time')
  ParticipantCountOverTimeResponse? get countOverTime;

  @BuiltValueField(wireName: r'max_concurrent')
  int? get maxConcurrent;

  @BuiltValueField(wireName: r'publishers')
  PublisherStatsResponse? get publishers;

  @BuiltValueField(wireName: r'subscribers')
  SubscriberStatsResponse? get subscribers;

  @BuiltValueField(wireName: r'sum')
  int get sum;

  @BuiltValueField(wireName: r'unique')
  int get unique;

  ParticipantReportResponse._();

  factory ParticipantReportResponse(
          [void updates(ParticipantReportResponseBuilder b)]) =
      _$ParticipantReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParticipantReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ParticipantReportResponse> get serializer =>
      _$ParticipantReportResponseSerializer();
}

class _$ParticipantReportResponseSerializer
    implements PrimitiveSerializer<ParticipantReportResponse> {
  @override
  final Iterable<Type> types = const [
    ParticipantReportResponse,
    _$ParticipantReportResponse
  ];

  @override
  final String wireName = r'ParticipantReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ParticipantReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.byBrowser != null) {
      yield r'by_browser';
      yield serializers.serialize(
        object.byBrowser,
        specifiedType: const FullType(
            BuiltList, [FullType.nullable(GroupedStatsResponse)]),
      );
    }
    if (object.byCountry != null) {
      yield r'by_country';
      yield serializers.serialize(
        object.byCountry,
        specifiedType: const FullType(
            BuiltList, [FullType.nullable(GroupedStatsResponse)]),
      );
    }
    if (object.byDevice != null) {
      yield r'by_device';
      yield serializers.serialize(
        object.byDevice,
        specifiedType: const FullType(
            BuiltList, [FullType.nullable(GroupedStatsResponse)]),
      );
    }
    if (object.byOperatingSystem != null) {
      yield r'by_operating_system';
      yield serializers.serialize(
        object.byOperatingSystem,
        specifiedType: const FullType(
            BuiltList, [FullType.nullable(GroupedStatsResponse)]),
      );
    }
    if (object.countOverTime != null) {
      yield r'count_over_time';
      yield serializers.serialize(
        object.countOverTime,
        specifiedType: const FullType(ParticipantCountOverTimeResponse),
      );
    }
    if (object.maxConcurrent != null) {
      yield r'max_concurrent';
      yield serializers.serialize(
        object.maxConcurrent,
        specifiedType: const FullType(int),
      );
    }
    if (object.publishers != null) {
      yield r'publishers';
      yield serializers.serialize(
        object.publishers,
        specifiedType: const FullType(PublisherStatsResponse),
      );
    }
    if (object.subscribers != null) {
      yield r'subscribers';
      yield serializers.serialize(
        object.subscribers,
        specifiedType: const FullType(SubscriberStatsResponse),
      );
    }
    yield r'sum';
    yield serializers.serialize(
      object.sum,
      specifiedType: const FullType(int),
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
    ParticipantReportResponse object, {
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
    required ParticipantReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'by_browser':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(GroupedStatsResponse)]),
          ) as BuiltList<GroupedStatsResponse?>;
          result.byBrowser.replace(valueDes);
          break;
        case r'by_country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(GroupedStatsResponse)]),
          ) as BuiltList<GroupedStatsResponse?>;
          result.byCountry.replace(valueDes);
          break;
        case r'by_device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(GroupedStatsResponse)]),
          ) as BuiltList<GroupedStatsResponse?>;
          result.byDevice.replace(valueDes);
          break;
        case r'by_operating_system':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(GroupedStatsResponse)]),
          ) as BuiltList<GroupedStatsResponse?>;
          result.byOperatingSystem.replace(valueDes);
          break;
        case r'count_over_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ParticipantCountOverTimeResponse),
          ) as ParticipantCountOverTimeResponse;
          result.countOverTime.replace(valueDes);
          break;
        case r'max_concurrent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxConcurrent = valueDes;
          break;
        case r'publishers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublisherStatsResponse),
          ) as PublisherStatsResponse;
          result.publishers.replace(valueDes);
          break;
        case r'subscribers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubscriberStatsResponse),
          ) as SubscriberStatsResponse;
          result.subscribers.replace(valueDes);
          break;
        case r'sum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sum = valueDes;
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
  ParticipantReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParticipantReportResponseBuilder();
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
