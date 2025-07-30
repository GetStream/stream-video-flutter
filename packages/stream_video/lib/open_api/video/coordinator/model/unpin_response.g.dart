// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unpin_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnpinResponse extends UnpinResponse {
  @override
  final String duration;

  factory _$UnpinResponse([void Function(UnpinResponseBuilder)? updates]) =>
      (UnpinResponseBuilder()..update(updates))._build();

  _$UnpinResponse._({required this.duration}) : super._();
  @override
  UnpinResponse rebuild(void Function(UnpinResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnpinResponseBuilder toBuilder() => UnpinResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnpinResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'UnpinResponse')
          ..add('duration', duration))
        .toString();
  }
}

class UnpinResponseBuilder
    implements Builder<UnpinResponse, UnpinResponseBuilder> {
  _$UnpinResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  UnpinResponseBuilder() {
    UnpinResponse._defaults(this);
  }

  UnpinResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnpinResponse other) {
    _$v = other as _$UnpinResponse;
  }

  @override
  void update(void Function(UnpinResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnpinResponse build() => _build();

  _$UnpinResponse _build() {
    final _$result = _$v ??
        _$UnpinResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'UnpinResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
