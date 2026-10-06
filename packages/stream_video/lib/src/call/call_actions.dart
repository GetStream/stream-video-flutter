part of 'call.dart';

/// Call actions that forward to the call's permissions manager or the
/// coordinator client, updating the call state where the action changes it.
extension CallActions on Call {
  /// Adds members to the current call.
  Future<Result<None>> addMembers(List<UserInfo> users) {
    return _coordinatorClient.addMembers(
      callCid: callCid,
      members: users.map((user) {
        return MemberRequest(userId: user.id, role: user.role);
      }).toList(),
    );
  }

  /// Removes members from the current call.
  Future<Result<None>> removeMembers(List<String> userIds) {
    return _coordinatorClient.removeMembers(
      callCid: callCid,
      removeIds: userIds,
    );
  }

  Future<Result<None>> updateCallMembers({
    List<UserInfo> updateMembers = const [],
    List<String> removeIds = const [],
  }) {
    return _coordinatorClient.updateCallMembers(
      callCid: callCid,
      updateMembers: updateMembers.map((user) {
        return MemberRequest(userId: user.id, role: user.role);
      }).toList(),
      removeIds: removeIds,
    );
  }

  /// Returns true if the current user has the [CallPermission] supplied.
  bool hasPermission(CallPermission permission) {
    return _permissionsManager.hasPermission(permission);
  }

  Future<Result<None>> requestPermissions(List<CallPermission> permissions) {
    return _permissionsManager.request(permissions);
  }

