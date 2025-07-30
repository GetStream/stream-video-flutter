// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EndCallResponse extends EndCallResponse {
  @override
  final String duration;

  factory _$EndCallResponse([void Function(EndCallResponseBuilder)? updates]) =>
      (EndCallResponseBuilder()..update(updates))._build();

  _$EndCallResponse._({required this.duration}) : super._();
  @override
  EndCallResponse rebuild(void Function(EndCallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EndCallResponseBuilder toBuilder() => EndCallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EndCallResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'EndCallResponse')
          ..add('duration', duration))
        .toString();
  }
}

class EndCallResponseBuilder
    implements Builder<EndCallResponse, EndCallResponseBuilder> {
  _$EndCallResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  EndCallResponseBuilder() {
    EndCallResponse._defaults(this);
  }

  EndCallResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EndCallResponse other) {
    _$v = other as _$EndCallResponse;
  }

  @override
  void update(void Function(EndCallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EndCallResponse build() => _build();

  _$EndCallResponse _build() {
    final _$result = _$v ??
        _$EndCallResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'EndCallResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
