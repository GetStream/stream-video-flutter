// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_recording_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartRecordingRequest {
  String? get recordingExternalStorage;

  /// Create a copy of StartRecordingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StartRecordingRequestCopyWith<StartRecordingRequest> get copyWith =>
      _$StartRecordingRequestCopyWithImpl<StartRecordingRequest>(
        this as StartRecordingRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StartRecordingRequest &&
            (identical(
                  other.recordingExternalStorage,
                  recordingExternalStorage,
                ) ||
                other.recordingExternalStorage == recordingExternalStorage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, recordingExternalStorage);

  @override
  String toString() {
    return 'StartRecordingRequest(recordingExternalStorage: $recordingExternalStorage)';
  }
}

/// @nodoc
abstract mixin class $StartRecordingRequestCopyWith<$Res> {
  factory $StartRecordingRequestCopyWith(
    StartRecordingRequest value,
    $Res Function(StartRecordingRequest) _then,
  ) = _$StartRecordingRequestCopyWithImpl;
  @useResult
  $Res call({String? recordingExternalStorage});
}

/// @nodoc
class _$StartRecordingRequestCopyWithImpl<$Res>
    implements $StartRecordingRequestCopyWith<$Res> {
  _$StartRecordingRequestCopyWithImpl(this._self, this._then);

  final StartRecordingRequest _self;
  final $Res Function(StartRecordingRequest) _then;

  /// Create a copy of StartRecordingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? recordingExternalStorage = freezed}) {
    return _then(
      StartRecordingRequest(
        recordingExternalStorage: freezed == recordingExternalStorage
            ? _self.recordingExternalStorage
            : recordingExternalStorage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
