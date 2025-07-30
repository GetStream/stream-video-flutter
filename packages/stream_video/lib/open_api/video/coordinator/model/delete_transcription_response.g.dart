// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_transcription_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteTranscriptionResponse extends DeleteTranscriptionResponse {
  @override
  final String duration;

  factory _$DeleteTranscriptionResponse(
          [void Function(DeleteTranscriptionResponseBuilder)? updates]) =>
      (DeleteTranscriptionResponseBuilder()..update(updates))._build();

  _$DeleteTranscriptionResponse._({required this.duration}) : super._();
  @override
  DeleteTranscriptionResponse rebuild(
          void Function(DeleteTranscriptionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeleteTranscriptionResponseBuilder toBuilder() =>
      DeleteTranscriptionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteTranscriptionResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'DeleteTranscriptionResponse')
          ..add('duration', duration))
        .toString();
  }
}

class DeleteTranscriptionResponseBuilder
    implements
        Builder<DeleteTranscriptionResponse,
            DeleteTranscriptionResponseBuilder> {
  _$DeleteTranscriptionResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  DeleteTranscriptionResponseBuilder() {
    DeleteTranscriptionResponse._defaults(this);
  }

  DeleteTranscriptionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteTranscriptionResponse other) {
    _$v = other as _$DeleteTranscriptionResponse;
  }

  @override
  void update(void Function(DeleteTranscriptionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteTranscriptionResponse build() => _build();

  _$DeleteTranscriptionResponse _build() {
    final _$result = _$v ??
        _$DeleteTranscriptionResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'DeleteTranscriptionResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
