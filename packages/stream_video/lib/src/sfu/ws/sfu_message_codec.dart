import 'package:stream_core/stream_core.dart'
    show HealthCheckInfo, WebSocketMessageCodec, WsEvent, WsRequest;

import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../data/events/sfu_event_mapper_extensions.dart';
import '../data/events/sfu_events.dart';

/// A thin [WsEvent] wrapper produced by [SfuMessageCodec].
final class SfuWsEvent extends WsEvent {
  const SfuWsEvent(this.event, {this.healthCheckInfo});

  /// The decoded SFU domain event.
  final SfuEvent event;

  @override
  final HealthCheckInfo? healthCheckInfo;
}

/// A [WsRequest] wrapper that carries an outgoing [sfu_events.SfuRequest]
/// protobuf message.
final class SfuWsRequest extends WsRequest {
  const SfuWsRequest(this.request);

  final sfu_events.SfuRequest request;

  @override
  Map<String, Object?> toJson() => throw UnsupportedError(
    'SFU uses binary encoding — call encode() instead',
  );

  @override
  List<Object?> get props => [request.writeToBuffer()];
}

/// Encodes/decodes messages between the SFU WebSocket wire format (binary
/// protobuf) and [SfuWsEvent].
class SfuMessageCodec implements WebSocketMessageCodec<WsEvent, WsRequest> {
  const SfuMessageCodec();

  @override
  Object encode(WsRequest message) {
    if (message is SfuWsRequest) return message.request.writeToBuffer();
    throw ArgumentError(
      'SfuMessageCodec.encode: expected SfuWsRequest, got ${message.runtimeType}',
    );
  }

  @override
  SfuWsEvent decode(Object message) {
    final rawEvent = sfu_events.SfuEvent.fromBuffer(message as List<int>);
    final event = rawEvent.toDomain();
    return SfuWsEvent(
      event,
      healthCheckInfo: switch (event) {
        SfuJoinResponseEvent() => const HealthCheckInfo(),
        SfuHealthCheckResponseEvent(:final participantCount) => HealthCheckInfo(
          participantCount: participantCount.total,
        ),
        _ => null,
      },
    );
  }
}
