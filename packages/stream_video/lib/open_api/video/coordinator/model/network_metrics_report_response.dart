//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'network_metrics_report_response.g.dart';

/// NetworkMetricsReportResponse
///
/// Properties:
/// * [averageConnectionTime]
/// * [averageJitter]
/// * [averageLatency]
/// * [averageTimeToReconnect]
@BuiltValue()
abstract class NetworkMetricsReportResponse
    implements
        Built<NetworkMetricsReportResponse,
            NetworkMetricsReportResponseBuilder> {
  @BuiltValueField(wireName: r'average_connection_time')
  double? get averageConnectionTime;

  @BuiltValueField(wireName: r'average_jitter')
  double? get averageJitter;

  @BuiltValueField(wireName: r'average_latency')
  double? get averageLatency;

  @BuiltValueField(wireName: r'average_time_to_reconnect')
  double? get averageTimeToReconnect;

  NetworkMetricsReportResponse._();

  factory NetworkMetricsReportResponse(
          [void updates(NetworkMetricsReportResponseBuilder b)]) =
      _$NetworkMetricsReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NetworkMetricsReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NetworkMetricsReportResponse> get serializer =>
      _$NetworkMetricsReportResponseSerializer();
}

class _$NetworkMetricsReportResponseSerializer
    implements PrimitiveSerializer<NetworkMetricsReportResponse> {
  @override
  final Iterable<Type> types = const [
    NetworkMetricsReportResponse,
    _$NetworkMetricsReportResponse
  ];

  @override
  final String wireName = r'NetworkMetricsReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NetworkMetricsReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.averageConnectionTime != null) {
      yield r'average_connection_time';
      yield serializers.serialize(
        object.averageConnectionTime,
        specifiedType: const FullType(double),
      );
    }
    if (object.averageJitter != null) {
      yield r'average_jitter';
      yield serializers.serialize(
        object.averageJitter,
        specifiedType: const FullType(double),
      );
    }
    if (object.averageLatency != null) {
      yield r'average_latency';
      yield serializers.serialize(
        object.averageLatency,
        specifiedType: const FullType(double),
      );
    }
    if (object.averageTimeToReconnect != null) {
      yield r'average_time_to_reconnect';
      yield serializers.serialize(
        object.averageTimeToReconnect,
        specifiedType: const FullType(double),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NetworkMetricsReportResponse object, {
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
    required NetworkMetricsReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'average_connection_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.averageConnectionTime = valueDes;
          break;
        case r'average_jitter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.averageJitter = valueDes;
          break;
        case r'average_latency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.averageLatency = valueDes;
          break;
        case r'average_time_to_reconnect':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.averageTimeToReconnect = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NetworkMetricsReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NetworkMetricsReportResponseBuilder();
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
