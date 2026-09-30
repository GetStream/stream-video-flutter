import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

CallStateNotifier _notifier() {
  return CallStateNotifier(
    CallState(
      callCid: StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'id',
      ),
      currentUserId: 'userId',
      preferences: DefaultCallPreferences(),
    ),
  );
}

void main() {
  group('lifecycleCallConnecting', () {
    test('reports a reconnect as joining unless told otherwise', () {
      final notifier = _notifier()
        ..lifecycleCallConnecting(
          attempt: 1,
          strategy: SfuReconnectionStrategy.fast,
        );

      expect(
        notifier.callState.status,
        const CallStatusReconnecting(
          attempt: 1,
          isFastReconnectAttempt: true,
          phase: CallReconnectPhase.joining,
        ),
      );
    });

    test('carries the phase it is given', () {
      final notifier = _notifier()
        ..lifecycleCallConnecting(
          attempt: 2,
          strategy: SfuReconnectionStrategy.rejoin,
          phase: CallReconnectPhase.waiting,
        );

      expect(
        notifier.callState.status,
        const CallStatusReconnecting(
          attempt: 2,
        ),
      );
    });

    test('reports a first join as connecting, whatever the phase', () {
      final notifier = _notifier()
        ..lifecycleCallConnecting(
          attempt: 0,
          strategy: SfuReconnectionStrategy.unspecified,
          phase: CallReconnectPhase.offline,
        );

      expect(notifier.callState.status, CallStatus.connecting());
    });

    test('reports a migration as migrating, whatever the phase', () {
      final notifier = _notifier()
        ..lifecycleCallConnecting(
          attempt: 1,
          strategy: SfuReconnectionStrategy.migrate,
          phase: CallReconnectPhase.offline,
        );

      expect(notifier.callState.status, CallStatus.migrating());
    });
  });

  group('lifecycleCallReconnectPhase', () {
    test('moves a reconnect to the phase, keeping attempt and strategy', () {
      final notifier = _notifier()
        ..lifecycleCallConnecting(
          attempt: 3,
          strategy: SfuReconnectionStrategy.fast,
          phase: CallReconnectPhase.waiting,
        )
        ..lifecycleCallReconnectPhase(CallReconnectPhase.offline);

      expect(
        notifier.callState.status,
        const CallStatusReconnecting(
          attempt: 3,
          isFastReconnectAttempt: true,
          phase: CallReconnectPhase.offline,
        ),
      );
    });

    // A network report can land after the reconnect is over. It must not pull
    // a connected or ended call back into reconnecting.
    test('leaves a call that is not reconnecting alone', () {
      final connected = _notifier()
        ..lifecycleCallConnected()
        ..lifecycleCallReconnectPhase(CallReconnectPhase.offline);
      expect(connected.callState.status, CallStatus.connected());

      final migrating = _notifier()
        ..lifecycleCallConnecting(
          attempt: 1,
          strategy: SfuReconnectionStrategy.migrate,
        )
        ..lifecycleCallReconnectPhase(CallReconnectPhase.offline);
      expect(migrating.callState.status, CallStatus.migrating());

      final disconnected = _notifier()
        ..lifecycleCallDisconnected()
        ..lifecycleCallReconnectPhase(CallReconnectPhase.joining);
      expect(disconnected.callState.status.isDisconnected, isTrue);
    });
  });

  group('CallStatusReconnecting', () {
    test('is offline only while waiting for the network', () {
      expect(
        const CallStatusReconnecting(
          attempt: 1,
          phase: CallReconnectPhase.offline,
        ).isOffline,
        isTrue,
      );
      expect(
        const CallStatusReconnecting(
          attempt: 1,
        ).isOffline,
        isFalse,
      );
      expect(CallStatus.connected().isOffline, isFalse);
    });

    test('tells phases apart', () {
      expect(
        const CallStatusReconnecting(
          attempt: 1,
        ),
        isNot(
          const CallStatusReconnecting(
            attempt: 1,
            phase: CallReconnectPhase.joining,
          ),
        ),
      );
    });

    test('names the strategy it is using', () {
      expect(
        const CallStatusReconnecting(
          attempt: 1,
          isFastReconnectAttempt: true,
        ).toString(),
        contains('strategy: fast'),
      );
      expect(
        const CallStatusReconnecting(attempt: 1).toString(),
        contains('strategy: rejoin'),
      );
    });
  });
}
