// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReportResponse extends ReportResponse {
  @override
  final CallReportResponse call;
  @override
  final ParticipantReportResponse participants;
  @override
  final UserRatingReportResponse userRatings;

  factory _$ReportResponse([void Function(ReportResponseBuilder)? updates]) =>
      (ReportResponseBuilder()..update(updates))._build();

  _$ReportResponse._(
      {required this.call,
      required this.participants,
      required this.userRatings})
      : super._();
  @override
  ReportResponse rebuild(void Function(ReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportResponseBuilder toBuilder() => ReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReportResponse &&
        call == other.call &&
        participants == other.participants &&
        userRatings == other.userRatings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, participants.hashCode);
    _$hash = $jc(_$hash, userRatings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReportResponse')
          ..add('call', call)
          ..add('participants', participants)
          ..add('userRatings', userRatings))
        .toString();
  }
}

class ReportResponseBuilder
    implements Builder<ReportResponse, ReportResponseBuilder> {
  _$ReportResponse? _$v;

  CallReportResponseBuilder? _call;
  CallReportResponseBuilder get call =>
      _$this._call ??= CallReportResponseBuilder();
  set call(CallReportResponseBuilder? call) => _$this._call = call;

  ParticipantReportResponseBuilder? _participants;
  ParticipantReportResponseBuilder get participants =>
      _$this._participants ??= ParticipantReportResponseBuilder();
  set participants(ParticipantReportResponseBuilder? participants) =>
      _$this._participants = participants;

  UserRatingReportResponseBuilder? _userRatings;
  UserRatingReportResponseBuilder get userRatings =>
      _$this._userRatings ??= UserRatingReportResponseBuilder();
  set userRatings(UserRatingReportResponseBuilder? userRatings) =>
      _$this._userRatings = userRatings;

  ReportResponseBuilder() {
    ReportResponse._defaults(this);
  }

  ReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _participants = $v.participants.toBuilder();
      _userRatings = $v.userRatings.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReportResponse other) {
    _$v = other as _$ReportResponse;
  }

  @override
  void update(void Function(ReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReportResponse build() => _build();

  _$ReportResponse _build() {
    _$ReportResponse _$result;
    try {
      _$result = _$v ??
          _$ReportResponse._(
            call: call.build(),
            participants: participants.build(),
            userRatings: userRatings.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
        _$failedField = 'participants';
        participants.build();
        _$failedField = 'userRatings';
        userRatings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
