// import 'dart:async';

// import 'package:rxdart/rxdart.dart';
// import 'package:stream_video/src/models/events/events.dart';
// class VideoController {
//   final _videoController = BehaviorSubject<VideoEvent>();

//   void emit(VideoEvent event) => _videoController.add(event);

//   void emitStarted(VideoStarted event) => emit(VideoStartedEvent(event));

//   void emitStopped(VideoStopped event) => emit(VideoStoppedEvent(event));

//   VideoEvent get videoEvent => _videoController.value;

//   Stream<VideoEvent> get videoStream => _videoController.stream.distinct();

//   StreamSubscription<VideoEvent> listen(
//           FutureOr<void> Function(VideoEvent event) onEvent) =>
//       videoStream.listen(onEvent);

//   StreamSubscription<VideoEvent> on<E extends VideoEvent>(
//           FutureOr<void> Function(E) then,
//           {bool Function(E)? filter}) =>
//       listen((event) async {
//         // event must be E
//         if (event is! E) return;
//         // filter must be true (if filter is used)
//         if (filter != null && !filter(event)) return;
//         // cast to E
//         await then(event);
//       });

//   Future<void> dispose() async => _videoController.close();
// }
