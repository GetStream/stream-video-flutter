import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

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
const _ringingPush = {'sender': 'stream.video', 'type': 'call.ring'};

/// A missed call: reported as handled, but nothing ever resolves it.
const _missedCallPush = {'sender': 'stream.video', 'type': 'call.missed'};

RemoteMessage _message([Map<String, dynamic> data = _ringingPush]) =>
    RemoteMessage(data: data);

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
    Map<String, dynamic> data = _ringingPush,
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

  setUp(() {
    ringing = StreamController<RingingEvent>.broadcast();
    onRingingEvent = null;
    factoryCalls = 0;
    onDisposeCalled = false;
    client = stubbedClient();
  });

  tearDown(() async {
    await StreamVideoPushHandler.releaseForTesting();
    await ringing.close();
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

      onRingingEvent!(const ActionCallDecline(data: CallData(uuid: 'u')));
      // Teardown is deferred so the flow resolving the call finishes first.
      verifyNever(() => client.dispose());

      await Future<void>.delayed(const Duration(milliseconds: 1200));

      verify(() => client.dispose()).called(1);
      expect(onDisposeCalled, isTrue);
    });

    test('ignores ringing events that are not a resolution', () async {
      await handle(createStreamVideo: factoryReturning(client));

      onRingingEvent!(const ActionCallIncoming(data: CallData(uuid: 'u')));
      await Future<void>.delayed(const Duration(milliseconds: 1200));

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

    test('releases when handling throws', () async {
      when(
        () => client.handleRingingFlowNotifications(any()),
      ).thenThrow(Exception('boom'));

      final handled = await handle(createStreamVideo: factoryReturning(client));

      expect(handled, isFalse);
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

      await Future<void>.delayed(const Duration(milliseconds: 1200));

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

        await Future<void>.delayed(const Duration(milliseconds: 1200));

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
        Map<String, dynamic> data = _ringingPush,
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

        await Future<void>.delayed(const Duration(milliseconds: 1200));

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
