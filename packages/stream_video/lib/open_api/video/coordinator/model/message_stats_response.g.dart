// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_stats_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MessageStatsResponse extends MessageStatsResponse {
  @override
  final BuiltList<CountByMinuteResponse?>? countOverTime;

  factory _$MessageStatsResponse(
          [void Function(MessageStatsResponseBuilder)? updates]) =>
      (MessageStatsResponseBuilder()..update(updates))._build();

  _$MessageStatsResponse._({this.countOverTime}) : super._();
  @override
  MessageStatsResponse rebuild(
          void Function(MessageStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageStatsResponseBuilder toBuilder() =>
      MessageStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessageStatsResponse &&
        countOverTime == other.countOverTime;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, countOverTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MessageStatsResponse')
          ..add('countOverTime', countOverTime))
        .toString();
  }
}

class MessageStatsResponseBuilder
    implements Builder<MessageStatsResponse, MessageStatsResponseBuilder> {
  _$MessageStatsResponse? _$v;

  ListBuilder<CountByMinuteResponse?>? _countOverTime;
  ListBuilder<CountByMinuteResponse?> get countOverTime =>
      _$this._countOverTime ??= ListBuilder<CountByMinuteResponse?>();
  set countOverTime(ListBuilder<CountByMinuteResponse?>? countOverTime) =>
      _$this._countOverTime = countOverTime;

  MessageStatsResponseBuilder() {
    MessageStatsResponse._defaults(this);
  }

  MessageStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _countOverTime = $v.countOverTime?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessageStatsResponse other) {
    _$v = other as _$MessageStatsResponse;
  }

  @override
  void update(void Function(MessageStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MessageStatsResponse build() => _build();

  _$MessageStatsResponse _build() {
    _$MessageStatsResponse _$result;
    try {
      _$result = _$v ??
          _$MessageStatsResponse._(
            countOverTime: _countOverTime?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'countOverTime';
        _countOverTime?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MessageStatsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
