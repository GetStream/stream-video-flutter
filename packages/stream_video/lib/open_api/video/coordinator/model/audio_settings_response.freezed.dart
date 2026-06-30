// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioSettingsResponse {
  bool get accessRequestEnabled;
  AudioSettingsResponseDefaultDevice get defaultDevice;
  bool get hifiAudioEnabled;
  bool get micDefaultOn;
  NoiseCancellationSettings? get noiseCancellation;
  bool get opusDtxEnabled;
  bool get redundantCodingEnabled;
  bool get speakerDefaultOn;

  /// Create a copy of AudioSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AudioSettingsResponseCopyWith<AudioSettingsResponse> get copyWith =>
      _$AudioSettingsResponseCopyWithImpl<AudioSettingsResponse>(
        this as AudioSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AudioSettingsResponse &&
            (identical(other.accessRequestEnabled, accessRequestEnabled) ||
                other.accessRequestEnabled == accessRequestEnabled) &&
            (identical(other.defaultDevice, defaultDevice) ||
                other.defaultDevice == defaultDevice) &&
            (identical(other.hifiAudioEnabled, hifiAudioEnabled) ||
                other.hifiAudioEnabled == hifiAudioEnabled) &&
            (identical(other.micDefaultOn, micDefaultOn) ||
                other.micDefaultOn == micDefaultOn) &&
            (identical(other.noiseCancellation, noiseCancellation) ||
                other.noiseCancellation == noiseCancellation) &&
            (identical(other.opusDtxEnabled, opusDtxEnabled) ||
                other.opusDtxEnabled == opusDtxEnabled) &&
            (identical(other.redundantCodingEnabled, redundantCodingEnabled) ||
                other.redundantCodingEnabled == redundantCodingEnabled) &&
            (identical(other.speakerDefaultOn, speakerDefaultOn) ||
                other.speakerDefaultOn == speakerDefaultOn));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessRequestEnabled,
    defaultDevice,
    hifiAudioEnabled,
    micDefaultOn,
    noiseCancellation,
    opusDtxEnabled,
    redundantCodingEnabled,
    speakerDefaultOn,
  );

  @override
  String toString() {
    return 'AudioSettingsResponse(accessRequestEnabled: $accessRequestEnabled, defaultDevice: $defaultDevice, hifiAudioEnabled: $hifiAudioEnabled, micDefaultOn: $micDefaultOn, noiseCancellation: $noiseCancellation, opusDtxEnabled: $opusDtxEnabled, redundantCodingEnabled: $redundantCodingEnabled, speakerDefaultOn: $speakerDefaultOn)';
  }
}

/// @nodoc
abstract mixin class $AudioSettingsResponseCopyWith<$Res> {
  factory $AudioSettingsResponseCopyWith(
    AudioSettingsResponse value,
    $Res Function(AudioSettingsResponse) _then,
  ) = _$AudioSettingsResponseCopyWithImpl;
  @useResult
  $Res call({
    bool accessRequestEnabled,
    AudioSettingsResponseDefaultDevice defaultDevice,
    bool hifiAudioEnabled,
    bool micDefaultOn,
    NoiseCancellationSettings? noiseCancellation,
    bool opusDtxEnabled,
    bool redundantCodingEnabled,
    bool speakerDefaultOn,
  });
}

/// @nodoc
class _$AudioSettingsResponseCopyWithImpl<$Res>
    implements $AudioSettingsResponseCopyWith<$Res> {
  _$AudioSettingsResponseCopyWithImpl(this._self, this._then);

  final AudioSettingsResponse _self;
  final $Res Function(AudioSettingsResponse) _then;

  /// Create a copy of AudioSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessRequestEnabled = null,
    Object? defaultDevice = null,
    Object? hifiAudioEnabled = null,
    Object? micDefaultOn = null,
    Object? noiseCancellation = freezed,
    Object? opusDtxEnabled = null,
    Object? redundantCodingEnabled = null,
    Object? speakerDefaultOn = null,
  }) {
    return _then(
      AudioSettingsResponse(
        accessRequestEnabled: null == accessRequestEnabled
            ? _self.accessRequestEnabled
            : accessRequestEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        defaultDevice: null == defaultDevice
            ? _self.defaultDevice
            : defaultDevice // ignore: cast_nullable_to_non_nullable
                  as AudioSettingsResponseDefaultDevice,
        hifiAudioEnabled: null == hifiAudioEnabled
            ? _self.hifiAudioEnabled
            : hifiAudioEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        micDefaultOn: null == micDefaultOn
            ? _self.micDefaultOn
            : micDefaultOn // ignore: cast_nullable_to_non_nullable
                  as bool,
        noiseCancellation: freezed == noiseCancellation
            ? _self.noiseCancellation
            : noiseCancellation // ignore: cast_nullable_to_non_nullable
                  as NoiseCancellationSettings?,
        opusDtxEnabled: null == opusDtxEnabled
            ? _self.opusDtxEnabled
            : opusDtxEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        redundantCodingEnabled: null == redundantCodingEnabled
            ? _self.redundantCodingEnabled
            : redundantCodingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        speakerDefaultOn: null == speakerDefaultOn
            ? _self.speakerDefaultOn
            : speakerDefaultOn // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
