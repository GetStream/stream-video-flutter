// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_guest_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateGuestResponse extends CreateGuestResponse {
  @override
  final String accessToken;
  @override
  final String duration;
  @override
  final UserResponse user;

  factory _$CreateGuestResponse(
          [void Function(CreateGuestResponseBuilder)? updates]) =>
      (CreateGuestResponseBuilder()..update(updates))._build();

  _$CreateGuestResponse._(
      {required this.accessToken, required this.duration, required this.user})
      : super._();
  @override
  CreateGuestResponse rebuild(
          void Function(CreateGuestResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateGuestResponseBuilder toBuilder() =>
      CreateGuestResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateGuestResponse &&
        accessToken == other.accessToken &&
        duration == other.duration &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateGuestResponse')
          ..add('accessToken', accessToken)
          ..add('duration', duration)
          ..add('user', user))
        .toString();
  }
}

class CreateGuestResponseBuilder
    implements Builder<CreateGuestResponse, CreateGuestResponseBuilder> {
  _$CreateGuestResponse? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  CreateGuestResponseBuilder() {
    CreateGuestResponse._defaults(this);
  }

  CreateGuestResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _duration = $v.duration;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateGuestResponse other) {
    _$v = other as _$CreateGuestResponse;
  }

  @override
  void update(void Function(CreateGuestResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateGuestResponse build() => _build();

  _$CreateGuestResponse _build() {
    _$CreateGuestResponse _$result;
    try {
      _$result = _$v ??
          _$CreateGuestResponse._(
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'CreateGuestResponse', 'accessToken'),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'CreateGuestResponse', 'duration'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateGuestResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
