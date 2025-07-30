// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_live_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopLiveResponse extends StopLiveResponse {
  @override
  final CallResponse call;
  @override
  final String duration;

  factory _$StopLiveResponse(
          [void Function(StopLiveResponseBuilder)? updates]) =>
      (StopLiveResponseBuilder()..update(updates))._build();

  _$StopLiveResponse._({required this.call, required this.duration})
      : super._();
  @override
  StopLiveResponse rebuild(void Function(StopLiveResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopLiveResponseBuilder toBuilder() =>
      StopLiveResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopLiveResponse &&
        call == other.call &&
        duration == other.duration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StopLiveResponse')
          ..add('call', call)
          ..add('duration', duration))
        .toString();
  }
}

class StopLiveResponseBuilder
    implements Builder<StopLiveResponse, StopLiveResponseBuilder> {
  _$StopLiveResponse? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StopLiveResponseBuilder() {
    StopLiveResponse._defaults(this);
  }

  StopLiveResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopLiveResponse other) {
    _$v = other as _$StopLiveResponse;
  }

  @override
  void update(void Function(StopLiveResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopLiveResponse build() => _build();

  _$StopLiveResponse _build() {
    _$StopLiveResponse _$result;
    try {
      _$result = _$v ??
          _$StopLiveResponse._(
            call: call.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'StopLiveResponse', 'duration'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StopLiveResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
