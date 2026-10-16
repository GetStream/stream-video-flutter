import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/coordinator/open_api/event/event_type.dart';
import 'package:stream_video/src/coordinator/open_api/event/open_api_event.dart';
import 'package:stream_video/src/coordinator/open_api/open_api_mapper_extensions.dart';
import 'package:stream_video/stream_video.dart';

class _RecordingLogger extends StreamLogger {
  final records = <(Priority, String)>[];

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    records.add((priority, message()));
  }
}

void main() {
  late _RecordingLogger logger;

  setUp(() {
    logger = _RecordingLogger();
    StreamLog()
      ..priority = Priority.verbose
      ..logger = logger;
  });

  tearDown(() {
    StreamLog()
      ..priority = Priority.none
      ..logger = const SilentStreamLogger();
  });

  List<(Priority, String)> recordsAtOrAbove(Priority priority) =>
      logger.records.where((r) => r.$1.index >= priority.index).toList();

  group('EventType.fromAlias', () {
    test('maps every known alias to its type', () {
      for (final type in EventType.values) {
        expect(EventType.fromAlias(type.alias), type);
      }
    });

    test('returns unknown for chat events with only a verbose log', () {
      for (final alias in [
        'message.new',
        'reaction.new',
        'typing.start',
        'notification.message_new',
      ]) {
        expect(EventType.fromAlias(alias), EventType.unknown);
      }

      expect(recordsAtOrAbove(Priority.debug), isEmpty);
      expect(
        logger.records.map((r) => r.$1),
        everyElement(Priority.verbose),
      );
    });

    test('logs an unknown call event at verbose', () {
      expect(EventType.fromAlias('call.future_event'), EventType.unknown);

      expect(recordsAtOrAbove(Priority.debug), isEmpty);
      expect(
        logger.records,
        contains(
          (Priority.verbose, '[fromAlias] unhandled alias: call.future_event'),
        ),
      );
    });
  });

  group('OpenApiEvent.fromJson', () {
    test('parses a chat message.new without throwing or warning', () {
      final jsonObj =
          json.decode(
                jsonEncode({
                  'type': 'message.new',
                  'cid': 'livestream:room-1',
                  'message': {'id': 'msg-1', 'text': 'hi', 'type': 'regular'},
                  'created_at': '2026-10-16T10:00:00.000Z',
                }),
              )
              as Map<String, dynamic>;

      final event = OpenApiEvent.fromJson(jsonObj);

      expect(event?.type, EventType.unknown);
      expect(event?.unknown, jsonObj);
      expect(event?.toCoordinatorEvent(), isA<CoordinatorUnknownEvent>());
      expect(recordsAtOrAbove(Priority.debug), isEmpty);
    });

    test('still parses a known video event', () {
      final event = OpenApiEvent.fromJson({
        'type': 'health.check',
        'connection_id': 'connection-1',
        'created_at': '2026-10-16T10:00:00.000Z',
        'custom': <String, dynamic>{},
      });

      expect(event?.type, EventType.healthCheck);
      expect(event?.healthCheck?.connectionId, 'connection-1');
    });
  });
}
