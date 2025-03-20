import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'call_client_publish_options.dart';
import 'health_check_endpoint.dart';

abstract class CallPreferences {
  Duration get connectTimeout;
  Duration get reactionAutoDismissTime;
  Duration get callStatsReportingInterval;
  bool get dropIfAloneInRingingFlow;

  ClientPublishOptions? get clientPublishOptions;

  int get closedCaptionsVisibilityDurationMs;
  int get closedCaptionsVisibleCaptions;

  InternetConnection? get internetConnectionInstance;
  List<HealthCheckEndpoint>? get healthCheckEndpoints;
  Duration get healthCheckInterval;
}

class DefaultCallPreferences implements CallPreferences {
  DefaultCallPreferences({
    this.connectTimeout = const Duration(seconds: 60),
    this.reactionAutoDismissTime = const Duration(seconds: 5),
    this.callStatsReportingInterval = const Duration(seconds: 2),
    this.dropIfAloneInRingingFlow = true,
    this.clientPublishOptions,
    this.closedCaptionsVisibilityDurationMs = 2700,
    this.closedCaptionsVisibleCaptions = 2,
    this.internetConnectionInstance,
    this.healthCheckEndpoints,
    this.healthCheckInterval = const Duration(seconds: 1),
  });

  @override
  final Duration connectTimeout;

  @override
  final Duration reactionAutoDismissTime;

  @override
  final Duration callStatsReportingInterval;

  @override
  final bool dropIfAloneInRingingFlow;

  @override
  final ClientPublishOptions? clientPublishOptions;

  @override
  final int closedCaptionsVisibilityDurationMs;

  @override
  final int closedCaptionsVisibleCaptions;

  @override
  final InternetConnection? internetConnectionInstance;

  @override
  final List<HealthCheckEndpoint>? healthCheckEndpoints;

  @override
  final Duration healthCheckInterval;
}
