// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioSettingsRequest {
  bool? get accessRequestEnabled;
  AudioSettingsRequestDefaultDevice get defaultDevice;
  bool? get hifiAudioEnabled;
  bool? get micDefaultOn;
  NoiseCancellationSettings? get noiseCancellation;
  bool? get opusDtxEnabled;
  bool? get redundantCodingEnabled;
  bool? get speakerDefaultOn;

  /// Create a copy of AudioSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AudioSettingsRequestCopyWith<AudioSettingsRequest> get copyWith =>
      _$AudioSettingsRequestCopyWithImpl<AudioSettingsRequest>(
        this as AudioSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AudioSettingsRequest &&
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
    return 'AudioSettingsRequest(accessRequestEnabled: $accessRequestEnabled, defaultDevice: $defaultDevice, hifiAudioEnabled: $hifiAudioEnabled, micDefaultOn: $micDefaultOn, noiseCancellation: $noiseCancellation, opusDtxEnabled: $opusDtxEnabled, redundantCodingEnabled: $redundantCodingEnabled, speakerDefaultOn: $speakerDefaultOn)';
  }
}

/// @nodoc
abstract mixin class $AudioSettingsRequestCopyWith<$Res> {
  factory $AudioSettingsRequestCopyWith(
    AudioSettingsRequest value,
    $Res Function(AudioSettingsRequest) _then,
  ) = _$AudioSettingsRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? accessRequestEnabled,
    AudioSettingsRequestDefaultDevice defaultDevice,
    bool? hifiAudioEnabled,
    bool? micDefaultOn,
    NoiseCancellationSettings? noiseCancellation,
    bool? opusDtxEnabled,
    bool? redundantCodingEnabled,
    bool? speakerDefaultOn,
  });
}

/// @nodoc
class _$AudioSettingsRequestCopyWithImpl<$Res>
    implements $AudioSettingsRequestCopyWith<$Res> {
  _$AudioSettingsRequestCopyWithImpl(this._self, this._then);

  final AudioSettingsRequest _self;
  final $Res Function(AudioSettingsRequest) _then;

  /// Create a copy of AudioSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessRequestEnabled = freezed,
    Object? defaultDevice = null,
    Object? hifiAudioEnabled = freezed,
    Object? micDefaultOn = freezed,
    Object? noiseCancellation = freezed,
    Object? opusDtxEnabled = freezed,
    Object? redundantCodingEnabled = freezed,
    Object? speakerDefaultOn = freezed,
  }) {
    return _then(
      AudioSettingsRequest(
        accessRequestEnabled: freezed == accessRequestEnabled
            ? _self.accessRequestEnabled
            : accessRequestEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        defaultDevice: null == defaultDevice
            ? _self.defaultDevice
            : defaultDevice // ignore: cast_nullable_to_non_nullable
                  as AudioSettingsRequestDefaultDevice,
        hifiAudioEnabled: freezed == hifiAudioEnabled
            ? _self.hifiAudioEnabled
            : hifiAudioEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        micDefaultOn: freezed == micDefaultOn
            ? _self.micDefaultOn
            : micDefaultOn // ignore: cast_nullable_to_non_nullable
                  as bool?,
        noiseCancellation: freezed == noiseCancellation
            ? _self.noiseCancellation
            : noiseCancellation // ignore: cast_nullable_to_non_nullable
                  as NoiseCancellationSettings?,
        opusDtxEnabled: freezed == opusDtxEnabled
            ? _self.opusDtxEnabled
            : opusDtxEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        redundantCodingEnabled: freezed == redundantCodingEnabled
            ? _self.redundantCodingEnabled
            : redundantCodingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        speakerDefaultOn: freezed == speakerDefaultOn
            ? _self.speakerDefaultOn
            : speakerDefaultOn // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
