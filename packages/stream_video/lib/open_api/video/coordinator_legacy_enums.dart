// Backward-compatibility aliases for OpenAPI enum types.
//
// The previous generator suffixed generated enum types with `Enum`
// (e.g. `AudioSettingsRequestDefaultDeviceEnum`). The current generator emits
// plain Dart enums without that suffix (`AudioSettingsRequestDefaultDevice`).
// These typedefs keep the old names working so existing code (and integrators)
// does not break.
//
// NOTE: this file intentionally lives outside the generated `coordinator/`
// directory because the generation script runs `rm -rf` on it; keeping the
// aliases here ensures they survive regeneration.

import 'coordinator/api.dart';

@Deprecated('Use AudioSettingsRequestDefaultDevice instead.')
typedef AudioSettingsRequestDefaultDeviceEnum =
    AudioSettingsRequestDefaultDevice;
@Deprecated('Use AudioSettingsResponseDefaultDevice instead.')
typedef AudioSettingsResponseDefaultDeviceEnum =
    AudioSettingsResponseDefaultDevice;
@Deprecated('Use CallRecordingFailedEventRecordingType instead.')
typedef CallRecordingFailedEventRecordingTypeEnum =
    CallRecordingFailedEventRecordingType;
@Deprecated('Use CallRecordingReadyEventRecordingType instead.')
typedef CallRecordingReadyEventRecordingTypeEnum =
    CallRecordingReadyEventRecordingType;
@Deprecated('Use CallRecordingStartedEventRecordingType instead.')
typedef CallRecordingStartedEventRecordingTypeEnum =
    CallRecordingStartedEventRecordingType;
@Deprecated('Use CallRecordingStoppedEventRecordingType instead.')
typedef CallRecordingStoppedEventRecordingTypeEnum =
    CallRecordingStoppedEventRecordingType;
@Deprecated('Use CreateDeviceRequestPushProvider instead.')
typedef CreateDeviceRequestPushProviderEnum = CreateDeviceRequestPushProvider;
@Deprecated('Use FrameRecordingSettingsRequestMode instead.')
typedef FrameRecordingSettingsRequestModeEnum =
    FrameRecordingSettingsRequestMode;
@Deprecated('Use FrameRecordingSettingsRequestQuality instead.')
typedef FrameRecordingSettingsRequestQualityEnum =
    FrameRecordingSettingsRequestQuality;
@Deprecated('Use FrameRecordingSettingsResponseMode instead.')
typedef FrameRecordingSettingsResponseModeEnum =
    FrameRecordingSettingsResponseMode;
@Deprecated('Use HLSSettingsRequestQualityTracks instead.')
typedef HLSSettingsRequestQualityTracksEnum = HLSSettingsRequestQualityTracks;
@Deprecated('Use IndividualRecordingSettingsRequestMode instead.')
typedef IndividualRecordingSettingsRequestModeEnum =
    IndividualRecordingSettingsRequestMode;
@Deprecated('Use IndividualRecordingSettingsRequestOutputTypes instead.')
typedef IndividualRecordingSettingsRequestOutputTypesEnum =
    IndividualRecordingSettingsRequestOutputTypes;
@Deprecated('Use IndividualRecordingSettingsResponseMode instead.')
typedef IndividualRecordingSettingsResponseModeEnum =
    IndividualRecordingSettingsResponseMode;
@Deprecated('Use IngressAudioEncodingOptionsRequestChannels instead.')
typedef IngressAudioEncodingOptionsRequestChannelsEnum =
    IngressAudioEncodingOptionsRequestChannels;
