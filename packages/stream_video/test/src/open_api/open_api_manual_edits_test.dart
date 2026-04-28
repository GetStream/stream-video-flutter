import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/open_api/video/coordinator/api.dart';

/// Verify MANUAL_EDIT patches survive OpenAPI code regeneration.
void main() {
  // CallSessionResponse: acceptedBy / missedBy / rejectedBy → Map<String, DateTime>
  group('CallSessionResponse – date-time map fields', () {
    late Map<String, dynamic> json;

    setUp(() {
      json = {
        'accepted_by': {
          'user-1': '2024-05-01T10:00:00.000Z',
          'user-2': '2024-05-01T10:01:00.000Z',
        },
        'anonymous_participant_count': 3,
        'id': 'session-123',
        'missed_by': {
          'user-3': '2024-05-01T10:02:00.000Z',
        },
        'participants': <dynamic>[],
        'participants_count_by_role': {'admin': 1, 'user': 2},
        'rejected_by': {
          'user-4': '2024-05-01T10:03:00.000Z',
        },
      };
    });

    test('acceptedBy values are parsed as DateTime', () {
      final result = CallSessionResponse.fromJson(json)!;

      expect(result.acceptedBy, isA<Map<String, DateTime>>());
      expect(result.acceptedBy['user-1'], DateTime.utc(2024, 5, 1, 10, 0));
      expect(result.acceptedBy['user-2'], DateTime.utc(2024, 5, 1, 10, 1));
    });

    test('missedBy values are parsed as DateTime', () {
      final result = CallSessionResponse.fromJson(json)!;

      expect(result.missedBy, isA<Map<String, DateTime>>());
      expect(result.missedBy['user-3'], DateTime.utc(2024, 5, 1, 10, 2));
    });

    test('rejectedBy values are parsed as DateTime', () {
      final result = CallSessionResponse.fromJson(json)!;

      expect(result.rejectedBy, isA<Map<String, DateTime>>());
      expect(result.rejectedBy['user-4'], DateTime.utc(2024, 5, 1, 10, 3));
    });

    test('empty maps are handled', () {
      json['accepted_by'] = <String, dynamic>{};
      json['missed_by'] = <String, dynamic>{};
      json['rejected_by'] = <String, dynamic>{};

      final result = CallSessionResponse.fromJson(json)!;

      expect(result.acceptedBy, isEmpty);
      expect(result.missedBy, isEmpty);
      expect(result.rejectedBy, isEmpty);
    });
  });

  // DurationResponse: renamed from Response to avoid http package collision
  group('DurationResponse – renamed from Response', () {
    test('DurationResponse parses from JSON', () {
      final json = {'duration': '42ms'};

      final result = DurationResponse.fromJson(json);

      expect(result, isNotNull);
      expect(result!.duration, '42ms');
    });

    test('DurationResponse serializes to JSON', () {
      final response = DurationResponse(duration: '100ms');

      final json = response.toJson();

      expect(json['duration'], '100ms');
    });
  });

  // UserResponse.custom: Map<String, Object?> (nullable values)
  // Tests iterate .values/.entries to trigger the lazy CastMap type check;
  // plain [] returns V? regardless of V and would not catch the regression.
  group('UserResponse – custom field allows null values', () {
    Map<String, dynamic> _minimalUserJson({
      required Map<String, dynamic> custom,
    }) => {
      'blocked_user_ids': <dynamic>[],
      'created_at': '2024-01-01T00:00:00.000Z',
      'custom': custom,
      'id': 'user-1',
      'language': 'en',
      'role': 'admin',
      'teams': <dynamic>[],
      'updated_at': '2024-01-01T00:00:00.000Z',
    };

    test('fromJson: iterating custom values with nulls does not throw', () {
      final json = _minimalUserJson(
        custom: {
          'nickname': 'Bob',
          'avatar': null,
          'score': 42,
        },
      );

      final result = UserResponse.fromJson(json)!;

      expect(() => result.custom.values.toList(), returnsNormally);
      expect(result.custom.values, contains(isNull));
    });

    test('fromJson: iterating custom entries with nulls does not throw', () {
      final json = _minimalUserJson(
        custom: {
          'field_a': null,
          'field_b': null,
        },
      );

      final result = UserResponse.fromJson(json)!;

      expect(() => result.custom.entries.toList(), returnsNormally);
      expect(result.custom.entries.length, 2);
    });
  });

  // CallUpdatedEvent: fromJson uses capabilitiesFromJson for capabilities_by_role.
  // capabilitiesFromJson skips non-List values; the generated inline code throws.
  group('CallUpdatedEvent – capabilitiesByRole parsing via fromJson', () {
    test('fromJson parses capabilities_by_role correctly', () {
      final json = _callUpdatedEventJson(
        capabilitiesByRole: {
          'admin': ['send-audio', 'send-video', 'screenshare'],
          'user': ['send-audio'],
        },
      );

      final result = CallUpdatedEvent.fromJson(json)!;

      expect(result.capabilitiesByRole, isA<Map<String, List<String>>>());
      expect(result.capabilitiesByRole['admin'], hasLength(3));
      expect(result.capabilitiesByRole['admin'], contains('send-video'));
      expect(result.capabilitiesByRole['user'], ['send-audio']);
    });

    test(
      'fromJson tolerates non-List values in capabilities_by_role',
      () {
        final json = _callUpdatedEventJson(
          capabilitiesByRole: {
            'admin': ['send-audio'],
            'broken_role': 'not-a-list',
          },
        );

        expect(
          () => CallUpdatedEvent.fromJson(json),
          returnsNormally,
        );

        final result = CallUpdatedEvent.fromJson(json)!;
        expect(result.capabilitiesByRole['admin'], ['send-audio']);
        expect(
          result.capabilitiesByRole.containsKey('broken_role'),
          isFalse,
        );
      },
    );
  });

  // CallMemberUpdatedPermissionEvent: same capabilitiesByRole fix
  group(
    'CallMemberUpdatedPermissionEvent – capabilitiesByRole via fromJson',
    () {
      test(
        'fromJson tolerates non-List values in capabilities_by_role',
        () {
          final json = _callMemberUpdatedPermissionEventJson(
            capabilitiesByRole: {
              'moderator': ['mute-users'],
              'broken_role': 42,
            },
          );

          expect(
            () => CallMemberUpdatedPermissionEvent.fromJson(json),
            returnsNormally,
          );

          final result = CallMemberUpdatedPermissionEvent.fromJson(json)!;
          expect(result.capabilitiesByRole['moderator'], ['mute-users']);
          expect(
            result.capabilitiesByRole.containsKey('broken_role'),
            isFalse,
          );
        },
      );
    },
  );

  // TranscriptionSettingsResponse: language defaults to .auto on empty/unknown string
  group('TranscriptionSettingsResponse – language fallback to auto', () {
    test('empty string language falls back to auto', () {
      final json = {
        'closed_caption_mode': 'disabled',
        'language': '',
        'mode': 'disabled',
      };

      final result = TranscriptionSettingsResponse.fromJson(json)!;

      expect(
        result.language,
        TranscriptionSettingsResponseLanguageEnum.auto,
      );
    });

    test('valid language is parsed correctly', () {
      final json = {
        'closed_caption_mode': 'disabled',
        'language': 'en',
        'mode': 'available',
      };

      final result = TranscriptionSettingsResponse.fromJson(json)!;

      expect(
        result.language,
        TranscriptionSettingsResponseLanguageEnum.en,
      );
    });

    test('unknown language string falls back to auto', () {
      final json = {
        'closed_caption_mode': 'disabled',
        'language': 'unknown_language_xyz',
        'mode': 'disabled',
      };

      final result = TranscriptionSettingsResponse.fromJson(json)!;

      expect(
        result.language,
        TranscriptionSettingsResponseLanguageEnum.auto,
      );
    });
  });

  // ParticipantSeriesTrackMetrics: metrics via _mapListListDoubleFromJson
  group('ParticipantSeriesTrackMetrics – nested list metrics', () {
    test('metrics with nested List<List<double>> parses correctly', () {
      final json = {
        'track_id': 'track-1',
        'metrics': {
          'jitter': [
            [1.5, 2.0, 3.5],
            [4.0, 5.5, 6.0],
          ],
          'bitrate': [
            [100.0, 200.0],
          ],
        },
        'metrics_meta': <String, dynamic>{},
        'metrics_order': ['jitter', 'bitrate'],
      };

      final result = ParticipantSeriesTrackMetrics.fromJson(json)!;

      expect(result.metrics, isA<Map<String, List<List<double>>>>());
      expect(result.metrics['jitter'], hasLength(2));
      expect(result.metrics['jitter']![0], [1.5, 2.0, 3.5]);
      expect(result.metrics['jitter']![1], [4.0, 5.5, 6.0]);
      expect(result.metrics['bitrate']![0], [100.0, 200.0]);
    });

    test('metrics with integer values are converted to double', () {
      final json = {
        'track_id': 'track-2',
        'metrics': {
          'fps': [
            [30, 60, 24],
          ],
        },
        'metrics_meta': <String, dynamic>{},
        'metrics_order': ['fps'],
      };

      final result = ParticipantSeriesTrackMetrics.fromJson(json)!;

      expect(result.metrics['fps']![0], isA<List<double>>());
      expect(result.metrics['fps']![0], [30.0, 60.0, 24.0]);
    });

    test('null metrics produces empty map', () {
      final json = {
        'track_id': 'track-3',
        'metrics': null,
      };

      final result = ParticipantSeriesTrackMetrics.fromJson(json)!;

      expect(result.metrics, isEmpty);
    });
  });

  // ParticipantSeriesPublisherStats: global via _mapListListDoubleFromJson
  group('ParticipantSeriesPublisherStats – nested list global', () {
    test('global with nested List<List<double>> parses correctly', () {
      final json = {
        'global': {
          'packet_loss': [
            [0.1, 0.2],
            [0.3, 0.4],
          ],
        },
        'global_meta': <String, dynamic>{},
        'global_metrics_order': ['packet_loss'],
      };

      final result = ParticipantSeriesPublisherStats.fromJson(json)!;

      expect(result.global, isA<Map<String, List<List<double>>>>());
      expect(result.global['packet_loss']![0], [0.1, 0.2]);
      expect(result.global['packet_loss']![1], [0.3, 0.4]);
    });

    test('global with integer values converts to double', () {
      final json = {
        'global': {
          'rtt': [
            [10, 20, 30],
          ],
        },
        'global_meta': <String, dynamic>{},
        'global_metrics_order': ['rtt'],
      };

      final result = ParticipantSeriesPublisherStats.fromJson(json)!;

      expect(result.global['rtt']![0], [10.0, 20.0, 30.0]);
    });
  });

  // ParticipantSeriesSubscriberStats: global via _mapListListDoubleFromJson
  group('ParticipantSeriesSubscriberStats – nested list global', () {
    test('global with nested List<List<double>> parses correctly', () {
      final json = {
        'global': {
          'latency': [
            [50.0, 55.0],
          ],
        },
        'global_meta': <String, dynamic>{},
        'global_metrics_order': ['latency'],
        'subscriptions': <dynamic>[],
      };

      final result = ParticipantSeriesSubscriberStats.fromJson(json)!;

      expect(result.global, isA<Map<String, List<List<double>>>>());
      expect(result.global['latency']![0], [50.0, 55.0]);
    });
  });

  // ParticipantSeriesUserStats: metrics via _mapListListDoubleFromJson
  group('ParticipantSeriesUserStats – nested list metrics', () {
    test('metrics with nested List<List<double>> parses correctly', () {
      final json = {
        'metrics': {
          'cpu_usage': [
            [0.5, 0.6, 0.7],
          ],
        },
        'metrics_meta': <String, dynamic>{},
        'metrics_order': ['cpu_usage'],
      };

      final result = ParticipantSeriesUserStats.fromJson(json)!;

      expect(result.metrics, isA<Map<String, List<List<double>>>>());
      expect(result.metrics['cpu_usage']![0], [0.5, 0.6, 0.7]);
    });

    test('mixed int/double values are all converted to double', () {
      final json = {
        'metrics': {
          'memory': [
            [512, 1024.5, 2048],
          ],
        },
        'metrics_meta': <String, dynamic>{},
        'metrics_order': ['memory'],
      };

      final result = ParticipantSeriesUserStats.fromJson(json)!;

      expect(result.metrics['memory']![0], isA<List<double>>());
      expect(result.metrics['memory']![0], [512.0, 1024.5, 2048.0]);
    });
  });

  // ApiClient: DurationResponse registered in the deserialize type map
  group('ApiClient – DurationResponse registered', () {
    test('ApiClient can deserialize DurationResponse by type name', () {
      final client = ApiClient();
      final result = client.deserialize(
        '{"duration":"50ms"}',
        'DurationResponse',
        growable: true,
      );

      expect(result, isA<DurationResponse>());
      expect((result as DurationResponse).duration, '50ms');
    });
  });
}

