// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PinRequest extends PinRequest {
  @override
  final String sessionId;
  @override
  final String userId;

  factory _$PinRequest([void Function(PinRequestBuilder)? updates]) =>
      (PinRequestBuilder()..update(updates))._build();

  _$PinRequest._({required this.sessionId, required this.userId}) : super._();
  @override
  PinRequest rebuild(void Function(PinRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PinRequestBuilder toBuilder() => PinRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PinRequest &&
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
    return (newBuiltValueToStringHelper(r'PinRequest')
          ..add('sessionId', sessionId)
          ..add('userId', userId))
        .toString();
  }
}

class PinRequestBuilder implements Builder<PinRequest, PinRequestBuilder> {
  _$PinRequest? _$v;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  PinRequestBuilder() {
    PinRequest._defaults(this);
  }

  PinRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionId = $v.sessionId;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PinRequest other) {
    _$v = other as _$PinRequest;
  }

  @override
  void update(void Function(PinRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PinRequest build() => _build();

  _$PinRequest _build() {
    final _$result = _$v ??
        _$PinRequest._(
          sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId, r'PinRequest', 'sessionId'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'PinRequest', 'userId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
