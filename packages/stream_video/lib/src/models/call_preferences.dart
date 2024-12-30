abstract class CallPreferences {
  Duration get connectTimeout;
  Duration get reactionAutoDismissTime;

  bool get dropIfAloneInRingingFlow;

  int get closedCaptionsVisibilityDurationMs;
  int get closedCaptionsVisibleCaptions;
}

class DefaultCallPreferences implements CallPreferences {
  DefaultCallPreferences({
    this.connectTimeout = const Duration(seconds: 60),
    this.reactionAutoDismissTime = const Duration(seconds: 5),
    this.dropIfAloneInRingingFlow = true,
    this.closedCaptionsVisibilityDurationMs = 2700,
    this.closedCaptionsVisibleCaptions = 2,
  });

  @override
  final Duration connectTimeout;

  @override
  final Duration reactionAutoDismissTime;

  @override
  final bool dropIfAloneInRingingFlow;

  @override
  final int closedCaptionsVisibilityDurationMs;

  @override
  final int closedCaptionsVisibleCaptions;
}
