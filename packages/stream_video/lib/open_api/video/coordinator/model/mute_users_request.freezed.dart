// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mute_users_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MuteUsersRequest {
  bool? get audio;
  bool? get muteAllUsers;
  bool? get screenshare;
  bool? get screenshareAudio;
  List<String>? get userIds;
  bool? get video;

  /// Create a copy of MuteUsersRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MuteUsersRequestCopyWith<MuteUsersRequest> get copyWith =>
      _$MuteUsersRequestCopyWithImpl<MuteUsersRequest>(
        this as MuteUsersRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MuteUsersRequest &&
            (identical(other.audio, audio) || other.audio == audio) &&
            (identical(other.muteAllUsers, muteAllUsers) ||
                other.muteAllUsers == muteAllUsers) &&
            (identical(other.screenshare, screenshare) ||
                other.screenshare == screenshare) &&
            (identical(other.screenshareAudio, screenshareAudio) ||
                other.screenshareAudio == screenshareAudio) &&
            const DeepCollectionEquality().equals(other.userIds, userIds) &&
            (identical(other.video, video) || other.video == video));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    audio,
    muteAllUsers,
    screenshare,
    screenshareAudio,
    const DeepCollectionEquality().hash(userIds),
    video,
  );

  @override
  String toString() {
    return 'MuteUsersRequest(audio: $audio, muteAllUsers: $muteAllUsers, screenshare: $screenshare, screenshareAudio: $screenshareAudio, userIds: $userIds, video: $video)';
  }
}

/// @nodoc
abstract mixin class $MuteUsersRequestCopyWith<$Res> {
  factory $MuteUsersRequestCopyWith(
    MuteUsersRequest value,
    $Res Function(MuteUsersRequest) _then,
  ) = _$MuteUsersRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? audio,
    bool? muteAllUsers,
    bool? screenshare,
    bool? screenshareAudio,
    List<String>? userIds,
    bool? video,
  });
}

/// @nodoc
class _$MuteUsersRequestCopyWithImpl<$Res>
    implements $MuteUsersRequestCopyWith<$Res> {
  _$MuteUsersRequestCopyWithImpl(this._self, this._then);

  final MuteUsersRequest _self;
  final $Res Function(MuteUsersRequest) _then;

  /// Create a copy of MuteUsersRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audio = freezed,
    Object? muteAllUsers = freezed,
    Object? screenshare = freezed,
    Object? screenshareAudio = freezed,
    Object? userIds = freezed,
    Object? video = freezed,
  }) {
    return _then(
      MuteUsersRequest(
        audio: freezed == audio
            ? _self.audio
            : audio // ignore: cast_nullable_to_non_nullable
                  as bool?,
        muteAllUsers: freezed == muteAllUsers
            ? _self.muteAllUsers
            : muteAllUsers // ignore: cast_nullable_to_non_nullable
                  as bool?,
        screenshare: freezed == screenshare
            ? _self.screenshare
            : screenshare // ignore: cast_nullable_to_non_nullable
                  as bool?,
        screenshareAudio: freezed == screenshareAudio
            ? _self.screenshareAudio
            : screenshareAudio // ignore: cast_nullable_to_non_nullable
                  as bool?,
        userIds: freezed == userIds
            ? _self.userIds
            : userIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        video: freezed == video
            ? _self.video
            : video // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
