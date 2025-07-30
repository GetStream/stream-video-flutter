// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_feedback_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserFeedbackReportResponse extends UserFeedbackReportResponse {
  @override
  final BuiltList<DailyAggregateUserFeedbackReportResponse> daily;

  factory _$UserFeedbackReportResponse(
          [void Function(UserFeedbackReportResponseBuilder)? updates]) =>
      (UserFeedbackReportResponseBuilder()..update(updates))._build();

  _$UserFeedbackReportResponse._({required this.daily}) : super._();
  @override
  UserFeedbackReportResponse rebuild(
          void Function(UserFeedbackReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserFeedbackReportResponseBuilder toBuilder() =>
      UserFeedbackReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserFeedbackReportResponse && daily == other.daily;
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
    return (newBuiltValueToStringHelper(r'UserFeedbackReportResponse')
          ..add('daily', daily))
        .toString();
  }
}

class UserFeedbackReportResponseBuilder
    implements
        Builder<UserFeedbackReportResponse, UserFeedbackReportResponseBuilder> {
  _$UserFeedbackReportResponse? _$v;

  ListBuilder<DailyAggregateUserFeedbackReportResponse>? _daily;
  ListBuilder<DailyAggregateUserFeedbackReportResponse> get daily =>
      _$this._daily ??= ListBuilder<DailyAggregateUserFeedbackReportResponse>();
  set daily(ListBuilder<DailyAggregateUserFeedbackReportResponse>? daily) =>
      _$this._daily = daily;

  UserFeedbackReportResponseBuilder() {
    UserFeedbackReportResponse._defaults(this);
  }

  UserFeedbackReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _daily = $v.daily.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserFeedbackReportResponse other) {
    _$v = other as _$UserFeedbackReportResponse;
  }

  @override
  void update(void Function(UserFeedbackReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserFeedbackReportResponse build() => _build();

  _$UserFeedbackReportResponse _build() {
    _$UserFeedbackReportResponse _$result;
    try {
      _$result = _$v ??
          _$UserFeedbackReportResponse._(
            daily: daily.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'daily';
        daily.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserFeedbackReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
