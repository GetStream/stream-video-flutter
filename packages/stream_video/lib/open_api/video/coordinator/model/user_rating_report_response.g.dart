// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rating_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserRatingReportResponse extends UserRatingReportResponse {
  @override
  final double average;
  @override
  final int count;

  factory _$UserRatingReportResponse(
          [void Function(UserRatingReportResponseBuilder)? updates]) =>
      (UserRatingReportResponseBuilder()..update(updates))._build();

  _$UserRatingReportResponse._({required this.average, required this.count})
      : super._();
  @override
  UserRatingReportResponse rebuild(
          void Function(UserRatingReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserRatingReportResponseBuilder toBuilder() =>
      UserRatingReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserRatingReportResponse &&
        average == other.average &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserRatingReportResponse')
          ..add('average', average)
          ..add('count', count))
        .toString();
  }
}

class UserRatingReportResponseBuilder
    implements
        Builder<UserRatingReportResponse, UserRatingReportResponseBuilder> {
  _$UserRatingReportResponse? _$v;

  double? _average;
  double? get average => _$this._average;
  set average(double? average) => _$this._average = average;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  UserRatingReportResponseBuilder() {
    UserRatingReportResponse._defaults(this);
  }

  UserRatingReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _average = $v.average;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserRatingReportResponse other) {
    _$v = other as _$UserRatingReportResponse;
  }

  @override
  void update(void Function(UserRatingReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserRatingReportResponse build() => _build();

  _$UserRatingReportResponse _build() {
    final _$result = _$v ??
        _$UserRatingReportResponse._(
          average: BuiltValueNullFieldError.checkNotNull(
              average, r'UserRatingReportResponse', 'average'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'UserRatingReportResponse', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
