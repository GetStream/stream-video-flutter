abstract class CallPreferences {
  Duration get connectTimeout;
  Duration get reactionAutoDismissTime;

  bool get dropIfAloneInRingingFlow;
}

class DefaultCallPreferences implements CallPreferences {
  DefaultCallPreferences({
    this.connectTimeout = const Duration(seconds: 60),
    this.reactionAutoDismissTime = const Duration(seconds: 5),
    this.dropIfAloneInRingingFlow = true,
  });

  @override
  final Duration connectTimeout;

  @override
  final Duration reactionAutoDismissTime;

  @override
  final bool dropIfAloneInRingingFlow;
}
