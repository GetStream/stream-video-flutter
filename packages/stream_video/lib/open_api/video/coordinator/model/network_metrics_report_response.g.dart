// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_metrics_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NetworkMetricsReportResponse extends NetworkMetricsReportResponse {
  @override
  final double? averageConnectionTime;
  @override
  final double? averageJitter;
  @override
  final double? averageLatency;
  @override
  final double? averageTimeToReconnect;

  factory _$NetworkMetricsReportResponse(
          [void Function(NetworkMetricsReportResponseBuilder)? updates]) =>
      (NetworkMetricsReportResponseBuilder()..update(updates))._build();

  _$NetworkMetricsReportResponse._(
      {this.averageConnectionTime,
      this.averageJitter,
      this.averageLatency,
      this.averageTimeToReconnect})
      : super._();
  @override
  NetworkMetricsReportResponse rebuild(
          void Function(NetworkMetricsReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NetworkMetricsReportResponseBuilder toBuilder() =>
      NetworkMetricsReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NetworkMetricsReportResponse &&
        averageConnectionTime == other.averageConnectionTime &&
        averageJitter == other.averageJitter &&
        averageLatency == other.averageLatency &&
        averageTimeToReconnect == other.averageTimeToReconnect;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, averageConnectionTime.hashCode);
    _$hash = $jc(_$hash, averageJitter.hashCode);
    _$hash = $jc(_$hash, averageLatency.hashCode);
    _$hash = $jc(_$hash, averageTimeToReconnect.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NetworkMetricsReportResponse')
          ..add('averageConnectionTime', averageConnectionTime)
          ..add('averageJitter', averageJitter)
          ..add('averageLatency', averageLatency)
          ..add('averageTimeToReconnect', averageTimeToReconnect))
        .toString();
  }
}

class NetworkMetricsReportResponseBuilder
    implements
        Builder<NetworkMetricsReportResponse,
            NetworkMetricsReportResponseBuilder> {
  _$NetworkMetricsReportResponse? _$v;

  double? _averageConnectionTime;
  double? get averageConnectionTime => _$this._averageConnectionTime;
  set averageConnectionTime(double? averageConnectionTime) =>
      _$this._averageConnectionTime = averageConnectionTime;

  double? _averageJitter;
  double? get averageJitter => _$this._averageJitter;
  set averageJitter(double? averageJitter) =>
      _$this._averageJitter = averageJitter;

  double? _averageLatency;
  double? get averageLatency => _$this._averageLatency;
  set averageLatency(double? averageLatency) =>
      _$this._averageLatency = averageLatency;

  double? _averageTimeToReconnect;
  double? get averageTimeToReconnect => _$this._averageTimeToReconnect;
  set averageTimeToReconnect(double? averageTimeToReconnect) =>
      _$this._averageTimeToReconnect = averageTimeToReconnect;

  NetworkMetricsReportResponseBuilder() {
    NetworkMetricsReportResponse._defaults(this);
  }

  NetworkMetricsReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _averageConnectionTime = $v.averageConnectionTime;
      _averageJitter = $v.averageJitter;
      _averageLatency = $v.averageLatency;
      _averageTimeToReconnect = $v.averageTimeToReconnect;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NetworkMetricsReportResponse other) {
    _$v = other as _$NetworkMetricsReportResponse;
  }

  @override
  void update(void Function(NetworkMetricsReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NetworkMetricsReportResponse build() => _build();

  _$NetworkMetricsReportResponse _build() {
    final _$result = _$v ??
        _$NetworkMetricsReportResponse._(
          averageConnectionTime: averageConnectionTime,
          averageJitter: averageJitter,
          averageLatency: averageLatency,
          averageTimeToReconnect: averageTimeToReconnect,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
