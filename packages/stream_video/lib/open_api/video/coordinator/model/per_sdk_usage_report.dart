//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'per_sdk_usage_report.g.dart';

/// PerSDKUsageReport
///
/// Properties:
/// * [byVersion]
/// * [total]
@BuiltValue()
abstract class PerSDKUsageReport
    implements Built<PerSDKUsageReport, PerSDKUsageReportBuilder> {
  @BuiltValueField(wireName: r'by_version')
  BuiltMap<String, int> get byVersion;

  @BuiltValueField(wireName: r'total')
  int get total;

  PerSDKUsageReport._();

  factory PerSDKUsageReport([void updates(PerSDKUsageReportBuilder b)]) =
      _$PerSDKUsageReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PerSDKUsageReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PerSDKUsageReport> get serializer =>
      _$PerSDKUsageReportSerializer();
}

class _$PerSDKUsageReportSerializer
    implements PrimitiveSerializer<PerSDKUsageReport> {
  @override
  final Iterable<Type> types = const [PerSDKUsageReport, _$PerSDKUsageReport];

  @override
  final String wireName = r'PerSDKUsageReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PerSDKUsageReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'by_version';
    yield serializers.serialize(
      object.byVersion,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PerSDKUsageReport object, {
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
    required PerSDKUsageReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'by_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.byVersion.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PerSDKUsageReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PerSDKUsageReportBuilder();
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
