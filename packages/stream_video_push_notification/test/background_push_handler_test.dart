import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

class MockCall extends Mock implements Call {}

// ignore: subtype_of_sealed_class
class MockRingingFlowCoordinator extends Mock
    implements RingingFlowCoordinator {}

// ignore: subtype_of_sealed_class
class MockStreamVideo extends Mock implements StreamVideo {
  @override
  final MockRingingFlowCoordinator ringing = MockRingingFlowCoordinator();

  // StreamVideo marks dispose as @mustBeOverridden. Routed back through the
  // mock rather than stubbed out here, since teardown is what these tests
  // verify.
  @override
  Future<void> dispose() =>
      noSuchMethod(Invocation.method(#dispose, const [])) as Future<void>;
}

class MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

// ignore: avoid_implementing_value_types
class MockRejectedEvent extends Mock implements StreamCallRejectedEvent {}

void _ignore(RingingEvent _) {}

/// The `call.rejected` a caller sends when it cancels the ring for [callCid].
StreamCallRejectedEvent _rejected(String callCid) {
  final event = MockRejectedEvent();
  when(() => event.callCid).thenReturn(StreamCallCid(cid: callCid));
  return event;
}

/// A missed call for [callCid], as the backend sends once a ring expires.
Map<String, dynamic> _missedCallPushFor(String callCid) => {
  'sender': 'stream.video',
  'type': 'call.missed',
  'call_cid': callCid,
};

/// The payload of a ringing push, the only one whose flow waits for the user.
///
/// The cid is what ties the push to the event that eventually resolves it, and
/// the SDK reports a ringing push without one as unhandled, so every fixture
/// here carries one.
///
/// Spelled out rather than built from `StreamPushPayload`: these fixtures are
/// what pins the wire format, and a constant gone wrong would otherwise agree
/// with itself on both sides and pass.
Map<String, dynamic> _ringingPushFor(String callCid) => {
  'sender': 'stream.video',
  'type': 'call.ring',
  'call_cid': callCid,
};

final _ringingPush = _ringingPushFor('default:call-a');

/// A missed call: reported as handled, but nothing ever resolves it.
const _missedCallPush = {'sender': 'stream.video', 'type': 'call.missed'};

/// A push from somebody else's integration, sharing the app's FCM channel.
const _foreignPush = {'sender': 'some.other.app', 'body': 'hello'};

/// The resolution the platform sends back for [callCid].
ActionCallDecline _declined(String callCid) => ActionCallDecline(
  data: CallData(uuid: 'u', callCid: callCid),
);

RemoteMessage _message([Map<String, dynamic>? data]) =>
    RemoteMessage(data: data ?? _ringingPush);

/// [source], through a subscription whose `cancel` completes on fake time.
///
/// A broadcast subscription's `cancel` hands back the future dart:async keeps
/// on the root zone, and the session awaits it when it releases. Awaited
/// inside a fake zone, that parks the rest of the release on the real event
/// loop, where no `elapse` reaches it. A single-subscription controller's
/// `cancel` returns what its `onCancel` does, made in the zone that cancels.
///
/// Synchronous, so an event reaches the listener on the one microtask the
/// broadcast delivery takes, as it would straight from [source].
Stream<T> _cancellableOnFakeTime<T>(Stream<T> source) {
  StreamSubscription<T>? forwarding;
  late final StreamController<T> controller;
  controller = StreamController<T>(
    sync: true,
    onListen: () => forwarding = source.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    ),
    onCancel: () {
      unawaited(forwarding?.cancel());
      unawaited(controller.close());
      return Future<void>.value();
    },
  );
  return controller.stream;
}

/// A test body on fake time: the grace and every delay inside it pass with
/// `async.elapse`, so no test sleeps.
dynamic Function() onFakeTime(void Function(FakeAsync async) body) =>
    () => fakeAsync(body);

/// Drives [future] to completion on fake time and returns its value.
///
/// Stubs answer on microtasks, so a flush completes most futures. One waiting
/// on a timer, such as a slow factory's delay, needs that time passed as
/// [elapsing]. A future still pending after that throws, rather than leaving a
/// half-run handler for the assertions that follow to look at.
T run<T>(FakeAsync async, Future<T> future, {Duration? elapsing}) {
  var done = false;
  late T value;
  Object? error;
  StackTrace? stackTrace;

  // Listening before any time passes: a future that fails in the fake zone
  // with nobody listening surfaces as an unhandled error instead.
  unawaited(
    future.then(
      (result) {
        value = result;
        done = true;
      },
      onError: (Object e, StackTrace s) {
        error = e;
        stackTrace = s;
        done = true;
      },
    ),
  );

  if (elapsing != null) {
    async.elapse(elapsing);
  } else {
    async.flushMicrotasks();
  }

  if (!done) {
    throw StateError(
      'The future did not complete on fake time; it is waiting on a timer, '
      'so pass the delay as `elapsing`.',
    );
  }
  if (error != null) Error.throwWithStackTrace(error!, stackTrace!);

  return value;
}

void main() {
  registerFallbackValue((RingingEvent _) {});

  late MockStreamVideo client;
  late StreamController<RingingEvent> ringing;
  late StreamController<StreamVideoEvent> coordinatorEvents;
  late MockPushNotificationManager pushManager;

  /// The calls the platform shows, as the push manager reads them back.
  late List<CallData> nativeCalls;

  /// The callback the handler registered for ringing resolution.
  void Function(RingingEvent)? onRingingEvent;

  /// Whether the handler asked for a client, and how many times.
  late int factoryCalls;
  late bool onDisposeCalled;

  /// A factory returning [client], or null to stand in for "nobody logged in".
  CreateStreamVideo factoryReturning(StreamVideo? value) => () async {
    factoryCalls++;
    return value;
  };

  Future<bool> handle({
    required CreateStreamVideo createStreamVideo,
    ResolveExistingClient? existingClient,
    Map<String, dynamic>? data,
  }) {
    return StreamVideoPushHandler.handleBackgroundMessage(
      _message(data),
      createStreamVideo: createStreamVideo,
      existingClient: existingClient,
      onDispose: () => onDisposeCalled = true,
    );
  }

  /// A client stubbed for the happy path: live, observable, and handling
  /// whatever it is given.
  MockStreamVideo stubbedClient() {
    final stub = MockStreamVideo();

    when(() => stub.isDisposed).thenReturn(false);
    when(() => stub.activeCalls).thenReturn([]);
    when(
      () => stub.events,
    ).thenAnswer((_) => _cancellableOnFakeTime(coordinatorEvents.stream));
    when(() => stub.pushNotificationManager).thenReturn(pushManager);
    when(stub.dispose).thenAnswer((_) async {});
    when(
      stub.ringing.observeCoreRingingEventsForBackground,
    ).thenReturn(CompositeSubscription());
    when(
      () => stub.ringing.onRingingEvent<RingingEvent>(captureAny()),
    ).thenAnswer((
      invocation,
    ) {
      onRingingEvent =
          invocation.positionalArguments.first as void Function(RingingEvent);
      return _cancellableOnFakeTime(ringing.stream).listen(_ignore);
    });
    when(
      () => stub.ringing.handleRingingFlowNotifications(any()),
    ).thenAnswer((_) async => true);

    return stub;
  }

  /// Long enough that nothing resolves inside it by accident. Fake time, so
  /// no test has to sleep through it.
  const grace = Duration(milliseconds: 20);

  /// Comfortably past a scheduled release falling due.
  void pastTheGrace(FakeAsync async) => async.elapse(grace * 6);

  /// Past the release and every check a ring that may have ended gets.
  void pastEveryCheck(FakeAsync async) => async.elapse(grace * 20);

  setUp(() {
    // Everything outside the group below is the Android background isolate:
    // the only place this handler owns a client.
    StreamVideoPushHandler.ownsClientLifecycle = () => true;
    StreamVideoPushHandler.resolutionGrace = grace;
    ringing = StreamController<RingingEvent>.broadcast();
    coordinatorEvents = StreamController<StreamVideoEvent>.broadcast();
    nativeCalls = [];
    pushManager = MockPushNotificationManager();
    when(pushManager.activeCalls).thenAnswer((_) async => nativeCalls);
    onRingingEvent = null;
    factoryCalls = 0;
    onDisposeCalled = false;
    client = stubbedClient();
  });

  // On real time, outside the test's fake zone. Nothing here waits on a timer,
  // and a release a test left scheduled on fake time never fires, so the
  // session a test kept is let go of here.
  tearDown(() async {
    await StreamVideoPushHandler.releaseForTesting();
    await ringing.close();
    await coordinatorEvents.close();
    StreamVideoPushHandler.resolutionGrace = const Duration(seconds: 1);
    StreamVideoPushHandler.ownsClientLifecycle = () =>
        CurrentPlatform.isAndroid;
  });

  group('StreamVideoPushHandler', () {
    test(
      'reports a ringing push as handled and keeps the client alive',
      onFakeTime((async) {
        final handled = run(
          async,
          handle(createStreamVideo: factoryReturning(client)),
        );

        expect(handled, isTrue);
        // Still ringing: disposing here would take the notification with it.
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      }),
    );

    test(
      'builds its client without media',
      onFakeTime((async) {
        bool? withoutMediaAtStart;
        bool? withoutMediaAfterAwait;

        run(
          async,
          handle(
            createStreamVideo: () async {
              withoutMediaAtStart = StreamVideo.debugBuildsWithoutMedia;
              // A factory that reads credentials first still builds inside it.
              await Future<void>.delayed(Duration.zero);
              withoutMediaAfterAwait = StreamVideo.debugBuildsWithoutMedia;
              return client;
            },
          ),
          // A zero delay is still a timer: it takes a tick, not a flush.
          elapsing: Duration.zero,
        );

        expect(withoutMediaAtStart, isTrue);
        expect(withoutMediaAfterAwait, isTrue);
        expect(StreamVideo.debugBuildsWithoutMedia, isFalse);
      }),
    );

    test(
      'does nothing when nobody is logged in',
      onFakeTime((async) {
        final handled = run(
          async,
          handle(createStreamVideo: factoryReturning(null)),
        );

        expect(handled, isFalse);
        // Whatever the factory set up on its way to finding no credentials
        // still has to come back down.
        expect(onDisposeCalled, isTrue);
      }),
    );

    test(
      'releases once the user resolves the notification',
      onFakeTime((async) {
        run(async, handle(createStreamVideo: factoryReturning(client)));

        onRingingEvent!(_declined('default:call-a'));
        // Teardown is deferred so the flow resolving the call finishes first.
        verifyNever(() => client.dispose());

        pastTheGrace(async);

        verify(() => client.dispose()).called(1);
        expect(onDisposeCalled, isTrue);
      }),
    );

    test(
      'ignores ringing events that are not a resolution',
      onFakeTime((async) {
        run(async, handle(createStreamVideo: factoryReturning(client)));

        onRingingEvent!(const ActionCallIncoming(data: CallData(uuid: 'u')));
        pastTheGrace(async);

        // An incoming call is the *start* of the flow this isolate exists for.
        verifyNever(() => client.dispose());
      }),
    );

    test(
      'releases a message that turns out not to be ours',
      onFakeTime((async) {
        when(
          () => client.ringing.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => false);

        final handled = run(
          async,
          handle(createStreamVideo: factoryReturning(client)),
        );

        expect(handled, isFalse);
        // No ringing event is ever coming, so nothing else would let go of the
        // isolate.
        pastTheGrace(async);
        verify(() => client.dispose()).called(1);
        expect(onDisposeCalled, isTrue);
      }),
    );

    test(
      'builds the client once for two messages in the same isolate',
      onFakeTime((async) {
        run(async, handle(createStreamVideo: factoryReturning(client)));
        run(async, handle(createStreamVideo: factoryReturning(client)));

        // Calling the factory twice would install a second singleton over a
        // live one, which throws.
        expect(factoryCalls, 1);
        verify(
          () => client.ringing.handleRingingFlowNotifications(any()),
        ).called(2);
        // And the second message must not wire a second set of observers.
        verify(client.ringing.observeCoreRingingEventsForBackground).called(1);
      }),
    );

    test(
      'a foreign message arriving mid-ring does not cut the ring short',
      onFakeTime((async) {
        run(async, handle(createStreamVideo: factoryReturning(client)));

        when(
          () => client.ringing.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => false);
        run(async, handle(createStreamVideo: factoryReturning(client)));
        // The unhandled push schedules a release; it has to fall due and
        // stand down for the assertion to mean anything.
        pastTheGrace(async);

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      }),
    );

    test(
      'reaches the app teardown even when dispose throws',
      onFakeTime((async) {
        when(client.dispose).thenThrow(Exception('boom'));

        run(
          async,
          handle(
            createStreamVideo: factoryReturning(client),
            data: _missedCallPush,
          ),
        );
        pastTheGrace(async);

        // The client's teardown failing must not strand the app's own: nothing
        // can retry this release, and the dependencies would stay registered.
        expect(onDisposeCalled, isTrue);

        // And the isolate still has to be able to take the next call.
        onDisposeCalled = false;
        final handled = run(
          async,
          handle(createStreamVideo: factoryReturning(stubbedClient())),
        );

        expect(handled, isTrue);
        expect(factoryCalls, 2);
      }),
    );

    test(
      'a failing setup is torn down before the next push tries',
      onFakeTime((async) {
        var disposeCalls = 0;
        var setUp = 0;
        Future<bool> race() => StreamVideoPushHandler.handleBackgroundMessage(
          _message(),
          createStreamVideo: () async {
            factoryCalls++;
            setUp++;
            await Future<void>.delayed(grace);
            throw Exception('no network');
          },
          onDispose: () {
            // Resetting the app's dependencies while the other push is still
            // using them would wipe them mid-flight.
            expect(setUp, 1);
            setUp--;
            disposeCalls++;
          },
        );

        // Started back to back; each attempt waits the grace out in turn.
        final handled = run(
          async,
          Future.wait([race(), race()]),
          elapsing: grace * 2,
        );

        expect(handled, [false, false]);
        // Each push gets its own attempt—the second is a retry, not a rider on
        // a failure it never saw—and the two never overlap.
        expect(factoryCalls, 2);
        expect(disposeCalls, 2);
      }),
    );

    test(
      'two pushes racing the setup share one session',
      onFakeTime((async) {
        CreateStreamVideo slowFactory(StreamVideo value) => () async {
          factoryCalls++;
          await Future<void>.delayed(grace);
          return value;
        };

        // Firebase drains the messages buffered during a cold start back to
        // back, so the second push lands while the first is still awaiting its
        // token fetch.
        final handled = run(
          async,
          Future.wait([
            handle(createStreamVideo: slowFactory(client)),
            handle(createStreamVideo: slowFactory(client)),
          ]),
          elapsing: grace,
        );

        // A second client would leak: nothing disposes it, and the app's own
        // factory is the thing that trips over being called twice.
        expect(factoryCalls, 1);
        expect(handled, [true, true]);
        // One session means one set of observers and one teardown.
        verify(client.ringing.observeCoreRingingEventsForBackground).called(1);
        verify(
          () => client.ringing.handleRingingFlowNotifications(any()),
        ).called(2);
        expect(onDisposeCalled, isFalse);
      }),
    );

    test(
      'releases when handling throws',
      onFakeTime((async) {
        when(
          () => client.ringing.handleRingingFlowNotifications(any()),
        ).thenThrow(Exception('boom'));

        final handled = run(
          async,
          handle(createStreamVideo: factoryReturning(client)),
        );

        expect(handled, isFalse);
        pastTheGrace(async);
        verify(() => client.dispose()).called(1);
        expect(onDisposeCalled, isTrue);
      }),
    );

    test(
      'releases a missed call, which nothing else resolves',
      onFakeTime((async) {
        final handled = run(
          async,
          handle(
            createStreamVideo: factoryReturning(client),
            data: _missedCallPush,
          ),
        );

        // Handled — the notification was posted — but no accept, decline,
        // timeout or end is ever emitted for a missed call.
        expect(handled, isTrue);
        // Not immediately: the SDK posts the notification without waiting.
        verifyNever(() => client.dispose());

        pastTheGrace(async);

        verify(() => client.dispose()).called(1);
        expect(onDisposeCalled, isTrue);
      }),
    );

    test(
      'a missed call arriving mid-ring does not cut the ring short',
      onFakeTime((async) {
        run(async, handle(createStreamVideo: factoryReturning(client)));
        run(
          async,
          handle(
            createStreamVideo: factoryReturning(client),
            data: _missedCallPush,
          ),
        );

        pastTheGrace(async);

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      }),
    );

    test(
      'a ring still in flight when the release falls due survives',
      onFakeTime((async) {
        run(
          async,
          handle(
            createStreamVideo: factoryReturning(client),
            data: _missedCallPush,
          ),
        );

        // The ring lands just before the missed call's release falls due and
        // takes longer than the grace to handle, so the release comes up while
        // the ring is still in flight.
        async.elapse(grace ~/ 2);
        when(
          () => client.ringing.handleRingingFlowNotifications(any()),
        ).thenAnswer((
          _,
        ) async {
          await Future<void>.delayed(grace * 2);
          return true;
        });
        run(
          async,
          handle(createStreamVideo: factoryReturning(client)),
          elapsing: grace * 2,
        );

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      }),
    );

    test(
      'a ring arriving after a missed call is not cut short',
      onFakeTime((async) {
        run(
          async,
          handle(
            createStreamVideo: factoryReturning(client),
            data: _missedCallPush,
          ),
        );
        // Inside the grace window the missed call opened, the caller rings.
        run(async, handle(createStreamVideo: factoryReturning(client)));

        pastTheGrace(async);

        // The release the missed call scheduled would otherwise have taken the
        // ringing client with it.
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      }),
    );

    test(
      'a ring arriving inside the resolution grace keeps the client',
      onFakeTime((async) {
        run(async, handle(createStreamVideo: factoryReturning(client)));

        onRingingEvent!(_declined('default:call-a'));
        // The caller rings straight back, before the deferred teardown runs.
        run(async, handle(createStreamVideo: factoryReturning(client)));

        pastTheGrace(async);

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      }),
    );

    group('when the setup fails part way through', () {
      test(
        'undoes what the factory managed to set up',
        onFakeTime((async) {
          final handled = run(
            async,
            handle(
              createStreamVideo: () async {
                factoryCalls++;
                throw Exception('no credentials');
              },
            ),
          );

          expect(handled, isFalse);
          // Whatever the factory registered before it threw has to come back
          // down, or the next message finds a half set up isolate.
          expect(onDisposeCalled, isTrue);
        }),
      );

      test(
        'disposes a client built before the failure',
        onFakeTime((async) {
          when(
            client.ringing.observeCoreRingingEventsForBackground,
          ).thenThrow(Exception('boom'));

          final handled = run(
            async,
            handle(createStreamVideo: factoryReturning(client)),
          );

          expect(handled, isFalse);
          verify(() => client.dispose()).called(1);
          expect(onDisposeCalled, isTrue);
        }),
      );

      test(
        'leaves nothing behind for the next message',
        onFakeTime((async) {
          var fail = true;
          Future<StreamVideo?> factory() async {
            factoryCalls++;
            if (fail) throw Exception('no network');
            return client;
          }

          run(async, handle(createStreamVideo: factory));
          fail = false;
          final handled = run(async, handle(createStreamVideo: factory));

          expect(handled, isTrue);
          expect(factoryCalls, 2);
        }),
      );
    });

    group('when the app is already running in this isolate', () {
      // Firebase only spins up a background isolate on Android; on Apple
      // platforms this handler is called on the app's own isolate, where a
      // client is already live. An app that builds its client with
      // `StreamVideo.create` installs no singleton, so it says where the
      // client is.
      late ResolveExistingClient existingClient;

      setUp(() => existingClient = () => client);

      Future<bool> handleOnAppIsolate({
        CreateStreamVideo? createStreamVideo,
        Map<String, dynamic>? data,
      }) {
        return handle(
          createStreamVideo: createStreamVideo ?? factoryReturning(client),
          existingClient: existingClient,
          data: data,
        );
      }

      test(
        'forwards the message to the running client',
        onFakeTime((async) {
          final handled = run(
            async,
            handleOnAppIsolate(
              createStreamVideo: factoryReturning(MockStreamVideo()),
            ),
          );

          expect(handled, isTrue);
          verify(
            () => client.ringing.handleRingingFlowNotifications(any()),
          ).called(1);
          // Nothing to build: the running app already has a client.
          expect(factoryCalls, 0);
        }),
      );

      test(
        'never observes ringing events on a client it does not own',
        onFakeTime((async) {
          run(async, handleOnAppIsolate());

          // The running app has its own observers; a second set would show
          // every incoming call twice.
          verifyNever(client.ringing.observeCoreRingingEventsForBackground);
        }),
      );

      test(
        'ignores a disposed client and builds its own',
        onFakeTime((async) {
          // Nothing can be forwarded to a client that is already gone.
          when(() => client.isDisposed).thenReturn(true);
          final ours = stubbedClient();

          final handled = run(
            async,
            handleOnAppIsolate(createStreamVideo: factoryReturning(ours)),
          );

          expect(handled, isTrue);
          expect(factoryCalls, 1);
          verifyNever(
            () => client.ringing.handleRingingFlowNotifications(any()),
          );
          verify(
            () => ours.ringing.handleRingingFlowNotifications(any()),
          ).called(1);
        }),
      );

      test(
        'leaves the running client alone for a foreign message',
        onFakeTime((async) {
          when(
            () => client.ringing.handleRingingFlowNotifications(any()),
          ).thenAnswer((_) async => false);

          final handled = run(async, handleOnAppIsolate());

          expect(handled, isFalse);
          // Disposing here would take the live app's client and dependencies
          // down with it.
          verifyNever(() => client.dispose());
          expect(onDisposeCalled, isFalse);
        }),
      );

      test(
        'leaves the running client alone once a call resolves',
        onFakeTime((async) {
          run(async, handleOnAppIsolate());

          // No resolution observer was registered, so nothing is scheduled.
          expect(onRingingEvent, isNull);
          expect(async.nonPeriodicTimerCount, 0);

          pastTheGrace(async);

          verifyNever(() => client.dispose());
          expect(onDisposeCalled, isFalse);
        }),
      );
    });

    group('when a ring ends without the user', () {
      // The push manager ends the native call silently on these, so no accept,
      // decline, timeout or end ever reaches the handler.

      test(
        'releases once the caller cancels the ring',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));

          coordinatorEvents.add(_rejected('default:call-a'));
          pastTheGrace(async);

          verify(() => client.dispose()).called(1);
          expect(onDisposeCalled, isTrue);
        }),
      );

      test(
        'releases on a missed call for the ring, with no socket',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));

