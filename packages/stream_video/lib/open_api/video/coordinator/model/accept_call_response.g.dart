// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AcceptCallResponse extends AcceptCallResponse {
  @override
  final String duration;

  factory _$AcceptCallResponse(
          [void Function(AcceptCallResponseBuilder)? updates]) =>
      (AcceptCallResponseBuilder()..update(updates))._build();

  _$AcceptCallResponse._({required this.duration}) : super._();
  @override
  AcceptCallResponse rebuild(
          void Function(AcceptCallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AcceptCallResponseBuilder toBuilder() =>
      AcceptCallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AcceptCallResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'AcceptCallResponse')
          ..add('duration', duration))
        .toString();
  }
}

class AcceptCallResponseBuilder
    implements Builder<AcceptCallResponse, AcceptCallResponseBuilder> {
  _$AcceptCallResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  AcceptCallResponseBuilder() {
    AcceptCallResponse._defaults(this);
  }

  AcceptCallResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AcceptCallResponse other) {
    _$v = other as _$AcceptCallResponse;
  }

  @override
  void update(void Function(AcceptCallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AcceptCallResponse build() => _build();

  _$AcceptCallResponse _build() {
    final _$result = _$v ??
        _$AcceptCallResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'AcceptCallResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
