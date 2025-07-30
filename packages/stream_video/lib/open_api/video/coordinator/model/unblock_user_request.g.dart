// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unblock_user_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnblockUserRequest extends UnblockUserRequest {
  @override
  final String userId;

  factory _$UnblockUserRequest(
          [void Function(UnblockUserRequestBuilder)? updates]) =>
      (UnblockUserRequestBuilder()..update(updates))._build();

  _$UnblockUserRequest._({required this.userId}) : super._();
  @override
  UnblockUserRequest rebuild(
          void Function(UnblockUserRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnblockUserRequestBuilder toBuilder() =>
      UnblockUserRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnblockUserRequest && userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnblockUserRequest')
          ..add('userId', userId))
        .toString();
  }
}

class UnblockUserRequestBuilder
    implements Builder<UnblockUserRequest, UnblockUserRequestBuilder> {
  _$UnblockUserRequest? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  UnblockUserRequestBuilder() {
    UnblockUserRequest._defaults(this);
  }

  UnblockUserRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnblockUserRequest other) {
    _$v = other as _$UnblockUserRequest;
  }

  @override
  void update(void Function(UnblockUserRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnblockUserRequest build() => _build();

  _$UnblockUserRequest _build() {
    final _$result = _$v ??
        _$UnblockUserRequest._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'UnblockUserRequest', 'userId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
