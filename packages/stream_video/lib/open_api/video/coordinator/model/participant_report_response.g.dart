// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ParticipantReportResponse extends ParticipantReportResponse {
  @override
  final BuiltList<GroupedStatsResponse?>? byBrowser;
  @override
  final BuiltList<GroupedStatsResponse?>? byCountry;
  @override
  final BuiltList<GroupedStatsResponse?>? byDevice;
  @override
  final BuiltList<GroupedStatsResponse?>? byOperatingSystem;
  @override
  final ParticipantCountOverTimeResponse? countOverTime;
  @override
  final int? maxConcurrent;
  @override
  final PublisherStatsResponse? publishers;
  @override
  final SubscriberStatsResponse? subscribers;
  @override
  final int sum;
  @override
  final int unique;

  factory _$ParticipantReportResponse(
          [void Function(ParticipantReportResponseBuilder)? updates]) =>
      (ParticipantReportResponseBuilder()..update(updates))._build();

  _$ParticipantReportResponse._(
      {this.byBrowser,
      this.byCountry,
      this.byDevice,
      this.byOperatingSystem,
      this.countOverTime,
      this.maxConcurrent,
      this.publishers,
      this.subscribers,
      required this.sum,
      required this.unique})
      : super._();
  @override
  ParticipantReportResponse rebuild(
          void Function(ParticipantReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParticipantReportResponseBuilder toBuilder() =>
      ParticipantReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParticipantReportResponse &&
        byBrowser == other.byBrowser &&
        byCountry == other.byCountry &&
        byDevice == other.byDevice &&
        byOperatingSystem == other.byOperatingSystem &&
        countOverTime == other.countOverTime &&
        maxConcurrent == other.maxConcurrent &&
        publishers == other.publishers &&
        subscribers == other.subscribers &&
        sum == other.sum &&
        unique == other.unique;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, byBrowser.hashCode);
    _$hash = $jc(_$hash, byCountry.hashCode);
    _$hash = $jc(_$hash, byDevice.hashCode);
    _$hash = $jc(_$hash, byOperatingSystem.hashCode);
    _$hash = $jc(_$hash, countOverTime.hashCode);
    _$hash = $jc(_$hash, maxConcurrent.hashCode);
    _$hash = $jc(_$hash, publishers.hashCode);
    _$hash = $jc(_$hash, subscribers.hashCode);
    _$hash = $jc(_$hash, sum.hashCode);
    _$hash = $jc(_$hash, unique.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParticipantReportResponse')
          ..add('byBrowser', byBrowser)
          ..add('byCountry', byCountry)
          ..add('byDevice', byDevice)
          ..add('byOperatingSystem', byOperatingSystem)
          ..add('countOverTime', countOverTime)
          ..add('maxConcurrent', maxConcurrent)
          ..add('publishers', publishers)
          ..add('subscribers', subscribers)
          ..add('sum', sum)
          ..add('unique', unique))
        .toString();
  }
}

