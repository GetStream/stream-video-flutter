// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_closed_captions_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopClosedCaptionsRequest extends StopClosedCaptionsRequest {
  @override
  final bool? stopTranscription;

  factory _$StopClosedCaptionsRequest(
          [void Function(StopClosedCaptionsRequestBuilder)? updates]) =>
      (StopClosedCaptionsRequestBuilder()..update(updates))._build();

  _$StopClosedCaptionsRequest._({this.stopTranscription}) : super._();
  @override
  StopClosedCaptionsRequest rebuild(
          void Function(StopClosedCaptionsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopClosedCaptionsRequestBuilder toBuilder() =>
      StopClosedCaptionsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopClosedCaptionsRequest &&
        stopTranscription == other.stopTranscription;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stopTranscription.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StopClosedCaptionsRequest')
          ..add('stopTranscription', stopTranscription))
        .toString();
  }
}

class StopClosedCaptionsRequestBuilder
    implements
        Builder<StopClosedCaptionsRequest, StopClosedCaptionsRequestBuilder> {
  _$StopClosedCaptionsRequest? _$v;

  bool? _stopTranscription;
  bool? get stopTranscription => _$this._stopTranscription;
  set stopTranscription(bool? stopTranscription) =>
      _$this._stopTranscription = stopTranscription;

  StopClosedCaptionsRequestBuilder() {
    StopClosedCaptionsRequest._defaults(this);
  }

  StopClosedCaptionsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stopTranscription = $v.stopTranscription;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopClosedCaptionsRequest other) {
    _$v = other as _$StopClosedCaptionsRequest;
  }

  @override
  void update(void Function(StopClosedCaptionsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopClosedCaptionsRequest build() => _build();

  _$StopClosedCaptionsRequest _build() {
    final _$result = _$v ??
        _$StopClosedCaptionsRequest._(
          stopTranscription: stopTranscription,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
