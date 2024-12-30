import 'call_client_publish_options.dart';

abstract class CallPreferences {
  Duration get connectTimeout;
  Duration get reactionAutoDismissTime;
  bool get dropIfAloneInRingingFlow;
  ClientPublishOptions? get clientPublishOptions;
}

class DefaultCallPreferences implements CallPreferences {
  DefaultCallPreferences({
    this.connectTimeout = const Duration(seconds: 60),
    this.reactionAutoDismissTime = const Duration(seconds: 5),
    this.dropIfAloneInRingingFlow = true,
    this.clientPublishOptions,
  });

  @override
  final Duration connectTimeout;

  @override
  final Duration reactionAutoDismissTime;

  @override
  final bool dropIfAloneInRingingFlow;

  @override
  final ClientPublishOptions? clientPublishOptions;
}
