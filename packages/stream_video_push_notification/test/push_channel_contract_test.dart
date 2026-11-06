import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_push_notification/src/stream_video_call_event.dart';

// The names on the wire between the Dart package and its two native plugins:
// the method names Dart invokes, the method names each platform handles, and
// the event names each platform declares.
//
// The three sides are coupled by bare strings in three languages, so nothing
// else fails when one of them drifts. This test reads the names out of the
// Dart, Swift and Kotlin sources and pins them against the sets below. A PR
// that renames or drops one on purpose updates these sets in the same change;
// a PR that does it by accident fails here.
//
// What it does not pin: that an event is actually sent (a declared constant
// passes even when no `sendEvent` uses it), and the keys of method arguments
// and event bodies. The body of the call events is pinned separately, by the
// per-platform payloads in `test/fixtures/ringing_events/` that both sides of
// the channel test against.
//
// "Handled" means the native switch has a case for the name, not that the
// case does anything: a few iOS cases answer `true` and stop.

/// The Dart side of the method channel, relative to the package root.
const _dartMethodChannel =
    'lib/stream_video_push_notification_method_channel.dart';

const _swiftSources =
    'ios/stream_video_push_notification/Sources/stream_video_push_notification';
const _swiftConstants = '$_swiftSources/StreamVideoIncomingCallConstants.swift';
const _swiftMethodHandlers = [
  '$_swiftSources/Plugin/PushMethodCallRouter.swift',
];

const _kotlinSources =
    'android/src/main/kotlin/io/getstream/video/flutter/stream_video_push_notification';
const _kotlinConstants = '$_kotlinSources/IncomingCallConstants.kt';
const _kotlinMethodHandler =
    '$_kotlinSources/StreamVideoPushNotificationPlugin.kt';

// The contract.

/// Methods the Dart channel invokes on both platforms.
const _sharedMethods = {
  'initData',
  'showIncomingCall',
  'startCall',
  'endCall',
  'muteCall',
  'isMuted',
  'holdCall',
  'callConnected',
  'activeCalls',
  'endAllCalls',
  'silenceEvents',
};

/// Methods the Dart channel invokes on iOS only, guarded by
/// `CurrentPlatform.isIos` in the method channel.
const _iosOnlyMethods = {
  'getDevicePushTokenVoIP',
  'reportCallEnded',
};

/// Methods the Dart channel invokes on Android only.
///
/// All but `dismissRingingCall` are guarded by `CurrentPlatform.isAndroid` in
/// the method channel; `dismissRingingCall` is guarded one level up, in
/// `StreamVideoPushNotificationManager.dismissRingingCallByCid`, which ends
/// the call through `endCallByCid` on iOS instead.
const _androidOnlyMethods = {
  'showMissCallNotification',
  'hideIncomingCall',
  'dismissRingingCall',
  'ensureFullScreenIntentPermission',
  'requestNotificationPermission',
  'canUseFullScreenIntent',
};

/// Cases the iOS switch has beyond what Dart invokes there. The first two
/// answer `true` and do nothing; Dart never sends them to iOS.
const _iosExtraHandledMethods = {
  'showMissCallNotification',
  'requestNotificationPermission',
};

/// Cases the Android switch has beyond what Dart invokes there.
/// `showIncomingCallSilently` has no Dart caller; `getDevicePushTokenVoIP`
/// answers an empty string and Dart short-circuits before asking.
const _androidExtraHandledMethods = {
  'showIncomingCallSilently',
  'getDevicePushTokenVoIP',
};

/// Events only the iOS plugin declares.
const _iosOnlyEvents = {
  Event.actionDidUpdateDevicePushTokenVoip,
  Event.actionCallIncomingFailed,
  Event.actionCallToggleDtmf,
  Event.actionCallToggleGroup,
  Event.actionCallToggleAudioSession,
};

/// Events only the Android plugin declares.
const _androidOnlyEvents = {
  Event.actionCallCallback,
};

/// `ACTION_*` constants the Android plugin declares for its own intents, which
/// never reach the event channel: the two hold-by-cell intents have no sender,
/// the audio-state one is unused, and the ringing one starts the foreground
/// service.
const _androidInternalActions = {
  'io.getstream.video.ACTION_CALL_AUDIO_STATE_CHANGE',
  'io.getstream.video.ACTION_CALL_HELD',
  'io.getstream.video.ACTION_CALL_UNHELD',
  'io.getstream.video.ACTION_CALL_RINGING',
};

// Source parsing.

String _read(String path) {
  final file = File(path);
  expect(file.existsSync(), isTrue, reason: 'expected a source file at $path');
  return file.readAsStringSync();
}

/// The method names the Dart channel passes to `invokeMethod`.
Set<String> _dartInvokedMethods() {
  final source = _read(_dartMethodChannel);
  return RegExp(
    r"invokeMethod(?:<[^>]*>)?\(\s*'([A-Za-z]+)'",
  ).allMatches(source).map((match) => match.group(1)!).toSet();
}

/// The `case "name":` labels of the `switch call.method` in a Swift file.
Set<String> _swiftHandledMethods(String path) {
  final source = _read(path);
  final start = source.indexOf('switch call.method {');
  expect(start, isNot(-1), reason: 'no `switch call.method` in $path');
  final end = source.indexOf('default:', start);
  expect(end, isNot(-1), reason: 'no `default:` after the switch in $path');
  return RegExp('case "([A-Za-z]+)":')
      .allMatches(source.substring(start, end))
      .map((match) => match.group(1)!)
      .toSet();
}

