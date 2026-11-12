import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

import 'background/background_push_router.dart';

export 'background/background_push_router.dart'
    show CreateStreamVideo, ResolveExistingClient;

/// Runs a Stream ringing push through its whole background lifecycle.
///
/// On Android, Firebase delivers background messages to an isolate that never
/// ran `main()`, so nothing you set up at launch exists there. Everything
/// from building the client to tearing it down again needs to happen inside the
/// handler, and that is what this does.
///
/// Firebase spins up that background isolate on Android alone. On Apple
/// platforms your handler is called on the app's own isolate instead, and only
/// for data-only messages, so there is no isolate to set up: the client belongs
/// to the running app, the push is forwarded to it, and nothing is built or
/// torn down.
///
/// That is not where iOS ringing is set up. A ringing push normally reaches an
/// Apple device as a VoIP push over APNs, which PushKit and CallKit handle
/// without Firebase in the picture at all. What this covers on Apple platforms
/// is whatever Firebase does deliver, such as a missed call, or a ringing push
/// in an app that rings over Firebase rather than PushKit.
///
/// The same call site is safe on both:
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

  /// This isolate's router. Static because the isolate outlives a single
  /// message: a second push can arrive while the first call is still ringing.
  static final _router = BackgroundPushRouter();

  /// How long to wait before tearing the client down, so the flow that is
  /// resolving the notification finishes first.
  @visibleForTesting
  static Duration get resolutionGrace => _router.resolutionGrace;

  @visibleForTesting
  static set resolutionGrace(Duration value) => _router.resolutionGrace = value;

  /// Whether this handler owns the client's lifecycle where it is running.
  ///
  /// It does on Android, where Firebase delivers background messages to an
  /// isolate that never ran `main()`: nothing else is there to build a client
  /// or take it down again. Everywhere else the handler is called on the app's
  /// own isolate, where that belongs to the running app. A function rather
  /// than a constant so a test can stand somewhere other than the host it
  /// happens to run on.
  @visibleForTesting
  static bool Function() get ownsClientLifecycle => _router.ownsClientLifecycle;

  @visibleForTesting
  static set ownsClientLifecycle(bool Function() value) =>
      _router.ownsClientLifecycle = value;

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
    return _router.handle(
      message.data,
      createStreamVideo: createStreamVideo,
      existingClient: existingClient,
      onDispose: onDispose,
    );
  }

  /// Drops the session this isolate is holding, for tests that run more than
  /// one case in the same isolate.
  @visibleForTesting
  static Future<void> releaseForTesting() =>
      // ignore: invalid_use_of_visible_for_testing_member
      _router.releaseSession();
}
