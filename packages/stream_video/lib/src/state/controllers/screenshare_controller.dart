import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/models/events/events.dart';
import 'package:stream_video/protobuf/video_events/events.pb.dart';

class ScreenshareController {
  final _screenshareController = BehaviorSubject<ScreenshareEvent>();

  void emit(ScreenshareEvent event) => _screenshareController.add(event);

  void emitStarted(ScreenshareStarted event) =>
      emit(ScreenshareStartedEvent(event));

  void emitStopped(ScreenshareStopped event) =>
      emit(ScreenshareStoppedEvent(event));

  ScreenshareEvent get screenshareEvent => _screenshareController.value;

  Stream<ScreenshareEvent> get screenshareStream =>
      _screenshareController.stream.distinct();

  StreamSubscription<ScreenshareEvent> listen(
          FutureOr<void> Function(ScreenshareEvent event) onEvent) =>
      screenshareStream.listen(onEvent);

  StreamSubscription<ScreenshareEvent> on<E extends ScreenshareEvent>(
          FutureOr<void> Function(E) then,
          {bool Function(E)? filter}) =>
      listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _screenshareController.close();
}
