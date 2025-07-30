// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_closed_captions_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartClosedCaptionsResponse extends StartClosedCaptionsResponse {
  @override
  final String duration;

  factory _$StartClosedCaptionsResponse(
          [void Function(StartClosedCaptionsResponseBuilder)? updates]) =>
      (StartClosedCaptionsResponseBuilder()..update(updates))._build();

  _$StartClosedCaptionsResponse._({required this.duration}) : super._();
  @override
  StartClosedCaptionsResponse rebuild(
          void Function(StartClosedCaptionsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartClosedCaptionsResponseBuilder toBuilder() =>
      StartClosedCaptionsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartClosedCaptionsResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StartClosedCaptionsResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StartClosedCaptionsResponseBuilder
    implements
        Builder<StartClosedCaptionsResponse,
            StartClosedCaptionsResponseBuilder> {
  _$StartClosedCaptionsResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StartClosedCaptionsResponseBuilder() {
    StartClosedCaptionsResponse._defaults(this);
  }

  StartClosedCaptionsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartClosedCaptionsResponse other) {
    _$v = other as _$StartClosedCaptionsResponse;
  }

  @override
  void update(void Function(StartClosedCaptionsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartClosedCaptionsResponse build() => _build();

  _$StartClosedCaptionsResponse _build() {
    final _$result = _$v ??
        _$StartClosedCaptionsResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StartClosedCaptionsResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
