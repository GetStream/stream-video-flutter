// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_recordings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListRecordingsResponse extends ListRecordingsResponse {
  @override
  final String duration;
  @override
  final BuiltList<CallRecording> recordings;

  factory _$ListRecordingsResponse(
          [void Function(ListRecordingsResponseBuilder)? updates]) =>
      (ListRecordingsResponseBuilder()..update(updates))._build();

  _$ListRecordingsResponse._({required this.duration, required this.recordings})
      : super._();
  @override
  ListRecordingsResponse rebuild(
          void Function(ListRecordingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListRecordingsResponseBuilder toBuilder() =>
      ListRecordingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListRecordingsResponse &&
        duration == other.duration &&
        recordings == other.recordings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, recordings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListRecordingsResponse')
          ..add('duration', duration)
          ..add('recordings', recordings))
        .toString();
  }
}

class ListRecordingsResponseBuilder
    implements Builder<ListRecordingsResponse, ListRecordingsResponseBuilder> {
  _$ListRecordingsResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ListBuilder<CallRecording>? _recordings;
  ListBuilder<CallRecording> get recordings =>
      _$this._recordings ??= ListBuilder<CallRecording>();
  set recordings(ListBuilder<CallRecording>? recordings) =>
      _$this._recordings = recordings;

  ListRecordingsResponseBuilder() {
    ListRecordingsResponse._defaults(this);
  }

  ListRecordingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _recordings = $v.recordings.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListRecordingsResponse other) {
    _$v = other as _$ListRecordingsResponse;
  }

  @override
  void update(void Function(ListRecordingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListRecordingsResponse build() => _build();

  _$ListRecordingsResponse _build() {
    _$ListRecordingsResponse _$result;
    try {
      _$result = _$v ??
          _$ListRecordingsResponse._(
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'ListRecordingsResponse', 'duration'),
            recordings: recordings.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recordings';
        recordings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListRecordingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
