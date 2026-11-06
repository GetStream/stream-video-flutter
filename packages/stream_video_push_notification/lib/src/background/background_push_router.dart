import 'dart:async';

import 'package:stream_video/stream_video.dart';
import 'package:synchronized/synchronized.dart';

import 'background_session.dart';

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

/// Routes one isolate's background pushes: to the client the app is already
/// running, or to a session of its own that it builds, keeps while a ring
/// waits on the user, and tears down again.
///
/// One instance per isolate; `StreamVideoPushHandler` holds it.
class BackgroundPushRouter {
  BackgroundPushRouter({
    this.resolutionGrace = const Duration(seconds: 1),
    bool Function()? ownsClientLifecycle,
  }) : ownsClientLifecycle =
           ownsClientLifecycle ?? (() => CurrentPlatform.isAndroid);

  static const _tag = 'SV:BackgroundPush';

  /// How long to wait before tearing the client down, so the flow that is
  /// resolving the notification finishes first.
  Duration resolutionGrace;

  /// Whether this router owns the client's lifecycle where it is running.
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
  bool Function() ownsClientLifecycle;

  /// The client and observers for this isolate, or null when none is running.
  ///
  /// Kept because the isolate outlives a single message: a second push can
  /// arrive while the first call is still ringing.
  BackgroundSession? _session;

  /// Serialises everything that touches [_session].
  ///
  /// Firebase delivers background messages concurrently on the same isolate,
  /// so a mutex prevents race conditions creating duplicate clients and losing cleanup.
  final _lock = Lock();

  /// Handles a Stream call notification in the background.
  ///
  /// Returns `true` if the push was a Stream Video notification and was handled;
  /// otherwise returns `false`.
  Future<bool> handle(
    Map<String, dynamic> data, {
    required CreateStreamVideo createStreamVideo,
    ResolveExistingClient? existingClient,
    FutureOr<void> Function()? onDispose,
  }) {
    if (!StreamPushPayload.isStreamPush(data)) return Future.value(false);

    if (!ownsClientLifecycle()) {
      return _handleOnAppIsolate(data, existingClient);
    }

    return _lock.synchronized(
      () =>
          _handleStreamPush(data, createStreamVideo, existingClient, onDispose),
    );
  }

  /// Drops the session this isolate is holding, for tests that run more than
  /// one case in the same isolate.
  Future<void> releaseSession() => _lock.synchronized(() async {
    await _session?.release();
  });

  /// Handles a push that arrived on the app's own isolate.
  ///
  /// Every push is forwarded to the client the app is already running, whatever
  /// it carries: an iOS app that rings over Firebase rather than PushKit needs
  /// its ringing pushes handled here just as much as its missed calls. What
  /// does not happen is building one — that client is the app's.
  Future<bool> _handleOnAppIsolate(
    Map<String, dynamic> data,
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

    final handled = await appClient.ringing.handleRingingFlowNotifications(
      data,
    );

    return handled;
  }

  /// Handles one Stream push, with this isolate's session to itself.
  Future<bool> _handleStreamPush(
    Map<String, dynamic> data,
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

          return await appClient.ringing.handleRingingFlowNotifications(data);
        }

        mine = await _startSession(createStreamVideo, onDispose);

