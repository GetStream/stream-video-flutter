import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart'
    show StreamApiError, StreamErrorCodePredicates;
import 'package:stream_video/src/call/call_events.dart';
import 'package:stream_video/src/coordinator/models/coordinator_events.dart';
import 'package:stream_video/src/coordinator/open_api/coordinator_message_codec.dart';
import 'package:stream_video/src/coordinator/open_api/event/event_type.dart';
import 'package:stream_video/src/models/call_settings.dart';

import '../fixtures/coordinator_json.dart';

/// The wire form of a coordinator API error with the given [code].
String _apiErrorMessage(int code) {
  return json.encode({
    'error': {
      'code': code,
      'details': <int>[],
      'duration': '0.1ms',
      'message': 'error message',
      'more_info': 'https://getstream.io/docs',
      'StatusCode': 401,
    },
  });
}

void main() {
  group('CoordinatorMessageCodec', () {
    late CoordinatorMessageCodec codec;

    setUp(() => codec = CoordinatorMessageCodec());

    // The socket client reads `error` to close the connection with it, which is
    // what tells the next authentication attempt why the previous one was
    // refused. An error that is only suppressed leaves the attempt refreshing
    // nothing and resending the token the server just rejected.
    test('surfaces an expired-token error as the event error', () {
      final event = codec.decode(_apiErrorMessage(40));

      expect(event.event, isNull);
      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).code.isTokenExpired, isTrue);
    });

    test('surfaces a not-yet-valid token as the event error', () {
      final event = codec.decode(_apiErrorMessage(41));

      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).code.isTokenNotYetValid, isTrue);
    });

    test('surfaces a refused token signature as the event error', () {
      final event = codec.decode(_apiErrorMessage(43));

      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).code.isTokenSignatureInvalid, isTrue);
    });

    test('surfaces a rejected API key as the event error', () {
      final event = codec.decode(_apiErrorMessage(2));

      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).code.isApiKeyInvalid, isTrue);
    });

    // The socket client closes the connection with any error it is handed, so
    // an error that says nothing about the credentials must stay suppressed —
    // otherwise a working connection is dropped over an error about a single
    // request.
    test('suppresses an error unrelated to the credentials', () {
      final event = codec.decode(_apiErrorMessage(17));

      expect(event.event, isNull);
      expect(event.error, isNull);
    });

    test('decodes a domain event without an error', () {
      final event = codec.decode(
        json.encode({
          'type': 'health.check',
          'connection_id': 'connection-1',
          'created_at': '2026-01-01T00:00:00.000Z',
        }),
      );

      expect(event.event, isA<CoordinatorHealthCheckEvent>());
      expect(event.error, isNull);
      expect(event.healthCheckInfo?.connectionId, 'connection-1');
    });

    // The connected event is the first pong, and it carries the connection id
    // every health check ping after it is sent with.
    test('decodes the connected event as a pong', () {
      final event = codec.decode(
        json.encode({
          'type': 'connection.ok',
          'connection_id': 'connection-1',
          'created_at': '2026-01-01T00:00:00.000Z',
          'me': {
            'id': 'user-1',
            'role': 'user',
            'banned': false,
            'online': true,
            'invisible': false,
            'language': 'en',
            'custom': <String, Object?>{},
            'teams': <String>[],
            'devices': <Object>[],
            'mutes': <Object>[],
            'channel_mutes': <Object>[],
            'total_unread_count': 0,
            'unread_channels': 0,
            'unread_count': 0,
            'unread_threads': 0,
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-01T00:00:00.000Z',
          },
        }),
      );

      expect(
        event.event,
        const CoordinatorConnectedEvent(
          connectionId: 'connection-1',
          userId: 'user-1',
        ),
      );
      expect(event.healthCheckInfo?.connectionId, 'connection-1');
    });

    // A call event is decoded once, straight into the type `Call.callEvents`
    // delivers, rather than into a coordinator copy each call maps again.
    test('decodes a call event into its call event type', () {
      final event = codec.decode(
        json.encode({
          'type': 'call.recording_started',
          'call_cid': 'default:call-1',
          'created_at': '2026-01-01T00:00:00.000Z',
          'egress_id': 'egress-1',
          'recording_type': 'composite',
        }),
      );

      expect(
        event.event,
        isA<StreamCallRecordingStartedEvent>()
            .having((it) => it.callCid.value, 'callCid', 'default:call-1')
            .having(
              (it) => it.recordingType,
              'recordingType',
              RecordingType.composite,
            ),
      );
    });

    test('suppresses a message it cannot read, without an error', () {
      final event = codec.decode('not json');

      expect(event.event, isNull);
      expect(event.error, isNull);
    });
  });

  // Dropping is the one sanctioned way a failure goes undelivered: there is no
  // operation to fail, and closing a healthy connection over one bad frame
  // would be worse. What the socket must never see is a half-decoded message.
  group('CoordinatorMessageCodec suppresses what it cannot deliver', () {
    late CoordinatorMessageCodec codec;

    setUp(() => codec = CoordinatorMessageCodec());

    void expectSuppressed(Object message) {
      final event = codec.decode(message);

      expect(event.event, isNull);
      expect(event.error, isNull);
      expect(event.healthCheckInfo, isNull);
    }

    test('a frame that is not text', () => expectSuppressed(const [1, 2, 3]));

    test('a frame that is not JSON', () => expectSuppressed('not json'));

    test('a server error it does not surface', () {
      expectSuppressed(_apiErrorMessage(17));
    });

    test('an envelope it does not recognise', () {
      expectSuppressed(json.encode({'nothing': 'recognisable'}));
    });

    // Suppressed by the codec, which still knows the type name to log, rather
    // than handed to the socket as an event it can only discard unnamed.
    test('an event type this SDK version has no model for', () {
      expectSuppressed(
        json.encode({
          'type': 'call.invented_in_a_later_version',
          'created_at': '2026-01-01T00:00:00.000Z',
        }),
      );
    });
  });

  // Every coordinator event is parsed straight into its generated model and
  // mapped from there, one case per type. Each case is decoded here, so a
  // case that parses the wrong model or maps the wrong field fails.
  group('CoordinatorMessageCodec decodes every event type', () {
    final codec = CoordinatorMessageCodec();

    // Every type except the two connection pongs, tested above, and unknown.
    final expected = <EventType, Matcher>{
      EventType.callCreated: isA<StreamCallCreatedEvent>(),
      EventType.callAccepted: isA<StreamCallAcceptedEvent>(),
      EventType.callRejected: isA<StreamCallRejectedEvent>(),
      EventType.callMissed: isA<StreamCallMissedEvent>(),
      EventType.callRing: isA<StreamCallRingingEvent>()
          .having((it) => it.ringing, 'ringing', isTrue)
          .having((it) => it.video, 'video', isTrue)
          .having((it) => it.sessionId, 'sessionId', 'session-1'),
      EventType.callUpdated: isA<StreamCallUpdatedEvent>(),
      EventType.callEnded: isA<StreamCallEndedEvent>(),
      EventType.callSessionStarted: isA<StreamCallSessionStartedEvent>(),
      EventType.callSessionEnded: isA<StreamCallSessionEndedEvent>(),
      EventType.callSessionParticipantJoined:
          isA<StreamCallSessionParticipantJoinedEvent>(),
      EventType.callSessionParticipantLeft:
          isA<StreamCallSessionParticipantLeftEvent>().having(
            (it) => it.duration,
            'duration',
            const Duration(seconds: 3),
          ),
      EventType.callSessionParticipantCountUpdated:
          isA<StreamCallSessionParticipantCountUpdatedEvent>().having(
            (it) => it.anonymousParticipantCount,
            'anonymousParticipantCount',
            2,
          ),
      EventType.callPermissionRequest: isA<StreamCallPermissionRequestEvent>(),
      EventType.callPermissionsUpdated:
          isA<StreamCallPermissionsUpdatedEvent>(),
      EventType.callUserBlocked: isA<StreamCallUserBlockedEvent>(),
      EventType.callUserKicked: isA<StreamCallUserKickedEvent>(),
      EventType.callUserUnblocked: isA<StreamCallUserUnblockedEvent>(),
      EventType.callRecordingStarted: isA<StreamCallRecordingStartedEvent>()
          .having((it) => it.recordingType, 'recordingType', _recordingType),
      EventType.callRecordingStopped: isA<StreamCallRecordingStoppedEvent>()
          .having((it) => it.recordingType, 'recordingType', _recordingType),
      EventType.callBroadcastingStarted:
          isA<StreamCallBroadcastingStartedEvent>()
              .having(
                (it) => it.hlsPlaylistUrl,
                'hlsPlaylistUrl',
                'https://hls',
              )
              .having(
                (it) => it.metadata.details.createdBy.id,
                'metadata createdBy',
                'user-fixture',
              ),
      EventType.callBroadcastingStopped:
          isA<StreamCallBroadcastingStoppedEvent>(),
      EventType.callBroadcastingFailed:
          isA<StreamCallBroadcastingFailedEvent>(),
      EventType.callRtmpBroadcastStarted:
          isA<StreamCallRtmpBroadcastStartedEvent>(),
      EventType.callRtmpBroadcastStopped:
          isA<StreamCallRtmpBroadcastStoppedEvent>(),
      EventType.callRtmpBroadcastFailed:
          isA<StreamCallRtmpBroadcastFailedEvent>(),
      EventType.callLiveStarted: isA<StreamCallLiveStartedEvent>(),
      EventType.callMemberAdded: isA<StreamCallMemberAddedEvent>(),
      EventType.callMemberRemoved: isA<StreamCallMemberRemovedEvent>(),
      EventType.callMemberUpdated: isA<StreamCallMemberUpdatedEvent>(),
      EventType.callMemberUpdatedPermission:
          isA<StreamCallMemberUpdatedPermissionEvent>(),
      EventType.callNotification: isA<StreamCallNotificationEvent>(),
      EventType.callReaction: isA<StreamCallReactionEvent>().having(
        (it) => it.reactionType,
        'reactionType',
        'like',
      ),
      EventType.callUserMuted: isA<StreamCallUserMutedEvent>(),
      EventType.callRecordingReady: isA<StreamCallRecordingReadyEvent>()
          .having((it) => it.recordingType, 'recordingType', _recordingType)
          .having((it) => it.filename, 'filename', 'recording.mp4'),
      EventType.callRecordingFailed: isA<StreamCallRecordingFailedEvent>()
          .having((it) => it.recordingType, 'recordingType', _recordingType),
      EventType.callTranscriptionStarted:
          isA<StreamCallTranscriptionStartedEvent>(),
      EventType.callTranscriptionStopped:
          isA<StreamCallTranscriptionStoppedEvent>(),
      EventType.callTranscriptionFailed:
          isA<StreamCallTranscriptionFailedEvent>(),
      EventType.callClosedCaptionStarted:
          isA<StreamCallClosedCaptionsStartedEvent>(),
      EventType.callClosedCaptionStopped:
          isA<StreamCallClosedCaptionsStoppedEvent>(),
      EventType.callClosedCaptionFailed:
          isA<StreamCallClosedCaptionsFailedEvent>(),
      EventType.callClosedCaption: isA<StreamCallClosedCaptionsEvent>().having(
        (it) => it.text,
        'text',
        'hello',
      ),
      EventType.callFrameRecordingStarted:
          isA<StreamCallFrameRecordingStartedEvent>(),
      EventType.callFrameRecordingStopped:
          isA<StreamCallFrameRecordingStoppedEvent>(),
      EventType.callFrameRecordingFailed:
          isA<StreamCallFrameRecordingFailedEvent>(),
      EventType.callFrameRecordingReady:
          isA<StreamCallFrameRecordingReadyEvent>(),
      EventType.callModerationBlur: isA<StreamCallModerationBlurEvent>(),
      EventType.callModerationWarning: isA<StreamCallModerationWarningEvent>()
          .having((it) => it.message, 'message', 'a warning'),
      EventType.callDeleted: isA<StreamCallDeletedEvent>(),
      EventType.callUserFeedbackSubmitted:
          isA<StreamCallUserFeedbackSubmittedEvent>().having(
            (it) => it.rating,
            'rating',
            4,
          ),
      EventType.callTranscriptionReady:
          isA<StreamCallTranscriptionReadyEvent>(),
      EventType.ingressStarted: isA<StreamCallIngressStartedEvent>(),
      EventType.ingressStopped: isA<StreamCallIngressStoppedEvent>(),
      EventType.ingressError: isA<StreamCallIngressErrorEvent>(),
      EventType.custom: isA<StreamCallCustomEvent>(),
    };

    test('covers every event type', () {
      expect(
        expected.keys.toSet(),
        EventType.values.toSet().difference({
          EventType.connectionOk,
          EventType.healthCheck,
          EventType.unknown,
        }),
      );
    });

    for (final MapEntry(key: type, value: matcher) in expected.entries) {
      test(type.alias, () {
        final decoded = codec.decode(json.encode(_eventJson(type)));

        expect(decoded.error, isNull);
        expect(decoded.healthCheckInfo, isNull);
        expect(decoded.event, matcher);
        expect(
          (decoded.event! as StreamCallEvent).callCid.value,
          'default:call-1',
        );
      });
    }
  });
}

