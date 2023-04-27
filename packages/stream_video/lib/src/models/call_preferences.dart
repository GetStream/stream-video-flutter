abstract class CallPreferences {
  Duration get connectTimeout;

  bool get dropIfAloneInRingingFlow;
}

class DefaultCallPreferences implements CallPreferences {
  DefaultCallPreferences({
    this.connectTimeout = const Duration(seconds: 60),
    this.dropIfAloneInRingingFlow = true,
  });

  @override
  final Duration connectTimeout;

  @override
  final bool dropIfAloneInRingingFlow;
}
