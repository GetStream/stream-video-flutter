//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/bound.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_by_histogram_bucket.g.dart';

/// ReportByHistogramBucket
///
/// Properties:
/// * [category]
/// * [count]
/// * [lowerBound]
/// * [sum]
/// * [upperBound]
@BuiltValue()
abstract class ReportByHistogramBucket
    implements Built<ReportByHistogramBucket, ReportByHistogramBucketBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'lower_bound')
  Bound? get lowerBound;

  @BuiltValueField(wireName: r'sum')
  double get sum;

  @BuiltValueField(wireName: r'upper_bound')
  Bound? get upperBound;

  ReportByHistogramBucket._();

  factory ReportByHistogramBucket(
          [void updates(ReportByHistogramBucketBuilder b)]) =
      _$ReportByHistogramBucket;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReportByHistogramBucketBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReportByHistogramBucket> get serializer =>
      _$ReportByHistogramBucketSerializer();
}

class _$ReportByHistogramBucketSerializer
    implements PrimitiveSerializer<ReportByHistogramBucket> {
  @override
  final Iterable<Type> types = const [
    ReportByHistogramBucket,
    _$ReportByHistogramBucket
  ];

  @override
  final String wireName = r'ReportByHistogramBucket';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReportByHistogramBucket object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    if (object.lowerBound != null) {
      yield r'lower_bound';
      yield serializers.serialize(
        object.lowerBound,
        specifiedType: const FullType(Bound),
      );
    }
    yield r'sum';
    yield serializers.serialize(
      object.sum,
      specifiedType: const FullType(double),
    );
    if (object.upperBound != null) {
      yield r'upper_bound';
      yield serializers.serialize(
        object.upperBound,
        specifiedType: const FullType(Bound),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReportByHistogramBucket object, {
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
    required ReportByHistogramBucketBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'lower_bound':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Bound),
          ) as Bound;
          result.lowerBound.replace(valueDes);
          break;
        case r'sum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.sum = valueDes;
          break;
        case r'upper_bound':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Bound),
          ) as Bound;
          result.upperBound.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReportByHistogramBucket deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReportByHistogramBucketBuilder();
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
