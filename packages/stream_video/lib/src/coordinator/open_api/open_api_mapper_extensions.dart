import '../models/coordinator_events.dart';
import 'generated/event_dto.dart';
import 'generated/health_check_event_dto.dart';

extension WebsocketEventMapperExt on EventDto {
  /// Returns [CoordinatorEvent].
  CoordinatorEvent? toCoordinatorEvent() {
    final self = this;
    if (self is HealthCheckEventDto) {
      return CoordinatorHealthCheckEvent(
        clientId: self.connectionId!,
        userId: self.me?.id ?? '',
      );
    }
    return null;
  }
}

