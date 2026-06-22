// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_by_minute_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountByMinuteResponse _$CountByMinuteResponseFromJson(
  Map<String, dynamic> json,
) => CountByMinuteResponse(
  count: (json['count'] as num).toInt(),
  startTs: const EpochDateTimeConverter().fromJson(json['start_ts'] as Object),
);

Map<String, dynamic> _$CountByMinuteResponseToJson(
  CountByMinuteResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'start_ts': const EpochDateTimeConverter().toJson(instance.startTs),
};
