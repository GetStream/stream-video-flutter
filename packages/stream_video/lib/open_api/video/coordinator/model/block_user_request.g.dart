// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_user_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockUserRequest extends BlockUserRequest {
  @override
  final String userId;

  factory _$BlockUserRequest(
          [void Function(BlockUserRequestBuilder)? updates]) =>
      (BlockUserRequestBuilder()..update(updates))._build();

  _$BlockUserRequest._({required this.userId}) : super._();
  @override
  BlockUserRequest rebuild(void Function(BlockUserRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockUserRequestBuilder toBuilder() =>
      BlockUserRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockUserRequest && userId == other.userId;
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
    return (newBuiltValueToStringHelper(r'BlockUserRequest')
          ..add('userId', userId))
        .toString();
  }
}

class BlockUserRequestBuilder
    implements Builder<BlockUserRequest, BlockUserRequestBuilder> {
  _$BlockUserRequest? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  BlockUserRequestBuilder() {
    BlockUserRequest._defaults(this);
  }

  BlockUserRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockUserRequest other) {
    _$v = other as _$BlockUserRequest;
  }

  @override
  void update(void Function(BlockUserRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockUserRequest build() => _build();

  _$BlockUserRequest _build() {
    final _$result = _$v ??
        _$BlockUserRequest._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'BlockUserRequest', 'userId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
