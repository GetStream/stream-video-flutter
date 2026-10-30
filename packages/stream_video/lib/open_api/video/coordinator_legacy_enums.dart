// Backward-compatibility aliases for OpenAPI enum types.
//
// Earlier generators named each enum after the field it came from, suffixed
// with `Enum` (e.g. `AudioSettingsRequestDefaultDeviceEnum`). The current
// generator emits one named enum per value set (`AudioDefaultDevice`). These
// typedefs keep the old names working so existing code (and integrators) does
// not break.
//
// NOTE: this file intentionally lives outside the generated `coordinator/`
// directory because the generation script runs `rm -rf` on it; keeping the
// aliases here ensures they survive regeneration.

import 'coordinator/api.dart';
import 'coordinator_aliases.dart';

@Deprecated('Use AudioDefaultDevice instead.')
typedef AudioSettingsRequestDefaultDeviceEnum = AudioDefaultDevice;
@Deprecated('Use AudioDefaultDevice instead.')
typedef AudioSettingsResponseDefaultDeviceEnum = AudioDefaultDevice;
@Deprecated('Use CallRecordingType instead.')
typedef CallRecordingFailedEventRecordingTypeEnum = CallRecordingType;
@Deprecated('Use CallRecordingType instead.')
typedef CallRecordingReadyEventRecordingTypeEnum = CallRecordingType;
@Deprecated('Use CallRecordingType instead.')
typedef CallRecordingStartedEventRecordingTypeEnum = CallRecordingType;
@Deprecated('Use CallRecordingType instead.')
typedef CallRecordingStoppedEventRecordingTypeEnum = CallRecordingType;
@Deprecated('Use PushProviderName instead.')
typedef CreateDeviceRequestPushProviderEnum = PushProviderName;
@Deprecated('Use FeatureActivationMode instead.')
typedef FrameRecordingSettingsRequestModeEnum = FeatureActivationMode;
@Deprecated('Use FrameRecordingSettingsRequestQuality instead.')
typedef FrameRecordingSettingsRequestQualityEnum =
    FrameRecordingSettingsRequestQuality;
@Deprecated('Use FeatureActivationMode instead.')
typedef FrameRecordingSettingsResponseModeEnum = FeatureActivationMode;
@Deprecated('Use HLSSettingsRequestQualityTracks instead.')
typedef HLSSettingsRequestQualityTracksEnum = HLSSettingsRequestQualityTracks;
@Deprecated('Use FeatureActivationMode instead.')
typedef IndividualRecordingSettingsRequestModeEnum = FeatureActivationMode;
@Deprecated('Use IndividualRecordingSettingsRequestOutputTypes instead.')
typedef IndividualRecordingSettingsRequestOutputTypesEnum =
    IndividualRecordingSettingsRequestOutputTypes;
@Deprecated('Use FeatureActivationMode instead.')
typedef IndividualRecordingSettingsResponseModeEnum = FeatureActivationMode;
@Deprecated('Use VideoCodec instead.')
typedef IngressVideoLayerRequestCodecEnum = VideoCodec;
@Deprecated('Use LayoutName instead.')
typedef LayoutSettingsRequestNameEnum = LayoutName;
@Deprecated('Use FeatureActivationMode instead.')
typedef NoiseCancellationSettingsModeEnum = FeatureActivationMode;
@Deprecated('Use FeatureActivationMode instead.')
typedef RawRecordingSettingsRequestModeEnum = FeatureActivationMode;
@Deprecated('Use FeatureActivationMode instead.')
typedef RawRecordingSettingsResponseModeEnum = FeatureActivationMode;
@Deprecated('Use FeatureActivationMode instead.')
typedef RecordSettingsRequestModeEnum = FeatureActivationMode;
@Deprecated('Use RecordSettingsRequestQuality instead.')
typedef RecordSettingsRequestQualityEnum = RecordSettingsRequestQuality;
@Deprecated('Use RequestPermissionRequestPermissions instead.')
typedef RequestPermissionRequestPermissionsEnum =
    RequestPermissionRequestPermissions;
@Deprecated('Use RTMPBroadcastRequestQuality instead.')
typedef RTMPBroadcastRequestQualityEnum = RTMPBroadcastRequestQuality;
@Deprecated('Use RTMPSettingsRequestQuality instead.')
typedef RTMPSettingsRequestQualityEnum = RTMPSettingsRequestQuality;
@Deprecated('Use TranscriptionLanguage instead.')
typedef StartClosedCaptionsRequestLanguageEnum = TranscriptionLanguage;
@Deprecated('Use TranscriptionLanguage instead.')
typedef StartTranscriptionRequestLanguageEnum = TranscriptionLanguage;
@Deprecated('Use FeatureActivationMode instead.')
typedef TranscriptionSettingsRequestClosedCaptionModeEnum =
    FeatureActivationMode;
@Deprecated('Use TranscriptionLanguage instead.')
typedef TranscriptionSettingsRequestLanguageEnum = TranscriptionLanguage;
@Deprecated('Use FeatureActivationMode instead.')
typedef TranscriptionSettingsRequestModeEnum = FeatureActivationMode;
@Deprecated('Use FeatureActivationMode instead.')
typedef TranscriptionSettingsResponseClosedCaptionModeEnum =
    FeatureActivationMode;
@Deprecated('Use TranscriptionLanguage instead.')
typedef TranscriptionSettingsResponseLanguageEnum = TranscriptionLanguage;
@Deprecated('Use FeatureActivationMode instead.')
typedef TranscriptionSettingsResponseModeEnum = FeatureActivationMode;
@Deprecated('Use TranslationSettingsLanguages instead.')
typedef TranslationSettingsLanguagesEnum = TranslationSettingsLanguages;
@Deprecated('Use UpdateUserPermissionsRequestGrantPermissions instead.')
typedef UpdateUserPermissionsRequestGrantPermissionsEnum =
    UpdateUserPermissionsRequestGrantPermissions;
@Deprecated('Use UpdateUserPermissionsRequestRevokePermissions instead.')
typedef UpdateUserPermissionsRequestRevokePermissionsEnum =
    UpdateUserPermissionsRequestRevokePermissions;
@Deprecated('Use CameraFacing instead.')
typedef VideoSettingsRequestCameraFacingEnum = CameraFacing;
@Deprecated('Use CameraFacing instead.')
typedef VideoSettingsResponseCameraFacingEnum = CameraFacing;
@Deprecated('Use WSAuthMessageProducts instead.')
typedef WSAuthMessageProductsEnum = WSAuthMessageProducts;

@Deprecated('Use int instead.')
typedef IngressAudioEncodingOptionsRequestChannelsEnum = int;
@Deprecated('Use int instead.')
typedef IngressSourceRequestFpsEnum = int;
