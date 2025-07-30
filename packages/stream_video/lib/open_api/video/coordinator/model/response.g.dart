// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Response extends Response {
  @override
  final String duration;

  factory _$Response([void Function(ResponseBuilder)? updates]) =>
      (ResponseBuilder()..update(updates))._build();

  _$Response._({required this.duration}) : super._();
  @override
  Response rebuild(void Function(ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResponseBuilder toBuilder() => ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Response && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'Response')..add('duration', duration))
        .toString();
  }
}

class ResponseBuilder implements Builder<Response, ResponseBuilder> {
  _$Response? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ResponseBuilder() {
    Response._defaults(this);
  }

  ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Response other) {
    _$v = other as _$Response;
  }

  @override
  void update(void Function(ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Response build() => _build();

  _$Response _build() {
    final _$result = _$v ??
        _$Response._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'Response', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
