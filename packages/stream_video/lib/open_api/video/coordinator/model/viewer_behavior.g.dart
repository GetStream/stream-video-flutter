// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer_behavior.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewerBehavior _$ViewerBehaviorFromJson(Map<String, dynamic> json) =>
    ViewerBehavior(
      bounceRatePct: (json['bounce_rate_pct'] as num?)?.toDouble(),
      connectionDurationP50S: (json['connection_duration_p50_s'] as num)
          .toInt(),
      connectionsPerViewerMean: (json['connections_per_viewer_mean'] as num)
          .toDouble(),
      connectionsUnder30sPct: (json['connections_under_30s_pct'] as num?)
          ?.toDouble(),
      medianWatchMin: (json['median_watch_min'] as num).toDouble(),
      note: json['note'] as String,
      p90WatchMin: (json['p90_watch_min'] as num).toDouble(),
      returnVisitRatePct: (json['return_visit_rate_pct'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ViewerBehaviorToJson(ViewerBehavior instance) =>
    <String, dynamic>{
      'bounce_rate_pct': instance.bounceRatePct,
      'connection_duration_p50_s': instance.connectionDurationP50S,
      'connections_per_viewer_mean': instance.connectionsPerViewerMean,
      'connections_under_30s_pct': instance.connectionsUnder30sPct,
      'median_watch_min': instance.medianWatchMin,
      'note': instance.note,
      'p90_watch_min': instance.p90WatchMin,
      'return_visit_rate_pct': instance.returnVisitRatePct,
    };
