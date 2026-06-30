// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'published_track_flags.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublishedTrackFlags {
  bool get audio;
  bool get screenshare;
  bool get screenshareAudio;
  bool get video;

  /// Create a copy of PublishedTrackFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PublishedTrackFlagsCopyWith<PublishedTrackFlags> get copyWith =>
      _$PublishedTrackFlagsCopyWithImpl<PublishedTrackFlags>(
        this as PublishedTrackFlags,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PublishedTrackFlags &&
            (identical(other.audio, audio) || other.audio == audio) &&
            (identical(other.screenshare, screenshare) ||
                other.screenshare == screenshare) &&
            (identical(other.screenshareAudio, screenshareAudio) ||
                other.screenshareAudio == screenshareAudio) &&
            (identical(other.video, video) || other.video == video));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, audio, screenshare, screenshareAudio, video);

  @override
  String toString() {
    return 'PublishedTrackFlags(audio: $audio, screenshare: $screenshare, screenshareAudio: $screenshareAudio, video: $video)';
  }
}

/// @nodoc
abstract mixin class $PublishedTrackFlagsCopyWith<$Res> {
  factory $PublishedTrackFlagsCopyWith(
    PublishedTrackFlags value,
    $Res Function(PublishedTrackFlags) _then,
  ) = _$PublishedTrackFlagsCopyWithImpl;
  @useResult
  $Res call({bool audio, bool screenshare, bool screenshareAudio, bool video});
}

/// @nodoc
class _$PublishedTrackFlagsCopyWithImpl<$Res>
    implements $PublishedTrackFlagsCopyWith<$Res> {
  _$PublishedTrackFlagsCopyWithImpl(this._self, this._then);

  final PublishedTrackFlags _self;
  final $Res Function(PublishedTrackFlags) _then;

  /// Create a copy of PublishedTrackFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audio = null,
    Object? screenshare = null,
    Object? screenshareAudio = null,
    Object? video = null,
  }) {
    return _then(
      PublishedTrackFlags(
        audio: null == audio
            ? _self.audio
            : audio // ignore: cast_nullable_to_non_nullable
                  as bool,
        screenshare: null == screenshare
            ? _self.screenshare
            : screenshare // ignore: cast_nullable_to_non_nullable
                  as bool,
        screenshareAudio: null == screenshareAudio
            ? _self.screenshareAudio
            : screenshareAudio // ignore: cast_nullable_to_non_nullable
                  as bool,
        video: null == video
            ? _self.video
            : video // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
