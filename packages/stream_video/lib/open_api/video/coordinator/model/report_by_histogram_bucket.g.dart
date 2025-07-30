// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_by_histogram_bucket.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReportByHistogramBucket extends ReportByHistogramBucket {
  @override
  final String category;
  @override
  final int count;
  @override
  final Bound? lowerBound;
  @override
  final double sum;
  @override
  final Bound? upperBound;

  factory _$ReportByHistogramBucket(
          [void Function(ReportByHistogramBucketBuilder)? updates]) =>
      (ReportByHistogramBucketBuilder()..update(updates))._build();

  _$ReportByHistogramBucket._(
      {required this.category,
      required this.count,
      this.lowerBound,
      required this.sum,
      this.upperBound})
      : super._();
  @override
  ReportByHistogramBucket rebuild(
          void Function(ReportByHistogramBucketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportByHistogramBucketBuilder toBuilder() =>
      ReportByHistogramBucketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReportByHistogramBucket &&
        category == other.category &&
        count == other.count &&
        lowerBound == other.lowerBound &&
        sum == other.sum &&
        upperBound == other.upperBound;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, lowerBound.hashCode);
    _$hash = $jc(_$hash, sum.hashCode);
    _$hash = $jc(_$hash, upperBound.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReportByHistogramBucket')
          ..add('category', category)
          ..add('count', count)
          ..add('lowerBound', lowerBound)
          ..add('sum', sum)
          ..add('upperBound', upperBound))
        .toString();
  }
}

class ReportByHistogramBucketBuilder
    implements
        Builder<ReportByHistogramBucket, ReportByHistogramBucketBuilder> {
  _$ReportByHistogramBucket? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  BoundBuilder? _lowerBound;
  BoundBuilder get lowerBound => _$this._lowerBound ??= BoundBuilder();
  set lowerBound(BoundBuilder? lowerBound) => _$this._lowerBound = lowerBound;

  double? _sum;
  double? get sum => _$this._sum;
  set sum(double? sum) => _$this._sum = sum;

  BoundBuilder? _upperBound;
  BoundBuilder get upperBound => _$this._upperBound ??= BoundBuilder();
  set upperBound(BoundBuilder? upperBound) => _$this._upperBound = upperBound;

  ReportByHistogramBucketBuilder() {
    ReportByHistogramBucket._defaults(this);
  }

  ReportByHistogramBucketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _count = $v.count;
      _lowerBound = $v.lowerBound?.toBuilder();
      _sum = $v.sum;
      _upperBound = $v.upperBound?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReportByHistogramBucket other) {
    _$v = other as _$ReportByHistogramBucket;
  }

  @override
  void update(void Function(ReportByHistogramBucketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReportByHistogramBucket build() => _build();

  _$ReportByHistogramBucket _build() {
    _$ReportByHistogramBucket _$result;
    try {
      _$result = _$v ??
          _$ReportByHistogramBucket._(
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'ReportByHistogramBucket', 'category'),
            count: BuiltValueNullFieldError.checkNotNull(
                count, r'ReportByHistogramBucket', 'count'),
            lowerBound: _lowerBound?.build(),
            sum: BuiltValueNullFieldError.checkNotNull(
                sum, r'ReportByHistogramBucket', 'sum'),
            upperBound: _upperBound?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lowerBound';
        _lowerBound?.build();

        _$failedField = 'upperBound';
        _upperBound?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReportByHistogramBucket', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
