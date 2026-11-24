import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/media/call_audio_interruptions.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';

void main() {
  late CallStateNotifier stateManager;
  late bool active;
  late AudioInterruptionReaction reaction;
  late List<String> calls;
  late Completer<void>? pendingStart;
  late CallAudioInterruptions interruptions;

  setUp(() {
    stateManager = CallStateNotifier(createTestCallState());
    active = true;
    reaction = AudioInterruptionReaction.muteMicrophone;
    calls = [];
    pendingStart = null;
    interruptions = CallAudioInterruptions(
      stateManager: stateManager,
      isActive: () => active,
      reaction: () => reaction,
      onStarted: ({required muteMicrophone}) async {
        calls.add('started(mute: $muteMicrophone)');
        await pendingStart?.future;
      },
      onEnded: ({required restore}) async {
        calls.add('ended(restore: $restore)');
      },
      logger: taggedLogger(tag: 'test'),
    );
  });

  bool interrupted() => stateManager.callState.isAudioInterrupted;

  test('reports an interruption and its end', () async {
    await interruptions.onInterruption(interrupted: true);
    expect(interrupted(), isTrue);

    await interruptions.onInterruption(interrupted: false);
    expect(interrupted(), isFalse);
    expect(calls, ['started(mute: true)', 'ended(restore: true)']);
  });

  test('passes the reaction on', () async {
    reaction = AudioInterruptionReaction.none;

    await interruptions.onInterruption(interrupted: true);

    expect(interrupted(), isTrue);
    expect(calls, ['started(mute: false)']);
  });

  test('takes no interruption while the call is not active', () async {
    active = false;

    await interruptions.onInterruption(interrupted: true);
    await interruptions.onInterruption(interrupted: false);

    expect(interrupted(), isFalse);
    expect(calls, isEmpty);
  });

  test('ignores a repeated start and an end with no start', () async {
    await interruptions.onInterruption(interrupted: false);
    await interruptions.onInterruption(interrupted: true);
    await interruptions.onInterruption(interrupted: true);

    expect(calls, ['started(mute: true)']);
  });

  test('does not restore once the call is not active', () async {
    await interruptions.onInterruption(interrupted: true);

    active = false;
    await interruptions.onInterruption(interrupted: false);

    expect(interrupted(), isFalse);
    expect(calls.last, 'ended(restore: false)');
  });

  test('handles an end only after the start it follows', () async {
    pendingStart = Completer<void>();

    final start = interruptions.onInterruption(interrupted: true);
    final end = interruptions.onInterruption(interrupted: false);
    await pumpEventQueue();
    expect(calls, ['started(mute: true)']);

    pendingStart!.complete();
    await Future.wait([start, end]);

    expect(calls, ['started(mute: true)', 'ended(restore: true)']);
    expect(interrupted(), isFalse);
  });

  test('reset ends the interruption at once without restoring', () async {
    await interruptions.onInterruption(interrupted: true);

    final reset = interruptions.reset();
    expect(interrupted(), isFalse);
    await reset;
    await interruptions.onInterruption(interrupted: false);

    expect(calls, ['started(mute: true)', 'ended(restore: false)']);
  });
}
