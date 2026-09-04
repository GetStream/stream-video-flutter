import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../core/model/environment.dart';
import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../router/routes.dart';
import '../theme/app_palette.dart';
import '../utils/consts.dart';

/// Turns a `/join/<callId>` link into the lobby for that call.
///
/// Fetching the call is asynchronous and the environment may have to change
/// first, so the route lands here rather than on the lobby directly. This
/// screen replaces itself with the lobby as soon as the call is ready.
class JoinCallScreen extends StatefulWidget {
  const JoinCallScreen({super.key, required this.callId, this.linkHost});

  /// Id of the call to join.
  final String callId;

  /// Host of the link that opened the app, empty when the navigation did not
  /// come from a link. It is the only place the app learns which environment
  /// the call lives in.
  final String? linkHost;

  @override
  State<JoinCallScreen> createState() => _JoinCallScreenState();
}

class _JoinCallScreenState extends State<JoinCallScreen> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _openCall();
  }

  Future<void> _openCall() async {
    try {
      await _switchEnvironmentIfNeeded();

      final call = locator.get<StreamVideo>().makeCall(
        callType: kCallType,
        id: widget.callId,
      );
      await call.getOrCreate();

      if (!mounted) return;
      LobbyRoute($extra: call).replace(context);
    } catch (e, stk) {
      debugPrint('Could not open the call from the link: $e');
      debugPrintStack(stackTrace: stk);
      if (mounted) setState(() => _failed = true);
    }
  }

  /// A link carries its environment in its host, so a link to staging must not
  /// be joined against pronto.
  ///
  /// Re-initialising the injector tears down the video and chat clients and
  /// reconnects them, so it only happens when the link actually points
  /// somewhere other than where the app is already pointing.
  Future<void> _switchEnvironmentIfNeeded() async {
    final host = widget.linkHost;
    if (host == null || host.isEmpty) return;

    final target = Environment.fromHost(host);
    if (locator.get<AppPreferences>().environment == target) return;

    final user = locator.get<UserAuthController>().currentUser;
    if (user == null) return;

    await AppInjector.reset();
    await AppInjector.init(forceEnvironment: target);
    await locator.get<UserAuthController>().login(User(info: user), target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.backgroundColor,
      body: Center(
        child: _failed
            ? _JoinFailed(callId: widget.callId)
            : const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

class _JoinFailed extends StatelessWidget {
  const _JoinFailed({required this.callId});

  final String callId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Could not open call $callId',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Check that the link is still valid, then try again.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => HomeRoute().go(context),
            child: const Text('Go to home'),
          ),
        ],
      ),
    );
  }
}
