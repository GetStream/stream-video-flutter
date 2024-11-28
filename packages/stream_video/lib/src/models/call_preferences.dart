abstract class CallPreferences {
  Duration get connectTimeout;
  Duration get reactionAutoDismissTime;

  bool get dropIfAloneInRingingFlow;

  int get closedCaptionsRetentionTimeInMs;
  int get closedCaptionsQueueSize;
}

class DefaultCallPreferences implements CallPreferences {
  DefaultCallPreferences({
    this.connectTimeout = const Duration(seconds: 60),
    this.reactionAutoDismissTime = const Duration(seconds: 5),
    this.dropIfAloneInRingingFlow = true,
    this.closedCaptionsRetentionTimeInMs = 2700,
    this.closedCaptionsQueueSize = 2,
  });

  @override
  final Duration connectTimeout;

  @override
  final Duration reactionAutoDismissTime;

  @override
  final bool dropIfAloneInRingingFlow;

  @override
  final int closedCaptionsRetentionTimeInMs;

  @override
  final int closedCaptionsQueueSize;
}