const _recordingType = RecordingType.composite;

const _createdAt = '2026-01-01T00:00:00.000Z';

/// A `[type]` envelope carrying every field any coordinator event requires.
///
/// The generated models ignore keys they do not declare, so one payload serves
/// every type.
Map<String, Object?> _eventJson(EventType type) {
  final user = minimalUserResponseJson();
  return {
    'type': type.alias,
    'call_cid': 'default:call-1',
    'created_at': _createdAt,
    'call': minimalCallResponseJson(),
    'user': user,
    'members': <Object>[],
    'session_id': 'session-1',
    'video': true,
    'notify_user': false,
    'capabilities_by_role': <String, Object>{},
    'egress_id': 'egress-1',
    'recording_type': 'composite',
    'hls_playlist_url': 'https://hls',
    'name': 'rtmp-1',
    'permissions': <String>[],
    'own_capabilities': <String>[],
    'participant': {
      'joined_at': _createdAt,
      'role': 'user',
      'user': user,
      'user_session_id': 'user-session-1',
    },
    'duration_seconds': 3,
    'participants_count_by_role': <String, int>{},
    'anonymous_participant_count': 2,
    'reaction': {
      'type': 'like',
      'custom': <String, Object>{},
      'message_id': 'message-1',
      'score': 1,
      'created_at': _createdAt,
      'updated_at': _createdAt,
      'user': user,
      'user_id': user['id'],
    },
    'closed_caption': {
      'id': 'caption-1',
      'text': 'hello',
      'speaker_id': 'user-fixture',
      'language': 'en',
      'translated': false,
      'start_time': _createdAt,
      'end_time': _createdAt,
      'user': user,
    },
    'url': 'https://file',
    'captured_at': _createdAt,
    'track_type': 'video',
    'users': <String, Object>{},
    'from_user_id': 'user-fixture',
    'muted_user_ids': <String>[],
    'reason': 'a reason',
    'call_recording': {
      'filename': 'recording.mp4',
      'url': 'https://file',
      'recording_type': 'composite',
      'session_id': 'session-1',
      'start_time': _createdAt,
      'end_time': _createdAt,
    },
    'call_transcription': {
      'filename': 'transcription.txt',
      'url': 'https://file',
      'session_id': 'session-1',
      'start_time': _createdAt,
      'end_time': _createdAt,
    },
    'user_id': 'user-fixture',
    'message': 'a warning',
    'custom': <String, Object>{},
    'rating': 4,
    'blocked_by_user': user,
    'kicked_by_user': user,
    'ingress_stream_id': 'ingress-1',
    'publisher_type': 'rtmp',
    'error': 'an error',
  };
}
