import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// A [Call] whose state a test sets through [callState], and whose partial
/// states follow every change.
class FakeLivestreamCall extends Mock implements Call {
  FakeLivestreamCall(
    CallState callState, {
    this.participants = const [],
  }) : _emitter = MutableStateEmitter<CallState>(callState, sync: true);

  final MutableStateEmitter<CallState> _emitter;

  /// What [participantsStream] emits.
  final List<CallParticipantState> participants;

  CallState get callState => _emitter.value;
  set callState(CallState value) => _emitter.value = value;

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) =>
      _emitter.map(selector).distinct();

  @override
  Stream<List<CallParticipantState>> get participantsStream =>
      Stream.value(participants);

  @override
  Stream<Duration> get callDurationStream =>
      Stream.value(const Duration(seconds: 5));

  @override
  Stream<Duration> get liveDurationStream =>
      Stream.value(const Duration(seconds: 5));
}
