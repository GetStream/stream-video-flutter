import 'facing_mode.dart';

/// Enum type to represent the camera position of a video track.
enum CameraPosition {
  front,
  back;

  /// Returns a flipped camera position.
  CameraPosition flip() {
    switch (this) {
      case CameraPosition.front:
        return CameraPosition.back;
      case CameraPosition.back:
        return CameraPosition.front;
    }
  }

  /// Converts this enum to a [FacingMode].
  FacingMode toFacingMode() {
    switch (this) {
      case CameraPosition.front:
        return FacingMode.user;
      case CameraPosition.back:
        return FacingMode.environment;
    }
  }

  @override
  String toString() => name;
}
