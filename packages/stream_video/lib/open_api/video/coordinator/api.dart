//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/productvideo_api.dart';

part 'model/api_error.dart';
part 'model/accept_call_response.dart';
part 'model/aggregated_stats.dart';
part 'model/app_event_response.dart';
part 'model/app_updated_event.dart';
part 'model/audio_settings_request.dart';
part 'model/audio_settings_response.dart';
part 'model/backstage_settings_request.dart';
part 'model/backstage_settings_response.dart';
part 'model/block_user_request.dart';
part 'model/block_user_response.dart';
part 'model/blocked_user_event.dart';
part 'model/bound.dart';
part 'model/broadcast_settings_request.dart';
part 'model/broadcast_settings_response.dart';
part 'model/call_accepted_event.dart';
part 'model/call_closed_caption.dart';
part 'model/call_closed_captions_failed_event.dart';
part 'model/call_closed_captions_started_event.dart';
part 'model/call_closed_captions_stopped_event.dart';
part 'model/call_created_event.dart';
part 'model/call_deleted_event.dart';
part 'model/call_duration_report.dart';
part 'model/call_duration_report_response.dart';
part 'model/call_ended_event.dart';
part 'model/call_event.dart';
part 'model/call_frame_recording_failed_event.dart';
part 'model/call_frame_recording_frame_ready_event.dart';
part 'model/call_frame_recording_started_event.dart';
part 'model/call_frame_recording_stopped_event.dart';
part 'model/call_hls_broadcasting_failed_event.dart';
part 'model/call_hls_broadcasting_started_event.dart';
part 'model/call_hls_broadcasting_stopped_event.dart';
part 'model/call_ingress_response.dart';
part 'model/call_live_started_event.dart';
part 'model/call_member_added_event.dart';
part 'model/call_member_removed_event.dart';
part 'model/call_member_updated_event.dart';
part 'model/call_member_updated_permission_event.dart';
part 'model/call_missed_event.dart';
part 'model/call_notification_event.dart';
part 'model/call_participant_count_report.dart';
part 'model/call_participant_count_report_response.dart';
part 'model/call_participant_response.dart';
part 'model/call_reaction_event.dart';
part 'model/call_recording.dart';
part 'model/call_recording_failed_event.dart';
part 'model/call_recording_ready_event.dart';
part 'model/call_recording_started_event.dart';
part 'model/call_recording_stopped_event.dart';
part 'model/call_rejected_event.dart';
part 'model/call_request.dart';
part 'model/call_response.dart';
part 'model/call_ring_event.dart';
part 'model/call_rtmp_broadcast_failed_event.dart';
part 'model/call_rtmp_broadcast_started_event.dart';
part 'model/call_rtmp_broadcast_stopped_event.dart';
part 'model/call_session_ended_event.dart';
part 'model/call_session_participant_counts_updated_event.dart';
part 'model/call_session_participant_joined_event.dart';
part 'model/call_session_participant_left_event.dart';
part 'model/call_session_response.dart';
part 'model/call_session_started_event.dart';
part 'model/call_settings_request.dart';
part 'model/call_settings_response.dart';
part 'model/call_state_response_fields.dart';
part 'model/call_stats_report_summary_response.dart';
part 'model/call_timeline.dart';
part 'model/call_transcription.dart';
part 'model/call_transcription_failed_event.dart';
part 'model/call_transcription_ready_event.dart';
part 'model/call_transcription_started_event.dart';
part 'model/call_transcription_stopped_event.dart';
part 'model/call_updated_event.dart';
part 'model/call_user_muted_event.dart';
part 'model/calls_per_day_report.dart';
part 'model/calls_per_day_report_response.dart';
part 'model/closed_caption_event.dart';
part 'model/collect_user_feedback_request.dart';
part 'model/collect_user_feedback_response.dart';
part 'model/connect_user_details_request.dart';
part 'model/connected_event.dart';
part 'model/connection_error_event.dart';
part 'model/coordinates.dart';
part 'model/count.dart';
part 'model/create_device_request.dart';
part 'model/create_guest_request.dart';
part 'model/create_guest_response.dart';
part 'model/credentials.dart';
part 'model/custom_video_event.dart';
part 'model/daily_aggregate_call_duration_report_response.dart';
part 'model/daily_aggregate_call_participant_count_report_response.dart';
part 'model/daily_aggregate_calls_per_day_report_response.dart';
part 'model/daily_aggregate_quality_score_report_response.dart';
part 'model/daily_aggregate_sdk_usage_report_response.dart';
part 'model/daily_aggregate_user_feedback_report_response.dart';
part 'model/delete_call_request.dart';
part 'model/delete_call_response.dart';
part 'model/delete_recording_response.dart';
part 'model/delete_transcription_response.dart';
part 'model/device_response.dart';
part 'model/edge_response.dart';
part 'model/egress_hls_response.dart';
part 'model/egress_rtmp_response.dart';
part 'model/egress_response.dart';
part 'model/end_call_response.dart';
part 'model/fps_stats.dart';
part 'model/file_upload_config.dart';
part 'model/frame_recording_response.dart';
part 'model/frame_recording_settings_request.dart';
part 'model/frame_recording_settings_response.dart';
part 'model/geofence_settings_request.dart';
part 'model/geofence_settings_response.dart';
part 'model/geolocation_result.dart';
part 'model/get_call_response.dart';
part 'model/get_call_stats_response.dart';
part 'model/get_edges_response.dart';
part 'model/get_or_create_call_request.dart';
part 'model/get_or_create_call_response.dart';
part 'model/go_live_request.dart';
part 'model/go_live_response.dart';
part 'model/hls_settings_request.dart';
part 'model/hls_settings_response.dart';
part 'model/health_check_event.dart';
part 'model/ice_server.dart';
part 'model/join_call_request.dart';
part 'model/join_call_response.dart';
part 'model/layout_settings_request.dart';
part 'model/limits_settings_request.dart';
part 'model/limits_settings_response.dart';
part 'model/list_devices_response.dart';
part 'model/list_recordings_response.dart';
part 'model/list_transcriptions_response.dart';
part 'model/location.dart';
part 'model/media_pub_sub_hint.dart';
part 'model/member_request.dart';
part 'model/member_response.dart';
part 'model/mute_users_request.dart';
part 'model/mute_users_response.dart';
part 'model/network_metrics_report_response.dart';
part 'model/noise_cancellation_settings.dart';
part 'model/own_capability.dart';
part 'model/own_user_response.dart';
part 'model/per_sdk_usage_report.dart';
part 'model/permission_request_event.dart';
part 'model/pin_request.dart';
part 'model/pin_response.dart';
part 'model/published_track_info.dart';
part 'model/publisher_aggregate_stats.dart';
part 'model/push_preferences.dart';
part 'model/quality_score_report.dart';
part 'model/quality_score_report_response.dart';
part 'model/query_aggregate_call_stats_request.dart';
part 'model/query_aggregate_call_stats_response.dart';
part 'model/query_call_members_request.dart';
part 'model/query_call_members_response.dart';
part 'model/query_call_stats_request.dart';
part 'model/query_call_stats_response.dart';
part 'model/query_calls_request.dart';
part 'model/query_calls_response.dart';
part 'model/rtmp_broadcast_request.dart';
part 'model/rtmp_ingress.dart';
part 'model/rtmp_settings_request.dart';
part 'model/rtmp_settings_response.dart';
part 'model/reaction_response.dart';
part 'model/read_receipts.dart';
part 'model/record_settings_request.dart';
part 'model/record_settings_response.dart';
part 'model/reject_call_request.dart';
part 'model/reject_call_response.dart';
part 'model/report_by_histogram_bucket.dart';
part 'model/request_permission_request.dart';
part 'model/request_permission_response.dart';
part 'model/response.dart';
part 'model/ring_settings_request.dart';
part 'model/ring_settings_response.dart';
part 'model/sdk_usage_report.dart';
part 'model/sdk_usage_report_response.dart';
part 'model/sfu_location_response.dart';
part 'model/sfu_response.dart';
part 'model/screensharing_settings_request.dart';
part 'model/screensharing_settings_response.dart';
part 'model/send_call_event_request.dart';
part 'model/send_call_event_response.dart';
part 'model/send_reaction_request.dart';
part 'model/send_reaction_response.dart';
part 'model/session_settings_request.dart';
part 'model/session_settings_response.dart';
part 'model/sort_param_request.dart';
part 'model/start_closed_captions_request.dart';
part 'model/start_closed_captions_response.dart';
part 'model/start_frame_recording_request.dart';
part 'model/start_frame_recording_response.dart';
part 'model/start_hls_broadcasting_response.dart';
part 'model/start_rtmp_broadcasts_request.dart';
part 'model/start_rtmp_broadcasts_response.dart';
part 'model/start_recording_request.dart';
part 'model/start_recording_response.dart';
part 'model/start_transcription_request.dart';
part 'model/start_transcription_response.dart';
part 'model/stats_options.dart';
part 'model/stop_all_rtmp_broadcasts_response.dart';
part 'model/stop_closed_captions_request.dart';
part 'model/stop_closed_captions_response.dart';
part 'model/stop_frame_recording_response.dart';
part 'model/stop_hls_broadcasting_response.dart';
part 'model/stop_live_request.dart';
part 'model/stop_live_response.dart';
part 'model/stop_rtmp_broadcasts_response.dart';
part 'model/stop_recording_response.dart';
part 'model/stop_transcription_request.dart';
part 'model/stop_transcription_response.dart';
part 'model/subsession.dart';
part 'model/turn_aggregated_stats.dart';
part 'model/target_resolution.dart';
part 'model/thumbnail_response.dart';
part 'model/thumbnails_settings_request.dart';
part 'model/thumbnails_settings_response.dart';
part 'model/time_stats.dart';
part 'model/transcription_settings_request.dart';
part 'model/transcription_settings_response.dart';
part 'model/unblock_user_request.dart';
part 'model/unblock_user_response.dart';
part 'model/unblocked_user_event.dart';
part 'model/unpin_request.dart';
part 'model/unpin_response.dart';
part 'model/update_call_members_request.dart';
part 'model/update_call_members_response.dart';
part 'model/update_call_request.dart';
part 'model/update_call_response.dart';
part 'model/update_user_permissions_request.dart';
part 'model/update_user_permissions_response.dart';
part 'model/updated_call_permissions_event.dart';
part 'model/user_feedback_report.dart';
part 'model/user_feedback_report_response.dart';
part 'model/user_info_response.dart';
part 'model/user_request.dart';
part 'model/user_response.dart';
part 'model/user_response_privacy_fields.dart';
part 'model/user_session_stats.dart';
part 'model/user_stats.dart';
part 'model/user_updated_event.dart';
part 'model/video_dimension.dart';
part 'model/video_event.dart';
part 'model/video_quality.dart';
part 'model/video_settings_request.dart';
part 'model/video_settings_response.dart';
part 'model/ws_auth_message.dart';

/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) =>
    pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
