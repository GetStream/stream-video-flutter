import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';
import 'package:synchronized/synchronized.dart';

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
/// handler, and that is what this does.
///
/// Firebase spins up that background isolate on Android alone. On Apple
/// platforms your handler is called on the app's own isolate instead, where the
/// client belongs to the running app: the push is forwarded to it and nothing is
/// built or torn down. The same call site works on both:
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
/// You keep the parts that are genuinely yours, such as Firebase
/// initialization and credential management, and hand the rest over.
///
/// The `@pragma('vm:entry-point')` function remains your responsibility on
/// purpose. It is the only thing the background isolate can reach, so the
/// factory must be reachable from inside it—a factory registered at app launch
/// would simply not be there.
class StreamVideoPushHandler {
  const StreamVideoPushHandler._();

  static const _tag = 'SV:BackgroundPush';

  /// How long to wait before tearing the client down, so the flow that is
  /// resolving the notification finishes first.
  ///
  /// Not const only so a test does not have to sleep through it.
  @visibleForTesting
  static Duration resolutionGrace = const Duration(seconds: 1);

  /// The client and observers for this isolate, or null when none is running.
  ///
  /// Static because the isolate outlives a single message: a second push can
  /// arrive while the first call is still ringing.
  static _BackgroundSession? _session;

  /// Serialises everything that touches [_session].
  ///
  /// Firebase delivers background messages concurrently on the same isolate,
  /// so a mutex prevents race conditions creating duplicate clients and losing cleanup.
  static final _lock = Lock();

  /// Whether this handler owns the client's lifecycle where it is running.
  ///
  /// It does on Android, where Firebase delivers background messages to an
  /// isolate that never ran `main()`: nothing else is there to build a client
  /// or take it down again. Everywhere else the handler is called on the app's
  /// own isolate, where that belongs to the running app — a second client
  /// installed over the app's would be disposed again a second after the user
  /// answers, taking the app's own and its ringing observers with it.
  ///
  /// The one thing that genuinely differs by platform, and the only place this
  /// class asks. A function rather than a constant so a test can stand
  /// somewhere other than the host it happens to run on.
  @visibleForTesting
  static bool Function() ownsClientLifecycle = () => CurrentPlatform.isAndroid;

  /// Handles a Stream call notification in the background.
  ///
  /// Returns `true` if the push was a Stream Video notification and was handled;
  /// otherwise returns `false`.
  ///
  /// If no client exists in the isolate, this builds one using [createStreamVideo],
  /// sets up observers, and disposes of all resources (optionally via [onDispose])
  /// once the notification is resolved (answered, declined, or missed).
  ///
  /// If a client already exists (e.g., on the main app isolate), the notification
  /// is simply forwarded to it—no extra lifecycle or teardown logic runs.
  /// The [existingClient] callback lets you provide that own client if needed.
  ///
  /// Messages not intended for Stream Video are ignored, so your app can handle
  /// its own background notifications as usual.
  ///
  /// Handles multiple concurrent calls; the client stays alive until all calls finish.
  static Future<bool> handleBackgroundMessage(
    RemoteMessage message, {
    required CreateStreamVideo createStreamVideo,
    ResolveExistingClient? existingClient,
    FutureOr<void> Function()? onDispose,
  }) {
    final payload = message.data;
    if (!StreamPushPayload.isStreamPush(payload)) return Future.value(false);

    final ownsLifecycle = ownsClientLifecycle();
    if (!ownsLifecycle) {
      return _handleOnAppIsolate(message, existingClient);
    }

    return _lock.synchronized(
      () => _handleStreamPush(
        message,
        createStreamVideo,
        existingClient,
        onDispose,
      ),
    );
  }

  /// Handles a push that arrived on the app's own isolate.
  ///
  /// Every push is forwarded to the client the app is already running, whatever
  /// it carries: an iOS app that rings over Firebase rather than PushKit needs
  /// its ringing pushes handled here just as much as its missed calls. What
  /// does not happen is building one — that client is the app's.
  static Future<bool> _handleOnAppIsolate(
    RemoteMessage message,
    ResolveExistingClient? existingClient,
  ) async {
    final appClient = _existingClient(existingClient);
    if (appClient == null) {
      streamLog.w(
        _tag,
        () => '[handleOnAppIsolate] no running client; leaving the push alone',
      );

      return false;
    }

    final handled = await appClient.handleRingingFlowNotifications(
      message.data,
    );

    return handled;
  }