/// The `"name" ->` branches of the `when (call.method)` in the Kotlin plugin.
Set<String> _kotlinHandledMethods() {
  final source = _read(_kotlinMethodHandler);
  final start = source.indexOf('when (call.method)');
  expect(start, isNot(-1), reason: 'no `when (call.method)` in the plugin');
  final end = source.indexOf('else ->', start);
  expect(end, isNot(-1), reason: 'no `else ->` after the when in the plugin');
  return RegExp(r'"([A-Za-z]+)"\s*->')
      .allMatches(source.substring(start, end))
      .map((match) => match.group(1)!)
      .toSet();
}

/// Constant name to value for every `ACTION_*` string constant in a Swift or
/// Kotlin constants file. The value may sit on the line after the `=`. The
/// lookbehind keeps `EXTRA_CALL_ACTION_FROM` and the like out.
Map<String, String> _declaredEvents(String path) {
  final source = _read(path);
  return {
    for (final match in RegExp(
      r'(?<![A-Z_])(ACTION_[A-Z_]+)\s*=\s*"([^"]+)"',
    ).allMatches(source))
      match.group(1)!: match.group(2)!,
  };
}

void main() {
  group('method channel contract', () {
    test('Dart invokes exactly the documented methods', () {
      final invoked = _dartInvokedMethods();
      expect(
        invoked,
        contains('showIncomingCall'),
        reason: 'the method names could not be read out of $_dartMethodChannel',
      );
      expect(
        invoked,
        equals({..._sharedMethods, ..._iosOnlyMethods, ..._androidOnlyMethods}),
        reason:
            'the methods the Dart channel invokes changed; update the '
            'contract sets at the top of this test in the same PR',
      );
    });

    test('iOS handles every method Dart invokes there', () {
      final handled = <String>{
        for (final path in _swiftMethodHandlers) ..._swiftHandledMethods(path),
      };
      expect(
        handled,
        contains('showIncomingCall'),
        reason: 'the method cases could not be read out of the Swift sources',
      );
      expect(
        handled,
        equals({
          ..._sharedMethods,
          ..._iosOnlyMethods,
          ..._iosExtraHandledMethods,
        }),
        reason:
            'the iOS method switch changed; update the contract sets at the '
            'top of this test in the same PR',
      );
    });

    test('Android handles every method Dart invokes there', () {
      final handled = _kotlinHandledMethods();
      expect(
        handled,
        contains('showIncomingCall'),
        reason:
            'the method cases could not be read out of $_kotlinMethodHandler',
      );
      expect(
        handled,
        equals({
          ..._sharedMethods,
          ..._androidOnlyMethods,
          ..._androidExtraHandledMethods,
        }),
        reason:
            'the Android method switch changed; update the contract sets at '
            'the top of this test in the same PR',
      );
    });

    test('the platform-only sets do not overlap', () {
      expect(_sharedMethods.intersection(_iosOnlyMethods), isEmpty);
      expect(_sharedMethods.intersection(_androidOnlyMethods), isEmpty);
      expect(_iosOnlyMethods.intersection(_androidOnlyMethods), isEmpty);
      expect(_iosOnlyEvents.intersection(_androidOnlyEvents), isEmpty);
    });
  });

  group('event channel contract', () {
    test('every event has a distinct wire name in the package namespace', () {
      final names = Event.values.map((event) => event.wireName).toList();
      expect(names.toSet(), hasLength(names.length));
      for (final name in names) {
        expect(name, startsWith('io.getstream.video.'));
      }
    });

    test('fromWireName round-trips every event and rejects the rest', () {
      for (final event in Event.values) {
        expect(Event.fromWireName(event.wireName), event);
      }
      expect(Event.fromWireName('io.getstream.video.ACTION_UNKNOWN'), isNull);
      expect(Event.fromWireName(''), isNull);
      expect(Event.fromWireName(null), isNull);
    });

    test('iOS declares exactly the events Dart expects from it', () {
      final declared = _declaredEvents(_swiftConstants);
      expect(
        declared.values,
        contains('io.getstream.video.ACTION_CALL_INCOMING'),
        reason: 'the event constants could not be read out of $_swiftConstants',
      );
      expect(
        declared.values.toSet(),
        equals({
          for (final event in Event.values)
            if (!_androidOnlyEvents.contains(event)) event.wireName,
        }),
        reason:
            'the iOS event constants and the Dart events drifted apart; '
            'update the contract sets at the top of this test in the same PR',
      );
    });

    test('Android declares exactly the events Dart expects from it', () {
      final declared = _declaredEvents(_kotlinConstants);
      expect(
        declared.values,
        contains('io.getstream.video.ACTION_CALL_INCOMING'),
        reason:
            'the event constants could not be read out of $_kotlinConstants',
      );
      expect(
        declared.values.toSet(),
        equals({
          for (final event in Event.values)
            if (!_iosOnlyEvents.contains(event)) event.wireName,
          ..._androidInternalActions,
        }),
        reason:
            'the Android event constants and the Dart events drifted apart; '
            'update the contract sets at the top of this test in the same PR',
      );
    });
  });
}
