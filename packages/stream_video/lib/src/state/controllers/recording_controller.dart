import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart';
import 'package:stream_video/src/models/events/events.dart';

class RecordingController {
  final _recordingController = BehaviorSubject<RecordingEvent>();

  void emit(RecordingEvent event) => _recordingController.add(event);

  void emitStarted(RecordingStarted event) =>
      emit(RecordingStartedEvent(event));

  void emitStopped(RecordingStopped event) =>
      emit(RecordingStoppedEvent(event));

  RecordingEvent get recordingEvent => _recordingController.value;

  Stream<RecordingEvent> get recordingStream =>
      _recordingController.stream.distinct();

  StreamSubscription<RecordingEvent> listen(
    FutureOr<void> Function(RecordingEvent event) onEvent,
  ) =>
      recordingStream.listen(onEvent);

  StreamSubscription<RecordingEvent> on<E extends RecordingEvent>(
    FutureOr<void> Function(E) then, {
    bool Function(E)? filter,
  }) =>
      listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _recordingController.close();
}
