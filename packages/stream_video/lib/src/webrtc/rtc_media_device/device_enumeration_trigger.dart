/// What caused a device enumeration in `RtcMediaDeviceNotifier`.
///
/// Recorded in the RTC trace next to each enumeration so a dump shows why the
/// device list was read.
enum DeviceEnumerationTrigger {
  /// The first enumeration, when the notifier is created.
  initial,

  /// The platform reported that the set of media devices changed.
  deviceChange,

  /// The call settings are being applied on join.
  callSettings,

  /// The camera was flipped and the current camera is being resolved.
  flipCamera,

  /// Called by the app or a widget, e.g. to list the available devices.
  explicit,
}
