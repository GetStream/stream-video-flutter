/// Minimal coordinator JSON, the smallest payloads the generated models
/// accept.
library;

Map<String, dynamic> minimalCallResponseJson() => {
  'backstage': false,
  'blocked_user_ids': <dynamic>[],
  'captioning': false,
  'cid': 'default:call-1',
  'created_at': '2024-05-01T10:00:00.000Z',
  'created_by': minimalUserResponseJson(),
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
  'settings': minimalCallSettingsJson(),
  'transcribing': false,
  'translating': false,
  'type': 'default',
  'updated_at': '2024-05-01T10:00:00.000Z',
};

Map<String, dynamic> minimalUserResponseJson() => {
  'banned': false,
  'blocked_user_ids': <dynamic>[],
  'created_at': '2024-01-01T00:00:00.000Z',
  'custom': <String, dynamic>{},
  'id': 'user-fixture',
  'language': 'en',
  'online': false,
  'role': 'user',
  'teams': <dynamic>[],
  'updated_at': '2024-01-01T00:00:00.000Z',
};

Map<String, dynamic> minimalCallSettingsJson() => {
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
  'encryption': {'mode': 'disabled'},
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
