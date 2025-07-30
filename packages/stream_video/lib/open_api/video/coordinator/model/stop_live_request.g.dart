// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_live_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopLiveRequest extends StopLiveRequest {
  @override
  final bool? continueClosedCaption;
  @override
  final bool? continueHls;
  @override
  final bool? continueRecording;
  @override
  final bool? continueRtmpBroadcasts;
  @override
  final bool? continueTranscription;

  factory _$StopLiveRequest([void Function(StopLiveRequestBuilder)? updates]) =>
      (StopLiveRequestBuilder()..update(updates))._build();

  _$StopLiveRequest._(
      {this.continueClosedCaption,
      this.continueHls,
      this.continueRecording,
      this.continueRtmpBroadcasts,
      this.continueTranscription})
      : super._();
  @override
  StopLiveRequest rebuild(void Function(StopLiveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopLiveRequestBuilder toBuilder() => StopLiveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopLiveRequest &&
        continueClosedCaption == other.continueClosedCaption &&
        continueHls == other.continueHls &&
        continueRecording == other.continueRecording &&
        continueRtmpBroadcasts == other.continueRtmpBroadcasts &&
        continueTranscription == other.continueTranscription;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, continueClosedCaption.hashCode);
    _$hash = $jc(_$hash, continueHls.hashCode);
    _$hash = $jc(_$hash, continueRecording.hashCode);
    _$hash = $jc(_$hash, continueRtmpBroadcasts.hashCode);
    _$hash = $jc(_$hash, continueTranscription.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StopLiveRequest')
          ..add('continueClosedCaption', continueClosedCaption)
          ..add('continueHls', continueHls)
          ..add('continueRecording', continueRecording)
          ..add('continueRtmpBroadcasts', continueRtmpBroadcasts)
          ..add('continueTranscription', continueTranscription))
        .toString();
  }
}

class StopLiveRequestBuilder
    implements Builder<StopLiveRequest, StopLiveRequestBuilder> {
  _$StopLiveRequest? _$v;

  bool? _continueClosedCaption;
  bool? get continueClosedCaption => _$this._continueClosedCaption;
  set continueClosedCaption(bool? continueClosedCaption) =>
      _$this._continueClosedCaption = continueClosedCaption;

  bool? _continueHls;
  bool? get continueHls => _$this._continueHls;
  set continueHls(bool? continueHls) => _$this._continueHls = continueHls;

  bool? _continueRecording;
  bool? get continueRecording => _$this._continueRecording;
  set continueRecording(bool? continueRecording) =>
      _$this._continueRecording = continueRecording;

  bool? _continueRtmpBroadcasts;
  bool? get continueRtmpBroadcasts => _$this._continueRtmpBroadcasts;
  set continueRtmpBroadcasts(bool? continueRtmpBroadcasts) =>
      _$this._continueRtmpBroadcasts = continueRtmpBroadcasts;

  bool? _continueTranscription;
  bool? get continueTranscription => _$this._continueTranscription;
  set continueTranscription(bool? continueTranscription) =>
      _$this._continueTranscription = continueTranscription;

  StopLiveRequestBuilder() {
    StopLiveRequest._defaults(this);
  }

  StopLiveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _continueClosedCaption = $v.continueClosedCaption;
      _continueHls = $v.continueHls;
      _continueRecording = $v.continueRecording;
      _continueRtmpBroadcasts = $v.continueRtmpBroadcasts;
      _continueTranscription = $v.continueTranscription;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopLiveRequest other) {
    _$v = other as _$StopLiveRequest;
  }

  @override
  void update(void Function(StopLiveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopLiveRequest build() => _build();

  _$StopLiveRequest _build() {
    final _$result = _$v ??
        _$StopLiveRequest._(
          continueClosedCaption: continueClosedCaption,
          continueHls: continueHls,
          continueRecording: continueRecording,
          continueRtmpBroadcasts: continueRtmpBroadcasts,
          continueTranscription: continueTranscription,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
