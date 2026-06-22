// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_api.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _DefaultApi implements DefaultApi {
  _DefaultApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  Future<AcceptCallResponse> _acceptCall({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<AcceptCallResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/accept',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AcceptCallResponse _value;
    try {
      _value = AcceptCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<AcceptCallResponse>> acceptCall({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<AcceptCallResponse>().adapt(
      () => _acceptCall(type: type, id: id),
    );
  }

  Future<AddUserGroupMembersResponse> _addUserGroupMembers({
    required String id,
    required AddUserGroupMembersRequest addUserGroupMembersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(addUserGroupMembersRequest.toJson());
    final _options = _setStreamType<Result<AddUserGroupMembersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}/members',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AddUserGroupMembersResponse _value;
    try {
      _value = AddUserGroupMembersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<AddUserGroupMembersResponse>> addUserGroupMembers({
    required String id,
    required AddUserGroupMembersRequest addUserGroupMembersRequest,
  }) {
    return _ResultCallAdapter<AddUserGroupMembersResponse>().adapt(
      () => _addUserGroupMembers(
        id: id,
        addUserGroupMembersRequest: addUserGroupMembersRequest,
      ),
    );
  }

  Future<AppealResponse> _appeal({required AppealRequest appealRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(appealRequest.toJson());
    final _options = _setStreamType<Result<AppealResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/appeal',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AppealResponse _value;
    try {
      _value = AppealResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<AppealResponse>> appeal({
    required AppealRequest appealRequest,
  }) {
    return _ResultCallAdapter<AppealResponse>().adapt(
      () => _appeal(appealRequest: appealRequest),
    );
  }

  Future<BanResponse> _ban({required BanRequest banRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(banRequest.toJson());
    final _options = _setStreamType<Result<BanResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/ban',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BanResponse _value;
    try {
      _value = BanResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BanResponse>> ban({required BanRequest banRequest}) {
    return _ResultCallAdapter<BanResponse>().adapt(
      () => _ban(banRequest: banRequest),
    );
  }

  Future<BlockUserResponse> _blockUser({
    required String type,
    required String id,
    required BlockUserRequest blockUserRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(blockUserRequest.toJson());
    final _options = _setStreamType<Result<BlockUserResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/block',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BlockUserResponse _value;
    try {
      _value = BlockUserResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BlockUserResponse>> blockUser({
    required String type,
    required String id,
    required BlockUserRequest blockUserRequest,
  }) {
    return _ResultCallAdapter<BlockUserResponse>().adapt(
      () => _blockUser(type: type, id: id, blockUserRequest: blockUserRequest),
    );
  }

  Future<BlockUsersResponse> _blockUsers({
    required BlockUsersRequest blockUsersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(blockUsersRequest.toJson());
    final _options = _setStreamType<Result<BlockUsersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/block',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BlockUsersResponse _value;
    try {
      _value = BlockUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BlockUsersResponse>> blockUsers({
    required BlockUsersRequest blockUsersRequest,
  }) {
    return _ResultCallAdapter<BlockUsersResponse>().adapt(
      () => _blockUsers(blockUsersRequest: blockUsersRequest),
    );
  }

  Future<BulkActionAppealsResponse> _bulkActionAppeals({
    required BulkActionAppealsRequest bulkActionAppealsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(bulkActionAppealsRequest.toJson());
    final _options = _setStreamType<Result<BulkActionAppealsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/appeals/bulk_action',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkActionAppealsResponse _value;
    try {
      _value = BulkActionAppealsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BulkActionAppealsResponse>> bulkActionAppeals({
    required BulkActionAppealsRequest bulkActionAppealsRequest,
  }) {
    return _ResultCallAdapter<BulkActionAppealsResponse>().adapt(
      () => _bulkActionAppeals(
        bulkActionAppealsRequest: bulkActionAppealsRequest,
      ),
    );
  }

  Future<BulkDeleteActionConfigResponse> _bulkDeleteActionConfig({
    required BulkDeleteActionConfigRequest bulkDeleteActionConfigRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(bulkDeleteActionConfigRequest.toJson());
    final _options = _setStreamType<Result<BulkDeleteActionConfigResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config/bulk_delete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkDeleteActionConfigResponse _value;
    try {
      _value = BulkDeleteActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BulkDeleteActionConfigResponse>> bulkDeleteActionConfig({
    required BulkDeleteActionConfigRequest bulkDeleteActionConfigRequest,
  }) {
    return _ResultCallAdapter<BulkDeleteActionConfigResponse>().adapt(
      () => _bulkDeleteActionConfig(
        bulkDeleteActionConfigRequest: bulkDeleteActionConfigRequest,
      ),
    );
  }

  Future<BulkUpsertActionConfigResponse> _bulkUpsertActionConfig({
    required BulkUpsertActionConfigRequest bulkUpsertActionConfigRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(bulkUpsertActionConfigRequest.toJson());
    final _options = _setStreamType<Result<BulkUpsertActionConfigResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config/bulk',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkUpsertActionConfigResponse _value;
    try {
      _value = BulkUpsertActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BulkUpsertActionConfigResponse>> bulkUpsertActionConfig({
    required BulkUpsertActionConfigRequest bulkUpsertActionConfigRequest,
  }) {
    return _ResultCallAdapter<BulkUpsertActionConfigResponse>().adapt(
      () => _bulkUpsertActionConfig(
        bulkUpsertActionConfigRequest: bulkUpsertActionConfigRequest,
      ),
    );
  }

  Future<CollectUserFeedbackResponse> _collectUserFeedback({
    required String type,
    required String id,
    required CollectUserFeedbackRequest collectUserFeedbackRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(collectUserFeedbackRequest.toJson());
    final _options = _setStreamType<Result<CollectUserFeedbackResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/feedback',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CollectUserFeedbackResponse _value;
    try {
      _value = CollectUserFeedbackResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<CollectUserFeedbackResponse>> collectUserFeedback({
    required String type,
    required String id,
    required CollectUserFeedbackRequest collectUserFeedbackRequest,
  }) {
    return _ResultCallAdapter<CollectUserFeedbackResponse>().adapt(
      () => _collectUserFeedback(
        type: type,
        id: id,
        collectUserFeedbackRequest: collectUserFeedbackRequest,
      ),
    );
  }

  Future<CreateBlockListResponse> _createBlockList({
    required CreateBlockListRequest createBlockListRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createBlockListRequest.toJson());
    final _options = _setStreamType<Result<CreateBlockListResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreateBlockListResponse _value;
    try {
      _value = CreateBlockListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<CreateBlockListResponse>> createBlockList({
    required CreateBlockListRequest createBlockListRequest,
  }) {
    return _ResultCallAdapter<CreateBlockListResponse>().adapt(
      () => _createBlockList(createBlockListRequest: createBlockListRequest),
    );
  }

  Future<DurationResponse> _createDevice({
    required CreateDeviceRequest createDeviceRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createDeviceRequest.toJson());
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/devices',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> createDevice({
    required CreateDeviceRequest createDeviceRequest,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _createDevice(createDeviceRequest: createDeviceRequest),
    );
  }

  Future<CreateGuestResponse> _createGuest({
    required CreateGuestRequest createGuestRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createGuestRequest.toJson());
    final _options = _setStreamType<Result<CreateGuestResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/guest',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreateGuestResponse _value;
    try {
      _value = CreateGuestResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<CreateGuestResponse>> createGuest({
    required CreateGuestRequest createGuestRequest,
  }) {
    return _ResultCallAdapter<CreateGuestResponse>().adapt(
      () => _createGuest(createGuestRequest: createGuestRequest),
    );
  }

  Future<PollResponse> _createPoll({
    required CreatePollRequest createPollRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createPollRequest.toJson());
    final _options = _setStreamType<Result<PollResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollResponse _value;
    try {
      _value = PollResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollResponse>> createPoll({
    required CreatePollRequest createPollRequest,
  }) {
    return _ResultCallAdapter<PollResponse>().adapt(
      () => _createPoll(createPollRequest: createPollRequest),
    );
  }

  Future<PollOptionResponse> _createPollOption({
    required String pollId,
    required CreatePollOptionRequest createPollOptionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createPollOptionRequest.toJson());
    final _options = _setStreamType<Result<PollOptionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/options',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollOptionResponse _value;
    try {
      _value = PollOptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollOptionResponse>> createPollOption({
    required String pollId,
    required CreatePollOptionRequest createPollOptionRequest,
  }) {
    return _ResultCallAdapter<PollOptionResponse>().adapt(
      () => _createPollOption(
        pollId: pollId,
        createPollOptionRequest: createPollOptionRequest,
      ),
    );
  }

  Future<CreateUserGroupResponse> _createUserGroup({
    required CreateUserGroupRequest createUserGroupRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createUserGroupRequest.toJson());
    final _options = _setStreamType<Result<CreateUserGroupResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreateUserGroupResponse _value;
    try {
      _value = CreateUserGroupResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<CreateUserGroupResponse>> createUserGroup({
    required CreateUserGroupRequest createUserGroupRequest,
  }) {
    return _ResultCallAdapter<CreateUserGroupResponse>().adapt(
      () => _createUserGroup(createUserGroupRequest: createUserGroupRequest),
    );
  }

  Future<DeleteActionConfigResponse> _deleteActionConfig({
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteActionConfigResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteActionConfigResponse _value;
    try {
      _value = DeleteActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteActionConfigResponse>> deleteActionConfig({
    required String id,
  }) {
    return _ResultCallAdapter<DeleteActionConfigResponse>().adapt(
      () => _deleteActionConfig(id: id),
    );
  }

  Future<DurationResponse> _deleteBlockList({
    required String name,
    String? team,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team': team};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists/${name}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteBlockList({
    required String name,
    String? team,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteBlockList(name: name, team: team),
    );
  }

  Future<DeleteCallResponse> _deleteCall({
    required String type,
    required String id,
    DeleteCallRequest? deleteCallRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(deleteCallRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<DeleteCallResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/delete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteCallResponse _value;
    try {
      _value = DeleteCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteCallResponse>> deleteCall({
    required String type,
    required String id,
    DeleteCallRequest? deleteCallRequest,
  }) {
    return _ResultCallAdapter<DeleteCallResponse>().adapt(
      () =>
          _deleteCall(type: type, id: id, deleteCallRequest: deleteCallRequest),
    );
  }

  Future<DeleteModerationConfigResponse> _deleteConfig({
    required String key,
    String? team,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team': team};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteModerationConfigResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/config/${key}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteModerationConfigResponse _value;
    try {
      _value = DeleteModerationConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteModerationConfigResponse>> deleteConfig({
    required String key,
    String? team,
  }) {
    return _ResultCallAdapter<DeleteModerationConfigResponse>().adapt(
      () => _deleteConfig(key: key, team: team),
    );
  }

  Future<DurationResponse> _deleteDevice({required String id}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': id};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/devices',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteDevice({required String id}) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteDevice(id: id),
    );
  }

  Future<DurationResponse> _deleteFile({String? url}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/file',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteFile({String? url}) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteFile(url: url),
    );
  }

  Future<DurationResponse> _deleteImage({String? url}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/image',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteImage({String? url}) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteImage(url: url),
    );
  }

  Future<DurationResponse> _deletePoll({
    required String pollId,
    String? userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'user_id': userId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deletePoll({
    required String pollId,
    String? userId,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deletePoll(pollId: pollId, userId: userId),
    );
  }

  Future<DurationResponse> _deletePollOption({
    required String pollId,
    required String optionId,
    String? userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'user_id': userId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/options/${optionId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deletePollOption({
    required String pollId,
    required String optionId,
    String? userId,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () =>
          _deletePollOption(pollId: pollId, optionId: optionId, userId: userId),
    );
  }

  Future<DeleteRecordingResponse> _deleteRecording({
    required String type,
    required String id,
    required String session,
    required String filename,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteRecordingResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/${session}/recordings/${filename}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteRecordingResponse _value;
    try {
      _value = DeleteRecordingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteRecordingResponse>> deleteRecording({
    required String type,
    required String id,
    required String session,
    required String filename,
  }) {
    return _ResultCallAdapter<DeleteRecordingResponse>().adapt(
      () => _deleteRecording(
        type: type,
        id: id,
        session: session,
        filename: filename,
      ),
    );
  }

  Future<DeleteTranscriptionResponse> _deleteTranscription({
    required String type,
    required String id,
    required String session,
    required String filename,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteTranscriptionResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/${session}/transcriptions/${filename}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteTranscriptionResponse _value;
    try {
      _value = DeleteTranscriptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteTranscriptionResponse>> deleteTranscription({
    required String type,
    required String id,
    required String session,
    required String filename,
  }) {
    return _ResultCallAdapter<DeleteTranscriptionResponse>().adapt(
      () => _deleteTranscription(
        type: type,
        id: id,
        session: session,
        filename: filename,
      ),
    );
  }

  Future<DurationResponse> _deleteUserGroup({
    required String id,
    String? teamId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team_id': teamId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteUserGroup({
    required String id,
    String? teamId,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteUserGroup(id: id, teamId: teamId),
    );
  }

  Future<EndCallResponse> _endCall({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<EndCallResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/mark_ended',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late EndCallResponse _value;
    try {
      _value = EndCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<EndCallResponse>> endCall({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<EndCallResponse>().adapt(
      () => _endCall(type: type, id: id),
    );
  }

  Future<FlagResponse> _flag({required FlagRequest flagRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(flagRequest.toJson());
    final _options = _setStreamType<Result<FlagResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/flag',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FlagResponse _value;
    try {
      _value = FlagResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<FlagResponse>> flag({required FlagRequest flagRequest}) {
    return _ResultCallAdapter<FlagResponse>().adapt(
      () => _flag(flagRequest: flagRequest),
    );
  }

  Future<GetActionConfigResponse> _getActionConfig({
    String? queueType,
    String? entityType,
    bool? excludeDefaults,
    bool? onlyDefaults,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'queue_type': queueType,
      r'entity_type': entityType,
      r'exclude_defaults': excludeDefaults,
      r'only_defaults': onlyDefaults,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetActionConfigResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetActionConfigResponse _value;
    try {
      _value = GetActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetActionConfigResponse>> getActionConfig({
    String? queueType,
    String? entityType,
    bool? excludeDefaults,
    bool? onlyDefaults,
  }) {
    return _ResultCallAdapter<GetActionConfigResponse>().adapt(
      () => _getActionConfig(
        queueType: queueType,
        entityType: entityType,
        excludeDefaults: excludeDefaults,
        onlyDefaults: onlyDefaults,
      ),
    );
  }

  Future<GetApplicationResponse> _getApp() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetApplicationResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/app',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetApplicationResponse _value;
    try {
      _value = GetApplicationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetApplicationResponse>> getApp() {
    return _ResultCallAdapter<GetApplicationResponse>().adapt(() => _getApp());
  }

  Future<GetAppealResponse> _getAppeal({required String id}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetAppealResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/appeal/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetAppealResponse _value;
    try {
      _value = GetAppealResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetAppealResponse>> getAppeal({required String id}) {
    return _ResultCallAdapter<GetAppealResponse>().adapt(
      () => _getAppeal(id: id),
    );
  }

  Future<GetBlockedUsersResponse> _getBlockedUsers() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetBlockedUsersResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/block',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetBlockedUsersResponse _value;
    try {
      _value = GetBlockedUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetBlockedUsersResponse>> getBlockedUsers() {
    return _ResultCallAdapter<GetBlockedUsersResponse>().adapt(
      () => _getBlockedUsers(),
    );
  }

  Future<GetCallResponse> _getCall({
    required String type,
    required String id,
    int? membersLimit,
    bool? ring,
    bool? notify,
    bool? video,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'members_limit': membersLimit,
      r'ring': ring,
      r'notify': notify,
      r'video': video,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetCallResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetCallResponse _value;
    try {
      _value = GetCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetCallResponse>> getCall({
    required String type,
    required String id,
    int? membersLimit,
    bool? ring,
    bool? notify,
    bool? video,
  }) {
    return _ResultCallAdapter<GetCallResponse>().adapt(
      () => _getCall(
        type: type,
        id: id,
        membersLimit: membersLimit,
        ring: ring,
        notify: notify,
        video: video,
      ),
    );
  }

  Future<GetCallParticipantSessionMetricsResponse>
  _getCallParticipantSessionMetrics({
    required String type,
    required String id,
    required String session,
    required String user,
    required String userSession,
    DateTime? since,
    DateTime? until,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'since': since?.toIso8601String(),
      r'until': until?.toIso8601String(),
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<Result<GetCallParticipantSessionMetricsResponse>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v2/video/call/${type}/${id}/session/${session}/participant/${user}/${userSession}/details/track',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetCallParticipantSessionMetricsResponse _value;
    try {
      _value = GetCallParticipantSessionMetricsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetCallParticipantSessionMetricsResponse>>
  getCallParticipantSessionMetrics({
    required String type,
    required String id,
    required String session,
    required String user,
    required String userSession,
    DateTime? since,
    DateTime? until,
  }) {
    return _ResultCallAdapter<GetCallParticipantSessionMetricsResponse>().adapt(
      () => _getCallParticipantSessionMetrics(
        type: type,
        id: id,
        session: session,
        user: user,
        userSession: userSession,
        since: since,
        until: until,
      ),
    );
  }

  Future<GetCallReportResponse> _getCallReport({
    required String type,
    required String id,
    String? sessionId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'session_id': sessionId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetCallReportResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/report',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetCallReportResponse _value;
    try {
      _value = GetCallReportResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetCallReportResponse>> getCallReport({
    required String type,
    required String id,
    String? sessionId,
  }) {
    return _ResultCallAdapter<GetCallReportResponse>().adapt(
      () => _getCallReport(type: type, id: id, sessionId: sessionId),
    );
  }

  Future<GetCallSessionParticipantStatsDetailsResponse>
  _getCallSessionParticipantStatsDetails({
    required String callType,
    required String callId,
    required String session,
    required String user,
    required String userSession,
    String? since,
    String? until,
    int? maxPoints,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'since': since,
      r'until': until,
      r'max_points': maxPoints,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<Result<GetCallSessionParticipantStatsDetailsResponse>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v2/video/call_stats/${callType}/${callId}/${session}/participant/${user}/${userSession}/details',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetCallSessionParticipantStatsDetailsResponse _value;
    try {
      _value = GetCallSessionParticipantStatsDetailsResponse.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetCallSessionParticipantStatsDetailsResponse>>
  getCallSessionParticipantStatsDetails({
    required String callType,
    required String callId,
    required String session,
    required String user,
    required String userSession,
    String? since,
    String? until,
    int? maxPoints,
  }) {
    return _ResultCallAdapter<GetCallSessionParticipantStatsDetailsResponse>()
        .adapt(
          () => _getCallSessionParticipantStatsDetails(
            callType: callType,
            callId: callId,
            session: session,
            user: user,
            userSession: userSession,
            since: since,
            until: until,
            maxPoints: maxPoints,
          ),
        );
  }

  Future<QueryCallSessionParticipantStatsTimelineResponse>
  _getCallSessionParticipantStatsTimeline({
    required String callType,
    required String callId,
    required String session,
    required String user,
    required String userSession,
    String? startTime,
    String? endTime,
    List<String>? severity,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'start_time': startTime,
      r'end_time': endTime,
      r'severity': severity,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<
          Result<QueryCallSessionParticipantStatsTimelineResponse>
        >(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v2/video/call_stats/${callType}/${callId}/${session}/participants/${user}/${userSession}/timeline',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallSessionParticipantStatsTimelineResponse _value;
    try {
      _value = QueryCallSessionParticipantStatsTimelineResponse.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallSessionParticipantStatsTimelineResponse>>
  getCallSessionParticipantStatsTimeline({
    required String callType,
    required String callId,
    required String session,
    required String user,
    required String userSession,
    String? startTime,
    String? endTime,
    List<String>? severity,
  }) {
    return _ResultCallAdapter<
          QueryCallSessionParticipantStatsTimelineResponse
        >()
        .adapt(
          () => _getCallSessionParticipantStatsTimeline(
            callType: callType,
            callId: callId,
            session: session,
            user: user,
            userSession: userSession,
            startTime: startTime,
            endTime: endTime,
            severity: severity,
          ),
        );
  }

  Future<QueryCallStatsMapResponse> _getCallStatsMap({
    required String callType,
    required String callId,
    required String session,
    DateTime? startTime,
    DateTime? endTime,
    bool? excludePublishers,
    bool? excludeSubscribers,
    bool? excludeSfus,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'start_time': startTime?.toIso8601String(),
      r'end_time': endTime?.toIso8601String(),
      r'exclude_publishers': excludePublishers,
      r'exclude_subscribers': excludeSubscribers,
      r'exclude_sfus': excludeSfus,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueryCallStatsMapResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call_stats/${callType}/${callId}/${session}/map',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallStatsMapResponse _value;
    try {
      _value = QueryCallStatsMapResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallStatsMapResponse>> getCallStatsMap({
    required String callType,
    required String callId,
    required String session,
    DateTime? startTime,
    DateTime? endTime,
    bool? excludePublishers,
    bool? excludeSubscribers,
    bool? excludeSfus,
  }) {
    return _ResultCallAdapter<QueryCallStatsMapResponse>().adapt(
      () => _getCallStatsMap(
        callType: callType,
        callId: callId,
        session: session,
        startTime: startTime,
        endTime: endTime,
        excludePublishers: excludePublishers,
        excludeSubscribers: excludeSubscribers,
        excludeSfus: excludeSfus,
      ),
    );
  }

  Future<GetConfigResponse> _getConfig({
    required String key,
    String? team,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team': team};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetConfigResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/config/${key}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetConfigResponse _value;
    try {
      _value = GetConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetConfigResponse>> getConfig({
    required String key,
    String? team,
  }) {
    return _ResultCallAdapter<GetConfigResponse>().adapt(
      () => _getConfig(key: key, team: team),
    );
  }

  Future<GetEdgesResponse> _getEdges() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetEdgesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/edges',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetEdgesResponse _value;
    try {
      _value = GetEdgesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetEdgesResponse>> getEdges() {
    return _ResultCallAdapter<GetEdgesResponse>().adapt(() => _getEdges());
  }

  Future<GetOGResponse> _getOG({required String url}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetOGResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/og',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetOGResponse _value;
    try {
      _value = GetOGResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetOGResponse>> getOG({required String url}) {
    return _ResultCallAdapter<GetOGResponse>().adapt(() => _getOG(url: url));
  }

  Future<GetOrCreateCallResponse> _getOrCreateCall({
    required String type,
    required String id,
    GetOrCreateCallRequest? getOrCreateCallRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(getOrCreateCallRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<GetOrCreateCallResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetOrCreateCallResponse _value;
    try {
      _value = GetOrCreateCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetOrCreateCallResponse>> getOrCreateCall({
    required String type,
    required String id,
    GetOrCreateCallRequest? getOrCreateCallRequest,
  }) {
    return _ResultCallAdapter<GetOrCreateCallResponse>().adapt(
      () => _getOrCreateCall(
        type: type,
        id: id,
        getOrCreateCallRequest: getOrCreateCallRequest,
      ),
    );
  }

  Future<PollResponse> _getPoll({
    required String pollId,
    String? userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'user_id': userId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<PollResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollResponse _value;
    try {
      _value = PollResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollResponse>> getPoll({
    required String pollId,
    String? userId,
  }) {
    return _ResultCallAdapter<PollResponse>().adapt(
      () => _getPoll(pollId: pollId, userId: userId),
    );
  }

  Future<PollOptionResponse> _getPollOption({
    required String pollId,
    required String optionId,
    String? userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'user_id': userId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<PollOptionResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/options/${optionId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollOptionResponse _value;
    try {
      _value = PollOptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollOptionResponse>> getPollOption({
    required String pollId,
    required String optionId,
    String? userId,
  }) {
    return _ResultCallAdapter<PollOptionResponse>().adapt(
      () => _getPollOption(pollId: pollId, optionId: optionId, userId: userId),
    );
  }

  Future<GetUserGroupResponse> _getUserGroup({
    required String id,
    String? teamId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team_id': teamId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetUserGroupResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetUserGroupResponse _value;
    try {
      _value = GetUserGroupResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetUserGroupResponse>> getUserGroup({
    required String id,
    String? teamId,
  }) {
    return _ResultCallAdapter<GetUserGroupResponse>().adapt(
      () => _getUserGroup(id: id, teamId: teamId),
    );
  }

  Future<SharedLocationsResponse> _getUserLiveLocations() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<SharedLocationsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/live_locations',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SharedLocationsResponse _value;
    try {
      _value = SharedLocationsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SharedLocationsResponse>> getUserLiveLocations() {
    return _ResultCallAdapter<SharedLocationsResponse>().adapt(
      () => _getUserLiveLocations(),
    );
  }

  Future<GoLiveResponse> _goLive({
    required String type,
    required String id,
    GoLiveRequest? goLiveRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(goLiveRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<GoLiveResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/go_live',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GoLiveResponse _value;
    try {
      _value = GoLiveResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GoLiveResponse>> goLive({
    required String type,
    required String id,
    GoLiveRequest? goLiveRequest,
  }) {
    return _ResultCallAdapter<GoLiveResponse>().adapt(
      () => _goLive(type: type, id: id, goLiveRequest: goLiveRequest),
    );
  }

  Future<JoinCallResponse> _joinCall({
    required String type,
    required String id,
    required JoinCallRequest joinCallRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(joinCallRequest.toJson());
    final _options = _setStreamType<Result<JoinCallResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/join',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late JoinCallResponse _value;
    try {
      _value = JoinCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<JoinCallResponse>> joinCall({
    required String type,
    required String id,
    required JoinCallRequest joinCallRequest,
  }) {
    return _ResultCallAdapter<JoinCallResponse>().adapt(
      () => _joinCall(type: type, id: id, joinCallRequest: joinCallRequest),
    );
  }

  Future<KickUserResponse> _kickUser({
    required String type,
    required String id,
    required KickUserRequest kickUserRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(kickUserRequest.toJson());
    final _options = _setStreamType<Result<KickUserResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/kick',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late KickUserResponse _value;
    try {
      _value = KickUserResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<KickUserResponse>> kickUser({
    required String type,
    required String id,
    required KickUserRequest kickUserRequest,
  }) {
    return _ResultCallAdapter<KickUserResponse>().adapt(
      () => _kickUser(type: type, id: id, kickUserRequest: kickUserRequest),
    );
  }

  Future<ListBlockListResponse> _listBlockLists({String? team}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team': team};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListBlockListResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListBlockListResponse _value;
    try {
      _value = ListBlockListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListBlockListResponse>> listBlockLists({String? team}) {
    return _ResultCallAdapter<ListBlockListResponse>().adapt(
      () => _listBlockLists(team: team),
    );
  }

  Future<ListDevicesResponse> _listDevices() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListDevicesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/devices',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListDevicesResponse _value;
    try {
      _value = ListDevicesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListDevicesResponse>> listDevices() {
    return _ResultCallAdapter<ListDevicesResponse>().adapt(
      () => _listDevices(),
    );
  }

  Future<ListRecordingsResponse> _listRecordings({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListRecordingsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/recordings',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListRecordingsResponse _value;
    try {
      _value = ListRecordingsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListRecordingsResponse>> listRecordings({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<ListRecordingsResponse>().adapt(
      () => _listRecordings(type: type, id: id),
    );
  }

  Future<ListTranscriptionsResponse> _listTranscriptions({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListTranscriptionsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/transcriptions',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListTranscriptionsResponse _value;
    try {
      _value = ListTranscriptionsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListTranscriptionsResponse>> listTranscriptions({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<ListTranscriptionsResponse>().adapt(
      () => _listTranscriptions(type: type, id: id),
    );
  }

  Future<ListUserGroupsResponse> _listUserGroups({
    int? limit,
    String? idGt,
    String? createdAtGt,
    String? teamId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'id_gt': idGt,
      r'created_at_gt': createdAtGt,
      r'team_id': teamId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListUserGroupsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListUserGroupsResponse _value;
    try {
      _value = ListUserGroupsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListUserGroupsResponse>> listUserGroups({
    int? limit,
    String? idGt,
    String? createdAtGt,
    String? teamId,
  }) {
    return _ResultCallAdapter<ListUserGroupsResponse>().adapt(
      () => _listUserGroups(
        limit: limit,
        idGt: idGt,
        createdAtGt: createdAtGt,
        teamId: teamId,
      ),
    );
  }

  Future<void> _longPoll({WSAuthMessage? json}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'json': json?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<void>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/longpoll',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<Result<void>> longPoll({WSAuthMessage? json}) {
    return _ResultCallAdapter<void>().adapt(() => _longPoll(json: json));
  }

  Future<MuteResponse> _mute({required MuteRequest muteRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(muteRequest.toJson());
    final _options = _setStreamType<Result<MuteResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/mute',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MuteResponse _value;
    try {
      _value = MuteResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MuteResponse>> mute({required MuteRequest muteRequest}) {
    return _ResultCallAdapter<MuteResponse>().adapt(
      () => _mute(muteRequest: muteRequest),
    );
  }

  Future<MuteUsersResponse> _muteUsers({
    required String type,
    required String id,
    MuteUsersRequest? muteUsersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(muteUsersRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<MuteUsersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/mute_users',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MuteUsersResponse _value;
    try {
      _value = MuteUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MuteUsersResponse>> muteUsers({
    required String type,
    required String id,
    MuteUsersRequest? muteUsersRequest,
  }) {
    return _ResultCallAdapter<MuteUsersResponse>().adapt(
      () => _muteUsers(type: type, id: id, muteUsersRequest: muteUsersRequest),
    );
  }

  Future<QueryAggregateCallStatsResponse> _queryAggregateCallStats({
    QueryAggregateCallStatsRequest? queryAggregateCallStatsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(
      queryAggregateCallStatsRequest?.toJson() ?? <String, dynamic>{},
    );
    final _options = _setStreamType<Result<QueryAggregateCallStatsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/stats',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryAggregateCallStatsResponse _value;
    try {
      _value = QueryAggregateCallStatsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryAggregateCallStatsResponse>> queryAggregateCallStats({
    QueryAggregateCallStatsRequest? queryAggregateCallStatsRequest,
  }) {
    return _ResultCallAdapter<QueryAggregateCallStatsResponse>().adapt(
      () => _queryAggregateCallStats(
        queryAggregateCallStatsRequest: queryAggregateCallStatsRequest,
      ),
    );
  }

  Future<QueryAppealsResponse> _queryAppeals({
    QueryAppealsRequest? queryAppealsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryAppealsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryAppealsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/appeals',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryAppealsResponse _value;
    try {
      _value = QueryAppealsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryAppealsResponse>> queryAppeals({
    QueryAppealsRequest? queryAppealsRequest,
  }) {
    return _ResultCallAdapter<QueryAppealsResponse>().adapt(
      () => _queryAppeals(queryAppealsRequest: queryAppealsRequest),
    );
  }

  Future<QueryCallMembersResponse> _queryCallMembers({
    required QueryCallMembersRequest queryCallMembersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryCallMembersRequest.toJson());
    final _options = _setStreamType<Result<QueryCallMembersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/members',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallMembersResponse _value;
    try {
      _value = QueryCallMembersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallMembersResponse>> queryCallMembers({
    required QueryCallMembersRequest queryCallMembersRequest,
  }) {
    return _ResultCallAdapter<QueryCallMembersResponse>().adapt(
      () => _queryCallMembers(queryCallMembersRequest: queryCallMembersRequest),
    );
  }

  Future<QueryCallParticipantSessionsResponse> _queryCallParticipantSessions({
    required String type,
    required String id,
    required String session,
    int? limit,
    String? prev,
    String? next,
    Map<String, Object?>? filterConditions,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'prev': prev,
      r'next': next,
      r'filter_conditions': filterConditions,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueryCallParticipantSessionsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/session/${session}/participant_sessions',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallParticipantSessionsResponse _value;
    try {
      _value = QueryCallParticipantSessionsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallParticipantSessionsResponse>>
  queryCallParticipantSessions({
    required String type,
    required String id,
    required String session,
    int? limit,
    String? prev,
    String? next,
    Map<String, Object?>? filterConditions,
  }) {
    return _ResultCallAdapter<QueryCallParticipantSessionsResponse>().adapt(
      () => _queryCallParticipantSessions(
        type: type,
        id: id,
        session: session,
        limit: limit,
        prev: prev,
        next: next,
        filterConditions: filterConditions,
      ),
    );
  }

  Future<QueryCallParticipantsResponse> _queryCallParticipants({
    required String id,
    required String type,
    int? limit,
    QueryCallParticipantsRequest? queryCallParticipantsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'limit': limit};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryCallParticipantsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryCallParticipantsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/participants',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallParticipantsResponse _value;
    try {
      _value = QueryCallParticipantsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallParticipantsResponse>> queryCallParticipants({
    required String id,
    required String type,
    int? limit,
    QueryCallParticipantsRequest? queryCallParticipantsRequest,
  }) {
    return _ResultCallAdapter<QueryCallParticipantsResponse>().adapt(
      () => _queryCallParticipants(
        id: id,
        type: type,
        limit: limit,
        queryCallParticipantsRequest: queryCallParticipantsRequest,
      ),
    );
  }

  Future<QueryCallSessionParticipantStatsResponse>
  _queryCallSessionParticipantStats({
    required String callType,
    required String callId,
    required String session,
    int? limit,
    String? prev,
    String? next,
    List<SortParamRequest>? sort,
    Map<String, Object?>? filterConditions,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'prev': prev,
      r'next': next,
      r'sort': sort,
      r'filter_conditions': filterConditions,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<Result<QueryCallSessionParticipantStatsResponse>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v2/video/call_stats/${callType}/${callId}/${session}/participants',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallSessionParticipantStatsResponse _value;
    try {
      _value = QueryCallSessionParticipantStatsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallSessionParticipantStatsResponse>>
  queryCallSessionParticipantStats({
    required String callType,
    required String callId,
    required String session,
    int? limit,
    String? prev,
    String? next,
    List<SortParamRequest>? sort,
    Map<String, Object?>? filterConditions,
  }) {
    return _ResultCallAdapter<QueryCallSessionParticipantStatsResponse>().adapt(
      () => _queryCallSessionParticipantStats(
        callType: callType,
        callId: callId,
        session: session,
        limit: limit,
        prev: prev,
        next: next,
        sort: sort,
        filterConditions: filterConditions,
      ),
    );
  }

  Future<QueryCallSessionStatsResponse> _queryCallSessionStats({
    QueryCallSessionStatsRequest? queryCallSessionStatsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryCallSessionStatsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryCallSessionStatsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call_stats',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallSessionStatsResponse _value;
    try {
      _value = QueryCallSessionStatsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallSessionStatsResponse>> queryCallSessionStats({
    QueryCallSessionStatsRequest? queryCallSessionStatsRequest,
  }) {
    return _ResultCallAdapter<QueryCallSessionStatsResponse>().adapt(
      () => _queryCallSessionStats(
        queryCallSessionStatsRequest: queryCallSessionStatsRequest,
      ),
    );
  }

  Future<QueryCallStatsResponse> _queryCallStats({
    QueryCallStatsRequest? queryCallStatsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryCallStatsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryCallStatsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/stats',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallStatsResponse _value;
    try {
      _value = QueryCallStatsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallStatsResponse>> queryCallStats({
    QueryCallStatsRequest? queryCallStatsRequest,
  }) {
    return _ResultCallAdapter<QueryCallStatsResponse>().adapt(
      () => _queryCallStats(queryCallStatsRequest: queryCallStatsRequest),
    );
  }

  Future<QueryCallsResponse> _queryCalls({
    QueryCallsRequest? queryCallsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryCallsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryCallsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/calls',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryCallsResponse _value;
    try {
      _value = QueryCallsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryCallsResponse>> queryCalls({
    QueryCallsRequest? queryCallsRequest,
  }) {
    return _ResultCallAdapter<QueryCallsResponse>().adapt(
      () => _queryCalls(queryCallsRequest: queryCallsRequest),
    );
  }

  Future<QueryModerationConfigsResponse> _queryModerationConfigs({
    QueryModerationConfigsRequest? queryModerationConfigsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(
      queryModerationConfigsRequest?.toJson() ?? <String, dynamic>{},
    );
    final _options = _setStreamType<Result<QueryModerationConfigsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/configs',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryModerationConfigsResponse _value;
    try {
      _value = QueryModerationConfigsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryModerationConfigsResponse>> queryModerationConfigs({
    QueryModerationConfigsRequest? queryModerationConfigsRequest,
  }) {
    return _ResultCallAdapter<QueryModerationConfigsResponse>().adapt(
      () => _queryModerationConfigs(
        queryModerationConfigsRequest: queryModerationConfigsRequest,
      ),
    );
  }

  Future<PollVotesResponse> _queryPollVotes({
    required String pollId,
    String? userId,
    QueryPollVotesRequest? queryPollVotesRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'user_id': userId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryPollVotesRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<PollVotesResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/votes',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollVotesResponse _value;
    try {
      _value = PollVotesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollVotesResponse>> queryPollVotes({
    required String pollId,
    String? userId,
    QueryPollVotesRequest? queryPollVotesRequest,
  }) {
    return _ResultCallAdapter<PollVotesResponse>().adapt(
      () => _queryPollVotes(
        pollId: pollId,
        userId: userId,
        queryPollVotesRequest: queryPollVotesRequest,
      ),
    );
  }

  Future<QueryPollsResponse> _queryPolls({
    String? userId,
    QueryPollsRequest? queryPollsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'user_id': userId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryPollsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryPollsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/query',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryPollsResponse _value;
    try {
      _value = QueryPollsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryPollsResponse>> queryPolls({
    String? userId,
    QueryPollsRequest? queryPollsRequest,
  }) {
    return _ResultCallAdapter<QueryPollsResponse>().adapt(
      () => _queryPolls(userId: userId, queryPollsRequest: queryPollsRequest),
    );
  }

  Future<QueryReviewQueueResponse> _queryReviewQueue({
    QueryReviewQueueRequest? queryReviewQueueRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryReviewQueueRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryReviewQueueResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/review_queue',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryReviewQueueResponse _value;
    try {
      _value = QueryReviewQueueResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryReviewQueueResponse>> queryReviewQueue({
    QueryReviewQueueRequest? queryReviewQueueRequest,
  }) {
    return _ResultCallAdapter<QueryReviewQueueResponse>().adapt(
      () => _queryReviewQueue(queryReviewQueueRequest: queryReviewQueueRequest),
    );
  }

  Future<QueryUsersResponse> _queryUsers({QueryUsersPayload? payload}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payload': payload?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueryUsersResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryUsersResponse _value;
    try {
      _value = QueryUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryUsersResponse>> queryUsers({QueryUsersPayload? payload}) {
    return _ResultCallAdapter<QueryUsersResponse>().adapt(
      () => _queryUsers(payload: payload),
    );
  }

  Future<RejectCallResponse> _rejectCall({
    required String type,
    required String id,
    RejectCallRequest? rejectCallRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(rejectCallRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<RejectCallResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/reject',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RejectCallResponse _value;
    try {
      _value = RejectCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<RejectCallResponse>> rejectCall({
    required String type,
    required String id,
    RejectCallRequest? rejectCallRequest,
  }) {
    return _ResultCallAdapter<RejectCallResponse>().adapt(
      () =>
          _rejectCall(type: type, id: id, rejectCallRequest: rejectCallRequest),
    );
  }

  Future<RemoveUserGroupMembersResponse> _removeUserGroupMembers({
    required String id,
    required RemoveUserGroupMembersRequest removeUserGroupMembersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(removeUserGroupMembersRequest.toJson());
    final _options = _setStreamType<Result<RemoveUserGroupMembersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}/members/delete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RemoveUserGroupMembersResponse _value;
    try {
      _value = RemoveUserGroupMembersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<RemoveUserGroupMembersResponse>> removeUserGroupMembers({
    required String id,
    required RemoveUserGroupMembersRequest removeUserGroupMembersRequest,
  }) {
    return _ResultCallAdapter<RemoveUserGroupMembersResponse>().adapt(
      () => _removeUserGroupMembers(
        id: id,
        removeUserGroupMembersRequest: removeUserGroupMembersRequest,
      ),
    );
  }

  Future<ReportClientEventResponse> _reportClientCallEvent({
    required ReportClientEventRequest reportClientEventRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(reportClientEventRequest.toJson());
    final _options = _setStreamType<Result<ReportClientEventResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call_client_event',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReportClientEventResponse _value;
    try {
      _value = ReportClientEventResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ReportClientEventResponse>> reportClientCallEvent({
    required ReportClientEventRequest reportClientEventRequest,
  }) {
    return _ResultCallAdapter<ReportClientEventResponse>().adapt(
      () => _reportClientCallEvent(
        reportClientEventRequest: reportClientEventRequest,
      ),
    );
  }

  Future<RequestPermissionResponse> _requestPermission({
    required String type,
    required String id,
    required RequestPermissionRequest requestPermissionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestPermissionRequest.toJson());
    final _options = _setStreamType<Result<RequestPermissionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/request_permission',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RequestPermissionResponse _value;
    try {
      _value = RequestPermissionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<RequestPermissionResponse>> requestPermission({
    required String type,
    required String id,
    required RequestPermissionRequest requestPermissionRequest,
  }) {
    return _ResultCallAdapter<RequestPermissionResponse>().adapt(
      () => _requestPermission(
        type: type,
        id: id,
        requestPermissionRequest: requestPermissionRequest,
      ),
    );
  }

  Future<ResolveSipAuthResponse> _resolveSipAuth({
    required ResolveSipAuthRequest resolveSipAuthRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(resolveSipAuthRequest.toJson());
    final _options = _setStreamType<Result<ResolveSipAuthResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/sip/auth',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ResolveSipAuthResponse _value;
    try {
      _value = ResolveSipAuthResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ResolveSipAuthResponse>> resolveSipAuth({
    required ResolveSipAuthRequest resolveSipAuthRequest,
  }) {
    return _ResultCallAdapter<ResolveSipAuthResponse>().adapt(
      () => _resolveSipAuth(resolveSipAuthRequest: resolveSipAuthRequest),
    );
  }

  Future<ResolveSipInboundResponse> _resolveSipInbound({
    required ResolveSipInboundRequest resolveSipInboundRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(resolveSipInboundRequest.toJson());
    final _options = _setStreamType<Result<ResolveSipInboundResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/sip/resolve',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ResolveSipInboundResponse _value;
    try {
      _value = ResolveSipInboundResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ResolveSipInboundResponse>> resolveSipInbound({
    required ResolveSipInboundRequest resolveSipInboundRequest,
  }) {
    return _ResultCallAdapter<ResolveSipInboundResponse>().adapt(
      () => _resolveSipInbound(
        resolveSipInboundRequest: resolveSipInboundRequest,
      ),
    );
  }

  Future<RingCallResponse> _ringCall({
    required String type,
    required String id,
    RingCallRequest? ringCallRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(ringCallRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<RingCallResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/ring',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RingCallResponse _value;
    try {
      _value = RingCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<RingCallResponse>> ringCall({
    required String type,
    required String id,
    RingCallRequest? ringCallRequest,
  }) {
    return _ResultCallAdapter<RingCallResponse>().adapt(
      () => _ringCall(type: type, id: id, ringCallRequest: ringCallRequest),
    );
  }

  Future<SearchRolesResponse> _searchRoles({
    required String query,
    int? limit,
    String? nameGt,
    String? roleType,
    bool? includeGlobalRoles,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'query': query,
      r'limit': limit,
      r'name_gt': nameGt,
      r'role_type': roleType,
      r'include_global_roles': includeGlobalRoles,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<SearchRolesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/roles/search',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchRolesResponse _value;
    try {
      _value = SearchRolesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SearchRolesResponse>> searchRoles({
    required String query,
    int? limit,
    String? nameGt,
    String? roleType,
    bool? includeGlobalRoles,
  }) {
    return _ResultCallAdapter<SearchRolesResponse>().adapt(
      () => _searchRoles(
        query: query,
        limit: limit,
        nameGt: nameGt,
        roleType: roleType,
        includeGlobalRoles: includeGlobalRoles,
      ),
    );
  }

  Future<SearchUserGroupsResponse> _searchUserGroups({
    required String query,
    int? limit,
    String? nameGt,
    String? idGt,
    String? teamId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'query': query,
      r'limit': limit,
      r'name_gt': nameGt,
      r'id_gt': idGt,
      r'team_id': teamId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<SearchUserGroupsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/search',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchUserGroupsResponse _value;
    try {
      _value = SearchUserGroupsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SearchUserGroupsResponse>> searchUserGroups({
    required String query,
    int? limit,
    String? nameGt,
    String? idGt,
    String? teamId,
  }) {
    return _ResultCallAdapter<SearchUserGroupsResponse>().adapt(
      () => _searchUserGroups(
        query: query,
        limit: limit,
        nameGt: nameGt,
        idGt: idGt,
        teamId: teamId,
      ),
    );
  }

  Future<SendCallEventResponse> _sendCallEvent({
    required String type,
    required String id,
    SendCallEventRequest? sendCallEventRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendCallEventRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<SendCallEventResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/event',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SendCallEventResponse _value;
    try {
      _value = SendCallEventResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SendCallEventResponse>> sendCallEvent({
    required String type,
    required String id,
    SendCallEventRequest? sendCallEventRequest,
  }) {
    return _ResultCallAdapter<SendCallEventResponse>().adapt(
      () => _sendCallEvent(
        type: type,
        id: id,
        sendCallEventRequest: sendCallEventRequest,
      ),
    );
  }

  Future<SendVideoReactionResponse> _sendVideoReaction({
    required String type,
    required String id,
    required SendVideoReactionRequest sendVideoReactionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendVideoReactionRequest.toJson());
    final _options = _setStreamType<Result<SendVideoReactionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/reaction',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SendVideoReactionResponse _value;
    try {
      _value = SendVideoReactionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SendVideoReactionResponse>> sendVideoReaction({
    required String type,
    required String id,
    required SendVideoReactionRequest sendVideoReactionRequest,
  }) {
    return _ResultCallAdapter<SendVideoReactionResponse>().adapt(
      () => _sendVideoReaction(
        type: type,
        id: id,
        sendVideoReactionRequest: sendVideoReactionRequest,
      ),
    );
  }

  Future<StartClosedCaptionsResponse> _startClosedCaptions({
    required String type,
    required String id,
    StartClosedCaptionsRequest? startClosedCaptionsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(startClosedCaptionsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<StartClosedCaptionsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/start_closed_captions',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StartClosedCaptionsResponse _value;
    try {
      _value = StartClosedCaptionsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StartClosedCaptionsResponse>> startClosedCaptions({
    required String type,
    required String id,
    StartClosedCaptionsRequest? startClosedCaptionsRequest,
  }) {
    return _ResultCallAdapter<StartClosedCaptionsResponse>().adapt(
      () => _startClosedCaptions(
        type: type,
        id: id,
        startClosedCaptionsRequest: startClosedCaptionsRequest,
      ),
    );
  }

  Future<StartFrameRecordingResponse> _startFrameRecording({
    required String type,
    required String id,
    StartFrameRecordingRequest? startFrameRecordingRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(startFrameRecordingRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<StartFrameRecordingResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/start_frame_recording',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StartFrameRecordingResponse _value;
    try {
      _value = StartFrameRecordingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StartFrameRecordingResponse>> startFrameRecording({
    required String type,
    required String id,
    StartFrameRecordingRequest? startFrameRecordingRequest,
  }) {
    return _ResultCallAdapter<StartFrameRecordingResponse>().adapt(
      () => _startFrameRecording(
        type: type,
        id: id,
        startFrameRecordingRequest: startFrameRecordingRequest,
      ),
    );
  }

  Future<StartHLSBroadcastingResponse> _startHLSBroadcasting({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<StartHLSBroadcastingResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/start_broadcasting',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StartHLSBroadcastingResponse _value;
    try {
      _value = StartHLSBroadcastingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StartHLSBroadcastingResponse>> startHLSBroadcasting({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<StartHLSBroadcastingResponse>().adapt(
      () => _startHLSBroadcasting(type: type, id: id),
    );
  }

  Future<StartRTMPBroadcastsResponse> _startRTMPBroadcasts({
    required String type,
    required String id,
    required StartRTMPBroadcastsRequest startRTMPBroadcastsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(startRTMPBroadcastsRequest.toJson());
    final _options = _setStreamType<Result<StartRTMPBroadcastsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/rtmp_broadcasts',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StartRTMPBroadcastsResponse _value;
    try {
      _value = StartRTMPBroadcastsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StartRTMPBroadcastsResponse>> startRTMPBroadcasts({
    required String type,
    required String id,
    required StartRTMPBroadcastsRequest startRTMPBroadcastsRequest,
  }) {
    return _ResultCallAdapter<StartRTMPBroadcastsResponse>().adapt(
      () => _startRTMPBroadcasts(
        type: type,
        id: id,
        startRTMPBroadcastsRequest: startRTMPBroadcastsRequest,
      ),
    );
  }

  Future<StartRecordingResponse> _startRecording({
    required String type,
    required String id,
    required String recordingType,
    StartRecordingRequest? startRecordingRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(startRecordingRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<StartRecordingResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/recordings/${recordingType}/start',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StartRecordingResponse _value;
    try {
      _value = StartRecordingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StartRecordingResponse>> startRecording({
    required String type,
    required String id,
    required String recordingType,
    StartRecordingRequest? startRecordingRequest,
  }) {
    return _ResultCallAdapter<StartRecordingResponse>().adapt(
      () => _startRecording(
        type: type,
        id: id,
        recordingType: recordingType,
        startRecordingRequest: startRecordingRequest,
      ),
    );
  }

  Future<StartTranscriptionResponse> _startTranscription({
    required String type,
    required String id,
    StartTranscriptionRequest? startTranscriptionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(startTranscriptionRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<StartTranscriptionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/start_transcription',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StartTranscriptionResponse _value;
    try {
      _value = StartTranscriptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StartTranscriptionResponse>> startTranscription({
    required String type,
    required String id,
    StartTranscriptionRequest? startTranscriptionRequest,
  }) {
    return _ResultCallAdapter<StartTranscriptionResponse>().adapt(
      () => _startTranscription(
        type: type,
        id: id,
        startTranscriptionRequest: startTranscriptionRequest,
      ),
    );
  }

  Future<StopAllRTMPBroadcastsResponse> _stopAllRTMPBroadcasts({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<StopAllRTMPBroadcastsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/rtmp_broadcasts/stop',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StopAllRTMPBroadcastsResponse _value;
    try {
      _value = StopAllRTMPBroadcastsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StopAllRTMPBroadcastsResponse>> stopAllRTMPBroadcasts({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<StopAllRTMPBroadcastsResponse>().adapt(
      () => _stopAllRTMPBroadcasts(type: type, id: id),
    );
  }

  Future<StopClosedCaptionsResponse> _stopClosedCaptions({
    required String type,
    required String id,
    StopClosedCaptionsRequest? stopClosedCaptionsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(stopClosedCaptionsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<StopClosedCaptionsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/stop_closed_captions',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StopClosedCaptionsResponse _value;
    try {
      _value = StopClosedCaptionsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StopClosedCaptionsResponse>> stopClosedCaptions({
    required String type,
    required String id,
    StopClosedCaptionsRequest? stopClosedCaptionsRequest,
  }) {
    return _ResultCallAdapter<StopClosedCaptionsResponse>().adapt(
      () => _stopClosedCaptions(
        type: type,
        id: id,
        stopClosedCaptionsRequest: stopClosedCaptionsRequest,
      ),
    );
  }

  Future<StopFrameRecordingResponse> _stopFrameRecording({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<StopFrameRecordingResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/stop_frame_recording',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StopFrameRecordingResponse _value;
    try {
      _value = StopFrameRecordingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StopFrameRecordingResponse>> stopFrameRecording({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<StopFrameRecordingResponse>().adapt(
      () => _stopFrameRecording(type: type, id: id),
    );
  }

  Future<StopHLSBroadcastingResponse> _stopHLSBroadcasting({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<StopHLSBroadcastingResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/stop_broadcasting',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StopHLSBroadcastingResponse _value;
    try {
      _value = StopHLSBroadcastingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StopHLSBroadcastingResponse>> stopHLSBroadcasting({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<StopHLSBroadcastingResponse>().adapt(
      () => _stopHLSBroadcasting(type: type, id: id),
    );
  }

  Future<StopLiveResponse> _stopLive({
    required String type,
    required String id,
    StopLiveRequest? stopLiveRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(stopLiveRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<StopLiveResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/stop_live',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StopLiveResponse _value;
    try {
      _value = StopLiveResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StopLiveResponse>> stopLive({
    required String type,
    required String id,
    StopLiveRequest? stopLiveRequest,
  }) {
    return _ResultCallAdapter<StopLiveResponse>().adapt(
      () => _stopLive(type: type, id: id, stopLiveRequest: stopLiveRequest),
    );
  }

  Future<StopRTMPBroadcastsResponse> _stopRTMPBroadcast({
    required String type,
    required String id,
    required String name,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<StopRTMPBroadcastsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/rtmp_broadcasts/${name}/stop',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StopRTMPBroadcastsResponse _value;
    try {
      _value = StopRTMPBroadcastsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StopRTMPBroadcastsResponse>> stopRTMPBroadcast({
    required String type,
    required String id,
    required String name,
  }) {
    return _ResultCallAdapter<StopRTMPBroadcastsResponse>().adapt(
      () => _stopRTMPBroadcast(type: type, id: id, name: name),
    );
  }

  Future<StopRecordingResponse> _stopRecording({
    required String type,
    required String id,
    required String recordingType,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<StopRecordingResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/recordings/${recordingType}/stop',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StopRecordingResponse _value;
    try {
      _value = StopRecordingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StopRecordingResponse>> stopRecording({
    required String type,
    required String id,
    required String recordingType,
  }) {
    return _ResultCallAdapter<StopRecordingResponse>().adapt(
      () => _stopRecording(type: type, id: id, recordingType: recordingType),
    );
  }

  Future<StopTranscriptionResponse> _stopTranscription({
    required String type,
    required String id,
    StopTranscriptionRequest? stopTranscriptionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(stopTranscriptionRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<StopTranscriptionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/stop_transcription',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StopTranscriptionResponse _value;
    try {
      _value = StopTranscriptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<StopTranscriptionResponse>> stopTranscription({
    required String type,
    required String id,
    StopTranscriptionRequest? stopTranscriptionRequest,
  }) {
    return _ResultCallAdapter<StopTranscriptionResponse>().adapt(
      () => _stopTranscription(
        type: type,
        id: id,
        stopTranscriptionRequest: stopTranscriptionRequest,
      ),
    );
  }

  Future<SubmitActionResponse> _submitAction({
    required SubmitActionRequest submitActionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(submitActionRequest.toJson());
    final _options = _setStreamType<Result<SubmitActionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/submit_action',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SubmitActionResponse _value;
    try {
      _value = SubmitActionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SubmitActionResponse>> submitAction({
    required SubmitActionRequest submitActionRequest,
  }) {
    return _ResultCallAdapter<SubmitActionResponse>().adapt(
      () => _submitAction(submitActionRequest: submitActionRequest),
    );
  }

  Future<UnblockUserResponse> _unblockUser({
    required String type,
    required String id,
    required UnblockUserRequest unblockUserRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(unblockUserRequest.toJson());
    final _options = _setStreamType<Result<UnblockUserResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/unblock',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UnblockUserResponse _value;
    try {
      _value = UnblockUserResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UnblockUserResponse>> unblockUser({
    required String type,
    required String id,
    required UnblockUserRequest unblockUserRequest,
  }) {
    return _ResultCallAdapter<UnblockUserResponse>().adapt(
      () => _unblockUser(
        type: type,
        id: id,
        unblockUserRequest: unblockUserRequest,
      ),
    );
  }

  Future<UnblockUsersResponse> _unblockUsers({
    required UnblockUsersRequest unblockUsersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(unblockUsersRequest.toJson());
    final _options = _setStreamType<Result<UnblockUsersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/unblock',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UnblockUsersResponse _value;
    try {
      _value = UnblockUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UnblockUsersResponse>> unblockUsers({
    required UnblockUsersRequest unblockUsersRequest,
  }) {
    return _ResultCallAdapter<UnblockUsersResponse>().adapt(
      () => _unblockUsers(unblockUsersRequest: unblockUsersRequest),
    );
  }

  Future<UpdateBlockListResponse> _updateBlockList({
    required String name,
    UpdateBlockListRequest? updateBlockListRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateBlockListRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateBlockListResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists/${name}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateBlockListResponse _value;
    try {
      _value = UpdateBlockListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateBlockListResponse>> updateBlockList({
    required String name,
    UpdateBlockListRequest? updateBlockListRequest,
  }) {
    return _ResultCallAdapter<UpdateBlockListResponse>().adapt(
      () => _updateBlockList(
        name: name,
        updateBlockListRequest: updateBlockListRequest,
      ),
    );
  }

  Future<UpdateCallResponse> _updateCall({
    required String type,
    required String id,
    UpdateCallRequest? updateCallRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateCallRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateCallResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateCallResponse _value;
    try {
      _value = UpdateCallResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateCallResponse>> updateCall({
    required String type,
    required String id,
    UpdateCallRequest? updateCallRequest,
  }) {
    return _ResultCallAdapter<UpdateCallResponse>().adapt(
      () =>
          _updateCall(type: type, id: id, updateCallRequest: updateCallRequest),
    );
  }

  Future<UpdateCallMembersResponse> _updateCallMembers({
    required String type,
    required String id,
    UpdateCallMembersRequest? updateCallMembersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateCallMembersRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateCallMembersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/members',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateCallMembersResponse _value;
    try {
      _value = UpdateCallMembersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateCallMembersResponse>> updateCallMembers({
    required String type,
    required String id,
    UpdateCallMembersRequest? updateCallMembersRequest,
  }) {
    return _ResultCallAdapter<UpdateCallMembersResponse>().adapt(
      () => _updateCallMembers(
        type: type,
        id: id,
        updateCallMembersRequest: updateCallMembersRequest,
      ),
    );
  }

  Future<SharedLocationResponse> _updateLiveLocation({
    required UpdateLiveLocationRequest updateLiveLocationRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateLiveLocationRequest.toJson());
    final _options = _setStreamType<Result<SharedLocationResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/live_locations',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SharedLocationResponse _value;
    try {
      _value = SharedLocationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SharedLocationResponse>> updateLiveLocation({
    required UpdateLiveLocationRequest updateLiveLocationRequest,
  }) {
    return _ResultCallAdapter<SharedLocationResponse>().adapt(
      () => _updateLiveLocation(
        updateLiveLocationRequest: updateLiveLocationRequest,
      ),
    );
  }

  Future<PollResponse> _updatePoll({
    required UpdatePollRequest updatePollRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updatePollRequest.toJson());
    final _options = _setStreamType<Result<PollResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollResponse _value;
    try {
      _value = PollResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollResponse>> updatePoll({
    required UpdatePollRequest updatePollRequest,
  }) {
    return _ResultCallAdapter<PollResponse>().adapt(
      () => _updatePoll(updatePollRequest: updatePollRequest),
    );
  }

  Future<PollOptionResponse> _updatePollOption({
    required String pollId,
    required UpdatePollOptionRequest updatePollOptionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updatePollOptionRequest.toJson());
    final _options = _setStreamType<Result<PollOptionResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/options',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollOptionResponse _value;
    try {
      _value = PollOptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollOptionResponse>> updatePollOption({
    required String pollId,
    required UpdatePollOptionRequest updatePollOptionRequest,
  }) {
    return _ResultCallAdapter<PollOptionResponse>().adapt(
      () => _updatePollOption(
        pollId: pollId,
        updatePollOptionRequest: updatePollOptionRequest,
      ),
    );
  }

  Future<PollResponse> _updatePollPartial({
    required String pollId,
    UpdatePollPartialRequest? updatePollPartialRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updatePollPartialRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<PollResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollResponse _value;
    try {
      _value = PollResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollResponse>> updatePollPartial({
    required String pollId,
    UpdatePollPartialRequest? updatePollPartialRequest,
  }) {
    return _ResultCallAdapter<PollResponse>().adapt(
      () => _updatePollPartial(
        pollId: pollId,
        updatePollPartialRequest: updatePollPartialRequest,
      ),
    );
  }

  Future<UpsertPushPreferencesResponse> _updatePushNotificationPreferences({
    required UpsertPushPreferencesRequest upsertPushPreferencesRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(upsertPushPreferencesRequest.toJson());
    final _options = _setStreamType<Result<UpsertPushPreferencesResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/push_preferences',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpsertPushPreferencesResponse _value;
    try {
      _value = UpsertPushPreferencesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpsertPushPreferencesResponse>>
  updatePushNotificationPreferences({
    required UpsertPushPreferencesRequest upsertPushPreferencesRequest,
  }) {
    return _ResultCallAdapter<UpsertPushPreferencesResponse>().adapt(
      () => _updatePushNotificationPreferences(
        upsertPushPreferencesRequest: upsertPushPreferencesRequest,
      ),
    );
  }

  Future<UpdateUserGroupResponse> _updateUserGroup({
    required String id,
    UpdateUserGroupRequest? updateUserGroupRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUserGroupRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateUserGroupResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateUserGroupResponse _value;
    try {
      _value = UpdateUserGroupResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateUserGroupResponse>> updateUserGroup({
    required String id,
    UpdateUserGroupRequest? updateUserGroupRequest,
  }) {
    return _ResultCallAdapter<UpdateUserGroupResponse>().adapt(
      () => _updateUserGroup(
        id: id,
        updateUserGroupRequest: updateUserGroupRequest,
      ),
    );
  }

  Future<UpdateUserPermissionsResponse> _updateUserPermissions({
    required String type,
    required String id,
    required UpdateUserPermissionsRequest updateUserPermissionsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUserPermissionsRequest.toJson());
    final _options = _setStreamType<Result<UpdateUserPermissionsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/user_permissions',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateUserPermissionsResponse _value;
    try {
      _value = UpdateUserPermissionsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateUserPermissionsResponse>> updateUserPermissions({
    required String type,
    required String id,
    required UpdateUserPermissionsRequest updateUserPermissionsRequest,
  }) {
    return _ResultCallAdapter<UpdateUserPermissionsResponse>().adapt(
      () => _updateUserPermissions(
        type: type,
        id: id,
        updateUserPermissionsRequest: updateUserPermissionsRequest,
      ),
    );
  }

  Future<UpdateUsersResponse> _updateUsers({
    required UpdateUsersRequest updateUsersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUsersRequest.toJson());
    final _options = _setStreamType<Result<UpdateUsersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateUsersResponse _value;
    try {
      _value = UpdateUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateUsersResponse>> updateUsers({
    required UpdateUsersRequest updateUsersRequest,
  }) {
    return _ResultCallAdapter<UpdateUsersResponse>().adapt(
      () => _updateUsers(updateUsersRequest: updateUsersRequest),
    );
  }

  Future<UpdateUsersResponse> _updateUsersPartial({
    required UpdateUsersPartialRequest updateUsersPartialRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUsersPartialRequest.toJson());
    final _options = _setStreamType<Result<UpdateUsersResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateUsersResponse _value;
    try {
      _value = UpdateUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateUsersResponse>> updateUsersPartial({
    required UpdateUsersPartialRequest updateUsersPartialRequest,
  }) {
    return _ResultCallAdapter<UpdateUsersResponse>().adapt(
      () => _updateUsersPartial(
        updateUsersPartialRequest: updateUsersPartialRequest,
      ),
    );
  }

  Future<FileUploadResponse> _uploadFile({
    FileUploadRequest? fileUploadRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(fileUploadRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<FileUploadResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/file',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FileUploadResponse _value;
    try {
      _value = FileUploadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<FileUploadResponse>> uploadFile({
    FileUploadRequest? fileUploadRequest,
  }) {
    return _ResultCallAdapter<FileUploadResponse>().adapt(
      () => _uploadFile(fileUploadRequest: fileUploadRequest),
    );
  }

  Future<ImageUploadResponse> _uploadImage({
    ImageUploadRequest? imageUploadRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(imageUploadRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<ImageUploadResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/image',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ImageUploadResponse _value;
    try {
      _value = ImageUploadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ImageUploadResponse>> uploadImage({
    ImageUploadRequest? imageUploadRequest,
  }) {
    return _ResultCallAdapter<ImageUploadResponse>().adapt(
      () => _uploadImage(imageUploadRequest: imageUploadRequest),
    );
  }

  Future<UpsertActionConfigResponse> _upsertActionConfig({
    required UpsertActionConfigRequest upsertActionConfigRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(upsertActionConfigRequest.toJson());
    final _options = _setStreamType<Result<UpsertActionConfigResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpsertActionConfigResponse _value;
    try {
      _value = UpsertActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpsertActionConfigResponse>> upsertActionConfig({
    required UpsertActionConfigRequest upsertActionConfigRequest,
  }) {
    return _ResultCallAdapter<UpsertActionConfigResponse>().adapt(
      () => _upsertActionConfig(
        upsertActionConfigRequest: upsertActionConfigRequest,
      ),
    );
  }

  Future<UpsertConfigResponse> _upsertConfig({
    required UpsertConfigRequest upsertConfigRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(upsertConfigRequest.toJson());
    final _options = _setStreamType<Result<UpsertConfigResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/config',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpsertConfigResponse _value;
    try {
      _value = UpsertConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpsertConfigResponse>> upsertConfig({
    required UpsertConfigRequest upsertConfigRequest,
  }) {
    return _ResultCallAdapter<UpsertConfigResponse>().adapt(
      () => _upsertConfig(upsertConfigRequest: upsertConfigRequest),
    );
  }

  Future<PinResponse> _videoPin({
    required String type,
    required String id,
    required PinRequest pinRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(pinRequest.toJson());
    final _options = _setStreamType<Result<PinResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/pin',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PinResponse _value;
    try {
      _value = PinResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PinResponse>> videoPin({
    required String type,
    required String id,
    required PinRequest pinRequest,
  }) {
    return _ResultCallAdapter<PinResponse>().adapt(
      () => _videoPin(type: type, id: id, pinRequest: pinRequest),
    );
  }

  Future<UnpinResponse> _videoUnpin({
    required String type,
    required String id,
    required UnpinRequest unpinRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(unpinRequest.toJson());
    final _options = _setStreamType<Result<UnpinResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/video/call/${type}/${id}/unpin',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UnpinResponse _value;
    try {
      _value = UnpinResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UnpinResponse>> videoUnpin({
    required String type,
    required String id,
    required UnpinRequest unpinRequest,
  }) {
    return _ResultCallAdapter<UnpinResponse>().adapt(
      () => _videoUnpin(type: type, id: id, unpinRequest: unpinRequest),
    );
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
