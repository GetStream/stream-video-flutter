// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RejectCallResponse extends RejectCallResponse {
  @override
  final String duration;

  factory _$RejectCallResponse(
          [void Function(RejectCallResponseBuilder)? updates]) =>
      (RejectCallResponseBuilder()..update(updates))._build();

  _$RejectCallResponse._({required this.duration}) : super._();
  @override
  RejectCallResponse rebuild(
          void Function(RejectCallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RejectCallResponseBuilder toBuilder() =>
      RejectCallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RejectCallResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'RejectCallResponse')
          ..add('duration', duration))
        .toString();
  }
}

class RejectCallResponseBuilder
    implements Builder<RejectCallResponse, RejectCallResponseBuilder> {
  _$RejectCallResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  RejectCallResponseBuilder() {
    RejectCallResponse._defaults(this);
  }

  RejectCallResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RejectCallResponse other) {
    _$v = other as _$RejectCallResponse;
  }

  @override
  void update(void Function(RejectCallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RejectCallResponse build() => _build();

  _$RejectCallResponse _build() {
    final _$result = _$v ??
        _$RejectCallResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'RejectCallResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
