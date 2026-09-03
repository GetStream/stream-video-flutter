import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

/// The Swift source that produces the wire values, relative to the package root.
const _swiftSource =
    'ios/stream_video_push_notification/Sources/stream_video_push_notification/'
    'StreamVideoCallkitManager.swift';

void main() {
  group('IncomingCallFailureReason.fromName', () {
    test('maps every wire value the platform can send', () {
      // Spelled out rather than derived from `values`, so renaming an enum member fails here
      // instead of silently degrading every one of these to `unknown` at runtime.
      expect(
        IncomingCallFailureReason.fromName('unentitled'),
        IncomingCallFailureReason.unentitled,
      );
      expect(
        IncomingCallFailureReason.fromName('callUuidAlreadyExists'),
        IncomingCallFailureReason.callUuidAlreadyExists,
      );
      expect(
        IncomingCallFailureReason.fromName('filteredByDoNotDisturb'),
        IncomingCallFailureReason.filteredByDoNotDisturb,
      );
      expect(
        IncomingCallFailureReason.fromName('filteredByBlockList'),
        IncomingCallFailureReason.filteredByBlockList,
      );
      expect(
        IncomingCallFailureReason.fromName('invalidCallData'),
        IncomingCallFailureReason.invalidCallData,
      );
    });

    test('falls back to unknown rather than throwing', () {
      // A newer iOS error code must not break the event stream.
      expect(
        IncomingCallFailureReason.fromName('somethingNewInIOS27'),
        IncomingCallFailureReason.unknown,
      );
      expect(
        IncomingCallFailureReason.fromName(null),
        IncomingCallFailureReason.unknown,
      );
      expect(
        IncomingCallFailureReason.fromName(''),
        IncomingCallFailureReason.unknown,
      );
    });

    test('every literal the Swift side emits resolves to a known reason', () {
      // The two sides are coupled by bare strings, so a typo or a rename on either one degrades
      // silently to `unknown`. This reads the literals out of the Swift source and checks each
      // one still lands somewhere real.
      final source = File(_swiftSource);
      expect(
        source.existsSync(),
        isTrue,
        reason: 'expected the CallKit manager at $_swiftSource',
      );

      final literals = RegExp('return "([A-Za-z]+)"')
          .allMatches(source.readAsStringSync())
          .map((match) => match.group(1)!)
          .toSet();

      // Guards the regex itself: if it stops matching, the assertions below are vacuous.
      expect(
        literals,
        contains('filteredByDoNotDisturb'),
        reason:
            'the error-code literals could not be read out of the Swift source',
      );

      for (final literal in literals) {
        if (literal == 'unknown') continue;
        expect(
          IncomingCallFailureReason.fromName(literal),
          isNot(IncomingCallFailureReason.unknown),
          reason:
              '"$literal" is emitted by Swift but has no matching reason in Dart',
        );
      }
    });
  });
}
