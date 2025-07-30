// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_closed_captions_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopClosedCaptionsResponse extends StopClosedCaptionsResponse {
  @override
  final String duration;

  factory _$StopClosedCaptionsResponse(
          [void Function(StopClosedCaptionsResponseBuilder)? updates]) =>
      (StopClosedCaptionsResponseBuilder()..update(updates))._build();

  _$StopClosedCaptionsResponse._({required this.duration}) : super._();
  @override
  StopClosedCaptionsResponse rebuild(
          void Function(StopClosedCaptionsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopClosedCaptionsResponseBuilder toBuilder() =>
      StopClosedCaptionsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopClosedCaptionsResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StopClosedCaptionsResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StopClosedCaptionsResponseBuilder
    implements
        Builder<StopClosedCaptionsResponse, StopClosedCaptionsResponseBuilder> {
  _$StopClosedCaptionsResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StopClosedCaptionsResponseBuilder() {
    StopClosedCaptionsResponse._defaults(this);
  }

  StopClosedCaptionsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopClosedCaptionsResponse other) {
    _$v = other as _$StopClosedCaptionsResponse;
  }

  @override
  void update(void Function(StopClosedCaptionsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopClosedCaptionsResponse build() => _build();

  _$StopClosedCaptionsResponse _build() {
    final _$result = _$v ??
        _$StopClosedCaptionsResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StopClosedCaptionsResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