@Deprecated('Use IngressSourceRequestFps instead.')
typedef IngressSourceRequestFpsEnum = IngressSourceRequestFps;
@Deprecated('Use IngressVideoLayerRequestCodec instead.')
typedef IngressVideoLayerRequestCodecEnum = IngressVideoLayerRequestCodec;
@Deprecated('Use LayoutSettingsRequestName instead.')
typedef LayoutSettingsRequestNameEnum = LayoutSettingsRequestName;
@Deprecated('Use NoiseCancellationSettingsMode instead.')
typedef NoiseCancellationSettingsModeEnum = NoiseCancellationSettingsMode;
@Deprecated('Use RawRecordingSettingsRequestMode instead.')
typedef RawRecordingSettingsRequestModeEnum = RawRecordingSettingsRequestMode;
@Deprecated('Use RawRecordingSettingsResponseMode instead.')
typedef RawRecordingSettingsResponseModeEnum = RawRecordingSettingsResponseMode;
@Deprecated('Use RecordSettingsRequestMode instead.')
typedef RecordSettingsRequestModeEnum = RecordSettingsRequestMode;
@Deprecated('Use RecordSettingsRequestQuality instead.')
typedef RecordSettingsRequestQualityEnum = RecordSettingsRequestQuality;
@Deprecated('Use RequestPermissionRequestPermissions instead.')
typedef RequestPermissionRequestPermissionsEnum =
    RequestPermissionRequestPermissions;
@Deprecated('Use RTMPBroadcastRequestQuality instead.')
typedef RTMPBroadcastRequestQualityEnum = RTMPBroadcastRequestQuality;
@Deprecated('Use RTMPSettingsRequestQuality instead.')
typedef RTMPSettingsRequestQualityEnum = RTMPSettingsRequestQuality;
@Deprecated('Use StartClosedCaptionsRequestLanguage instead.')
typedef StartClosedCaptionsRequestLanguageEnum =
    StartClosedCaptionsRequestLanguage;
@Deprecated('Use StartTranscriptionRequestLanguage instead.')
typedef StartTranscriptionRequestLanguageEnum =
    StartTranscriptionRequestLanguage;
@Deprecated('Use TranscriptionSettingsRequestClosedCaptionMode instead.')
typedef TranscriptionSettingsRequestClosedCaptionModeEnum =
    TranscriptionSettingsRequestClosedCaptionMode;
@Deprecated('Use TranscriptionSettingsRequestLanguage instead.')
typedef TranscriptionSettingsRequestLanguageEnum =
    TranscriptionSettingsRequestLanguage;
@Deprecated('Use TranscriptionSettingsRequestMode instead.')
typedef TranscriptionSettingsRequestModeEnum = TranscriptionSettingsRequestMode;
@Deprecated('Use TranscriptionSettingsResponseClosedCaptionMode instead.')
typedef TranscriptionSettingsResponseClosedCaptionModeEnum =
    TranscriptionSettingsResponseClosedCaptionMode;
@Deprecated('Use TranscriptionSettingsResponseLanguage instead.')
typedef TranscriptionSettingsResponseLanguageEnum =
    TranscriptionSettingsResponseLanguage;
@Deprecated('Use TranscriptionSettingsResponseMode instead.')
typedef TranscriptionSettingsResponseModeEnum =
    TranscriptionSettingsResponseMode;
@Deprecated('Use TranslationSettingsLanguages instead.')
typedef TranslationSettingsLanguagesEnum = TranslationSettingsLanguages;
@Deprecated('Use UpdateUserPermissionsRequestGrantPermissions instead.')
typedef UpdateUserPermissionsRequestGrantPermissionsEnum =
    UpdateUserPermissionsRequestGrantPermissions;
@Deprecated('Use UpdateUserPermissionsRequestRevokePermissions instead.')
typedef UpdateUserPermissionsRequestRevokePermissionsEnum =
    UpdateUserPermissionsRequestRevokePermissions;
@Deprecated('Use VideoSettingsRequestCameraFacing instead.')
typedef VideoSettingsRequestCameraFacingEnum = VideoSettingsRequestCameraFacing;
@Deprecated('Use VideoSettingsResponseCameraFacing instead.')
typedef VideoSettingsResponseCameraFacingEnum =
    VideoSettingsResponseCameraFacing;
@Deprecated('Use WSAuthMessageProducts instead.')
typedef WSAuthMessageProductsEnum = WSAuthMessageProducts;
