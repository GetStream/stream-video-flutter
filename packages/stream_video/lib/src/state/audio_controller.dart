import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/events/events.dart';
import 'package:stream_video/protobuf/video_events/events.pb.dart';

class AudioController {
  final _audioController = BehaviorSubject<AudioEvent>();

  void emit(AudioEvent event) => _audioController.add(event);

  void emitMuted(AudioMuted event) => emit(AudioMutedEvent(event));

   void emitUnmuted(AudioUnmuted event) => emit(AudioUnmutedEvent(event));
  

  AudioEvent get audioEvent => _audioController.value;

  Stream<AudioEvent> get audioStream => _audioController.stream.distinct();

  StreamSubscription<AudioEvent> listen(
          FutureOr<void> Function(AudioEvent event) onEvent) =>
      audioStream.listen(onEvent);

  StreamSubscription<AudioEvent> on<E extends AudioEvent>(
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

  Future<void> dispose() async => _audioController.close();

 
}
