import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/models/events/events.dart';

@internal
class TrackController {
  final _trackController = BehaviorSubject<TrackEvent>();

  void _emit(TrackEvent event) => _trackController.add(event);

  void emitLocalUpdated(MediaStreamTrack payload) =>
      _emit(LocalTrackUpdatedEvent(payload));

  void emitRemoteUpdated(MediaStreamTrack payload) =>
      _emit(RemoteTrackUpdatedEvent(payload));

  TrackEvent get trackEvent => _trackController.value;

  Stream<TrackEvent> get _trackStream => _trackController.stream.distinct();

  StreamSubscription<TrackEvent> _listen(
    FutureOr<void> Function(TrackEvent event) onEvent,
  ) =>
      _trackStream.listen(onEvent);

  StreamSubscription<TrackEvent> on<E extends TrackEvent>(
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
