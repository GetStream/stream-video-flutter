import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

/// Builds the client a background push needs, or returns null when there is
/// nobody to build it for.
///
/// Called from a fresh isolate that never ran `main()`, so it has to do
/// everything from scratch: read stored credentials, fetch a token, construct
/// [StreamVideo]. Returning null is the normal way to say "no user is logged
/// in", not an error.
typedef CreateStreamVideo = Future<StreamVideo?> Function();

/// Returns the client this isolate already has, or null when it has none.
///
/// Answers the one question the handler cannot answer for itself: whether it
/// was called on the app's own isolate, where a client is already running and
/// its lifecycle belongs to the app.
///
/// Defaults to the [StreamVideo] singleton. Pass your own when your app builds
/// its client with [StreamVideo.create], or holds it anywhere else: such a
/// client installs no singleton, so there is nothing for the default to find
/// and the handler would build a second one over the top of it.
typedef ResolveExistingClient = StreamVideo? Function();

/// Runs a Stream ringing push through its whole background lifecycle.
///
/// On Android, Firebase delivers background messages to an isolate that never
/// ran `main()`, so nothing you set up at launch exists there. Everything
/// from building the client to tearing it down again needs to happen inside the
/// handler. On Apple platforms, the same handler is called on the app's own
/// isolate, where the client already exists and must be left alone—both cases
/// are handled here.
///
/// You keep the parts that are genuinely yours, such as Firebase
/// initialization and credential management, and hand the rest over:
///
/// ```dart
/// @pragma('vm:entry-point')
/// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
///   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
///
///   await StreamVideoPushHandler.handleBackgroundMessage(
///     message,
///     createStreamVideo: () async {
///       // Read credentials, fetch a token, build the client. Return null if
///       // nobody is logged in.
///     },
///     onDispose: () => MyDependencies.reset(),
///   );
/// }
/// ```
///
/// The `@pragma('vm:entry-point')` function remains your responsibility on
/// purpose. It is the only thing the background isolate can reach, so the
/// factory must be reachable from inside it—a factory registered at app launch
/// would simply not be there.
class StreamVideoPushHandler {
  const StreamVideoPushHandler._();

  static const _tag = 'SV:BackgroundPush';

  /// How long to wait after the user resolves the notification before tearing
  /// the client down, so the flow that is resolving it finishes first.
  static const _resolutionGrace = Duration(seconds: 1);

  /// The client and observers for this isolate, or null when none is running.
  ///
  /// Static because the isolate outlives a single message: a second push can
  /// arrive while the first call is still ringing.
  static _BackgroundSession? _session;

  /// Handles a background [message] that may be a Stream ringing push notification.
  ///
  /// Returns `true` if the message was successfully identified and processed as a
  /// Stream call notification; otherwise, returns `false`.
  ///
  /// On the first relevant message, this method uses [createStreamVideo] to
  /// construct a [StreamVideo] client within the background isolate, sets up
  /// observers to process ringing events, and manages client disposal after the
  /// notification flow completes—whether the user answers, declines, or the call
  /// times out. The [onDispose] callback is always executed last to allow the app
  /// to clean up resources established in [createStreamVideo], including scenarios
  /// where initialization fails.
  ///
  /// If a [StreamVideo] client already exists (i.e., not constructed by this handler),
  /// it indicates the message was delivered on the main isolate, which owns the
  /// client's lifecycle. In this case, the notification is simply forwarded to the
  /// running client, and no new observers or teardowns occur. The [existingClient]
  /// callback provides access to the current client; if not provided, the default is
  /// the [StreamVideo] singleton (which may not reflect your app's actual client instance).
  ///
  /// Any background message not intended for Stream Video is ignored and reported as
  /// unhandled, allowing your application to process its own background notifications
  /// after this handler completes.
  static Future<bool> handleBackgroundMessage(
    RemoteMessage message, {
    required CreateStreamVideo createStreamVideo,
    ResolveExistingClient? existingClient,
    FutureOr<void> Function()? onDispose,
  }) async {
    try {
      final running = _session;
      if (running != null) return await _handleWithSession(running, message);

      final appClient = _existingClient(existingClient);
      if (appClient != null) {
        streamLog.d(
          _tag,
          () => '[handleBackgroundMessage] forwarding to the running client',
        );

        return await appClient.handleRingingFlowNotifications(message.data);
      }

      final session = await _startSession(createStreamVideo, onDispose);

      // Nobody is logged in, so there is no client to show anything with and
      // nothing to tear down but what the app itself set up.
      if (session == null) {
        await onDispose?.call();
        return false;
      }

      return await _handleWithSession(session, message);
    } catch (e, stk) {
      streamLog.e(_tag, () => '[handleBackgroundMessage] failed: $e; $stk');
      await _session?.release();
      return false;
    }
  }

