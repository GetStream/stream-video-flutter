//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

part 'api/default_api.dart';
part 'api/events_api.dart';
part 'api/users_api.dart';
part 'api/video_calls_api.dart';

part 'model/api_error.dart';
part 'model/any_event.dart';
part 'model/audio_settings.dart';
part 'model/backstage_settings.dart';
part 'model/block_user_request.dart';
part 'model/block_user_response.dart';
part 'model/blocked_user_event.dart';
part 'model/broadcast_settings.dart';
part 'model/call_accepted_event.dart';
part 'model/call_cancelled_event.dart';
part 'model/call_created_event.dart';
part 'model/call_ended_event.dart';
part 'model/call_recording_started_event.dart';
part 'model/call_recording_stopped_event.dart';
part 'model/call_rejected_event.dart';
part 'model/call_request.dart';
part 'model/call_response.dart';
part 'model/call_settings_request.dart';
part 'model/call_settings_response.dart';
part 'model/call_state_response_fields.dart';
part 'model/call_updated_event.dart';
part 'model/coordinates.dart';
part 'model/credentials.dart';
part 'model/custom_video_event.dart';
part 'model/datacenter_response.dart';
part 'model/device.dart';
part 'model/end_call_response.dart';
part 'model/geofence_settings.dart';
part 'model/geofence_settings_request.dart';
part 'model/get_call_edge_server_request.dart';
part 'model/get_call_edge_server_response.dart';
part 'model/get_or_create_call_request.dart';
part 'model/get_or_create_call_response.dart';
part 'model/go_live_response.dart';
part 'model/hls_settings.dart';
part 'model/health_check_event.dart';
part 'model/ice_server.dart';
part 'model/join_call_request.dart';
part 'model/join_call_response.dart';
part 'model/member_request.dart';
part 'model/member_response.dart';
part 'model/mute_users_request.dart';
part 'model/mute_users_response.dart';
part 'model/own_user_response.dart';
part 'model/pagination_params_request.dart';
part 'model/permission_request_event.dart';
part 'model/query_calls_request.dart';
part 'model/query_calls_response.dart';
part 'model/query_members_request.dart';
part 'model/query_members_response.dart';
part 'model/record_settings.dart';
part 'model/record_settings_request.dart';
part 'model/request_permission_request.dart';
part 'model/request_permission_response.dart';
part 'model/sfu_response.dart';
part 'model/screensharing_settings.dart';
part 'model/screensharing_settings_request.dart';
part 'model/send_event_request.dart';
part 'model/send_event_response.dart';
part 'model/sort_param_request.dart';
part 'model/stop_live_response.dart';
part 'model/unblock_user_request.dart';
part 'model/unblock_user_response.dart';
part 'model/unblocked_user_event.dart';
part 'model/update_call_request.dart';
part 'model/update_call_response.dart';
part 'model/update_user_permissions_request.dart';
part 'model/update_user_permissions_response.dart';
part 'model/updated_call_permissions_event.dart';
part 'model/user_request.dart';
part 'model/user_response.dart';
part 'model/video_settings.dart';
part 'model/video_settings_request.dart';


const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

ApiClient defaultApiClient = ApiClient();
