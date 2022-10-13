import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/models/events/events.dart';

//needs to communicate with call_participant_controller
class TrackController {
  final _trackController = BehaviorSubject<TrackUpdatedEvent>();

  void _emit(TrackUpdatedEvent event) => _trackController.add(event);

  void emitLocalUpdated(MediaStream payload, String id) =>
      _emit(LocalTrackUpdatedEvent(payload, id));

  void emitRemoteUpdated(MediaStream payload, String id) =>
      _emit(RemoteTrackUpdatedEvent(payload, id));

  TrackUpdatedEvent get trackEvent => _trackController.value;

  Stream<TrackUpdatedEvent> get _trackStream =>
      _trackController.stream.distinct();

  StreamSubscription<TrackUpdatedEvent> _listen(
    FutureOr<void> Function(TrackUpdatedEvent event) onEvent,
  ) =>
      _trackStream.listen(onEvent);

  StreamSubscription<TrackUpdatedEvent> on<E extends TrackUpdatedEvent>(
    FutureOr<void> Function(E) then, {
    bool Function(E)? filter,
  }) =>
      _listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _trackController.close();
}
