//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:stream_video/open_api/video/coordinator/src/date_serializer.dart';
import 'package:stream_video/open_api/video/coordinator/model/date.dart';

import 'package:stream_video/open_api/video/coordinator/model/api_error.dart';
import 'package:stream_video/open_api/video/coordinator/model/accept_call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/app_event_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/app_updated_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/audio_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/audio_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/backstage_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/backstage_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/block_user_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/block_user_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/blocked_user_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/bound.dart';
import 'package:stream_video/open_api/video/coordinator/model/broadcast_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/broadcast_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_accepted_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_closed_caption.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_closed_captions_failed_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_closed_captions_started_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_closed_captions_stopped_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_created_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_deleted_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_duration_report.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_duration_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_ended_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_frame_recording_failed_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_frame_recording_frame_ready_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_frame_recording_started_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_frame_recording_stopped_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_hls_broadcasting_failed_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_hls_broadcasting_started_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_hls_broadcasting_stopped_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_ingress_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_live_started_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_member_added_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_member_removed_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_member_updated_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_member_updated_permission_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_missed_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_moderation_blur_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_moderation_warning_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_notification_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_participant_count_report.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_participant_count_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_participant_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_reaction_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_recording.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_recording_failed_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_recording_ready_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_recording_started_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_recording_stopped_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_rejected_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_ring_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_rtmp_broadcast_failed_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_rtmp_broadcast_started_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_rtmp_broadcast_stopped_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_session_ended_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_session_participant_counts_updated_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_session_participant_joined_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_session_participant_left_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_session_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_session_started_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_state_response_fields.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_stats_report_ready_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_stats_report_summary_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_transcription.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_transcription_failed_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_transcription_ready_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_transcription_started_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_transcription_stopped_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_updated_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_user_muted_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/calls_per_day_report.dart';
import 'package:stream_video/open_api/video/coordinator/model/calls_per_day_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/chat_activity_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/closed_caption_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/collect_user_feedback_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/collect_user_feedback_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/connect_user_details_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/connected_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/connection_error_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/count_by_minute_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/create_device_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/create_guest_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/create_guest_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/credentials.dart';
import 'package:stream_video/open_api/video/coordinator/model/custom_video_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_call_duration_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_call_participant_count_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_calls_per_day_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_quality_score_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_sdk_usage_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_user_feedback_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/delete_call_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/delete_call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/delete_recording_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/delete_transcription_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/device_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/edge_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/egress_hls_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/egress_rtmp_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/egress_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/end_call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/file_upload_config.dart';
import 'package:stream_video/open_api/video/coordinator/model/frame_recording_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/frame_recording_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/frame_recording_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/geofence_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/geofence_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/get_call_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/get_call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/get_edges_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/get_or_create_call_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/get_or_create_call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/go_live_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/go_live_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/grouped_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/hls_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/hls_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/health_check_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/ice_server.dart';
import 'package:stream_video/open_api/video/coordinator/model/join_call_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/join_call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/layout_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/limits_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/limits_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/list_devices_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/list_recordings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/list_transcriptions_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/message_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/mute_users_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/mute_users_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/network_metrics_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/noise_cancellation_settings.dart';
import 'package:stream_video/open_api/video/coordinator/model/own_capability.dart';
import 'package:stream_video/open_api/video/coordinator/model/own_user_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/participant_count_by_minute_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/participant_count_over_time_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/participant_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/per_sdk_usage_report.dart';
import 'package:stream_video/open_api/video/coordinator/model/permission_request_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/pin_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/pin_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/privacy_settings.dart';
import 'package:stream_video/open_api/video/coordinator/model/publisher_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/push_preferences.dart';
import 'package:stream_video/open_api/video/coordinator/model/quality_score_report.dart';
import 'package:stream_video/open_api/video/coordinator/model/quality_score_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_aggregate_call_stats_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_aggregate_call_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_call_members_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_call_members_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_call_participants_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_call_participants_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_call_stats_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_call_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_calls_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/query_calls_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/rtmp_broadcast_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/rtmp_ingress.dart';
import 'package:stream_video/open_api/video/coordinator/model/rtmp_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/rtmp_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/reaction_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/read_receipts.dart';
import 'package:stream_video/open_api/video/coordinator/model/record_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/record_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/reject_call_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/reject_call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/report_by_histogram_bucket.dart';
import 'package:stream_video/open_api/video/coordinator/model/report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/request_permission_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/request_permission_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/response.dart';
import 'package:stream_video/open_api/video/coordinator/model/ring_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/ring_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/sdk_usage_report.dart';
import 'package:stream_video/open_api/video/coordinator/model/sdk_usage_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/sfu_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/screensharing_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/screensharing_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/send_call_event_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/send_call_event_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/send_reaction_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/send_reaction_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/session_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/session_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/sort_param_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_closed_captions_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_closed_captions_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_frame_recording_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_frame_recording_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_hls_broadcasting_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_rtmp_broadcasts_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_rtmp_broadcasts_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_recording_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_recording_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_transcription_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/start_transcription_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/stats_options.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_all_rtmp_broadcasts_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_closed_captions_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_closed_captions_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_frame_recording_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_hls_broadcasting_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_live_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_live_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_rtmp_broadcasts_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_recording_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_transcription_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/stop_transcription_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/subscriber_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/target_resolution.dart';
import 'package:stream_video/open_api/video/coordinator/model/thumbnail_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/thumbnails_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/thumbnails_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/track_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/transcription_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/transcription_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/typing_indicators.dart';
import 'package:stream_video/open_api/video/coordinator/model/unblock_user_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/unblock_user_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/unblocked_user_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/unpin_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/unpin_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/update_call_members_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/update_call_members_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/update_call_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/update_call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/update_user_permissions_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/update_user_permissions_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/updated_call_permissions_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/user.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_banned_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_deactivated_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_feedback_report.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_feedback_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_muted_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_rating_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_reactivated_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_response_privacy_fields.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_updated_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/video_event.dart';
import 'package:stream_video/open_api/video/coordinator/model/video_reaction_over_time_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/video_reactions_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/video_settings_request.dart';
import 'package:stream_video/open_api/video/coordinator/model/video_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/ws_auth_message.dart';

