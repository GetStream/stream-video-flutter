// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLiveResponse extends GoLiveResponse {
  @override
  final CallResponse call;
  @override
  final String duration;

  factory _$GoLiveResponse([void Function(GoLiveResponseBuilder)? updates]) =>
      (GoLiveResponseBuilder()..update(updates))._build();

  _$GoLiveResponse._({required this.call, required this.duration}) : super._();
  @override
  GoLiveResponse rebuild(void Function(GoLiveResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLiveResponseBuilder toBuilder() => GoLiveResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLiveResponse &&
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
    return (newBuiltValueToStringHelper(r'GoLiveResponse')
          ..add('call', call)
          ..add('duration', duration))
        .toString();
  }
}

class GoLiveResponseBuilder
    implements Builder<GoLiveResponse, GoLiveResponseBuilder> {
  _$GoLiveResponse? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  GoLiveResponseBuilder() {
    GoLiveResponse._defaults(this);
  }

  GoLiveResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLiveResponse other) {
    _$v = other as _$GoLiveResponse;
  }

  @override
  void update(void Function(GoLiveResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLiveResponse build() => _build();

  _$GoLiveResponse _build() {
    _$GoLiveResponse _$result;
    try {
      _$result = _$v ??
          _$GoLiveResponse._(
            call: call.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'GoLiveResponse', 'duration'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GoLiveResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