  Future<Result<None>> grantPermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return _permissionsManager.grant(userId: userId, permissions: permissions);
  }

  Future<Result<None>> revokePermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return _permissionsManager.revoke(userId: userId, permissions: permissions);
  }

  Future<Result<None>> blockUser(String userId) {
    return _permissionsManager.blockUser(userId);
  }

  Future<Result<None>> unblockUser(String userId) {
    return _permissionsManager.unblockUser(userId);
  }

  /// Kicks a user from the call.
  /// Set [block] to true to also block the user from rejoining.
  Future<Result<None>> kickUser(
    String userId, {
    bool block = false,
  }) {
    return _permissionsManager.kickUser(userId, block: block);
  }

  Future<Result<None>> startRecording({
    RecordingType recordingType = RecordingType.composite,
    String? recordingExternalStorage,
  }) async {
    final result = await _permissionsManager.startRecording(
      recordingType: recordingType,
      recordingExternalStorage: recordingExternalStorage,
    );

    if (result.isSuccess) {
      _stateManager.setCallRecording(isRecording: true);
    }

    return result;
  }

  Future<Result<List<CallRecording>>> listRecordings() async {
    return _permissionsManager.listRecordings();
  }

  Future<Result<None>> stopRecording({
    RecordingType recordingType = RecordingType.composite,
  }) async {
    final result = await _permissionsManager.stopRecording(
      recordingType: recordingType,
    );

    if (result.isSuccess) {
      _stateManager.setCallRecording(isRecording: false);
    }

    return result;
  }

  /// Starts transcription for the call.
  /// If [enableClosedCaptions] Enable closed captions along with transcriptions
  /// [language] The spoken language in the call, if not provided the language defined in the transcription settings will be used
  /// [transcriptionExternalStorage] Store transcriptions in this external storage
  Future<Result<None>> startTranscription({
    bool? enableClosedCaptions,
    TranscriptionSettingsLanguage? language,
    String? transcriptionExternalStorage,
  }) async {
    final result = await _permissionsManager.startTranscription(
      enableClosedCaptions: enableClosedCaptions,
      language: language,
      transcriptionExternalStorage: transcriptionExternalStorage,
    );

    if (result.isSuccess) {
      _stateManager.setCallTranscribing(isTranscribing: true);
    }

    return result;
  }

  Future<Result<List<CallTranscription>>> listTranscriptions() async {
    return _permissionsManager.listTranscriptions();
  }

  Future<Result<None>> stopTranscription() async {
    final result = await _permissionsManager.stopTranscription();

    if (result.isSuccess) {
      _stateManager.setCallTranscribing(isTranscribing: false);
    }

    return result;
  }

  /// Starts close captions for the call.
  /// If [enableTranscription] is set to `true`, it will also enable transcription.
  /// [language] The spoken language in the call, if not provided the language defined in the transcription settings will be used
  /// [transcriptionExternalStorage] Which external storage to use for transcriptions (only applicable if enable_transcription is true)
  Future<Result<None>> startClosedCaptions({
    bool? enableTranscription,
    TranscriptionSettingsLanguage? language,
    String? transcriptionExternalStorage,
  }) async {
    final result = await _permissionsManager.startClosedCaptions(
      enableTranscription: enableTranscription,
      language: language,
      transcriptionExternalStorage: transcriptionExternalStorage,
    );

    if (result.isSuccess) {
      _stateManager.setCallClosedCaptioning(isCaptioning: true);
    }

    return result;
  }

  /// Stops close captions for the call.
  Future<Result<None>> stopClosedCaptions() async {
    final result = await _permissionsManager.stopClosedCaptions();

    if (result.isSuccess) {
      _stateManager.setCallClosedCaptioning(isCaptioning: false);
    }

    return result;
  }

  /// Starts the broadcasting of the call.
  Future<Result<String?>> startHLS() async {
    final result = await _permissionsManager.startBroadcasting();

    if (result.isSuccess) {
      _stateManager.setCallBroadcasting(
        isBroadcasting: true,
        hlsPlaylistUrl: result.getDataOrNull(),
      );
    }
    return result;
  }

  /// Stops the broadcasting of the call.
  Future<Result<None>> stopHLS() async {
    final result = await _permissionsManager.stopBroadcasting();

    if (result.isSuccess) {
      _stateManager.setCallBroadcasting(isBroadcasting: false);
    }

    return result;
  }

  /// Starts RTMP broadcasts for the call to the provided [broadcasts]
  /// destinations.
  Future<Result<None>> startRtmpBroadcasts({
    required List<StreamRtmpBroadcastRequest> broadcasts,
  }) {
    return _coordinatorClient.startRtmpBroadcasts(
      state.value.callCid,
      broadcasts: broadcasts,
    );
  }

  /// Stops a single RTMP broadcast identified by [name].
  Future<Result<None>> stopRtmpBroadcast({required String name}) {
    return _coordinatorClient.stopRtmpBroadcast(
      state.value.callCid,
      name: name,
    );
  }

  /// Stops all RTMP broadcasts for this call.
  Future<Result<None>> stopAllRtmpBroadcasts() {
    return _coordinatorClient.stopAllRtmpBroadcasts(
      state.value.callCid,
    );
  }

  /// Allows for the muting of a or group of users as indicated by [userIds].
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  /// action else it will result in an error.
  Future<Result<None>> muteUsers({
    required List<String> userIds,
    TrackType track = TrackType.audio,
  }) {
    return _permissionsManager.muteUsers(userIds: userIds, track: track);
  }

  /// Allows for the muting of the current user.
  ///
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  Future<Result<None>> muteSelf({TrackType track = TrackType.audio}) {
    return _permissionsManager.muteSelf(track: track);
  }

  /// Allows for the muting of all users except current user calling the function.
  ///
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  /// action else it will result in an error.
  Future<Result<None>> muteOthers({TrackType track = TrackType.audio}) {
    return _permissionsManager.muteOthers(track: track);
  }

  /// Allows for the muting of all users on a call including the current user
  /// calling the function.
  ///
  /// By default the function will mute all the tracks (audio and video) of the users but this
  /// can be override by passing a [track] to the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  /// action else it will result in an error.
  Future<Result<None>> muteAllUsers({TrackType track = TrackType.all}) {
    return _permissionsManager.muteAllUsers(track: track);
  }

  /// Pins/unpins the given session to the top of the participants list.
  /// The change is done locally and won't affect other participants.
  void setParticipantPinnedLocally({
    required String sessionId,
    required String userId,
    required bool pinned,
  }) {
    _stateManager.setParticipantPinned(
      sessionId: sessionId,
      userId: userId,
      pinned: pinned,
    );
  }

  /// Pins/unpins the given session to the top of the participants list for everyone in the call.
  /// This method requires current user to have the `pin-for-everyone` capability.
  Future<Result<None>> setParticipantPinnedForEveryone({
    required String sessionId,
    required String userId,
    required bool pinned,
  }) async {
    return pinned
        ? _permissionsManager.pinForEveryone(
            userId: userId,
            sessionId: sessionId,
          )
        : _permissionsManager.unpinForEveryone(
            userId: userId,
            sessionId: sessionId,
          );
  }

  /// Starts the livestreaming of the call.
  Future<Result<CallMetadata>> goLive({
    bool? startHls,
    bool? startRecording,
    bool? startCompositeRecording,
    bool? startIndividualRecording,
    bool? startRawRecording,
    bool? startTranscription,
    bool? startClosedCaption,
    String? recordingStorageName,
    String? transcriptionStorageName,
  }) async {
    final result = await _coordinatorClient.goLive(
      callCid: callCid,
      startHls: startHls,
      startRecording: startRecording,
      startCompositeRecording: startCompositeRecording,
      startIndividualRecording: startIndividualRecording,
      startRawRecording: startRawRecording,
      startTranscription: startTranscription,
      startClosedCaption: startClosedCaption,
      recordingStorageName: recordingStorageName,
      transcriptionStorageName: transcriptionStorageName,
    );

    if (result.isSuccess) {
      _stateManager.setCallLive(isLive: true);
    }

    return result;
  }

  /// Stops the livestreaming of the call.
  Future<Result<CallMetadata>> stopLive({
    bool? continueClosedCaption,
    bool? continueCompositeRecording,
    bool? continueHls,
    bool? continueIndividualRecording,
    bool? continueRawRecording,
    bool? continueRecording,
    bool? continueRtmpBroadcasts,
    bool? continueTranscription,
  }) async {
    final result = await _coordinatorClient.stopLive(
      callCid,
      continueClosedCaption: continueClosedCaption,
      continueCompositeRecording: continueCompositeRecording,
      continueHls: continueHls,
      continueIndividualRecording: continueIndividualRecording,
      continueRawRecording: continueRawRecording,
      continueRecording: continueRecording,
      continueRtmpBroadcasts: continueRtmpBroadcasts,
      continueTranscription: continueTranscription,
    );

    if (result.isSuccess) {
      _stateManager.setCallLive(isLive: false);
    }

    return result;
  }

  Future<Result<QueriedMembers>> queryMembers({
    Map<String, Object> filterConditions = const {},
    String? next,
    String? prev,
    List<SortParamRequest> sorts = const [],
    int? limit,
  }) {
    return _permissionsManager.queryMembers(
      filterConditions: filterConditions,
      next: next,
      prev: prev,
      sorts: sorts,
      limit: limit,
    );
  }

  Future<Result<CallReaction>> sendReaction({
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  }) {
    return _permissionsManager.sendReaction(
      reactionType: reactionType,
      emojiCode: emojiCode,
      custom: custom,
    );
  }

  Future<Result<None>> sendCustomEvent({
    required String eventType,
    Map<String, Object> custom = const {},
  }) {
    return _coordinatorClient.sendCustomEvent(
      callCid: callCid,
      eventType: eventType,
      custom: custom,
    );
  }

  /// Collects user feedback asynchronously.
  ///
  /// Parameters:
  /// - `[rating]`: Rating between 1 and 5 denoting the experience of the user in the call
  /// - `[reason]`: The reason/description for the rating
  /// - `[custom]`: Custom data
  Future<Result<None>> collectUserFeedback({
    required int rating,
    String? reason,
    Map<String, Object>? custom,
  }) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }

    if (_session?.sessionId == null) {
      throw ArgumentError(
        'Feedback can be submitted only in the context of a call session',
      );
    }

    return _coordinatorClient.collectUserFeedback(
      callId: id,
      callType: type.value,
      sessionId: _session!.sessionId,
      rating: rating,
      reason: reason,
      custom: custom,
      sdk: streamSdkName,
      sdkVersion: streamVideoVersion,
      userSessionId: _session!.sessionId,
    );
  }
}
