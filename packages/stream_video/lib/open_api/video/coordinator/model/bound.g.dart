// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bound.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bound _$BoundFromJson(Map<String, dynamic> json) => Bound(
  inclusive: json['inclusive'] as bool,
  value: (json['value'] as num).toDouble(),
);

Map<String, dynamic> _$BoundToJson(Bound instance) => <String, dynamic>{
  'inclusive': instance.inclusive,
  'value': instance.value,
};
