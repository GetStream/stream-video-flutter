// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_recording_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteRecordingResponse extends DeleteRecordingResponse {
  @override
  final String duration;

  factory _$DeleteRecordingResponse(
          [void Function(DeleteRecordingResponseBuilder)? updates]) =>
      (DeleteRecordingResponseBuilder()..update(updates))._build();

  _$DeleteRecordingResponse._({required this.duration}) : super._();
  @override
  DeleteRecordingResponse rebuild(
          void Function(DeleteRecordingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeleteRecordingResponseBuilder toBuilder() =>
      DeleteRecordingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteRecordingResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'DeleteRecordingResponse')
          ..add('duration', duration))
        .toString();
  }
}

class DeleteRecordingResponseBuilder
    implements
        Builder<DeleteRecordingResponse, DeleteRecordingResponseBuilder> {
  _$DeleteRecordingResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  DeleteRecordingResponseBuilder() {
    DeleteRecordingResponse._defaults(this);
  }

  DeleteRecordingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteRecordingResponse other) {
    _$v = other as _$DeleteRecordingResponse;
  }

  @override
  void update(void Function(DeleteRecordingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteRecordingResponse build() => _build();

  _$DeleteRecordingResponse _build() {
    final _$result = _$v ??
        _$DeleteRecordingResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'DeleteRecordingResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
