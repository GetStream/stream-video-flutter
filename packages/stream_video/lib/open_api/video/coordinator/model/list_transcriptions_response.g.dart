// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transcriptions_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListTranscriptionsResponse extends ListTranscriptionsResponse {
  @override
  final String duration;
  @override
  final BuiltList<CallTranscription> transcriptions;

  factory _$ListTranscriptionsResponse(
          [void Function(ListTranscriptionsResponseBuilder)? updates]) =>
      (ListTranscriptionsResponseBuilder()..update(updates))._build();

  _$ListTranscriptionsResponse._(
      {required this.duration, required this.transcriptions})
      : super._();
  @override
  ListTranscriptionsResponse rebuild(
          void Function(ListTranscriptionsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListTranscriptionsResponseBuilder toBuilder() =>
      ListTranscriptionsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListTranscriptionsResponse &&
        duration == other.duration &&
        transcriptions == other.transcriptions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, transcriptions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListTranscriptionsResponse')
          ..add('duration', duration)
          ..add('transcriptions', transcriptions))
        .toString();
  }
}

class ListTranscriptionsResponseBuilder
    implements
        Builder<ListTranscriptionsResponse, ListTranscriptionsResponseBuilder> {
  _$ListTranscriptionsResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ListBuilder<CallTranscription>? _transcriptions;
  ListBuilder<CallTranscription> get transcriptions =>
      _$this._transcriptions ??= ListBuilder<CallTranscription>();
  set transcriptions(ListBuilder<CallTranscription>? transcriptions) =>
      _$this._transcriptions = transcriptions;

  ListTranscriptionsResponseBuilder() {
    ListTranscriptionsResponse._defaults(this);
  }

  ListTranscriptionsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _transcriptions = $v.transcriptions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListTranscriptionsResponse other) {
    _$v = other as _$ListTranscriptionsResponse;
  }

  @override
  void update(void Function(ListTranscriptionsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListTranscriptionsResponse build() => _build();

  _$ListTranscriptionsResponse _build() {
    _$ListTranscriptionsResponse _$result;
    try {
      _$result = _$v ??
          _$ListTranscriptionsResponse._(
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'ListTranscriptionsResponse', 'duration'),
            transcriptions: transcriptions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'transcriptions';
        transcriptions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListTranscriptionsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
