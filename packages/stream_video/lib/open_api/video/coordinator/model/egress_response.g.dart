// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'egress_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EgressResponse extends EgressResponse {
  @override
  final bool broadcasting;
  @override
  final FrameRecordingResponse? frameRecording;
  @override
  final EgressHLSResponse? hls;
  @override
  final BuiltList<EgressRTMPResponse> rtmps;

  factory _$EgressResponse([void Function(EgressResponseBuilder)? updates]) =>
      (EgressResponseBuilder()..update(updates))._build();

  _$EgressResponse._(
      {required this.broadcasting,
      this.frameRecording,
      this.hls,
      required this.rtmps})
      : super._();
  @override
  EgressResponse rebuild(void Function(EgressResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EgressResponseBuilder toBuilder() => EgressResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EgressResponse &&
        broadcasting == other.broadcasting &&
        frameRecording == other.frameRecording &&
        hls == other.hls &&
        rtmps == other.rtmps;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, broadcasting.hashCode);
    _$hash = $jc(_$hash, frameRecording.hashCode);
    _$hash = $jc(_$hash, hls.hashCode);
    _$hash = $jc(_$hash, rtmps.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EgressResponse')
          ..add('broadcasting', broadcasting)
          ..add('frameRecording', frameRecording)
          ..add('hls', hls)
          ..add('rtmps', rtmps))
        .toString();
  }
}

class EgressResponseBuilder
    implements Builder<EgressResponse, EgressResponseBuilder> {
  _$EgressResponse? _$v;

  bool? _broadcasting;
  bool? get broadcasting => _$this._broadcasting;
  set broadcasting(bool? broadcasting) => _$this._broadcasting = broadcasting;

  FrameRecordingResponseBuilder? _frameRecording;
  FrameRecordingResponseBuilder get frameRecording =>
      _$this._frameRecording ??= FrameRecordingResponseBuilder();
  set frameRecording(FrameRecordingResponseBuilder? frameRecording) =>
      _$this._frameRecording = frameRecording;

  EgressHLSResponseBuilder? _hls;
  EgressHLSResponseBuilder get hls =>
      _$this._hls ??= EgressHLSResponseBuilder();
  set hls(EgressHLSResponseBuilder? hls) => _$this._hls = hls;

  ListBuilder<EgressRTMPResponse>? _rtmps;
  ListBuilder<EgressRTMPResponse> get rtmps =>
      _$this._rtmps ??= ListBuilder<EgressRTMPResponse>();
  set rtmps(ListBuilder<EgressRTMPResponse>? rtmps) => _$this._rtmps = rtmps;

  EgressResponseBuilder() {
    EgressResponse._defaults(this);
  }

  EgressResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _broadcasting = $v.broadcasting;
      _frameRecording = $v.frameRecording?.toBuilder();
      _hls = $v.hls?.toBuilder();
      _rtmps = $v.rtmps.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EgressResponse other) {
    _$v = other as _$EgressResponse;
  }

  @override
  void update(void Function(EgressResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EgressResponse build() => _build();

  _$EgressResponse _build() {
    _$EgressResponse _$result;
    try {
      _$result = _$v ??
          _$EgressResponse._(
            broadcasting: BuiltValueNullFieldError.checkNotNull(
                broadcasting, r'EgressResponse', 'broadcasting'),
            frameRecording: _frameRecording?.build(),
            hls: _hls?.build(),
            rtmps: rtmps.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'frameRecording';
        _frameRecording?.build();
        _$failedField = 'hls';
        _hls?.build();
        _$failedField = 'rtmps';
        rtmps.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EgressResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
