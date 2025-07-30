// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_users_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MuteUsersResponse extends MuteUsersResponse {
  @override
  final String duration;

  factory _$MuteUsersResponse(
          [void Function(MuteUsersResponseBuilder)? updates]) =>
      (MuteUsersResponseBuilder()..update(updates))._build();

  _$MuteUsersResponse._({required this.duration}) : super._();
  @override
  MuteUsersResponse rebuild(void Function(MuteUsersResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MuteUsersResponseBuilder toBuilder() =>
      MuteUsersResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MuteUsersResponse && duration == other.duration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MuteUsersResponse')
          ..add('duration', duration))
        .toString();
  }
}

class MuteUsersResponseBuilder
    implements Builder<MuteUsersResponse, MuteUsersResponseBuilder> {
  _$MuteUsersResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  MuteUsersResponseBuilder() {
    MuteUsersResponse._defaults(this);
  }

  MuteUsersResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MuteUsersResponse other) {
    _$v = other as _$MuteUsersResponse;
  }

  @override
  void update(void Function(MuteUsersResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MuteUsersResponse build() => _build();

  _$MuteUsersResponse _build() {
    final _$result = _$v ??
        _$MuteUsersResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'MuteUsersResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
