// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_guest_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateGuestRequest extends CreateGuestRequest {
  @override
  final UserRequest user;

  factory _$CreateGuestRequest(
          [void Function(CreateGuestRequestBuilder)? updates]) =>
      (CreateGuestRequestBuilder()..update(updates))._build();

  _$CreateGuestRequest._({required this.user}) : super._();
  @override
  CreateGuestRequest rebuild(
          void Function(CreateGuestRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateGuestRequestBuilder toBuilder() =>
      CreateGuestRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateGuestRequest && user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateGuestRequest')
          ..add('user', user))
        .toString();
  }
}

class CreateGuestRequestBuilder
    implements Builder<CreateGuestRequest, CreateGuestRequestBuilder> {
  _$CreateGuestRequest? _$v;

  UserRequestBuilder? _user;
  UserRequestBuilder get user => _$this._user ??= UserRequestBuilder();
  set user(UserRequestBuilder? user) => _$this._user = user;

  CreateGuestRequestBuilder() {
    CreateGuestRequest._defaults(this);
  }

  CreateGuestRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateGuestRequest other) {
    _$v = other as _$CreateGuestRequest;
  }

  @override
  void update(void Function(CreateGuestRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateGuestRequest build() => _build();

  _$CreateGuestRequest _build() {
    _$CreateGuestRequest _$result;
    try {
      _$result = _$v ??
          _$CreateGuestRequest._(
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateGuestRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
