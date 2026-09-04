// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Incident _$IncidentFromJson(Map<String, dynamic> json) => Incident(
  from: json['from'] as String,
  peakConcurrency: (json['peak_concurrency'] as num).toInt(),
  to: json['to'] as String,
  viewersInterrupted: (json['viewers_interrupted'] as num).toInt(),
);

Map<String, dynamic> _$IncidentToJson(Incident instance) => <String, dynamic>{
  'from': instance.from,
  'peak_concurrency': instance.peakConcurrency,
  'to': instance.to,
  'viewers_interrupted': instance.viewersInterrupted,
};
