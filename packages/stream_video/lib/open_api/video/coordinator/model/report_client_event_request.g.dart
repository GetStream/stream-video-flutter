// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_client_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportClientEventRequest _$ReportClientEventRequestFromJson(
  Map<String, dynamic> json,
) => ReportClientEventRequest(
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => ClientEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$ReportClientEventRequestToJson(
  ReportClientEventRequest instance,
) => <String, dynamic>{'events': instance.events};