  /// Handles one Stream push, with this isolate's session to itself.
  static Future<bool> _handleStreamPush(
    RemoteMessage message,
    CreateStreamVideo createStreamVideo,
    ResolveExistingClient? existingClient,
    FutureOr<void> Function()? onDispose,
  ) async {
    var mine = _session;

    // A session that stood down because the app was in a call keeps its
    // client, and the app owns that client from then on — so it can be
    // disposed without this session hearing about it. Forwarding a push to a
    // dead client would drop it silently, so let the session go and start
    // over. `_existingClient` makes the same check for the app's own client.
    if (mine != null && mine.streamVideo.isDisposed) {
      streamLog.w(
        _tag,
        () => '[handleStreamPush] the session client is gone; starting over',
      );

      await mine.release();
      mine = null;
    }

    try {
      if (mine == null) {
        final appClient = _existingClient(existingClient);
        if (appClient != null) {
          streamLog.d(
            _tag,
            () => '[handleStreamPush] forwarding to the running client',
          );

          return await appClient.handleRingingFlowNotifications(message.data);
        }

        mine = await _startSession(createStreamVideo, onDispose);

        // Nobody is logged in, so there is no client to show anything with and
        // nothing to tear down but what the app itself set up.
        if (mine == null) {
          await onDispose?.call();
          return false;
        }
      }

      return await _handleWithSession(mine, message);
    } catch (e, stk) {
      streamLog.e(_tag, () => '[handleStreamPush] failed: $e; $stk');
      mine?.releaseAfter(resolutionGrace);
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

    final ringing = StreamPushPayload.ringingCallCid(message.data);
    if (handled && ringing != null) {
      // The user has to answer this one, and whatever they do arms the
      // release.
      session.pendingRings.add(ringing);
    } else {
      session.releaseAfter(resolutionGrace);
    }

    return handled;
  }

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
        if (event
            case ActionCallAccept(:final data) ||
                ActionCallDecline(:final data) ||
                ActionCallTimeout(:final data) ||
                ActionCallEnded(:final data)) {
          if (session.resolveRing(data.callCid)) {
            session.releaseAfter(resolutionGrace);
          }
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
  static Future<void> releaseForTesting() => _lock.synchronized(() async {
    await _session?.release();
  });
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

  /// The ringing flows still waiting on the user, by call cid.
  final pendingRings = <String>{};

  bool _released = false;

  /// The release this session has scheduled, if it has one.
  Timer? _pendingRelease;

  /// Releases after [delay], so a flow that is still running finishes first.
  void releaseAfter(Duration delay) {
    _pendingRelease?.cancel();
    _pendingRelease = Timer(delay, () => unawaited(_release()));
  }

  /// Marks the flow for [callCid] resolved, and reports whether this session
  /// is left with nothing to wait for.
  bool resolveRing(String? callCid) {
    if (callCid == null) {
      streamLog.w(
        StreamVideoPushHandler._tag,
        () => '[resolveRing] no call cid; releasing every pending ring',
      );

      pendingRings.clear();
    } else {
      pendingRings.remove(callCid);
    }

    return pendingRings.isEmpty;
  }

  /// The scheduled release, once it falls due.
  ///
  /// Nothing awaits this, and `onDispose` is the app's own code: an error
  /// escaping here would land in a background isolate that has no zone
  /// handler to catch it.
  Future<void> _release() async {
    try {
      await StreamVideoPushHandler._lock.synchronized(() async {
        // A ringing flow is live. Whatever resolves it arms the next release.
        if (pendingRings.isNotEmpty) {
          streamLog.d(
            StreamVideoPushHandler._tag,
            () =>
                '[release] still ringing (${pendingRings.length}); '
                'standing down',
          );

          return;
        }

        // The app answered on this client and is in the call, so the client is
        // the app's now and its lifecycle goes with it. Android delivers the
        // accept to whichever isolate is running, which is this one whenever
        // the app is alive but backgrounded - and there the accept is the
        // moment the app starts using the client, not the moment this session
        // is done with it. Disposing here drops a call that just connected.
        if (streamVideo.activeCalls.isNotEmpty) {
          streamLog.d(
            StreamVideoPushHandler._tag,
            () =>
                '[release] the app is in a call on this client; '
                'standing down',
          );

          return;
        }

        await release();
      });
    } catch (e, stk) {
      streamLog.e(
        StreamVideoPushHandler._tag,
        () => '[releaseAfter] release failed: $e; $stk',
      );
    }
  }

  /// Tears the session down, once.
  ///
  /// Only ever called holding the handler's lock. Still idempotent, because a
  /// release that falls due and one forced by a test can both decide the
  /// isolate is done.
  Future<void> release() async {
    if (_released) return;
    _released = true;

    _pendingRelease?.cancel();
    _pendingRelease = null;

    if (StreamVideoPushHandler._session == this) {
      StreamVideoPushHandler._session = null;
    }

    try {
      await resolution?.cancel();
      await observers.cancel();
      await streamVideo.dispose();
    } catch (e, stk) {
      streamLog.e(
        StreamVideoPushHandler._tag,
        () => '[release] teardown failed: $e; $stk',
      );
    } finally {
      try {
        await StreamVideoPushHandler._releaseSingleton(streamVideo);
      } catch (e, stk) {
        streamLog.e(
          StreamVideoPushHandler._tag,
          () => '[release] clearing the singleton failed: $e; $stk',
        );
      }

      await onDispose?.call();
    }
  }
}
