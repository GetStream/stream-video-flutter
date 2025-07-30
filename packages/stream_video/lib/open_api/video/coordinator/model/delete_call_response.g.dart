// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteCallResponse extends DeleteCallResponse {
  @override
  final CallResponse call;
  @override
  final String duration;
  @override
  final String? taskId;

  factory _$DeleteCallResponse(
          [void Function(DeleteCallResponseBuilder)? updates]) =>
      (DeleteCallResponseBuilder()..update(updates))._build();

  _$DeleteCallResponse._(
      {required this.call, required this.duration, this.taskId})
      : super._();
  @override
  DeleteCallResponse rebuild(
          void Function(DeleteCallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeleteCallResponseBuilder toBuilder() =>
      DeleteCallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteCallResponse &&
        call == other.call &&
        duration == other.duration &&
        taskId == other.taskId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, taskId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteCallResponse')
          ..add('call', call)
          ..add('duration', duration)
          ..add('taskId', taskId))
        .toString();
  }
}

class DeleteCallResponseBuilder
    implements Builder<DeleteCallResponse, DeleteCallResponseBuilder> {
  _$DeleteCallResponse? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  String? _taskId;
  String? get taskId => _$this._taskId;
  set taskId(String? taskId) => _$this._taskId = taskId;

  DeleteCallResponseBuilder() {
    DeleteCallResponse._defaults(this);
  }

  DeleteCallResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _duration = $v.duration;
      _taskId = $v.taskId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteCallResponse other) {
    _$v = other as _$DeleteCallResponse;
  }

  @override
  void update(void Function(DeleteCallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteCallResponse build() => _build();

  _$DeleteCallResponse _build() {
    _$DeleteCallResponse _$result;
    try {
      _$result = _$v ??
          _$DeleteCallResponse._(
            call: call.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'DeleteCallResponse', 'duration'),
            taskId: taskId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeleteCallResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
