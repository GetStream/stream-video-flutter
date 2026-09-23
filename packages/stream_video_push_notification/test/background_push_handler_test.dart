import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

class MockCall extends Mock implements Call {}

class MockStreamVideo extends Mock implements StreamVideo {
  // StreamVideo marks dispose as @mustBeOverridden. Routed back through the
  // mock rather than stubbed out here, since teardown is what these tests
  // verify.
  @override
  Future<void> dispose() =>
      noSuchMethod(Invocation.method(#dispose, const [])) as Future<void>;
}

void _ignore(RingingEvent _) {}

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

void main() {
  registerFallbackValue((RingingEvent _) {});

  late MockStreamVideo client;
  late StreamController<RingingEvent> ringing;

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
    when(stub.dispose).thenAnswer((_) async {});
    when(
      stub.observeCoreRingingEventsForBackground,
    ).thenReturn(CompositeSubscription());
    when(() => stub.onRingingEvent<RingingEvent>(captureAny())).thenAnswer((
      invocation,
    ) {
      onRingingEvent =
          invocation.positionalArguments.first as void Function(RingingEvent);
      return ringing.stream.listen(_ignore);
    });
    when(
      () => stub.handleRingingFlowNotifications(any()),
    ).thenAnswer((_) async => true);

    return stub;
  }

  /// Long enough that nothing resolves inside it by accident, short enough
  /// that a test can sleep through it.
  const grace = Duration(milliseconds: 20);

  /// Comfortably past a scheduled release falling due.
  Future<void> pastTheGrace() => Future<void>.delayed(grace * 6);

  setUp(() {
    // Everything outside the group below is the Android background isolate:
    // the only place this handler owns a client.
    StreamVideoPushHandler.ownsClientLifecycle = () => true;
    StreamVideoPushHandler.resolutionGrace = grace;
    ringing = StreamController<RingingEvent>.broadcast();
    onRingingEvent = null;
    factoryCalls = 0;
    onDisposeCalled = false;
    client = stubbedClient();
  });

  tearDown(() async {
    await StreamVideoPushHandler.releaseForTesting();
    await ringing.close();
    StreamVideoPushHandler.resolutionGrace = const Duration(seconds: 1);
    StreamVideoPushHandler.ownsClientLifecycle = () =>
        CurrentPlatform.isAndroid;
  });

  group('StreamVideoPushHandler', () {
    test(
      'reports a ringing push as handled and keeps the client alive',
      () async {
        final handled = await handle(
          createStreamVideo: factoryReturning(client),
        );

        expect(handled, isTrue);
        // Still ringing: disposing here would take the notification with it.
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      },
    );

    test('does nothing when nobody is logged in', () async {
      final handled = await handle(createStreamVideo: factoryReturning(null));

      expect(handled, isFalse);
      // Whatever the factory set up on its way to finding no credentials still
      // has to come back down.
      expect(onDisposeCalled, isTrue);
    });

    test('releases once the user resolves the notification', () async {
      await handle(createStreamVideo: factoryReturning(client));

      onRingingEvent!(_declined('default:call-a'));
      // Teardown is deferred so the flow resolving the call finishes first.
      verifyNever(() => client.dispose());

      await pastTheGrace();

      verify(() => client.dispose()).called(1);
      expect(onDisposeCalled, isTrue);
    });

    test('ignores ringing events that are not a resolution', () async {
      await handle(createStreamVideo: factoryReturning(client));

      onRingingEvent!(const ActionCallIncoming(data: CallData(uuid: 'u')));
      await pastTheGrace();

      // An incoming call is the *start* of the flow this isolate exists for.
      verifyNever(() => client.dispose());
    });

    test('releases a message that turns out not to be ours', () async {
      when(
        () => client.handleRingingFlowNotifications(any()),
      ).thenAnswer((_) async => false);

      final handled = await handle(createStreamVideo: factoryReturning(client));

      expect(handled, isFalse);
      // No ringing event is ever coming, so nothing else would let go of the
      // isolate.
      await pastTheGrace();
      verify(() => client.dispose()).called(1);
      expect(onDisposeCalled, isTrue);
    });

    test(
      'builds the client once for two messages in the same isolate',
      () async {
        await handle(createStreamVideo: factoryReturning(client));
        await handle(createStreamVideo: factoryReturning(client));

        // Calling the factory twice would install a second singleton over a live
        // one, which throws.
        expect(factoryCalls, 1);
        verify(() => client.handleRingingFlowNotifications(any())).called(2);
        // And the second message must not wire a second set of observers.
        verify(client.observeCoreRingingEventsForBackground).called(1);
      },
    );

    test(
      'a foreign message arriving mid-ring does not cut the ring short',
      () async {
        await handle(createStreamVideo: factoryReturning(client));

        when(
          () => client.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => false);
        await handle(createStreamVideo: factoryReturning(client));

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      },
    );

    test('reaches the app teardown even when dispose throws', () async {
      when(client.dispose).thenThrow(Exception('boom'));

      await handle(
        createStreamVideo: factoryReturning(client),
        data: _missedCallPush,
      );
      await pastTheGrace();

      // The client's teardown failing must not strand the app's own: nothing
      // can retry this release, and the dependencies would stay registered.
      expect(onDisposeCalled, isTrue);

      // And the isolate still has to be able to take the next call.
      onDisposeCalled = false;
      final handled = await handle(
        createStreamVideo: factoryReturning(stubbedClient()),
      );

      expect(handled, isTrue);
      expect(factoryCalls, 2);
    });

    test('a failing setup is torn down before the next push tries', () async {
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

      final handled = await Future.wait([race(), race()]);

      expect(handled, [false, false]);
      // Each push gets its own attempt—the second is a retry, not a rider on
      // a failure it never saw—and the two never overlap.
      expect(factoryCalls, 2);
      expect(disposeCalls, 2);
    });

    test('two pushes racing the setup share one session', () async {
      CreateStreamVideo slowFactory(StreamVideo value) => () async {
        factoryCalls++;
        await Future<void>.delayed(grace);
        return value;
      };

      // Firebase drains the messages buffered during a cold start back to
      // back, so the second push lands while the first is still awaiting its
      // token fetch.
      final handled = await Future.wait([
        handle(createStreamVideo: slowFactory(client)),
        handle(createStreamVideo: slowFactory(client)),
      ]);

      // A second client would leak: nothing disposes it, and the app's own
      // factory is the thing that trips over being called twice.
      expect(factoryCalls, 1);
      expect(handled, [true, true]);
      // One session means one set of observers and one teardown.
      verify(client.observeCoreRingingEventsForBackground).called(1);
      verify(() => client.handleRingingFlowNotifications(any())).called(2);
      expect(onDisposeCalled, isFalse);
    });

    test('releases when handling throws', () async {
      when(
        () => client.handleRingingFlowNotifications(any()),
      ).thenThrow(Exception('boom'));

      final handled = await handle(createStreamVideo: factoryReturning(client));

      expect(handled, isFalse);
      await pastTheGrace();
      verify(() => client.dispose()).called(1);
      expect(onDisposeCalled, isTrue);
    });

    test('releases a missed call, which nothing else resolves', () async {
      final handled = await handle(
        createStreamVideo: factoryReturning(client),
        data: _missedCallPush,
      );

      // Handled — the notification was posted — but no accept, decline,
      // timeout or end is ever emitted for a missed call.
      expect(handled, isTrue);
      // Not immediately: the SDK posts the notification without waiting.
      verifyNever(() => client.dispose());

      await pastTheGrace();

      verify(() => client.dispose()).called(1);
      expect(onDisposeCalled, isTrue);
    });

    test(
      'a missed call arriving mid-ring does not cut the ring short',
      () async {
        await handle(createStreamVideo: factoryReturning(client));
        await handle(
          createStreamVideo: factoryReturning(client),
          data: _missedCallPush,
        );

        await pastTheGrace();

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      },
    );

    test(
      'a ring still in flight when the release falls due survives',
      () async {
        await handle(
          createStreamVideo: factoryReturning(client),
          data: _missedCallPush,
        );

        // The ring lands just before the missed call's release falls due and
        // takes longer than the grace to handle, so the release comes up while
        // the ring is still in flight.
        await Future<void>.delayed(grace ~/ 2);
        when(() => client.handleRingingFlowNotifications(any())).thenAnswer((
          _,
        ) async {
          await Future<void>.delayed(grace * 2);
          return true;
        });
        await handle(createStreamVideo: factoryReturning(client));

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      },
    );

    test('a ring arriving after a missed call is not cut short', () async {
      await handle(
        createStreamVideo: factoryReturning(client),
        data: _missedCallPush,
      );
      // Inside the grace window the missed call opened, the caller rings.
      await handle(createStreamVideo: factoryReturning(client));

      await pastTheGrace();

      // The release the missed call scheduled would otherwise have taken the
      // ringing client with it.
      verifyNever(() => client.dispose());
      expect(onDisposeCalled, isFalse);
    });

    test(
      'a ring arriving inside the resolution grace keeps the client',
      () async {
        await handle(createStreamVideo: factoryReturning(client));

        onRingingEvent!(_declined('default:call-a'));
        // The caller rings straight back, before the deferred teardown runs.
        await handle(createStreamVideo: factoryReturning(client));

        await pastTheGrace();

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      },
    );

    group('when the setup fails part way through', () {
      test('undoes what the factory managed to set up', () async {
        final handled = await handle(
          createStreamVideo: () async {
            factoryCalls++;
            throw Exception('no credentials');
          },
        );

        expect(handled, isFalse);
        // Whatever the factory registered before it threw has to come back
        // down, or the next message finds a half set up isolate.
        expect(onDisposeCalled, isTrue);
      });

      test('disposes a client built before the failure', () async {
        when(
          client.observeCoreRingingEventsForBackground,
        ).thenThrow(Exception('boom'));

        final handled = await handle(
          createStreamVideo: factoryReturning(client),
        );

        expect(handled, isFalse);
        verify(() => client.dispose()).called(1);
        expect(onDisposeCalled, isTrue);
      });

      test('leaves nothing behind for the next message', () async {
        var fail = true;
        Future<StreamVideo?> factory() async {
          factoryCalls++;
          if (fail) throw Exception('no network');
          return client;
        }

        await handle(createStreamVideo: factory);
        fail = false;
        final handled = await handle(createStreamVideo: factory);

        expect(handled, isTrue);
        expect(factoryCalls, 2);
      });
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

      test('forwards the message to the running client', () async {
        final handled = await handleOnAppIsolate(
          createStreamVideo: factoryReturning(MockStreamVideo()),
        );

        expect(handled, isTrue);
        verify(() => client.handleRingingFlowNotifications(any())).called(1);
        // Nothing to build: the running app already has a client.
        expect(factoryCalls, 0);
      });

      test(
        'never observes ringing events on a client it does not own',
        () async {
          await handleOnAppIsolate();

          // The running app has its own observers; a second set would show every
          // incoming call twice.
          verifyNever(client.observeCoreRingingEventsForBackground);
        },
      );

      test('ignores a disposed client and builds its own', () async {
        // Nothing can be forwarded to a client that is already gone.
        when(() => client.isDisposed).thenReturn(true);
        final ours = stubbedClient();

        final handled = await handleOnAppIsolate(
          createStreamVideo: factoryReturning(ours),
        );

        expect(handled, isTrue);
        expect(factoryCalls, 1);
        verifyNever(() => client.handleRingingFlowNotifications(any()));
        verify(() => ours.handleRingingFlowNotifications(any())).called(1);
      });

      test('leaves the running client alone for a foreign message', () async {
        when(
          () => client.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => false);

        final handled = await handleOnAppIsolate();

        expect(handled, isFalse);
        // Disposing here would take the live app's client and dependencies
        // down with it.
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      });

      test('leaves the running client alone once a call resolves', () async {
        await handleOnAppIsolate();

        // No resolution observer was registered, so nothing is scheduled.
        expect(onRingingEvent, isNull);

        await pastTheGrace();

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      });
    });

    group('when more than one call is ringing', () {
      test('resolving one leaves the other one ringing', () async {
        // Caller A rings, then caller B rings while A is still up.
        await handle(createStreamVideo: factoryReturning(client));
        await handle(
          createStreamVideo: factoryReturning(client),
          data: _ringingPushFor('default:call-b'),
        );

        // The user declines B. A is still on screen.
        onRingingEvent!(_declined('default:call-b'));
        await pastTheGrace();

        // Disposing here would leave A ringing with nothing behind it to
        // deliver whatever the user does next.
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      });

      test('releases once the last one is resolved', () async {
        await handle(createStreamVideo: factoryReturning(client));
        await handle(
          createStreamVideo: factoryReturning(client),
          data: _ringingPushFor('default:call-b'),
        );

        onRingingEvent!(_declined('default:call-b'));
        onRingingEvent!(_declined('default:call-a'));
        await pastTheGrace();

        verify(() => client.dispose()).called(1);
        expect(onDisposeCalled, isTrue);
      });

      test(
        'a late event for a call already let go of changes nothing',
        () async {
          await handle(createStreamVideo: factoryReturning(client));
          await handle(
            createStreamVideo: factoryReturning(client),
            data: _ringingPushFor('default:call-b'),
          );

          onRingingEvent!(_declined('default:call-b'));
          // The platform reports B ending as well as being declined. It is not
          // a second resolution, and must not be taken for A's.
          onRingingEvent!(
            const ActionCallEnded(
              data: CallData(uuid: 'u', callCid: 'default:call-b'),
            ),
          );
          await pastTheGrace();

          verifyNever(() => client.dispose());
        },
      );

      test('an event without a cid resolves everything', () async {
        await handle(createStreamVideo: factoryReturning(client));
        await handle(
          createStreamVideo: factoryReturning(client),
          data: _ringingPushFor('default:call-b'),
        );

        // Nothing says which call this resolves, so the session cannot be
        // reasoned about any more. Letting go beats holding the isolate open
        // for a call nothing will ever resolve.
        onRingingEvent!(const ActionCallDecline(data: CallData(uuid: 'u')));
        await pastTheGrace();

        verify(() => client.dispose()).called(1);
        expect(onDisposeCalled, isTrue);
      });
    });

    test('leaves the client alone when the app is in a call on it', () async {
      await handle(createStreamVideo: factoryReturning(client));

      // The app answered on this client and joined. On Android the accept
      // lands on this isolate whenever the app is alive but backgrounded, so
      // the resolution that normally means "this session is done" is instead
      // the moment the app starts using the client.
      when(() => client.activeCalls).thenReturn([MockCall()]);
      onRingingEvent!(
        const ActionCallAccept(
          data: CallData(uuid: 'u', callCid: 'default:call-a'),
        ),
      );

      await pastTheGrace();

      // Disposing here drops a call that has just connected.
      verifyNever(() => client.dispose());
      expect(onDisposeCalled, isFalse);
    });

    group('when the push is not ours', () {
      test('builds nothing for it', () async {
        final handled = await handle(
          createStreamVideo: factoryReturning(client),
          data: _foreignPush,
        );

        expect(handled, isFalse);
        // A token fetch and everything the app's factory sets up around it,
        // spent on a push the SDK could never have acted on.
        expect(factoryCalls, 0);
        verifyNever(() => client.handleRingingFlowNotifications(any()));
      });

      test('does not disturb a call that is ringing', () async {
        await handle(createStreamVideo: factoryReturning(client));

        final handled = await handle(
          createStreamVideo: factoryReturning(client),
          data: _foreignPush,
        );

        expect(handled, isFalse);
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      });

      test('is turned away on the app isolate too', () async {
        final handled = await handle(
          createStreamVideo: factoryReturning(client),
          existingClient: () => client,
          data: _foreignPush,
        );

        expect(handled, isFalse);
        verifyNever(() => client.handleRingingFlowNotifications(any()));
      });
    });

    group('when two pushes race the setup', () {
      /// A factory slow enough that the second push lands mid-setup.
      CreateStreamVideo slowFactory() => () async {
        factoryCalls++;
        await Future<void>.delayed(grace);
        return client;
      };

      test('an unhandled one does not release under a live ring', () async {
        // The first push is for a call answered on another device, so the SDK
        // reports it unhandled; the second is a real ring.
        var calls = 0;
        when(
          () => client.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => calls++ != 0);

        await Future.wait([
          handle(createStreamVideo: slowFactory()),
          handle(createStreamVideo: slowFactory()),
        ]);
        await pastTheGrace();

        expect(factoryCalls, 1);
        // Both were handed the one session, so the first must not tear it
        // down before the second has even asked the client.
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      });

      test('one that throws does not release under a live ring', () async {
        var calls = 0;
        when(() => client.handleRingingFlowNotifications(any())).thenAnswer((
          _,
        ) async {
          if (calls++ == 0) throw Exception('boom');
          return true;
        });

        await Future.wait([
          handle(createStreamVideo: slowFactory()),
          handle(createStreamVideo: slowFactory()),
        ]);
        await pastTheGrace();

        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      });
    });

    group("on the app's own isolate", () {
      // Firebase spins up a background isolate on Android alone. On Apple
      // platforms the handler is called where the app already lives, and the
      // device is registered for both a VoIP and a regular push, so a ring
      // arrives twice.
      setUp(() => StreamVideoPushHandler.ownsClientLifecycle = () => false);

      test('forwards a ringing push to the running client', () async {
        final handled = await handle(
          createStreamVideo: factoryReturning(client),
          existingClient: () => client,
        );

        // An iOS app that rings over Firebase rather than PushKit gets its
        // incoming calls from here; dropping them would show nothing at all.
        expect(handled, isTrue);
        verify(() => client.handleRingingFlowNotifications(any())).called(1);
        expect(factoryCalls, 0);
      });

      test('builds nothing for a ringing push with no running client', () async {
        final handled = await handle(
          createStreamVideo: factoryReturning(client),
        );

        expect(handled, isFalse);
        // A client built here would be the app's second, and would be disposed
        // a second after the user answers — taking the app's own down with it.
        expect(factoryCalls, 0);
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      });

      test('forwards a missed call to the running client', () async {
        final handled = await handle(
          createStreamVideo: factoryReturning(client),
          existingClient: () => client,
          data: _missedCallPush,
        );

        // A missed call has no VoIP counterpart, so nothing else would post it.
        expect(handled, isTrue);
        verify(() => client.handleRingingFlowNotifications(any())).called(1);
        expect(factoryCalls, 0);
      });

      test('builds nothing for a missed call with no running client', () async {
        final handled = await handle(
          createStreamVideo: factoryReturning(client),
          data: _missedCallPush,
        );

        expect(handled, isFalse);
        expect(factoryCalls, 0);
      });

      test('never observes ringing events or schedules a teardown', () async {
        await handle(
          createStreamVideo: factoryReturning(client),
          existingClient: () => client,
          data: _missedCallPush,
        );

        await pastTheGrace();

        verifyNever(client.observeCoreRingingEventsForBackground);
        verifyNever(() => client.dispose());
        expect(onDisposeCalled, isFalse);
      });
    });

    test(
      'starts a fresh session after the previous one was released',
      () async {
        when(
          () => client.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => false);
        await handle(createStreamVideo: factoryReturning(client));
        await pastTheGrace();

        when(
          () => client.handleRingingFlowNotifications(any()),
        ).thenAnswer((_) async => true);
        await handle(createStreamVideo: factoryReturning(client));

        // The released session must not be reused, or the second message would
        // be handed a disposed client.
        expect(factoryCalls, 2);
      },
    );
  });
}