        // Nobody is logged in, so there is no client to show anything with and
        // nothing to tear down but what the app itself set up.
        if (mine == null) {
          await onDispose?.call();
          return false;
        }
      }

      return await _handleWithSession(mine, data);
    } catch (e, stk) {
      streamLog.e(_tag, () => '[handleStreamPush] failed: $e; $stk');
      mine?.releaseAfter(resolutionGrace);
      return false;
    }
  }

  /// Runs [data] through [session]'s client, releasing the session when
  /// nothing is left for it to wait for.
  Future<bool> _handleWithSession(
    BackgroundSession session,
    Map<String, dynamic> data,
  ) async {
    final handled = await session.streamVideo.ringing
        .handleRingingFlowNotifications(data);

    final ringing = StreamPushPayload.ringingCallCid(data);
    if (handled && ringing != null) {
      // The user has to answer this one, and whatever they do arms the
      // release.
      session.ledger.addRing(ringing);
    } else {
      // A missed call for a ring this session holds says that ring is over,
      // even when the socket that would have said so was down.
      if (StreamPushPayload.isMissedCallPush(data)) {
        session.ledger.markEnded(StreamPushPayload.callCidOf(data));
      }

      session.releaseAfter(resolutionGrace);
    }

    return handled;
  }

  /// The client already living in this isolate, if there is a usable one.
  ///
  /// Only ever a client this router did not build: a session of its own is
  /// checked first.
  StreamVideo? _existingClient(ResolveExistingClient? resolve) {
    final client = resolve != null ? resolve() : _singleton();
    if (client == null || client.isDisposed) return null;

    return client;
  }

  /// The installed singleton, or null when there is none.
  ///
  /// An app can run without one: [StreamVideo.create] builds a client that
  /// never takes the slot. Nothing here may assume the slot is filled, or that
  /// what fills it is the client at hand.
  StreamVideo? _singleton() =>
      StreamVideo.isInitialized() ? StreamVideo.instance : null;

  /// Clears the singleton slot if [client] is what is in it.
  ///
  /// Disposing a client leaves the slot occupied, and a later message in the
  /// same isolate would find it holding something dead. A client that never
  /// took the slot leaves nothing to clear, and one belonging to somebody else
  /// is not this router's to take.
  Future<void> _releaseSingleton(StreamVideo? client) async {
    if (client == null || !identical(_singleton(), client)) return;

    await StreamVideo.reset();
  }

  /// Starts this isolate's session, or returns null when nobody is logged in.
  Future<BackgroundSession?> _startSession(
    CreateStreamVideo createStreamVideo,
    FutureOr<void> Function()? onDispose,
  ) async {
    final stale = _singleton();
    if (stale != null && stale.isDisposed) await _releaseSingleton(stale);

    StreamVideo? streamVideo;
    try {
      // This isolate only handles the push, so its client sets up no media.
      streamVideo = await StreamVideo.runWithoutMedia(createStreamVideo);
      if (streamVideo == null) return null;

      // ignore: cancel_subscriptions -- cancelled by BackgroundSession.release.
      final observers = streamVideo.ringing
          .observeCoreRingingEventsForBackground();

      final session = BackgroundSession(
        streamVideo: streamVideo,
        observers: observers,
        onDispose: onDispose,
        lock: _lock,
        resolutionGrace: () => resolutionGrace,
        onDetach: (session) {
          if (_session == session) _session = null;
        },
        releaseSingleton: _releaseSingleton,
        logTag: _tag,
      );

      // Whatever the user does with the notification is what ends this
      // isolate's work.
      session.resolution = streamVideo.ringing.onRingingEvent<RingingEvent>((
        event,
      ) {
        if (event
            case ActionCallAccept(:final data) ||
                ActionCallDecline(:final data) ||
                ActionCallTimeout(:final data) ||
                ActionCallEnded(:final data)) {
          if (session.ledger.resolveRing(data.callCid)) {
            session.releaseAfter(resolutionGrace);
          }
        }
      });

      // A ring can also end without the user: the caller cancels, the call
      // ends, or another device answers. The push manager then ends the
      // native call silently, so none of the events above ever arrives.
      session.ringEnds = streamVideo.events.listen((event) {
        final callCid = switch (event) {
          StreamCallRejectedEvent(:final callCid) ||
          StreamCallEndedEvent(:final callCid) ||
          StreamCallMissedEvent(:final callCid) ||
          StreamCallAcceptedEvent(:final callCid) => callCid,
          _ => null,
        };
        if (callCid == null) return;

        if (session.ledger.markEnded(callCid.value)) {
          session.releaseAfter(resolutionGrace);
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
}
