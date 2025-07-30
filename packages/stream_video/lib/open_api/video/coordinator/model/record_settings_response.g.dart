// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecordSettingsResponse extends RecordSettingsResponse {
  @override
  final bool audioOnly;
  @override
  final String mode;
  @override
  final String quality;

  factory _$RecordSettingsResponse(
          [void Function(RecordSettingsResponseBuilder)? updates]) =>
      (RecordSettingsResponseBuilder()..update(updates))._build();

  _$RecordSettingsResponse._(
      {required this.audioOnly, required this.mode, required this.quality})
      : super._();
  @override
  RecordSettingsResponse rebuild(
          void Function(RecordSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecordSettingsResponseBuilder toBuilder() =>
      RecordSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecordSettingsResponse &&
        audioOnly == other.audioOnly &&
        mode == other.mode &&
        quality == other.quality;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, audioOnly.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, quality.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecordSettingsResponse')
          ..add('audioOnly', audioOnly)
          ..add('mode', mode)
          ..add('quality', quality))
        .toString();
  }
}

class RecordSettingsResponseBuilder
    implements Builder<RecordSettingsResponse, RecordSettingsResponseBuilder> {
  _$RecordSettingsResponse? _$v;

  bool? _audioOnly;
  bool? get audioOnly => _$this._audioOnly;
  set audioOnly(bool? audioOnly) => _$this._audioOnly = audioOnly;

  String? _mode;
  String? get mode => _$this._mode;
  set mode(String? mode) => _$this._mode = mode;

  String? _quality;
  String? get quality => _$this._quality;
  set quality(String? quality) => _$this._quality = quality;

  RecordSettingsResponseBuilder() {
    RecordSettingsResponse._defaults(this);
  }

  RecordSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _audioOnly = $v.audioOnly;
      _mode = $v.mode;
      _quality = $v.quality;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecordSettingsResponse other) {
    _$v = other as _$RecordSettingsResponse;
  }

  @override
  void update(void Function(RecordSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecordSettingsResponse build() => _build();

  _$RecordSettingsResponse _build() {
    final _$result = _$v ??
        _$RecordSettingsResponse._(
          audioOnly: BuiltValueNullFieldError.checkNotNull(
              audioOnly, r'RecordSettingsResponse', 'audioOnly'),
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'RecordSettingsResponse', 'mode'),
          quality: BuiltValueNullFieldError.checkNotNull(
              quality, r'RecordSettingsResponse', 'quality'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
