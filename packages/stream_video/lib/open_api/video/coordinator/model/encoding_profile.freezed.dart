// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encoding_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EncodingProfile {
  int? get avgSendKbps;
  String? get codec;
  String? get encoderImpl;
  int? get fpsP10;
  int? get fpsP50;
  int get getstatsSnapshots;
  bool? get hardwareEncode;
  String? get ladderType;
  bool? get powerEfficient;
  Map<String, int> get qualityLimitationDurationsS;
  Map<String, int> get qualityLimitationSamples;
  String? get resolution;
  int? get simulcastLayers;
  String get sourceFile;
  List<String> get svcModes;

  /// Create a copy of EncodingProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EncodingProfileCopyWith<EncodingProfile> get copyWith =>
      _$EncodingProfileCopyWithImpl<EncodingProfile>(
        this as EncodingProfile,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EncodingProfile &&
            (identical(other.avgSendKbps, avgSendKbps) ||
                other.avgSendKbps == avgSendKbps) &&
            (identical(other.codec, codec) || other.codec == codec) &&
            (identical(other.encoderImpl, encoderImpl) ||
                other.encoderImpl == encoderImpl) &&
            (identical(other.fpsP10, fpsP10) || other.fpsP10 == fpsP10) &&
            (identical(other.fpsP50, fpsP50) || other.fpsP50 == fpsP50) &&
            (identical(other.getstatsSnapshots, getstatsSnapshots) ||
                other.getstatsSnapshots == getstatsSnapshots) &&
            (identical(other.hardwareEncode, hardwareEncode) ||
                other.hardwareEncode == hardwareEncode) &&
            (identical(other.ladderType, ladderType) ||
                other.ladderType == ladderType) &&
            (identical(other.powerEfficient, powerEfficient) ||
                other.powerEfficient == powerEfficient) &&
            const DeepCollectionEquality().equals(
              other.qualityLimitationDurationsS,
              qualityLimitationDurationsS,
            ) &&
            const DeepCollectionEquality().equals(
              other.qualityLimitationSamples,
              qualityLimitationSamples,
            ) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.simulcastLayers, simulcastLayers) ||
                other.simulcastLayers == simulcastLayers) &&
            (identical(other.sourceFile, sourceFile) ||
                other.sourceFile == sourceFile) &&
            const DeepCollectionEquality().equals(other.svcModes, svcModes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    avgSendKbps,
    codec,
    encoderImpl,
    fpsP10,
    fpsP50,
    getstatsSnapshots,
    hardwareEncode,
    ladderType,
    powerEfficient,
    const DeepCollectionEquality().hash(qualityLimitationDurationsS),
    const DeepCollectionEquality().hash(qualityLimitationSamples),
    resolution,
    simulcastLayers,
    sourceFile,
    const DeepCollectionEquality().hash(svcModes),
  );

  @override
  String toString() {
    return 'EncodingProfile(avgSendKbps: $avgSendKbps, codec: $codec, encoderImpl: $encoderImpl, fpsP10: $fpsP10, fpsP50: $fpsP50, getstatsSnapshots: $getstatsSnapshots, hardwareEncode: $hardwareEncode, ladderType: $ladderType, powerEfficient: $powerEfficient, qualityLimitationDurationsS: $qualityLimitationDurationsS, qualityLimitationSamples: $qualityLimitationSamples, resolution: $resolution, simulcastLayers: $simulcastLayers, sourceFile: $sourceFile, svcModes: $svcModes)';
  }
}

/// @nodoc
abstract mixin class $EncodingProfileCopyWith<$Res> {
  factory $EncodingProfileCopyWith(
    EncodingProfile value,
    $Res Function(EncodingProfile) _then,
  ) = _$EncodingProfileCopyWithImpl;
  @useResult
  $Res call({
    int? avgSendKbps,
    String? codec,
    String? encoderImpl,
    int? fpsP10,
    int? fpsP50,
    int getstatsSnapshots,
    bool? hardwareEncode,
    String? ladderType,
    bool? powerEfficient,
    Map<String, int> qualityLimitationDurationsS,
    Map<String, int> qualityLimitationSamples,
    String? resolution,
    int? simulcastLayers,
    String sourceFile,
    List<String> svcModes,
  });
}

/// @nodoc
class _$EncodingProfileCopyWithImpl<$Res>
    implements $EncodingProfileCopyWith<$Res> {
  _$EncodingProfileCopyWithImpl(this._self, this._then);

  final EncodingProfile _self;
  final $Res Function(EncodingProfile) _then;

  /// Create a copy of EncodingProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgSendKbps = freezed,
    Object? codec = freezed,
    Object? encoderImpl = freezed,
    Object? fpsP10 = freezed,
    Object? fpsP50 = freezed,
    Object? getstatsSnapshots = null,
    Object? hardwareEncode = freezed,
    Object? ladderType = freezed,
    Object? powerEfficient = freezed,
    Object? qualityLimitationDurationsS = null,
    Object? qualityLimitationSamples = null,
    Object? resolution = freezed,
    Object? simulcastLayers = freezed,
    Object? sourceFile = null,
    Object? svcModes = null,
  }) {
    return _then(
      EncodingProfile(
        avgSendKbps: freezed == avgSendKbps
            ? _self.avgSendKbps
            : avgSendKbps // ignore: cast_nullable_to_non_nullable
                  as int?,
        codec: freezed == codec
            ? _self.codec
            : codec // ignore: cast_nullable_to_non_nullable
                  as String?,
        encoderImpl: freezed == encoderImpl
            ? _self.encoderImpl
            : encoderImpl // ignore: cast_nullable_to_non_nullable
                  as String?,
        fpsP10: freezed == fpsP10
            ? _self.fpsP10
            : fpsP10 // ignore: cast_nullable_to_non_nullable
                  as int?,
        fpsP50: freezed == fpsP50
            ? _self.fpsP50
            : fpsP50 // ignore: cast_nullable_to_non_nullable
                  as int?,
        getstatsSnapshots: null == getstatsSnapshots
            ? _self.getstatsSnapshots
            : getstatsSnapshots // ignore: cast_nullable_to_non_nullable
                  as int,
        hardwareEncode: freezed == hardwareEncode
            ? _self.hardwareEncode
            : hardwareEncode // ignore: cast_nullable_to_non_nullable
                  as bool?,
        ladderType: freezed == ladderType
            ? _self.ladderType
            : ladderType // ignore: cast_nullable_to_non_nullable
                  as String?,
        powerEfficient: freezed == powerEfficient
            ? _self.powerEfficient
            : powerEfficient // ignore: cast_nullable_to_non_nullable
                  as bool?,
        qualityLimitationDurationsS: null == qualityLimitationDurationsS
            ? _self.qualityLimitationDurationsS
            : qualityLimitationDurationsS // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        qualityLimitationSamples: null == qualityLimitationSamples
            ? _self.qualityLimitationSamples
            : qualityLimitationSamples // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        resolution: freezed == resolution
            ? _self.resolution
            : resolution // ignore: cast_nullable_to_non_nullable
                  as String?,
        simulcastLayers: freezed == simulcastLayers
            ? _self.simulcastLayers
            : simulcastLayers // ignore: cast_nullable_to_non_nullable
                  as int?,
        sourceFile: null == sourceFile
            ? _self.sourceFile
            : sourceFile // ignore: cast_nullable_to_non_nullable
                  as String,
        svcModes: null == svcModes
            ? _self.svcModes
            : svcModes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
