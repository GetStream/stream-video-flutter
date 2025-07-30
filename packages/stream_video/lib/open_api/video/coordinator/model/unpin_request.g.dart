// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unpin_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnpinRequest extends UnpinRequest {
  @override
  final String sessionId;
  @override
  final String userId;

  factory _$UnpinRequest([void Function(UnpinRequestBuilder)? updates]) =>
      (UnpinRequestBuilder()..update(updates))._build();

  _$UnpinRequest._({required this.sessionId, required this.userId}) : super._();
  @override
  UnpinRequest rebuild(void Function(UnpinRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnpinRequestBuilder toBuilder() => UnpinRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnpinRequest &&
        sessionId == other.sessionId &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnpinRequest')
          ..add('sessionId', sessionId)
          ..add('userId', userId))
        .toString();
  }
}

class UnpinRequestBuilder
    implements Builder<UnpinRequest, UnpinRequestBuilder> {
  _$UnpinRequest? _$v;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  UnpinRequestBuilder() {
    UnpinRequest._defaults(this);
  }

  UnpinRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionId = $v.sessionId;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnpinRequest other) {
    _$v = other as _$UnpinRequest;
  }

  @override
  void update(void Function(UnpinRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnpinRequest build() => _build();

  _$UnpinRequest _build() {
    final _$result = _$v ??
        _$UnpinRequest._(
          sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId, r'UnpinRequest', 'sessionId'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'UnpinRequest', 'userId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