// ---------------------------------------------------------------------------
// Minimal JSON fixture builders for events that embed a full CallResponse.
// ---------------------------------------------------------------------------

Map<String, dynamic> _callUpdatedEventJson({
  required Map<String, dynamic> capabilitiesByRole,
}) => {
  'call': _minimalCallResponseJson(),
  'call_cid': 'default:call-1',
  'capabilities_by_role': capabilitiesByRole,
  'created_at': '2024-05-01T10:00:00.000Z',
  'type': 'call.updated',
};

Map<String, dynamic> _callMemberUpdatedPermissionEventJson({
  required Map<String, dynamic> capabilitiesByRole,
}) => {
  'call': _minimalCallResponseJson(),
  'call_cid': 'default:call-1',
  'capabilities_by_role': capabilitiesByRole,
  'created_at': '2024-05-01T10:00:00.000Z',
  'members': <dynamic>[],
  'type': 'call.member_updated_permission',
};

Map<String, dynamic> _minimalCallResponseJson() => {
  'backstage': false,
  'blocked_user_ids': <dynamic>[],
  'captioning': false,
  'cid': 'default:call-1',
  'created_at': '2024-05-01T10:00:00.000Z',
  'created_by': _minimalUserResponseJson(),
  'current_session_id': '',
  'custom': <String, dynamic>{},
  'egress': {
    'broadcasting': false,
    'rtmps': <dynamic>[],
  },
  'id': 'call-1',
  'ingress': {
    'rtmp': {'address': ''},
    'srt': {'address': ''},
    'whip': {'address': ''},
  },
  'recording': false,
  'settings': _minimalCallSettingsJson(),
  'transcribing': false,
  'translating': false,
  'type': 'default',
  'updated_at': '2024-05-01T10:00:00.000Z',
};

