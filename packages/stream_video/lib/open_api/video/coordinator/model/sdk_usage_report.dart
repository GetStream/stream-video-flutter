//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/per_sdk_usage_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sdk_usage_report.g.dart';

/// SDKUsageReport
///
/// Properties:
/// * [perSdkUsage]
@BuiltValue()
abstract class SDKUsageReport
    implements Built<SDKUsageReport, SDKUsageReportBuilder> {
  @BuiltValueField(wireName: r'per_sdk_usage')
  BuiltMap<String, PerSDKUsageReport?> get perSdkUsage;

  SDKUsageReport._();

  factory SDKUsageReport([void updates(SDKUsageReportBuilder b)]) =
      _$SDKUsageReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SDKUsageReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SDKUsageReport> get serializer =>
      _$SDKUsageReportSerializer();
}

class _$SDKUsageReportSerializer
    implements PrimitiveSerializer<SDKUsageReport> {
  @override
  final Iterable<Type> types = const [SDKUsageReport, _$SDKUsageReport];

  @override
  final String wireName = r'SDKUsageReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SDKUsageReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'per_sdk_usage';
    yield serializers.serialize(
      object.perSdkUsage,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType.nullable(PerSDKUsageReport)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SDKUsageReport object, {
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
    required SDKUsageReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'per_sdk_usage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap,
                [FullType(String), FullType.nullable(PerSDKUsageReport)]),
          ) as BuiltMap<String, PerSDKUsageReport?>;
          result.perSdkUsage.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SDKUsageReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SDKUsageReportBuilder();
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