          run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _missedCallPushFor('default:call-a'),
            ),
          );
          pastTheGrace(async);

          verify(() => client.dispose()).called(1);
        }),
      );

      test(
        'releases once a slow native end catches up',
        onFakeTime((async) {
          // `endCall` only sends a broadcast, and a backgrounded app may handle
          // it after the first check: the call is still listed, then gone.
          var reads = 0;
          when(pushManager.activeCalls).thenAnswer(
            (_) async => reads++ == 0
                ? [const CallData(uuid: 'u', callCid: 'default:call-a')]
                : <CallData>[],
          );
          run(async, handle(createStreamVideo: factoryReturning(client)));

          coordinatorEvents.add(_rejected('default:call-a'));
          pastEveryCheck(async);

          // Kept on the first check, released on the next.
          expect(reads, 2);
          verify(() => client.dispose()).called(1);
        }),
      );

      test(
        'keeps a ring whose native call stays shown',
        onFakeTime((async) {
          // One member of a group call declining leaves the ring up for the
          // rest, and the push manager leaves the native call alone.
          nativeCalls = [const CallData(uuid: 'u', callCid: 'default:call-a')];
          run(async, handle(createStreamVideo: factoryReturning(client)));

          coordinatorEvents.add(_rejected('default:call-a'));
          pastEveryCheck(async);

          verifyNever(() => client.dispose());
          // Checked a bounded number of times, then left to the user.
          verify(pushManager.activeCalls).called(5);
        }),
      );

      test(
        'ignores an end for a call it is not ringing',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));

          coordinatorEvents.add(_rejected('default:call-b'));
          pastTheGrace(async);

          verifyNever(() => client.dispose());
        }),
      );

      test(
        'checks again when the native calls cannot be read',
        onFakeTime((async) {
          var reads = 0;
          when(pushManager.activeCalls).thenAnswer((_) async {
            if (reads++ == 0) throw Exception('no platform');
            return nativeCalls;
          });
          run(async, handle(createStreamVideo: factoryReturning(client)));

          coordinatorEvents.add(_rejected('default:call-a'));
          pastEveryCheck(async);

          // Not knowing is no reason to end a call the user may still answer,
          // so the ring survives the failed read and goes on the next one.
          expect(reads, 2);
          verify(() => client.dispose()).called(1);
        }),
      );

      test(
        'keeps the ring when the native calls never read',
        onFakeTime((async) {
          when(pushManager.activeCalls).thenThrow(Exception('no platform'));
          run(async, handle(createStreamVideo: factoryReturning(client)));

          coordinatorEvents.add(_rejected('default:call-a'));
          pastEveryCheck(async);

          verifyNever(() => client.dispose());
          verify(pushManager.activeCalls).called(5);
        }),
      );

      test(
        'keeps a ring that rings again before the release',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));

          coordinatorEvents.add(_rejected('default:call-a'));
          // The caller rings straight back, before its native call is posted.
          run(async, handle(createStreamVideo: factoryReturning(client)));
          pastTheGrace(async);

          verifyNever(() => client.dispose());
        }),
      );

      test(
        'releases only once every ring has ended',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));
          run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _ringingPushFor('default:call-b'),
            ),
          );

          coordinatorEvents.add(_rejected('default:call-a'));
          pastTheGrace(async);
          verifyNever(() => client.dispose());

          coordinatorEvents.add(_rejected('default:call-b'));
          pastTheGrace(async);
          verify(() => client.dispose()).called(1);
        }),
      );
    });

    group('when more than one call is ringing', () {
      test(
        'resolving one leaves the other one ringing',
        onFakeTime((async) {
          // Caller A rings, then caller B rings while A is still up.
          run(async, handle(createStreamVideo: factoryReturning(client)));
          run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _ringingPushFor('default:call-b'),
            ),
          );

          // The user declines B. A is still on screen.
          onRingingEvent!(_declined('default:call-b'));
          pastTheGrace(async);

          // Disposing here would leave A ringing with nothing behind it to
          // deliver whatever the user does next.
          verifyNever(() => client.dispose());
          expect(onDisposeCalled, isFalse);
        }),
      );

      test(
        'releases once the last one is resolved',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));
          run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _ringingPushFor('default:call-b'),
            ),
          );

          onRingingEvent!(_declined('default:call-b'));
          onRingingEvent!(_declined('default:call-a'));
          pastTheGrace(async);

          verify(() => client.dispose()).called(1);
          expect(onDisposeCalled, isTrue);
        }),
      );

      test(
        'a late event for a call already let go of changes nothing',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));
          run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _ringingPushFor('default:call-b'),
            ),
          );

          onRingingEvent!(_declined('default:call-b'));
          // The platform reports B ending as well as being declined. It is not
          // a second resolution, and must not be taken for A's.
          onRingingEvent!(
            const ActionCallEnded(
              data: CallData(uuid: 'u', callCid: 'default:call-b'),
            ),
          );
          pastTheGrace(async);

          verifyNever(() => client.dispose());
        }),
      );

      test(
        'an event without a cid resolves everything',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));
          run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _ringingPushFor('default:call-b'),
            ),
          );

          // Nothing says which call this resolves, so the session cannot be
          // reasoned about any more. Letting go beats holding the isolate open
          // for a call nothing will ever resolve.
          onRingingEvent!(const ActionCallDecline(data: CallData(uuid: 'u')));
          pastTheGrace(async);

          verify(() => client.dispose()).called(1);
          expect(onDisposeCalled, isTrue);
        }),
      );
    });

    test(
      'starts over when the app disposed the client',
      onFakeTime((async) {
        run(async, handle(createStreamVideo: factoryReturning(client)));
        when(() => client.isDisposed).thenReturn(true);

        // The next push must not be forwarded into a dead client.
        final fresh = stubbedClient();
        final handled = run(
          async,
          handle(createStreamVideo: factoryReturning(fresh)),
        );

        expect(handled, isTrue);
        expect(factoryCalls, 2);
        verify(
          () => fresh.ringing.handleRingingFlowNotifications(any()),
        ).called(1);
      }),
    );

    test(
      'releases the client after an accept, also with a call on it',
      onFakeTime((async) {
        run(async, handle(createStreamVideo: factoryReturning(client)));

        when(() => client.activeCalls).thenReturn([MockCall()]);
        onRingingEvent!(
          const ActionCallAccept(
            data: CallData(uuid: 'u', callCid: 'default:call-a'),
          ),
        );
        pastTheGrace(async);

        verify(() => client.dispose()).called(1);
        expect(onDisposeCalled, isTrue);
      }),
    );

    group('when the push is not ours', () {
      test(
        'builds nothing for it',
        onFakeTime((async) {
          final handled = run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _foreignPush,
            ),
          );

          expect(handled, isFalse);
          // A token fetch and everything the app's factory sets up around it,
          // spent on a push the SDK could never have acted on.
          expect(factoryCalls, 0);
          verifyNever(
            () => client.ringing.handleRingingFlowNotifications(any()),
          );
        }),
      );

      test(
        'does not disturb a call that is ringing',
        onFakeTime((async) {
          run(async, handle(createStreamVideo: factoryReturning(client)));

          final handled = run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _foreignPush,
            ),
          );
          pastTheGrace(async);

          expect(handled, isFalse);
          verifyNever(() => client.dispose());
          expect(onDisposeCalled, isFalse);
        }),
      );

      test(
        'is turned away on the app isolate too',
        onFakeTime((async) {
          final handled = run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              existingClient: () => client,
              data: _foreignPush,
            ),
          );

          expect(handled, isFalse);
          verifyNever(
            () => client.ringing.handleRingingFlowNotifications(any()),
          );
        }),
      );
    });

    group('when two pushes race the setup', () {
      /// A factory slow enough that the second push lands mid-setup.
      CreateStreamVideo slowFactory() => () async {
        factoryCalls++;
        await Future<void>.delayed(grace);
        return client;
      };

      test(
        'an unhandled one does not release under a live ring',
        onFakeTime((async) {
          // The first push is for a call answered on another device, so the
          // SDK reports it unhandled; the second is a real ring.
          var calls = 0;
          when(
            () => client.ringing.handleRingingFlowNotifications(any()),
          ).thenAnswer((_) async => calls++ != 0);

          run(
            async,
            Future.wait([
              handle(createStreamVideo: slowFactory()),
              handle(createStreamVideo: slowFactory()),
            ]),
            elapsing: grace,
          );
          pastTheGrace(async);

          expect(factoryCalls, 1);
          // Both were handed the one session, so the first must not tear it
          // down before the second has even asked the client.
          verifyNever(() => client.dispose());
          expect(onDisposeCalled, isFalse);
        }),
      );

      test(
        'one that throws does not release under a live ring',
        onFakeTime((async) {
          var calls = 0;
          when(
            () => client.ringing.handleRingingFlowNotifications(any()),
          ).thenAnswer((
            _,
          ) async {
            if (calls++ == 0) throw Exception('boom');
            return true;
          });

          run(
            async,
            Future.wait([
              handle(createStreamVideo: slowFactory()),
              handle(createStreamVideo: slowFactory()),
            ]),
            elapsing: grace,
          );
          pastTheGrace(async);

          verifyNever(() => client.dispose());
          expect(onDisposeCalled, isFalse);
        }),
      );
    });

    group("on the app's own isolate", () {
      // Firebase spins up a background isolate on Android alone. On Apple
      // platforms the handler is called where the app already lives, and the
      // device is registered for both a VoIP and a regular push, so a ring
      // arrives twice.
      setUp(() => StreamVideoPushHandler.ownsClientLifecycle = () => false);

      test(
        'forwards a ringing push to the running client',
        onFakeTime((async) {
          final handled = run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              existingClient: () => client,
            ),
          );

          // An iOS app that rings over Firebase rather than PushKit gets its
          // incoming calls from here; dropping them would show nothing at all.
          expect(handled, isTrue);
          verify(
            () => client.ringing.handleRingingFlowNotifications(any()),
          ).called(1);
          expect(factoryCalls, 0);
        }),
      );

      test(
        'builds nothing for a ringing push with no running client',
        onFakeTime((async) {
          final handled = run(
            async,
            handle(createStreamVideo: factoryReturning(client)),
          );

          expect(handled, isFalse);
          // A client built here would be the app's second, and would be
          // disposed a second after the user answers — taking the app's own
          // down with it.
          expect(factoryCalls, 0);
          verifyNever(() => client.dispose());
          expect(onDisposeCalled, isFalse);
        }),
      );

      test(
        'forwards a missed call to the running client',
        onFakeTime((async) {
          final handled = run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              existingClient: () => client,
              data: _missedCallPush,
            ),
          );

          // A missed call has no VoIP counterpart, so nothing else would post
          // it.
          expect(handled, isTrue);
          verify(
            () => client.ringing.handleRingingFlowNotifications(any()),
          ).called(1);
          expect(factoryCalls, 0);
        }),
      );

      test(
        'builds nothing for a missed call with no running client',
        onFakeTime((async) {
          final handled = run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              data: _missedCallPush,
            ),
          );

          expect(handled, isFalse);
          expect(factoryCalls, 0);
        }),
      );

      test(
        'never observes ringing events or schedules a teardown',
        onFakeTime((async) {
          run(
            async,
            handle(
              createStreamVideo: factoryReturning(client),
              existingClient: () => client,
              data: _missedCallPush,
            ),
          );

          expect(async.nonPeriodicTimerCount, 0);
          pastTheGrace(async);

          verifyNever(client.ringing.observeCoreRingingEventsForBackground);
          verifyNever(() => client.dispose());
          expect(onDisposeCalled, isFalse);
        }),
      );
    });

    test(
      'starts a fresh session after the previous one was released',
      onFakeTime((async) {
        when(
          () => client.ringing.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => false);
        run(async, handle(createStreamVideo: factoryReturning(client)));
        pastTheGrace(async);

        when(
          () => client.ringing.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => true);
        run(async, handle(createStreamVideo: factoryReturning(client)));

        // The released session must not be reused, or the second message would
        // be handed a disposed client.
        expect(factoryCalls, 2);
      }),
    );
  });
}
