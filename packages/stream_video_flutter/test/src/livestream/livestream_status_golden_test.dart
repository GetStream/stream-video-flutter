import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';

// Answers every partial-state request from one fixed call state.
class _FakeCall extends Mock implements Call {
  _FakeCall(this._callState)
    : _emitter = MutableStateEmitter<CallState>(_callState, sync: true);

  final CallState _callState;
  final MutableStateEmitter<CallState> _emitter;

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) =>
      Stream.value(selector(_callState));
}

void main() {
  final base = CallState(
    currentUserId: 'viewer',
    callCid: StreamCallCid(cid: 'livestream:test'),
    preferences: DefaultCallPreferences(),
  );

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'Livestream ended and backstage cards',
      fileName: 'livestream_status_cards',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 280,
          height: 482,
        ),
        children: [
          GoldenTestScenario(
            name: 'ended',
            child: LivestreamEndedContent(
              call: _FakeCall(base),
              showRecordings: false,
            ),
          ),
          GoldenTestScenario(
            name: 'backstage',
            child: LivestreamBackstageContent(
              call: _FakeCall(
                base.copyWith(isBackstage: true, participantCount: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
