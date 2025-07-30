// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_feedback_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserFeedbackReport extends UserFeedbackReport {
  @override
  final BuiltMap<String, int> countByRating;
  @override
  final int unreportedCount;

  factory _$UserFeedbackReport(
          [void Function(UserFeedbackReportBuilder)? updates]) =>
      (UserFeedbackReportBuilder()..update(updates))._build();

  _$UserFeedbackReport._(
      {required this.countByRating, required this.unreportedCount})
      : super._();
  @override
  UserFeedbackReport rebuild(
          void Function(UserFeedbackReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserFeedbackReportBuilder toBuilder() =>
      UserFeedbackReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserFeedbackReport &&
        countByRating == other.countByRating &&
        unreportedCount == other.unreportedCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, countByRating.hashCode);
    _$hash = $jc(_$hash, unreportedCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserFeedbackReport')
          ..add('countByRating', countByRating)
          ..add('unreportedCount', unreportedCount))
        .toString();
  }
}

class UserFeedbackReportBuilder
    implements Builder<UserFeedbackReport, UserFeedbackReportBuilder> {
  _$UserFeedbackReport? _$v;

  MapBuilder<String, int>? _countByRating;
  MapBuilder<String, int> get countByRating =>
      _$this._countByRating ??= MapBuilder<String, int>();
  set countByRating(MapBuilder<String, int>? countByRating) =>
      _$this._countByRating = countByRating;

  int? _unreportedCount;
  int? get unreportedCount => _$this._unreportedCount;
  set unreportedCount(int? unreportedCount) =>
      _$this._unreportedCount = unreportedCount;

  UserFeedbackReportBuilder() {
    UserFeedbackReport._defaults(this);
  }

  UserFeedbackReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _countByRating = $v.countByRating.toBuilder();
      _unreportedCount = $v.unreportedCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserFeedbackReport other) {
    _$v = other as _$UserFeedbackReport;
  }

  @override
  void update(void Function(UserFeedbackReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserFeedbackReport build() => _build();

  _$UserFeedbackReport _build() {
    _$UserFeedbackReport _$result;
    try {
      _$result = _$v ??
          _$UserFeedbackReport._(
            countByRating: countByRating.build(),
            unreportedCount: BuiltValueNullFieldError.checkNotNull(
                unreportedCount, r'UserFeedbackReport', 'unreportedCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'countByRating';
        countByRating.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserFeedbackReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