part 'serializers.g.dart';

@SerializersFor([
  APIError,
  AcceptCallResponse,
  AppEventResponse,
  AppUpdatedEvent,
  AudioSettingsRequest,
  AudioSettingsResponse,
  BackstageSettingsRequest,
  BackstageSettingsResponse,
  BlockUserRequest,
  BlockUserResponse,
  BlockedUserEvent,
  Bound,
  BroadcastSettingsRequest,
  BroadcastSettingsResponse,
  CallAcceptedEvent,
  CallClosedCaption,
  CallClosedCaptionsFailedEvent,
  CallClosedCaptionsStartedEvent,
  CallClosedCaptionsStoppedEvent,
  CallCreatedEvent,
  CallDeletedEvent,
  CallDurationReport,
  CallDurationReportResponse,
  CallEndedEvent,
  CallFrameRecordingFailedEvent,
  CallFrameRecordingFrameReadyEvent,
  CallFrameRecordingStartedEvent,
  CallFrameRecordingStoppedEvent,
  CallHLSBroadcastingFailedEvent,
  CallHLSBroadcastingStartedEvent,
  CallHLSBroadcastingStoppedEvent,
  CallIngressResponse,
  CallLiveStartedEvent,
  CallMemberAddedEvent,
  CallMemberRemovedEvent,
  CallMemberUpdatedEvent,
  CallMemberUpdatedPermissionEvent,
  CallMissedEvent,
  CallModerationBlurEvent,
  CallModerationWarningEvent,
  CallNotificationEvent,
  CallParticipantCountReport,
  CallParticipantCountReportResponse,
  CallParticipantResponse,
  CallReactionEvent,
  CallRecording,
  CallRecordingFailedEvent,
  CallRecordingReadyEvent,
  CallRecordingStartedEvent,
  CallRecordingStoppedEvent,
  CallRejectedEvent,
  CallReportResponse,
  CallRequest,
  CallResponse,
  CallRingEvent,
  CallRtmpBroadcastFailedEvent,
  CallRtmpBroadcastStartedEvent,
  CallRtmpBroadcastStoppedEvent,
  CallSessionEndedEvent,
  CallSessionParticipantCountsUpdatedEvent,
  CallSessionParticipantJoinedEvent,
  CallSessionParticipantLeftEvent,
  CallSessionResponse,
  CallSessionStartedEvent,
  CallSettingsRequest,
  CallSettingsResponse,
  CallStateResponseFields,
  CallStatsReportReadyEvent,
  CallStatsReportSummaryResponse,
  CallTranscription,
  CallTranscriptionFailedEvent,
  CallTranscriptionReadyEvent,
  CallTranscriptionStartedEvent,
  CallTranscriptionStoppedEvent,
  CallUpdatedEvent,
  CallUserMutedEvent,
  CallsPerDayReport,
  CallsPerDayReportResponse,
  ChatActivityStatsResponse,
  ClosedCaptionEvent,
  CollectUserFeedbackRequest,
  CollectUserFeedbackResponse,
  ConnectUserDetailsRequest,
  ConnectedEvent,
  ConnectionErrorEvent,
  CountByMinuteResponse,
  CreateDeviceRequest,
  CreateGuestRequest,
  CreateGuestResponse,
  Credentials,
  CustomVideoEvent,
  DailyAggregateCallDurationReportResponse,
  DailyAggregateCallParticipantCountReportResponse,
  DailyAggregateCallsPerDayReportResponse,
  DailyAggregateQualityScoreReportResponse,
  DailyAggregateSDKUsageReportResponse,
  DailyAggregateUserFeedbackReportResponse,
  DeleteCallRequest,
  DeleteCallResponse,
  DeleteRecordingResponse,
  DeleteTranscriptionResponse,
  DeviceResponse,
  EdgeResponse,
  EgressHLSResponse,
  EgressRTMPResponse,
  EgressResponse,
  EndCallResponse,
  FileUploadConfig,
  FrameRecordingResponse,
  FrameRecordingSettingsRequest,
  FrameRecordingSettingsResponse,
  GeofenceSettingsRequest,
  GeofenceSettingsResponse,
  GetCallReportResponse,
  GetCallResponse,
  GetEdgesResponse,
  GetOrCreateCallRequest,
  GetOrCreateCallResponse,
  GoLiveRequest,
  GoLiveResponse,
  GroupedStatsResponse,
  HLSSettingsRequest,
  HLSSettingsResponse,
  HealthCheckEvent,
  ICEServer,
  JoinCallRequest,
  JoinCallResponse,
  LayoutSettingsRequest,
  LimitsSettingsRequest,
  LimitsSettingsResponse,
  ListDevicesResponse,
  ListRecordingsResponse,
  ListTranscriptionsResponse,
  MemberRequest,
  MemberResponse,
  MessageStatsResponse,
  MuteUsersRequest,
  MuteUsersResponse,
  NetworkMetricsReportResponse,
  NoiseCancellationSettings,
  OwnCapability,
  OwnUserResponse,
  ParticipantCountByMinuteResponse,
  ParticipantCountOverTimeResponse,
  ParticipantReportResponse,
  PerSDKUsageReport,
  PermissionRequestEvent,
  PinRequest,
  PinResponse,
  PrivacySettings,
  PublisherStatsResponse,
  PushPreferences,
  QualityScoreReport,
  QualityScoreReportResponse,
  QueryAggregateCallStatsRequest,
  QueryAggregateCallStatsResponse,
  QueryCallMembersRequest,
  QueryCallMembersResponse,
  QueryCallParticipantsRequest,
  QueryCallParticipantsResponse,
  QueryCallStatsRequest,
  QueryCallStatsResponse,
  QueryCallsRequest,
  QueryCallsResponse,
  RTMPBroadcastRequest,
  RTMPIngress,
  RTMPSettingsRequest,
  RTMPSettingsResponse,
  ReactionResponse,
  ReadReceipts,
  RecordSettingsRequest,
  RecordSettingsResponse,
  RejectCallRequest,
  RejectCallResponse,
  ReportByHistogramBucket,
  ReportResponse,
  RequestPermissionRequest,
  RequestPermissionResponse,
  Response,
  RingSettingsRequest,
  RingSettingsResponse,
  SDKUsageReport,
  SDKUsageReportResponse,
  SFUResponse,
  ScreensharingSettingsRequest,
  ScreensharingSettingsResponse,
  SendCallEventRequest,
  SendCallEventResponse,
  SendReactionRequest,
  SendReactionResponse,
  SessionSettingsRequest,
  SessionSettingsResponse,
  SortParamRequest,
  StartClosedCaptionsRequest,
  StartClosedCaptionsResponse,
  StartFrameRecordingRequest,
  StartFrameRecordingResponse,
  StartHLSBroadcastingResponse,
  StartRTMPBroadcastsRequest,
  StartRTMPBroadcastsResponse,
  StartRecordingRequest,
  StartRecordingResponse,
  StartTranscriptionRequest,
  StartTranscriptionResponse,
  StatsOptions,
  StopAllRTMPBroadcastsResponse,
  StopClosedCaptionsRequest,
  StopClosedCaptionsResponse,
  StopFrameRecordingResponse,
  StopHLSBroadcastingResponse,
  StopLiveRequest,
  StopLiveResponse,
  StopRTMPBroadcastsResponse,
  StopRecordingResponse,
  StopTranscriptionRequest,
  StopTranscriptionResponse,
  SubscriberStatsResponse,
  TargetResolution,
  ThumbnailResponse,
  ThumbnailsSettingsRequest,
  ThumbnailsSettingsResponse,
  TrackStatsResponse,
  TranscriptionSettingsRequest,
  TranscriptionSettingsResponse,
  TypingIndicators,
  UnblockUserRequest,
  UnblockUserResponse,
  UnblockedUserEvent,
  UnpinRequest,
  UnpinResponse,
  UpdateCallMembersRequest,
  UpdateCallMembersResponse,
  UpdateCallRequest,
  UpdateCallResponse,
  UpdateUserPermissionsRequest,
  UpdateUserPermissionsResponse,
  UpdatedCallPermissionsEvent,
  User,
  UserBannedEvent,
  UserDeactivatedEvent,
  UserFeedbackReport,
  UserFeedbackReportResponse,
  UserMutedEvent,
  UserRatingReportResponse,
  UserReactivatedEvent,
  UserRequest,
  UserResponse,
  UserResponsePrivacyFields,
  UserUpdatedEvent,
  VideoEvent,
  VideoReactionOverTimeResponse,
  VideoReactionsResponse,
  VideoSettingsRequest,
  VideoSettingsResponse,
  WSAuthMessage,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
