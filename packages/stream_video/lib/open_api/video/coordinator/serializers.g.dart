// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(APIError.serializer)
      ..add(AcceptCallResponse.serializer)
      ..add(AppEventResponse.serializer)
      ..add(AppUpdatedEvent.serializer)
      ..add(AudioSettingsRequest.serializer)
      ..add(AudioSettingsRequestDefaultDeviceEnum.serializer)
      ..add(AudioSettingsResponse.serializer)
      ..add(AudioSettingsResponseDefaultDeviceEnum.serializer)
      ..add(BackstageSettingsRequest.serializer)
      ..add(BackstageSettingsResponse.serializer)
      ..add(BlockUserRequest.serializer)
      ..add(BlockUserResponse.serializer)
      ..add(BlockedUserEvent.serializer)
      ..add(Bound.serializer)
      ..add(BroadcastSettingsRequest.serializer)
      ..add(BroadcastSettingsResponse.serializer)
      ..add(CallAcceptedEvent.serializer)
      ..add(CallClosedCaption.serializer)
      ..add(CallClosedCaptionsFailedEvent.serializer)
      ..add(CallClosedCaptionsStartedEvent.serializer)
      ..add(CallClosedCaptionsStoppedEvent.serializer)
      ..add(CallCreatedEvent.serializer)
      ..add(CallDeletedEvent.serializer)
      ..add(CallDurationReport.serializer)
      ..add(CallDurationReportResponse.serializer)
      ..add(CallEndedEvent.serializer)
      ..add(CallFrameRecordingFailedEvent.serializer)
      ..add(CallFrameRecordingFrameReadyEvent.serializer)
      ..add(CallFrameRecordingStartedEvent.serializer)
      ..add(CallFrameRecordingStoppedEvent.serializer)
      ..add(CallHLSBroadcastingFailedEvent.serializer)
      ..add(CallHLSBroadcastingStartedEvent.serializer)
      ..add(CallHLSBroadcastingStoppedEvent.serializer)
      ..add(CallIngressResponse.serializer)
      ..add(CallLiveStartedEvent.serializer)
      ..add(CallMemberAddedEvent.serializer)
      ..add(CallMemberRemovedEvent.serializer)
      ..add(CallMemberUpdatedEvent.serializer)
      ..add(CallMemberUpdatedPermissionEvent.serializer)
      ..add(CallMissedEvent.serializer)
      ..add(CallModerationBlurEvent.serializer)
      ..add(CallModerationWarningEvent.serializer)
      ..add(CallNotificationEvent.serializer)
      ..add(CallParticipantCountReport.serializer)
      ..add(CallParticipantCountReportResponse.serializer)
      ..add(CallParticipantResponse.serializer)
      ..add(CallReactionEvent.serializer)
      ..add(CallRecording.serializer)
      ..add(CallRecordingFailedEvent.serializer)
      ..add(CallRecordingReadyEvent.serializer)
      ..add(CallRecordingStartedEvent.serializer)
      ..add(CallRecordingStoppedEvent.serializer)
      ..add(CallRejectedEvent.serializer)
      ..add(CallReportResponse.serializer)
      ..add(CallRequest.serializer)
      ..add(CallResponse.serializer)
      ..add(CallRingEvent.serializer)
      ..add(CallRtmpBroadcastFailedEvent.serializer)
      ..add(CallRtmpBroadcastStartedEvent.serializer)
      ..add(CallRtmpBroadcastStoppedEvent.serializer)
      ..add(CallSessionEndedEvent.serializer)
      ..add(CallSessionParticipantCountsUpdatedEvent.serializer)
      ..add(CallSessionParticipantJoinedEvent.serializer)
      ..add(CallSessionParticipantLeftEvent.serializer)
      ..add(CallSessionResponse.serializer)
      ..add(CallSessionStartedEvent.serializer)
      ..add(CallSettingsRequest.serializer)
      ..add(CallSettingsResponse.serializer)
      ..add(CallStateResponseFields.serializer)
      ..add(CallStatsReportReadyEvent.serializer)
      ..add(CallStatsReportSummaryResponse.serializer)
      ..add(CallTranscription.serializer)
      ..add(CallTranscriptionFailedEvent.serializer)
      ..add(CallTranscriptionReadyEvent.serializer)
      ..add(CallTranscriptionStartedEvent.serializer)
      ..add(CallTranscriptionStoppedEvent.serializer)
      ..add(CallUpdatedEvent.serializer)
      ..add(CallUserMutedEvent.serializer)
      ..add(CallsPerDayReport.serializer)
      ..add(CallsPerDayReportResponse.serializer)
      ..add(ChatActivityStatsResponse.serializer)
      ..add(ClosedCaptionEvent.serializer)
      ..add(CollectUserFeedbackRequest.serializer)
      ..add(CollectUserFeedbackResponse.serializer)
      ..add(ConnectUserDetailsRequest.serializer)
      ..add(ConnectedEvent.serializer)
      ..add(ConnectionErrorEvent.serializer)
      ..add(CountByMinuteResponse.serializer)
      ..add(CreateDeviceRequest.serializer)
      ..add(CreateDeviceRequestPushProviderEnum.serializer)
      ..add(CreateGuestRequest.serializer)
      ..add(CreateGuestResponse.serializer)
      ..add(Credentials.serializer)
      ..add(CustomVideoEvent.serializer)
      ..add(DailyAggregateCallDurationReportResponse.serializer)
      ..add(DailyAggregateCallParticipantCountReportResponse.serializer)
      ..add(DailyAggregateCallsPerDayReportResponse.serializer)
      ..add(DailyAggregateQualityScoreReportResponse.serializer)
      ..add(DailyAggregateSDKUsageReportResponse.serializer)
      ..add(DailyAggregateUserFeedbackReportResponse.serializer)
      ..add(DeleteCallRequest.serializer)
      ..add(DeleteCallResponse.serializer)
      ..add(DeleteRecordingResponse.serializer)
      ..add(DeleteTranscriptionResponse.serializer)
      ..add(DeviceResponse.serializer)
      ..add(EdgeResponse.serializer)
      ..add(EgressHLSResponse.serializer)
      ..add(EgressRTMPResponse.serializer)
      ..add(EgressResponse.serializer)
      ..add(EndCallResponse.serializer)
      ..add(FileUploadConfig.serializer)
      ..add(FrameRecordingResponse.serializer)
      ..add(FrameRecordingSettingsRequest.serializer)
      ..add(FrameRecordingSettingsRequestModeEnum.serializer)
      ..add(FrameRecordingSettingsRequestQualityEnum.serializer)
      ..add(FrameRecordingSettingsResponse.serializer)
      ..add(FrameRecordingSettingsResponseModeEnum.serializer)
      ..add(GeofenceSettingsRequest.serializer)
      ..add(GeofenceSettingsResponse.serializer)
      ..add(GetCallReportResponse.serializer)
      ..add(GetCallResponse.serializer)
      ..add(GetEdgesResponse.serializer)
      ..add(GetOrCreateCallRequest.serializer)
      ..add(GetOrCreateCallResponse.serializer)
      ..add(GoLiveRequest.serializer)
      ..add(GoLiveResponse.serializer)
      ..add(GroupedStatsResponse.serializer)
      ..add(HLSSettingsRequest.serializer)
      ..add(HLSSettingsResponse.serializer)
      ..add(HealthCheckEvent.serializer)
      ..add(ICEServer.serializer)
      ..add(JoinCallRequest.serializer)
      ..add(JoinCallResponse.serializer)
      ..add(LayoutSettingsRequest.serializer)
      ..add(LayoutSettingsRequestNameEnum.serializer)
      ..add(LimitsSettingsRequest.serializer)
      ..add(LimitsSettingsResponse.serializer)
      ..add(ListDevicesResponse.serializer)
      ..add(ListRecordingsResponse.serializer)
      ..add(ListTranscriptionsResponse.serializer)
      ..add(MemberRequest.serializer)
      ..add(MemberResponse.serializer)
      ..add(MessageStatsResponse.serializer)
      ..add(MuteUsersRequest.serializer)
      ..add(MuteUsersResponse.serializer)
      ..add(NetworkMetricsReportResponse.serializer)
      ..add(NoiseCancellationSettings.serializer)
      ..add(NoiseCancellationSettingsModeEnum.serializer)
      ..add(OwnCapability.serializer)
      ..add(OwnUserResponse.serializer)
      ..add(ParticipantCountByMinuteResponse.serializer)
      ..add(ParticipantCountOverTimeResponse.serializer)
      ..add(ParticipantReportResponse.serializer)
      ..add(PerSDKUsageReport.serializer)
      ..add(PermissionRequestEvent.serializer)
      ..add(PinRequest.serializer)
      ..add(PinResponse.serializer)
      ..add(PrivacySettings.serializer)
      ..add(PublisherStatsResponse.serializer)
      ..add(PushPreferences.serializer)
      ..add(QualityScoreReport.serializer)
      ..add(QualityScoreReportResponse.serializer)
      ..add(QueryAggregateCallStatsRequest.serializer)
      ..add(QueryAggregateCallStatsResponse.serializer)
      ..add(QueryCallMembersRequest.serializer)
      ..add(QueryCallMembersResponse.serializer)
      ..add(QueryCallParticipantsRequest.serializer)
      ..add(QueryCallParticipantsResponse.serializer)
      ..add(QueryCallStatsRequest.serializer)
      ..add(QueryCallStatsResponse.serializer)
      ..add(QueryCallsRequest.serializer)
      ..add(QueryCallsResponse.serializer)
      ..add(RTMPBroadcastRequest.serializer)
      ..add(RTMPBroadcastRequestQualityEnum.serializer)
      ..add(RTMPIngress.serializer)
      ..add(RTMPSettingsRequest.serializer)
      ..add(RTMPSettingsRequestQualityEnum.serializer)
      ..add(RTMPSettingsResponse.serializer)
      ..add(ReactionResponse.serializer)
      ..add(ReadReceipts.serializer)
      ..add(RecordSettingsRequest.serializer)
      ..add(RecordSettingsRequestModeEnum.serializer)
      ..add(RecordSettingsRequestQualityEnum.serializer)
      ..add(RecordSettingsResponse.serializer)
      ..add(RejectCallRequest.serializer)
      ..add(RejectCallResponse.serializer)
      ..add(ReportByHistogramBucket.serializer)
      ..add(ReportResponse.serializer)
      ..add(RequestPermissionRequest.serializer)
      ..add(RequestPermissionResponse.serializer)
      ..add(Response.serializer)
      ..add(RingSettingsRequest.serializer)
      ..add(RingSettingsResponse.serializer)
      ..add(SDKUsageReport.serializer)
      ..add(SDKUsageReportResponse.serializer)
      ..add(SFUResponse.serializer)
      ..add(ScreensharingSettingsRequest.serializer)
      ..add(ScreensharingSettingsResponse.serializer)
      ..add(SendCallEventRequest.serializer)
      ..add(SendCallEventResponse.serializer)
      ..add(SendReactionRequest.serializer)
      ..add(SendReactionResponse.serializer)
      ..add(SessionSettingsRequest.serializer)
      ..add(SessionSettingsResponse.serializer)
      ..add(SortParamRequest.serializer)
      ..add(StartClosedCaptionsRequest.serializer)
      ..add(StartClosedCaptionsRequestLanguageEnum.serializer)
      ..add(StartClosedCaptionsResponse.serializer)
      ..add(StartFrameRecordingRequest.serializer)
      ..add(StartFrameRecordingResponse.serializer)
      ..add(StartHLSBroadcastingResponse.serializer)
      ..add(StartRTMPBroadcastsRequest.serializer)
      ..add(StartRTMPBroadcastsResponse.serializer)
      ..add(StartRecordingRequest.serializer)
      ..add(StartRecordingResponse.serializer)
      ..add(StartTranscriptionRequest.serializer)
      ..add(StartTranscriptionRequestLanguageEnum.serializer)
      ..add(StartTranscriptionResponse.serializer)
      ..add(StatsOptions.serializer)
      ..add(StopAllRTMPBroadcastsResponse.serializer)
      ..add(StopClosedCaptionsRequest.serializer)
      ..add(StopClosedCaptionsResponse.serializer)
      ..add(StopFrameRecordingResponse.serializer)
      ..add(StopHLSBroadcastingResponse.serializer)
      ..add(StopLiveRequest.serializer)
      ..add(StopLiveResponse.serializer)
      ..add(StopRTMPBroadcastsResponse.serializer)
      ..add(StopRecordingResponse.serializer)
      ..add(StopTranscriptionRequest.serializer)
      ..add(StopTranscriptionResponse.serializer)
      ..add(SubscriberStatsResponse.serializer)
      ..add(TargetResolution.serializer)
      ..add(ThumbnailResponse.serializer)
      ..add(ThumbnailsSettingsRequest.serializer)
      ..add(ThumbnailsSettingsResponse.serializer)
      ..add(TrackStatsResponse.serializer)
      ..add(TranscriptionSettingsRequest.serializer)
      ..add(TranscriptionSettingsRequestClosedCaptionModeEnum.serializer)
      ..add(TranscriptionSettingsRequestLanguageEnum.serializer)
      ..add(TranscriptionSettingsRequestModeEnum.serializer)
      ..add(TranscriptionSettingsResponse.serializer)
      ..add(TranscriptionSettingsResponseClosedCaptionModeEnum.serializer)
      ..add(TranscriptionSettingsResponseLanguageEnum.serializer)
      ..add(TranscriptionSettingsResponseModeEnum.serializer)
      ..add(TypingIndicators.serializer)
      ..add(UnblockUserRequest.serializer)
      ..add(UnblockUserResponse.serializer)
      ..add(UnblockedUserEvent.serializer)
      ..add(UnpinRequest.serializer)
      ..add(UnpinResponse.serializer)
      ..add(UpdateCallMembersRequest.serializer)
      ..add(UpdateCallMembersResponse.serializer)
      ..add(UpdateCallRequest.serializer)
      ..add(UpdateCallResponse.serializer)
      ..add(UpdateUserPermissionsRequest.serializer)
      ..add(UpdateUserPermissionsResponse.serializer)
      ..add(UpdatedCallPermissionsEvent.serializer)
      ..add(User.serializer)
      ..add(UserBannedEvent.serializer)
      ..add(UserDeactivatedEvent.serializer)
      ..add(UserFeedbackReport.serializer)
      ..add(UserFeedbackReportResponse.serializer)
      ..add(UserMutedEvent.serializer)
      ..add(UserRatingReportResponse.serializer)
      ..add(UserReactivatedEvent.serializer)
      ..add(UserRequest.serializer)
      ..add(UserResponse.serializer)
      ..add(UserResponsePrivacyFields.serializer)
      ..add(UserUpdatedEvent.serializer)
      ..add(VideoEvent.serializer)
      ..add(VideoReactionOverTimeResponse.serializer)
      ..add(VideoReactionsResponse.serializer)
      ..add(VideoSettingsRequest.serializer)
      ..add(VideoSettingsRequestCameraFacingEnum.serializer)
      ..add(VideoSettingsResponse.serializer)
      ..add(VideoSettingsResponseCameraFacingEnum.serializer)
      ..add(WSAuthMessage.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CallRecording)]),
          () => ListBuilder<CallRecording>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CallStateResponseFields)]),
          () => ListBuilder<CallStateResponseFields>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(CallStatsReportSummaryResponse)]),
          () => ListBuilder<CallStatsReportSummaryResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CallTranscription)]),
          () => ListBuilder<CallTranscription>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DailyAggregateCallDurationReportResponse)]),
          () => ListBuilder<DailyAggregateCallDurationReportResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(DailyAggregateCallParticipantCountReportResponse)
          ]),
          () => ListBuilder<DailyAggregateCallParticipantCountReportResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DailyAggregateCallsPerDayReportResponse)]),
          () => ListBuilder<DailyAggregateCallsPerDayReportResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DailyAggregateQualityScoreReportResponse)]),
          () => ListBuilder<DailyAggregateQualityScoreReportResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DailyAggregateSDKUsageReportResponse)]),
          () => ListBuilder<DailyAggregateSDKUsageReportResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DailyAggregateUserFeedbackReportResponse)]),
          () => ListBuilder<DailyAggregateUserFeedbackReportResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DeviceResponse)]),
          () => ListBuilder<DeviceResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EdgeResponse)]),
          () => ListBuilder<EdgeResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EgressRTMPResponse)]),
          () => ListBuilder<EgressRTMPResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ICEServer)]),
          () => ListBuilder<ICEServer>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OwnCapability)]),
          () => ListBuilder<OwnCapability>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OwnCapability)]),
          () => ListBuilder<OwnCapability>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OwnCapability)]),
          () => ListBuilder<OwnCapability>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OwnCapability)]),
          () => ListBuilder<OwnCapability>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OwnCapability)]),
          () => ListBuilder<OwnCapability>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OwnCapability)]),
          () => ListBuilder<OwnCapability>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CallParticipantResponse)]),
          () => ListBuilder<CallParticipantResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OwnCapability)]),
          () => ListBuilder<OwnCapability>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(RTMPBroadcastRequest)]),
          () => ListBuilder<RTMPBroadcastRequest>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ReportByHistogramBucket)]),
          () => ListBuilder<ReportByHistogramBucket>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ReportByHistogramBucket)]),
          () => ListBuilder<ReportByHistogramBucket>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ReportByHistogramBucket)]),
          () => ListBuilder<ReportByHistogramBucket>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberRequest)]),
          () => ListBuilder<MemberRequest>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DeviceResponse)]),
          () => ListBuilder<DeviceResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType.nullable(CountByMinuteResponse)]),
          () => ListBuilder<CountByMinuteResponse?>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType.nullable(CountByMinuteResponse)]),
          () => ListBuilder<CountByMinuteResponse?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(GroupedStatsResponse)]),
          () => ListBuilder<GroupedStatsResponse?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(GroupedStatsResponse)]),
          () => ListBuilder<GroupedStatsResponse?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(GroupedStatsResponse)]),
          () => ListBuilder<GroupedStatsResponse?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(GroupedStatsResponse)]),
          () => ListBuilder<GroupedStatsResponse?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType.nullable(ParticipantCountByMinuteResponse)
          ]),
          () => ListBuilder<ParticipantCountByMinuteResponse?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(TrackStatsResponse)]),
          () => ListBuilder<TrackStatsResponse?>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType.nullable(VideoReactionsResponse)]),
          () => ListBuilder<VideoReactionsResponse?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => MapBuilder<String, BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => MapBuilder<String, BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberResponse)]),
          () => ListBuilder<MemberResponse>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(DateTime)]),
          () => MapBuilder<String, DateTime>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(DateTime)]),
          () => MapBuilder<String, DateTime>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CallParticipantResponse)]),
          () => ListBuilder<CallParticipantResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(DateTime)]),
          () => MapBuilder<String, DateTime>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(UserResponse)]),
          () => MapBuilder<String, UserResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberRequest)]),
          () => ListBuilder<MemberRequest>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(SortParamRequest)]),
          () => ListBuilder<SortParamRequest?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(SortParamRequest)]),
          () => ListBuilder<SortParamRequest?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(SortParamRequest)]),
          () => ListBuilder<SortParamRequest?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(PerSDKUsageReport)
          ]),
          () => MapBuilder<String, PerSDKUsageReport?>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
