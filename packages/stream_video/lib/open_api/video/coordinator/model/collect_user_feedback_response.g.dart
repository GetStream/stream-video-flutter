// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collect_user_feedback_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CollectUserFeedbackResponse extends CollectUserFeedbackResponse {
  @override
  final String duration;

  factory _$CollectUserFeedbackResponse(
          [void Function(CollectUserFeedbackResponseBuilder)? updates]) =>
      (CollectUserFeedbackResponseBuilder()..update(updates))._build();

  _$CollectUserFeedbackResponse._({required this.duration}) : super._();
  @override
  CollectUserFeedbackResponse rebuild(
          void Function(CollectUserFeedbackResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CollectUserFeedbackResponseBuilder toBuilder() =>
      CollectUserFeedbackResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CollectUserFeedbackResponse && duration == other.duration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CollectUserFeedbackResponse')
          ..add('duration', duration))
        .toString();
  }
}

class CollectUserFeedbackResponseBuilder
    implements
        Builder<CollectUserFeedbackResponse,
            CollectUserFeedbackResponseBuilder> {
  _$CollectUserFeedbackResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  CollectUserFeedbackResponseBuilder() {
    CollectUserFeedbackResponse._defaults(this);
  }

  CollectUserFeedbackResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CollectUserFeedbackResponse other) {
    _$v = other as _$CollectUserFeedbackResponse;
  }

  @override
  void update(void Function(CollectUserFeedbackResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CollectUserFeedbackResponse build() => _build();

  _$CollectUserFeedbackResponse _build() {
    final _$result = _$v ??
        _$CollectUserFeedbackResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'CollectUserFeedbackResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