  /// Runs [message] through [session]'s client, releasing the session when
  /// nothing is left for it to wait for.
  static Future<bool> _handleWithSession(
    _BackgroundSession session,
    RemoteMessage message,
  ) async {
    final handled = await session.streamVideo.handleRingingFlowNotifications(
      message.data,
    );

    if (handled && _isRingingPush(message.data)) {
      session.awaitingResolution = true;
    } else if (!session.awaitingResolution) {
      // Nothing that would release the session is coming: the message was
      // either not ours, or one that only posts a notification and is done.
      if (handled) {
        session.releaseAfter(_resolutionGrace);
      } else {
        await session.release();
      }
    }

    return handled;
  }

  /// Whether [payload] is the ringing push, the only one whose flow waits for
  /// the user.
  ///
  /// The SDK reports a missed call as handled too, but a missed call
  /// notification has no ringing lifecycle: no accept, decline, timeout or end
  /// is ever emitted for it, so treating it as pending would hold the client
  /// and the app's dependencies for as long as the isolate lives.
  static bool _isRingingPush(Map<String, dynamic> payload) =>
      payload['sender'] == 'stream.video' && payload['type'] == 'call.ring';

  /// The client already living in this isolate, if there is a usable one.
  ///
  /// Only ever a client this handler did not build: a session of its own is
  /// checked first.
  static StreamVideo? _existingClient(ResolveExistingClient? resolve) {
    final client = resolve != null ? resolve() : _singleton();
    if (client == null || client.isDisposed) return null;

    return client;
  }

  /// The installed singleton, or null when there is none.
  ///
  /// An app can run without one: [StreamVideo.create] builds a client that
  /// never takes the slot. Nothing here may assume the slot is filled, or that
  /// what fills it is the client at hand.
  static StreamVideo? _singleton() =>
      StreamVideo.isInitialized() ? StreamVideo.instance : null;

  /// Clears the singleton slot if [client] is what is in it.
  ///
  /// Disposing a client leaves the slot occupied, and a later message in the
  /// same isolate would find it holding something dead. A client that never
  /// took the slot leaves nothing to clear, and one belonging to somebody else
  /// is not this handler's to take.
  static Future<void> _releaseSingleton(StreamVideo? client) async {
    if (client == null || !identical(_singleton(), client)) return;

    await StreamVideo.reset();
  }

  /// Starts this isolate's session, or returns null when nobody is logged in.
  static Future<_BackgroundSession?> _startSession(
    CreateStreamVideo createStreamVideo,
    FutureOr<void> Function()? onDispose,
  ) async {
    final stale = _singleton();
    if (stale != null && stale.isDisposed) await _releaseSingleton(stale);

    StreamVideo? streamVideo;
    try {
      streamVideo = await createStreamVideo();
      if (streamVideo == null) return null;

      // ignore: cancel_subscriptions -- cancelled by _BackgroundSession.release.
      final observers = streamVideo.observeCoreRingingEventsForBackground();

      final session = _BackgroundSession(
        streamVideo: streamVideo,
        observers: observers,
        onDispose: onDispose,
      );

      // Whatever the user does with the notification is what ends this
      // isolate's work.
      session.resolution = streamVideo.onRingingEvent<RingingEvent>((event) {
        if (event is ActionCallAccept ||
            event is ActionCallDecline ||
            event is ActionCallTimeout ||
            event is ActionCallEnded) {
          session.releaseAfter(_resolutionGrace);
        }
      });

      _session = session;
      return session;
    } catch (e, stk) {
      streamLog.e(_tag, () => '[startSession] failed: $e; $stk');

      await streamVideo?.dispose();
      await _releaseSingleton(streamVideo);
      await onDispose?.call();

      rethrow;
    }
  }

  /// Drops the session this isolate is holding, for tests that run more than
  /// one case in the same isolate.
  @visibleForTesting
  static Future<void> releaseForTesting() =>
      _session?.release() ?? Future.value();
}

/// One isolate's client, its observers, and how to let go of them.
class _BackgroundSession {
  _BackgroundSession({
    required this.streamVideo,
    required this.observers,
    required this.onDispose,
  });

  final StreamVideo streamVideo;
  final CompositeSubscription observers;
  final FutureOr<void> Function()? onDispose;

  StreamSubscription<RingingEvent>? resolution;

  /// Whether a ringing flow is still waiting to be resolved by the user.
  bool awaitingResolution = false;

  bool _released = false;

  /// Releases after [delay], so a flow that is still running finishes first.
  void releaseAfter(Duration delay) =>
      unawaited(Future<void>.delayed(delay, release));

  /// Tears the session down, once.
  ///
  /// Idempotent because more than one thing can decide the isolate is done: a
  /// resolved notification, a message that turned out not to be ours, or a
  /// failure part way through.
  Future<void> release() async {
    if (_released) return;
    _released = true;

    if (StreamVideoPushHandler._session == this) {
      StreamVideoPushHandler._session = null;
    }

    await resolution?.cancel();
    await observers.cancel();
    await streamVideo.dispose();

    // `dispose` leaves the singleton installed, if this client is what is
    // installed at all: one built with `StreamVideo.create` never took the
    // slot.
    await StreamVideoPushHandler._releaseSingleton(streamVideo);

    await onDispose?.call();
  }
}
