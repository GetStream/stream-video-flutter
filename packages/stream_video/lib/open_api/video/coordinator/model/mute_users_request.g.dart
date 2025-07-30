// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_users_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MuteUsersRequest extends MuteUsersRequest {
  @override
  final bool? audio;
  @override
  final bool? muteAllUsers;
  @override
  final bool? screenshare;
  @override
  final bool? screenshareAudio;
  @override
  final BuiltList<String>? userIds;
  @override
  final bool? video;

  factory _$MuteUsersRequest(
          [void Function(MuteUsersRequestBuilder)? updates]) =>
      (MuteUsersRequestBuilder()..update(updates))._build();

  _$MuteUsersRequest._(
      {this.audio,
      this.muteAllUsers,
      this.screenshare,
      this.screenshareAudio,
      this.userIds,
      this.video})
      : super._();
  @override
  MuteUsersRequest rebuild(void Function(MuteUsersRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MuteUsersRequestBuilder toBuilder() =>
      MuteUsersRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MuteUsersRequest &&
        audio == other.audio &&
        muteAllUsers == other.muteAllUsers &&
        screenshare == other.screenshare &&
        screenshareAudio == other.screenshareAudio &&
        userIds == other.userIds &&
        video == other.video;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, audio.hashCode);
    _$hash = $jc(_$hash, muteAllUsers.hashCode);
    _$hash = $jc(_$hash, screenshare.hashCode);
    _$hash = $jc(_$hash, screenshareAudio.hashCode);
    _$hash = $jc(_$hash, userIds.hashCode);
    _$hash = $jc(_$hash, video.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MuteUsersRequest')
          ..add('audio', audio)
          ..add('muteAllUsers', muteAllUsers)
          ..add('screenshare', screenshare)
          ..add('screenshareAudio', screenshareAudio)
          ..add('userIds', userIds)
          ..add('video', video))
        .toString();
  }
}

class MuteUsersRequestBuilder
    implements Builder<MuteUsersRequest, MuteUsersRequestBuilder> {
  _$MuteUsersRequest? _$v;

  bool? _audio;
  bool? get audio => _$this._audio;
  set audio(bool? audio) => _$this._audio = audio;

  bool? _muteAllUsers;
  bool? get muteAllUsers => _$this._muteAllUsers;
  set muteAllUsers(bool? muteAllUsers) => _$this._muteAllUsers = muteAllUsers;

  bool? _screenshare;
  bool? get screenshare => _$this._screenshare;
  set screenshare(bool? screenshare) => _$this._screenshare = screenshare;

  bool? _screenshareAudio;
  bool? get screenshareAudio => _$this._screenshareAudio;
  set screenshareAudio(bool? screenshareAudio) =>
      _$this._screenshareAudio = screenshareAudio;

  ListBuilder<String>? _userIds;
  ListBuilder<String> get userIds => _$this._userIds ??= ListBuilder<String>();
  set userIds(ListBuilder<String>? userIds) => _$this._userIds = userIds;

  bool? _video;
  bool? get video => _$this._video;
  set video(bool? video) => _$this._video = video;

  MuteUsersRequestBuilder() {
    MuteUsersRequest._defaults(this);
  }

  MuteUsersRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _audio = $v.audio;
      _muteAllUsers = $v.muteAllUsers;
      _screenshare = $v.screenshare;
      _screenshareAudio = $v.screenshareAudio;
      _userIds = $v.userIds?.toBuilder();
      _video = $v.video;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MuteUsersRequest other) {
    _$v = other as _$MuteUsersRequest;
  }

  @override
  void update(void Function(MuteUsersRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MuteUsersRequest build() => _build();

  _$MuteUsersRequest _build() {
    _$MuteUsersRequest _$result;
    try {
      _$result = _$v ??
          _$MuteUsersRequest._(
            audio: audio,
            muteAllUsers: muteAllUsers,
            screenshare: screenshare,
            screenshareAudio: screenshareAudio,
            userIds: _userIds?.build(),
            video: video,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'userIds';
        _userIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MuteUsersRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
