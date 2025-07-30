// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_call_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RejectCallRequest extends RejectCallRequest {
  @override
  final String? reason;

  factory _$RejectCallRequest(
          [void Function(RejectCallRequestBuilder)? updates]) =>
      (RejectCallRequestBuilder()..update(updates))._build();

  _$RejectCallRequest._({this.reason}) : super._();
  @override
  RejectCallRequest rebuild(void Function(RejectCallRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RejectCallRequestBuilder toBuilder() =>
      RejectCallRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RejectCallRequest && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RejectCallRequest')
          ..add('reason', reason))
        .toString();
  }
}

class RejectCallRequestBuilder
    implements Builder<RejectCallRequest, RejectCallRequestBuilder> {
  _$RejectCallRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  RejectCallRequestBuilder() {
    RejectCallRequest._defaults(this);
  }

  RejectCallRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RejectCallRequest other) {
    _$v = other as _$RejectCallRequest;
  }

  @override
  void update(void Function(RejectCallRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RejectCallRequest build() => _build();

  _$RejectCallRequest _build() {
    final _$result = _$v ??
        _$RejectCallRequest._(
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
