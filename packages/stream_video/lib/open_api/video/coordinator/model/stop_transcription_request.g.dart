// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_transcription_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopTranscriptionRequest extends StopTranscriptionRequest {
  @override
  final bool? stopClosedCaptions;

  factory _$StopTranscriptionRequest(
          [void Function(StopTranscriptionRequestBuilder)? updates]) =>
      (StopTranscriptionRequestBuilder()..update(updates))._build();

  _$StopTranscriptionRequest._({this.stopClosedCaptions}) : super._();
  @override
  StopTranscriptionRequest rebuild(
          void Function(StopTranscriptionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopTranscriptionRequestBuilder toBuilder() =>
      StopTranscriptionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopTranscriptionRequest &&
        stopClosedCaptions == other.stopClosedCaptions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stopClosedCaptions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StopTranscriptionRequest')
          ..add('stopClosedCaptions', stopClosedCaptions))
        .toString();
  }
}

class StopTranscriptionRequestBuilder
    implements
        Builder<StopTranscriptionRequest, StopTranscriptionRequestBuilder> {
  _$StopTranscriptionRequest? _$v;

  bool? _stopClosedCaptions;
  bool? get stopClosedCaptions => _$this._stopClosedCaptions;
  set stopClosedCaptions(bool? stopClosedCaptions) =>
      _$this._stopClosedCaptions = stopClosedCaptions;

  StopTranscriptionRequestBuilder() {
    StopTranscriptionRequest._defaults(this);
  }

  StopTranscriptionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stopClosedCaptions = $v.stopClosedCaptions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopTranscriptionRequest other) {
    _$v = other as _$StopTranscriptionRequest;
  }

  @override
  void update(void Function(StopTranscriptionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopTranscriptionRequest build() => _build();

  _$StopTranscriptionRequest _build() {
    final _$result = _$v ??
        _$StopTranscriptionRequest._(
          stopClosedCaptions: stopClosedCaptions,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