class ParticipantReportResponseBuilder
    implements
        Builder<ParticipantReportResponse, ParticipantReportResponseBuilder> {
  _$ParticipantReportResponse? _$v;

  ListBuilder<GroupedStatsResponse?>? _byBrowser;
  ListBuilder<GroupedStatsResponse?> get byBrowser =>
      _$this._byBrowser ??= ListBuilder<GroupedStatsResponse?>();
  set byBrowser(ListBuilder<GroupedStatsResponse?>? byBrowser) =>
      _$this._byBrowser = byBrowser;

  ListBuilder<GroupedStatsResponse?>? _byCountry;
  ListBuilder<GroupedStatsResponse?> get byCountry =>
      _$this._byCountry ??= ListBuilder<GroupedStatsResponse?>();
  set byCountry(ListBuilder<GroupedStatsResponse?>? byCountry) =>
      _$this._byCountry = byCountry;

  ListBuilder<GroupedStatsResponse?>? _byDevice;
  ListBuilder<GroupedStatsResponse?> get byDevice =>
      _$this._byDevice ??= ListBuilder<GroupedStatsResponse?>();
  set byDevice(ListBuilder<GroupedStatsResponse?>? byDevice) =>
      _$this._byDevice = byDevice;

  ListBuilder<GroupedStatsResponse?>? _byOperatingSystem;
  ListBuilder<GroupedStatsResponse?> get byOperatingSystem =>
      _$this._byOperatingSystem ??= ListBuilder<GroupedStatsResponse?>();
  set byOperatingSystem(
          ListBuilder<GroupedStatsResponse?>? byOperatingSystem) =>
      _$this._byOperatingSystem = byOperatingSystem;

  ParticipantCountOverTimeResponseBuilder? _countOverTime;
  ParticipantCountOverTimeResponseBuilder get countOverTime =>
      _$this._countOverTime ??= ParticipantCountOverTimeResponseBuilder();
  set countOverTime(ParticipantCountOverTimeResponseBuilder? countOverTime) =>
      _$this._countOverTime = countOverTime;

  int? _maxConcurrent;
  int? get maxConcurrent => _$this._maxConcurrent;
  set maxConcurrent(int? maxConcurrent) =>
      _$this._maxConcurrent = maxConcurrent;

  PublisherStatsResponseBuilder? _publishers;
  PublisherStatsResponseBuilder get publishers =>
      _$this._publishers ??= PublisherStatsResponseBuilder();
  set publishers(PublisherStatsResponseBuilder? publishers) =>
      _$this._publishers = publishers;

  SubscriberStatsResponseBuilder? _subscribers;
  SubscriberStatsResponseBuilder get subscribers =>
      _$this._subscribers ??= SubscriberStatsResponseBuilder();
  set subscribers(SubscriberStatsResponseBuilder? subscribers) =>
      _$this._subscribers = subscribers;

  int? _sum;
  int? get sum => _$this._sum;
  set sum(int? sum) => _$this._sum = sum;

  int? _unique;
  int? get unique => _$this._unique;
  set unique(int? unique) => _$this._unique = unique;

  ParticipantReportResponseBuilder() {
    ParticipantReportResponse._defaults(this);
  }

  ParticipantReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _byBrowser = $v.byBrowser?.toBuilder();
      _byCountry = $v.byCountry?.toBuilder();
      _byDevice = $v.byDevice?.toBuilder();
      _byOperatingSystem = $v.byOperatingSystem?.toBuilder();
      _countOverTime = $v.countOverTime?.toBuilder();
      _maxConcurrent = $v.maxConcurrent;
      _publishers = $v.publishers?.toBuilder();
      _subscribers = $v.subscribers?.toBuilder();
      _sum = $v.sum;
      _unique = $v.unique;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParticipantReportResponse other) {
    _$v = other as _$ParticipantReportResponse;
  }

  @override
  void update(void Function(ParticipantReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParticipantReportResponse build() => _build();

  _$ParticipantReportResponse _build() {
    _$ParticipantReportResponse _$result;
    try {
      _$result = _$v ??
          _$ParticipantReportResponse._(
            byBrowser: _byBrowser?.build(),
            byCountry: _byCountry?.build(),
            byDevice: _byDevice?.build(),
            byOperatingSystem: _byOperatingSystem?.build(),
            countOverTime: _countOverTime?.build(),
            maxConcurrent: maxConcurrent,
            publishers: _publishers?.build(),
            subscribers: _subscribers?.build(),
            sum: BuiltValueNullFieldError.checkNotNull(
                sum, r'ParticipantReportResponse', 'sum'),
            unique: BuiltValueNullFieldError.checkNotNull(
                unique, r'ParticipantReportResponse', 'unique'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byBrowser';
        _byBrowser?.build();
        _$failedField = 'byCountry';
        _byCountry?.build();
        _$failedField = 'byDevice';
        _byDevice?.build();
        _$failedField = 'byOperatingSystem';
        _byOperatingSystem?.build();
        _$failedField = 'countOverTime';
        _countOverTime?.build();

        _$failedField = 'publishers';
        _publishers?.build();
        _$failedField = 'subscribers';
        _subscribers?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ParticipantReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
