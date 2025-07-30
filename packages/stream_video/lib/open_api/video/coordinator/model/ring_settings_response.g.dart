// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ring_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RingSettingsResponse extends RingSettingsResponse {
  @override
  final int autoCancelTimeoutMs;
  @override
  final int incomingCallTimeoutMs;
  @override
  final int missedCallTimeoutMs;

  factory _$RingSettingsResponse(
          [void Function(RingSettingsResponseBuilder)? updates]) =>
      (RingSettingsResponseBuilder()..update(updates))._build();

  _$RingSettingsResponse._(
      {required this.autoCancelTimeoutMs,
      required this.incomingCallTimeoutMs,
      required this.missedCallTimeoutMs})
      : super._();
  @override
  RingSettingsResponse rebuild(
          void Function(RingSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RingSettingsResponseBuilder toBuilder() =>
      RingSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RingSettingsResponse &&
        autoCancelTimeoutMs == other.autoCancelTimeoutMs &&
        incomingCallTimeoutMs == other.incomingCallTimeoutMs &&
        missedCallTimeoutMs == other.missedCallTimeoutMs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, autoCancelTimeoutMs.hashCode);
    _$hash = $jc(_$hash, incomingCallTimeoutMs.hashCode);
    _$hash = $jc(_$hash, missedCallTimeoutMs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RingSettingsResponse')
          ..add('autoCancelTimeoutMs', autoCancelTimeoutMs)
          ..add('incomingCallTimeoutMs', incomingCallTimeoutMs)
          ..add('missedCallTimeoutMs', missedCallTimeoutMs))
        .toString();
  }
}

class RingSettingsResponseBuilder
    implements Builder<RingSettingsResponse, RingSettingsResponseBuilder> {
  _$RingSettingsResponse? _$v;

  int? _autoCancelTimeoutMs;
  int? get autoCancelTimeoutMs => _$this._autoCancelTimeoutMs;
  set autoCancelTimeoutMs(int? autoCancelTimeoutMs) =>
      _$this._autoCancelTimeoutMs = autoCancelTimeoutMs;

  int? _incomingCallTimeoutMs;
  int? get incomingCallTimeoutMs => _$this._incomingCallTimeoutMs;
  set incomingCallTimeoutMs(int? incomingCallTimeoutMs) =>
      _$this._incomingCallTimeoutMs = incomingCallTimeoutMs;

  int? _missedCallTimeoutMs;
  int? get missedCallTimeoutMs => _$this._missedCallTimeoutMs;
  set missedCallTimeoutMs(int? missedCallTimeoutMs) =>
      _$this._missedCallTimeoutMs = missedCallTimeoutMs;

  RingSettingsResponseBuilder() {
    RingSettingsResponse._defaults(this);
  }

  RingSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _autoCancelTimeoutMs = $v.autoCancelTimeoutMs;
      _incomingCallTimeoutMs = $v.incomingCallTimeoutMs;
      _missedCallTimeoutMs = $v.missedCallTimeoutMs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RingSettingsResponse other) {
    _$v = other as _$RingSettingsResponse;
  }

  @override
  void update(void Function(RingSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RingSettingsResponse build() => _build();

  _$RingSettingsResponse _build() {
    final _$result = _$v ??
        _$RingSettingsResponse._(
          autoCancelTimeoutMs: BuiltValueNullFieldError.checkNotNull(
              autoCancelTimeoutMs,
              r'RingSettingsResponse',
              'autoCancelTimeoutMs'),
          incomingCallTimeoutMs: BuiltValueNullFieldError.checkNotNull(
              incomingCallTimeoutMs,
              r'RingSettingsResponse',
              'incomingCallTimeoutMs'),
          missedCallTimeoutMs: BuiltValueNullFieldError.checkNotNull(
              missedCallTimeoutMs,
              r'RingSettingsResponse',
              'missedCallTimeoutMs'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
