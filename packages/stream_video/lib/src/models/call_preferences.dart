import 'call_client_publish_options.dart';

abstract class CallPreferences {
  Duration get connectTimeout;
  Duration get reactionAutoDismissTime;
  Duration get callStatsReportingInterval;
  bool get dropIfAloneInRingingFlow;

  ClientPublishOptions? get clientPublishOptions;

  int get closedCaptionsVisibilityDurationMs;
  int get closedCaptionsVisibleCaptions;
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
}
