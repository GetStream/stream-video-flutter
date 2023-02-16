/// Enum type to represent the camera position of a video track.
enum CameraPositionV2 {
  front,
  back;

  /// Return a [CameraPositionV2] which front and back is switched.
  CameraPositionV2 switched() {
    switch (this) {
      case CameraPositionV2.front:
        return CameraPositionV2.back;
      case CameraPositionV2.back:
        return CameraPositionV2.front;
    }
  }

  @override
  String toString() => name;
}
