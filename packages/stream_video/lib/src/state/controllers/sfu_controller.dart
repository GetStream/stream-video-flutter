import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_events/events.pb.dart';
import 'package:stream_video/src/models/events/events.dart';

class SfuController {
  final _sfuController = BehaviorSubject<SFUEvent>();

  void _emit(SFUEvent event) => _sfuController.add(event);

  void emitSubscriberOffer(SubscriberOffer payload) =>
      _emit(SubscriberOfferEvent(payload));

  SFUEvent get sfuEvent => _sfuController.value;

  Stream<SFUEvent> get videoStream => _sfuController.stream.distinct();

  StreamSubscription<SFUEvent> _listen(
          FutureOr<void> Function(SFUEvent event) onEvent) =>
      videoStream.listen(onEvent);

  StreamSubscription<SFUEvent> on<E extends SFUEvent>(
          FutureOr<void> Function(E) then,
          {bool Function(E)? filter}) =>
      _listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _sfuController.close();
}
