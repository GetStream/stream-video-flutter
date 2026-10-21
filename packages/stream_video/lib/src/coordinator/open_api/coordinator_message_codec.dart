import 'dart:convert';

import '../../../stream_video.dart';
import 'error/open_api_error.dart';
import 'event/event_type.dart';
import 'open_api_mapper_extensions.dart';

final _logger = taggedLogger(tag: 'SV:CoordinatorCodec');

/// A thin [WsEvent] wrapper produced by [CoordinatorMessageCodec].
/// Carries the decoded [StreamVideoEvent]
/// [healthCheckInfo] is non-null only for events that act as pong signals
/// [error] is non-null only for API errors that refused the connection
final class CoordinatorWsEvent extends WsEvent {
  const CoordinatorWsEvent(this.event, {this.healthCheckInfo, this.error});

  /// `null` indicates the message was suppressed (not a domain event).
  final StreamVideoEvent? event;

  @override
  final HealthCheckInfo? healthCheckInfo;

  /// The API error the server refused the connection with, if this message
  /// was one.
  ///
  /// Read by the socket client, which closes the connection with it, so the
  /// next authentication attempt is told why the server refused this one. Only
  /// an error about the credentials is reported here — see [CoordinatorMessageCodec.decode].
  @override
  final Object? error;

  static const suppressed = CoordinatorWsEvent(null);
}

/// Why a coordinator message was dropped instead of delivered.
///
/// Names the drop in the log line: a decode failure on a live event stream is
/// the one failure deliberately not delivered — there is no operation to fail,
/// and closing a healthy connection over one bad frame would be worse — so the
/// log is the only account of it.
enum _DropReason {
  /// The frame was not text, so there is no JSON to read.
  notText,

  /// The frame was text, but not JSON — or not a JSON object.
  malformedJson,

  /// A server error that was not about the credentials. Reporting it would
  /// have the socket client close a connection the error was never about.
  serverError,

  /// A JSON object that names no event type, so is no event envelope.
  unrecognisedEnvelope,

  /// An envelope naming an event type this SDK version has no model for.
  unknownEventType,
}

/// Encodes/decodes messages between the coordinator WebSocket wire format
/// (JSON) and [CoordinatorWsEvent].
class CoordinatorMessageCodec
    implements WebSocketMessageCodec<WsEvent, WsRequest> {
  /// Logs a dropped message and suppresses it.
  CoordinatorWsEvent _drop(_DropReason reason, [Object? detail]) {
    _logger.w(
      () =>
          '[decode] dropped a message (${reason.name})'
          '${detail == null ? '' : ': $detail'}',
    );
    return CoordinatorWsEvent.suppressed;
  }

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
    if (message is! String) {
      return _drop(_DropReason.notText, message.runtimeType);
    }

    final Map<String, dynamic> jsonMap;
    try {
      jsonMap = json.decode(message) as Map<String, dynamic>;
    } catch (e) {
      return _drop(_DropReason.malformedJson, e);
    }

    final dtoError = OpenApiError.fromJson(jsonMap);
    if (dtoError != null) {
      final apiError = dtoError.apiError;
      final code = apiError.code;

      // Only an error about the credentials is reported as the event's error:
      // the socket client closes the connection with whatever error it is
      // handed, so reporting the rest would drop a working connection over an
      // error that was never about it.
      if (code.isTokenExpired ||
          code.isTokenNotYetValid ||
          code.isTokenSignatureInvalid ||
          code.isApiKeyInvalid) {
        return CoordinatorWsEvent(null, error: apiError);
      }

      return _drop(_DropReason.serverError, apiError);
    }

    final rawType = jsonMap['type'];
    if (rawType == null) {
      return _drop(_DropReason.unrecognisedEnvelope);
    }
    _logger.v(() => '[decode] type: $rawType');

    // An event type this SDK version has no model for. Dropped here, where the
    // type is still known, rather than delivered as an opaque event for the
    // socket to discard without being able to name it.
    final event = coordinatorEventFromJson(
      EventType.fromAlias(rawType),
      jsonMap,
    );
    if (event == null) {
      return _drop(_DropReason.unknownEventType, rawType);
    }

    return CoordinatorWsEvent(
      event,
      // Connected signals the initial pong and carries the connection ID used
      // for subsequent health check pings; a health check response is a pong.
      healthCheckInfo: switch (event) {
        CoordinatorConnectedEvent(:final connectionId) ||
        CoordinatorHealthCheckEvent(
          clientId: final connectionId,
        ) => HealthCheckInfo(connectionId: connectionId),
        _ => null,
      },
    );
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
