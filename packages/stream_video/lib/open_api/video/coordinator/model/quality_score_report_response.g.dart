// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_score_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QualityScoreReportResponse extends QualityScoreReportResponse {
  @override
  final BuiltList<DailyAggregateQualityScoreReportResponse> daily;

  factory _$QualityScoreReportResponse(
          [void Function(QualityScoreReportResponseBuilder)? updates]) =>
      (QualityScoreReportResponseBuilder()..update(updates))._build();

  _$QualityScoreReportResponse._({required this.daily}) : super._();
  @override
  QualityScoreReportResponse rebuild(
          void Function(QualityScoreReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QualityScoreReportResponseBuilder toBuilder() =>
      QualityScoreReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QualityScoreReportResponse && daily == other.daily;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, daily.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QualityScoreReportResponse')
          ..add('daily', daily))
        .toString();
  }
}

class QualityScoreReportResponseBuilder
    implements
        Builder<QualityScoreReportResponse, QualityScoreReportResponseBuilder> {
  _$QualityScoreReportResponse? _$v;

  ListBuilder<DailyAggregateQualityScoreReportResponse>? _daily;
  ListBuilder<DailyAggregateQualityScoreReportResponse> get daily =>
      _$this._daily ??= ListBuilder<DailyAggregateQualityScoreReportResponse>();
  set daily(ListBuilder<DailyAggregateQualityScoreReportResponse>? daily) =>
      _$this._daily = daily;

  QualityScoreReportResponseBuilder() {
    QualityScoreReportResponse._defaults(this);
  }

  QualityScoreReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _daily = $v.daily.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QualityScoreReportResponse other) {
    _$v = other as _$QualityScoreReportResponse;
  }

  @override
  void update(void Function(QualityScoreReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QualityScoreReportResponse build() => _build();

  _$QualityScoreReportResponse _build() {
    _$QualityScoreReportResponse _$result;
    try {
      _$result = _$v ??
          _$QualityScoreReportResponse._(
            daily: daily.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'daily';
        daily.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QualityScoreReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
