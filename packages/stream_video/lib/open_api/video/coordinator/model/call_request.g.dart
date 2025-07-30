// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRequest extends CallRequest {
  @override
  final String? channelCid;
  @override
  final BuiltMap<String, JsonObject?>? custom;
  @override
  final BuiltList<MemberRequest>? members;
  @override
  final CallSettingsRequest? settingsOverride;
  @override
  final DateTime? startsAt;
  @override
  final String? team;
  @override
  final bool? video;

  factory _$CallRequest([void Function(CallRequestBuilder)? updates]) =>
      (CallRequestBuilder()..update(updates))._build();

  _$CallRequest._(
      {this.channelCid,
      this.custom,
      this.members,
      this.settingsOverride,
      this.startsAt,
      this.team,
      this.video})
      : super._();
  @override
  CallRequest rebuild(void Function(CallRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRequestBuilder toBuilder() => CallRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRequest &&
        channelCid == other.channelCid &&
        custom == other.custom &&
        members == other.members &&
        settingsOverride == other.settingsOverride &&
        startsAt == other.startsAt &&
        team == other.team &&
        video == other.video;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelCid.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, settingsOverride.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, team.hashCode);
    _$hash = $jc(_$hash, video.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallRequest')
          ..add('channelCid', channelCid)
          ..add('custom', custom)
          ..add('members', members)
          ..add('settingsOverride', settingsOverride)
          ..add('startsAt', startsAt)
          ..add('team', team)
          ..add('video', video))
        .toString();
  }
}

class CallRequestBuilder implements Builder<CallRequest, CallRequestBuilder> {
  _$CallRequest? _$v;

  String? _channelCid;
  String? get channelCid => _$this._channelCid;
  set channelCid(String? channelCid) => _$this._channelCid = channelCid;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  ListBuilder<MemberRequest>? _members;
  ListBuilder<MemberRequest> get members =>
      _$this._members ??= ListBuilder<MemberRequest>();
  set members(ListBuilder<MemberRequest>? members) => _$this._members = members;

  CallSettingsRequestBuilder? _settingsOverride;
  CallSettingsRequestBuilder get settingsOverride =>
      _$this._settingsOverride ??= CallSettingsRequestBuilder();
  set settingsOverride(CallSettingsRequestBuilder? settingsOverride) =>
      _$this._settingsOverride = settingsOverride;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  String? _team;
  String? get team => _$this._team;
  set team(String? team) => _$this._team = team;

  bool? _video;
  bool? get video => _$this._video;
  set video(bool? video) => _$this._video = video;

  CallRequestBuilder() {
    CallRequest._defaults(this);
  }

  CallRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelCid = $v.channelCid;
      _custom = $v.custom?.toBuilder();
      _members = $v.members?.toBuilder();
      _settingsOverride = $v.settingsOverride?.toBuilder();
      _startsAt = $v.startsAt;
      _team = $v.team;
      _video = $v.video;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallRequest other) {
    _$v = other as _$CallRequest;
  }

  @override
  void update(void Function(CallRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRequest build() => _build();

  _$CallRequest _build() {
    _$CallRequest _$result;
    try {
      _$result = _$v ??
          _$CallRequest._(
            channelCid: channelCid,
            custom: _custom?.build(),
            members: _members?.build(),
            settingsOverride: _settingsOverride?.build(),
            startsAt: startsAt,
            team: team,
            video: video,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        _custom?.build();
        _$failedField = 'members';
        _members?.build();
        _$failedField = 'settingsOverride';
        _settingsOverride?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
