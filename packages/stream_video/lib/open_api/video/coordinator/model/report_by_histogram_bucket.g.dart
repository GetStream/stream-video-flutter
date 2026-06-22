// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_by_histogram_bucket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportByHistogramBucket _$ReportByHistogramBucketFromJson(
  Map<String, dynamic> json,
) => ReportByHistogramBucket(
  category: json['category'] as String,
  count: (json['count'] as num).toInt(),
  lowerBound: json['lower_bound'] == null
      ? null
      : Bound.fromJson(json['lower_bound'] as Map<String, dynamic>),
  sum: (json['sum'] as num).toDouble(),
  upperBound: json['upper_bound'] == null
      ? null
      : Bound.fromJson(json['upper_bound'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReportByHistogramBucketToJson(
  ReportByHistogramBucket instance,
) => <String, dynamic>{
  'category': instance.category,
  'count': instance.count,
  'lower_bound': instance.lowerBound,
  'sum': instance.sum,
  'upper_bound': instance.upperBound,
};
