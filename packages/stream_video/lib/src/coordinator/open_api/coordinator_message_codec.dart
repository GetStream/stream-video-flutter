import 'dart:convert';

import 'package:stream_core/stream_core.dart'
    show
        HealthCheckInfo,
        HealthCheckPingEvent,
        WebSocketMessageCodec,
        WsEvent,
        WsRequest;

import '../models/coordinator_events.dart';
import 'error/open_api_error.dart';
import 'error/open_api_error_code.dart';
import 'event/open_api_event.dart';
import 'open_api_mapper_extensions.dart';

/// A thin [WsEvent] wrapper produced by [CoordinatorMessageCodec].
/// Carries the decoded [CoordinatorEvent]
/// [healthCheckInfo] is non-null only for events that act as pong signals
final class CoordinatorWsEvent extends WsEvent {
  const CoordinatorWsEvent(this.event, {this.healthCheckInfo});

  /// `null` indicates the message was suppressed (not a domain event).
  final CoordinatorEvent? event;

  @override
  final HealthCheckInfo? healthCheckInfo;

  static const suppressed = CoordinatorWsEvent(null);
}

/// Encodes/decodes messages between the coordinator WebSocket wire format
/// (JSON) and [CoordinatorWsEvent].
///
/// [onTokenError] is invoked when the server sends an API error whose code
/// indicates an expired or invalid token, allowing the caller to schedule a
/// token refresh before the next connection attempt.
class CoordinatorMessageCodec
    implements WebSocketMessageCodec<WsEvent, WsRequest> {
  const CoordinatorMessageCodec({this.onTokenError});

  /// Called when the server reports a token-related API error.
  final void Function()? onTokenError;

  @override
  Object encode(WsRequest message) {
    if (message is HealthCheckPingEvent) {
      // The coordinator server expects health checks wrapped in a JSON array.
      return json.encode([message.toJson()]);
    }
    return json.encode(message.toJson());
  }

  @override
  CoordinatorWsEvent decode(Object message) {
    if (message is! String) return CoordinatorWsEvent.suppressed;

    final Map<String, dynamic> jsonMap;
    try {
      jsonMap = json.decode(message) as Map<String, dynamic>;
    } catch (_) {
      return CoordinatorWsEvent.suppressed;
    }

    // API error — notify caller for token refresh.
    final dtoError = OpenApiError.fromJson(jsonMap);
    if (dtoError != null) {
      if (OpenApiErrorCode.tokenRelated.contains(dtoError.apiError.code)) {
        onTokenError?.call();
      }
      return CoordinatorWsEvent.suppressed;
    }

    final dtoEvent = OpenApiEvent.fromJson(jsonMap);
    if (dtoEvent == null) return CoordinatorWsEvent.suppressed;

    // Connected — signals initial pong and carries the connection ID used
    // for subsequent health check pings.
    if (dtoEvent.connected case final connected?) {
      final event = CoordinatorConnectedEvent(
        connectionId: connected.connectionId,
        userId: connected.me.id,
      );
      return CoordinatorWsEvent(
        event,
        healthCheckInfo: HealthCheckInfo(connectionId: connected.connectionId),
      );
    }

    // Health check response — signals a pong.
    if (dtoEvent.healthCheck case final healthCheck?) {
      final event = CoordinatorHealthCheckEvent(
        clientId: healthCheck.connectionId,
      );
      return CoordinatorWsEvent(
        event,
        healthCheckInfo: HealthCheckInfo(
          connectionId: healthCheck.connectionId,
        ),
      );
    }

    final domainEvent = dtoEvent.toCoordinatorEvent();
    if (domainEvent == null) return CoordinatorWsEvent.suppressed;
    return CoordinatorWsEvent(domainEvent);
  }
}

/// A [WsRequest] that sends the coordinator WebSocket authentication payload.
final class CoordinatorAuthRequest extends WsRequest {
  const CoordinatorAuthRequest({
    required this.token,
    required this.userId,
    this.name,
    this.image,
    this.extraData = const {},
  });

  final String token;
  final String userId;
  final String? name;
  final String? image;
  final Map<String, dynamic> extraData;

  @override
  Map<String, Object?> toJson() {
    return {
      'token': token,
      'user_details': {
        'id': userId,
        if (name != null) 'name': name,
        if (image != null) 'image': image,
        if (extraData.isNotEmpty) 'custom': extraData,
      },
    };
  }

  @override
  List<Object?> get props => [token, userId, name, image, extraData];
}
