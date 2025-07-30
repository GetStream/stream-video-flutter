// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_count_over_time_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ParticipantCountOverTimeResponse
    extends ParticipantCountOverTimeResponse {
  @override
  final BuiltList<ParticipantCountByMinuteResponse?>? byMinute;

  factory _$ParticipantCountOverTimeResponse(
          [void Function(ParticipantCountOverTimeResponseBuilder)? updates]) =>
      (ParticipantCountOverTimeResponseBuilder()..update(updates))._build();

  _$ParticipantCountOverTimeResponse._({this.byMinute}) : super._();
  @override
  ParticipantCountOverTimeResponse rebuild(
          void Function(ParticipantCountOverTimeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParticipantCountOverTimeResponseBuilder toBuilder() =>
      ParticipantCountOverTimeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParticipantCountOverTimeResponse &&
        byMinute == other.byMinute;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, byMinute.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParticipantCountOverTimeResponse')
          ..add('byMinute', byMinute))
        .toString();
  }
}

class ParticipantCountOverTimeResponseBuilder
    implements
        Builder<ParticipantCountOverTimeResponse,
            ParticipantCountOverTimeResponseBuilder> {
  _$ParticipantCountOverTimeResponse? _$v;

  ListBuilder<ParticipantCountByMinuteResponse?>? _byMinute;
  ListBuilder<ParticipantCountByMinuteResponse?> get byMinute =>
      _$this._byMinute ??= ListBuilder<ParticipantCountByMinuteResponse?>();
  set byMinute(ListBuilder<ParticipantCountByMinuteResponse?>? byMinute) =>
      _$this._byMinute = byMinute;

  ParticipantCountOverTimeResponseBuilder() {
    ParticipantCountOverTimeResponse._defaults(this);
  }

  ParticipantCountOverTimeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _byMinute = $v.byMinute?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParticipantCountOverTimeResponse other) {
    _$v = other as _$ParticipantCountOverTimeResponse;
  }

  @override
  void update(void Function(ParticipantCountOverTimeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParticipantCountOverTimeResponse build() => _build();

  _$ParticipantCountOverTimeResponse _build() {
    _$ParticipantCountOverTimeResponse _$result;
    try {
      _$result = _$v ??
          _$ParticipantCountOverTimeResponse._(
            byMinute: _byMinute?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byMinute';
        _byMinute?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ParticipantCountOverTimeResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