Map<String, dynamic> _minimalUserResponseJson() => {
  'blocked_user_ids': <dynamic>[],
  'created_at': '2024-01-01T00:00:00.000Z',
  'custom': <String, dynamic>{},
  'id': 'user-fixture',
  'language': 'en',
  'role': 'user',
  'teams': <dynamic>[],
  'updated_at': '2024-01-01T00:00:00.000Z',
};

Map<String, dynamic> _minimalCallSettingsJson() => {
  'audio': {
    'access_request_enabled': false,
    'default_device': 'speaker',
    'hifi_audio_enabled': false,
    'mic_default_on': true,
    'opus_dtx_enabled': false,
    'redundant_coding_enabled': false,
    'speaker_default_on': true,
  },
  'backstage': {'enabled': false},
  'broadcasting': {
    'enabled': false,
    'hls': {
      'auto_on': false,
      'enabled': false,
      'quality_tracks': <dynamic>[],
    },
    'rtmp': {'enabled': false, 'quality': '720p'},
  },
  'frame_recording': {
    'capture_interval_in_seconds': 0,
    'mode': 'disabled',
  },
  'geofencing': {'names': <dynamic>[]},
  'individual_recording': {'mode': 'disabled'},
  'limits': {'max_participants_exclude_roles': <dynamic>[]},
  'raw_recording': {'mode': 'disabled'},
  'recording': {
    'audio_only': false,
    'mode': 'disabled',
    'quality': 'audio-only',
  },
  'ring': {
    'auto_cancel_timeout_ms': 0,
    'incoming_call_timeout_ms': 0,
    'missed_call_timeout_ms': 0,
  },
  'screensharing': {
    'access_request_enabled': false,
    'enabled': false,
  },
  'session': {'inactivity_timeout_seconds': 0},
  'thumbnails': {'enabled': false},
  'transcription': {
    'closed_caption_mode': 'disabled',
    'language': 'en',
    'mode': 'disabled',
  },
  'video': {
    'access_request_enabled': false,
    'camera_default_on': true,
    'camera_facing': 'front',
    'enabled': true,
    'target_resolution': {'height': 720, 'width': 1280},
  },
};
