// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PinResponse extends PinResponse {
  @override
  final String duration;

  factory _$PinResponse([void Function(PinResponseBuilder)? updates]) =>
      (PinResponseBuilder()..update(updates))._build();

  _$PinResponse._({required this.duration}) : super._();
  @override
  PinResponse rebuild(void Function(PinResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PinResponseBuilder toBuilder() => PinResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PinResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'PinResponse')
          ..add('duration', duration))
        .toString();
  }
}

class PinResponseBuilder implements Builder<PinResponse, PinResponseBuilder> {
  _$PinResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  PinResponseBuilder() {
    PinResponse._defaults(this);
  }

  PinResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PinResponse other) {
    _$v = other as _$PinResponse;
  }

  @override
  void update(void Function(PinResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PinResponse build() => _build();

  _$PinResponse _build() {
    final _$result = _$v ??
        _$PinResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'PinResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
