import 'dart:convert';

import '../../logger/impl/tagged_logger.dart';
import 'generated/call_created_event_dto.dart';
import 'generated/event_dto.dart';
import 'generated/health_check_event_dto.dart';

class OpenApiEventParser {
  final _logger = taggedLogger(tag: 'SV:CoodEventParser');

  EventDto? parse(String message) {
    final jsonObj = json.decode(message);
    final type = jsonObj['type'];
    if (type == 'health.check') {
      return HealthCheckEventDto.fromRawJson(message);
    } else if (type == 'call.created') {
      return CallCreatedEventDto.fromRawJson(message);
    }

    return null;
  }
}
