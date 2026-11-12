import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../core/model/environment.dart';
import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../router/routes.dart';
import '../utils/app_call.dart';
import '../utils/call_lookup.dart';
import 'call_screen.dart';
import 'lobby_screen.dart';

/// The page behind `/join/<callId>`: the lobby for the call, then the call
/// itself.
///
/// The route carries only the call id, so the address always names the call.
/// A call the app is already ringing or in opens on the call screen; any other
/// opens in the lobby. Leaving the lobby for the call stays on this page.
class CallRoutePage extends StatefulWidget {
  const CallRoutePage({
    super.key,
    required this.callId,
    required this.callType,
    this.linkHost,
    this.encryptionKey,
    this.publishOptions,
  });

  /// Id of the call to open.
  final String callId;

  /// Type of the call to open.
  final StreamCallType callType;

  /// Host of the link that opened the app, empty when the navigation did not
  /// come from a link. It is the only place the app learns which environment
  /// the call lives in.
  final String? linkHost;

  /// The shared passphrase that came with the navigation, null when none did.
  final String? encryptionKey;

  /// Codec overrides for a call this page makes, null for none.
  final ClientPublishOptions? publishOptions;

  /// Hands [call] to the next page that opens for its id, so a call the app
  /// already set up — one it is ringing, one ringing in, or one accepted from
  /// a notification — is shown instead of a fresh call with the same id.
  ///
  /// A call that has ended by the time the page opens closes the page.
  static void handOff(Call call) => _handedOff[call.callCid.value] = call;

  /// Handed-off calls by their call cid.
  static final _handedOff = <String, Call>{};

  @override
  State<CallRoutePage> createState() => _CallRoutePageState();
}

typedef _JoinOptions = ({
  CallConnectOptions connectOptions,
  StreamVideoEffectsManager effectsManager,
  String? encryptionKey,
});

class _CallRoutePageState extends State<CallRoutePage> {
  late final _callCid = StreamCallCid.from(
    type: widget.callType,
    id: widget.callId,
  );

  Call? _call;
  bool _callExists = false;

  /// Why the call could not be opened, null while it can.
  String? _error;

  /// Whether the call screen is showing rather than the lobby.
  bool _inCall = false;

  /// What the lobby settled on, null when the call skipped the lobby.
  _JoinOptions? _joinOptions;

  @override
  void initState() {
    super.initState();
    _openCall();
  }

  Future<void> _openCall() async {
    try {
      final handedOff = CallRoutePage._handedOff.remove(_callCid.value);
      if (handedOff != null && handedOff.state.value.status.isDisconnected) {
        _close();
        return;
      }

      final existing = handedOff ?? _activeCall();
      if (existing != null && !existing.state.value.status.isIdle) {
        setState(() {
          _call = existing;
          _inCall = true;
        });
        return;
      }

      await _switchEnvironmentIfNeeded();

      final call =
          existing ??
          makeAppCall(
            widget.callId,
            callType: widget.callType,
            publishOptions: widget.publishOptions,
          );

      // The call may not exist yet. Creation is left to the lobby, because
      // that is where the encryption mode is chosen and the mode is fixed at
      // creation.
      final lookup = await lookupCallExists(call);
      if (lookup is Failure) {
        debugPrint('Could not look up call ${widget.callId}: ${lookup.error}');
        if (mounted) setState(() => _error = lookup.videoError.message);
        return;
      }

      if (!mounted) return;
      setState(() {
        _call = call;
        _callExists = (lookup as Success<bool>).data;
      });
    } catch (e, stk) {
      debugPrint('Could not open call ${widget.callId}: $e');
      debugPrintStack(stackTrace: stk);
      if (mounted) setState(() => _error = e.toString());
    }
  }

  /// Whether [call] is a livestream this user only watches: they skip the
  /// lobby and get the livestream player, like the other SDKs' demo apps.
  /// Hosts, who can publish video, go through the lobby to the call screen.
  bool _isLivestreamViewer(Call call) {
    if (call.type != StreamCallType.liveStream() || !_callExists) return false;

    final capabilities = call.state.value.ownCapabilities;
    return !capabilities.contains(CallPermission.sendVideo);
  }

  /// Leaves this page once it is on screen, for a call that is already over.
  void _close() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        HomeRoute().go(context);
      }
    });
  }

  /// The call the client is in with this call cid.
  Call? _activeCall() {
    return locator
        .get<StreamVideo>()
        .activeCalls
        .where((call) => call.callCid == _callCid)
        .firstOrNull;
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
    await locator.get<UserAuthController>().login(user.toUser(), target);
  }

  @override
  Widget build(BuildContext context) {
    final call = _call;
    final error = _error;
    if (error != null || call == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: error != null
              ? _JoinFailed(callId: widget.callId, error: error)
              : const CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (_isLivestreamViewer(call)) {
      return LivestreamPlayer(
        call: call,
        // Stays open when the host ends the livestream, so the viewer sees
        // that it ended; the close button leaves.
        onCallDisconnected: (_) {},
        backButtonBuilder: (context) => StreamToolbarButton.icon(
          icon: Icon(context.streamIcons.xmark),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () async {
            // The player only leaves on its own when the call disconnects.
            await call.leave(
              reason: const DisconnectReason.left(
                initiator: LeaveInitiator.user,
              ),
            );
            if (context.mounted) await Navigator.maybePop(context);
          },
        ),
      );
    }

    if (_inCall) {
      final options = _joinOptions;
      return CallScreen(
        call: call,
        connectOptions: options?.connectOptions,
        videoEffectsManager: options?.effectsManager,
        encryptionKey: options?.encryptionKey,
      );
    }

    return LobbyScreen(
      call: call,
      callExists: _callExists,
      initialEncryptionKey: widget.encryptionKey,
      onJoinCallPressed:
          ({
            required call,
            required connectOptions,
            required effectsManager,
            encryptionKey,
          }) {
            setState(() {
              _inCall = true;
              _joinOptions = (
                connectOptions: connectOptions,
                effectsManager: effectsManager,
                // The passphrase the lobby settled on, so the call screen can
                // put it in the invite it offers.
                encryptionKey: encryptionKey,
              );
            });
          },
    );
  }
}

class _JoinFailed extends StatelessWidget {
  const _JoinFailed({required this.callId, required this.error});

  final String callId;
  final String error;

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
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Check the call id or your connection, then try again.',
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
