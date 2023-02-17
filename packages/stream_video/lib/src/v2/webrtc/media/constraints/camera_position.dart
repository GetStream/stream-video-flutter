import 'facing_mode.dart';

/// Enum type to represent the camera position of a video track.
enum CameraPositionV2 {
  front,
  back;

  /// Returns a flipped camera position.
  CameraPositionV2 flip() {
    switch (this) {
      case CameraPositionV2.front:
        return CameraPositionV2.back;
      case CameraPositionV2.back:
        return CameraPositionV2.front;
    }
  }

  /// Converts this enum to a [FacingMode].
  FacingMode toFacingMode() {
    switch (this) {
      case CameraPositionV2.front:
        return FacingMode.user;
      case CameraPositionV2.back:
        return FacingMode.environment;
    }
  }

  @override
  String toString() => name;
}
