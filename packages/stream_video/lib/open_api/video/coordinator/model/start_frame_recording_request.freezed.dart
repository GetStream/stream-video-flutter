// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_frame_recording_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartFrameRecordingRequest {
  String? get recordingExternalStorage;

  /// Create a copy of StartFrameRecordingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StartFrameRecordingRequestCopyWith<StartFrameRecordingRequest>
  get copyWith =>
      _$StartFrameRecordingRequestCopyWithImpl<StartFrameRecordingRequest>(
        this as StartFrameRecordingRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StartFrameRecordingRequest &&
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
    return 'StartFrameRecordingRequest(recordingExternalStorage: $recordingExternalStorage)';
  }
}

/// @nodoc
abstract mixin class $StartFrameRecordingRequestCopyWith<$Res> {
  factory $StartFrameRecordingRequestCopyWith(
    StartFrameRecordingRequest value,
    $Res Function(StartFrameRecordingRequest) _then,
  ) = _$StartFrameRecordingRequestCopyWithImpl;
  @useResult
  $Res call({String? recordingExternalStorage});
}

/// @nodoc
class _$StartFrameRecordingRequestCopyWithImpl<$Res>
    implements $StartFrameRecordingRequestCopyWith<$Res> {
  _$StartFrameRecordingRequestCopyWithImpl(this._self, this._then);

  final StartFrameRecordingRequest _self;
  final $Res Function(StartFrameRecordingRequest) _then;

  /// Create a copy of StartFrameRecordingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? recordingExternalStorage = freezed}) {
    return _then(
      StartFrameRecordingRequest(
        recordingExternalStorage: freezed == recordingExternalStorage
            ? _self.recordingExternalStorage
            : recordingExternalStorage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
