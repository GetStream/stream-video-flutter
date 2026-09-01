import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../stream_video_flutter.dart';

/// Applies a device the user picked. See
/// [StreamMediaDevicesController.onVideoInputSelected].
typedef StreamMediaDeviceSelected =
    FutureOr<void> Function(RtcMediaDevice? device);

/// Loads the available input and output devices and remembers which one is
/// picked.
///
/// Shared by every widget that offers a device choice, so that a split button
/// on a toggle's caret and a select input in a settings row read and write one
/// selection instead of each keeping their own.
///
/// The controller owns *which* device is picked; its owner supplies *what
/// picking it does*, through [onAudioInputSelected], [onAudioOutputSelected]
/// and [onVideoInputSelected]. That is what makes it reusable: the lobby hands
/// in a camera restart, an in-call switcher would hand in the call's own
/// setter, and neither the split button nor the select input has to know which
/// it is driving.
///
/// Device labels are only populated once `getUserMedia` has succeeded, so the
/// lists are empty until the user has granted permission.
class StreamMediaDevicesController extends ChangeNotifier {
  /// Creates a new instance of [StreamMediaDevicesController].
  StreamMediaDevicesController({
    RtcMediaDeviceNotifier? deviceNotifier,
    this.onAudioInputSelected,
    this.onAudioOutputSelected,
    this.onVideoInputSelected,
  }) : _deviceNotifier = deviceNotifier ?? RtcMediaDeviceNotifier.instance {
    _subscription = _deviceNotifier.onDeviceChange.listen(_handleDeviceChange);
    // The notifier replays its last enumeration to a new listener, but only
    // once it has run one; this kicks the first.
    unawaited(_deviceNotifier.enumerateDevices());
  }

  /// Drives [call]'s own device selection.
  ///
  /// The lobby builds one that restarts a preview instead; this is the
  /// in-call counterpart, so a device picker works the same either side of
  /// joining.
  factory StreamMediaDevicesController.forCall(
    Call call, {
    RtcMediaDeviceNotifier? deviceNotifier,
  }) {
    return StreamMediaDevicesController(
      deviceNotifier: deviceNotifier,
      onAudioInputSelected: (device) async {
        if (device != null) await call.setAudioInputDevice(device);
      },
      onAudioOutputSelected: (device) async {
        if (device != null) await call.setAudioOutputDevice(device);
      },
      onVideoInputSelected: (device) async {
        if (device != null) await call.setVideoInputDevice(device);
      },
    );
  }

  final RtcMediaDeviceNotifier _deviceNotifier;
  StreamSubscription<List<RtcMediaDevice>>? _subscription;

  /// Called when the microphone changes, with null for the system default.
  final StreamMediaDeviceSelected? onAudioInputSelected;

  /// Called when the speaker changes, with null for the system default.
  final StreamMediaDeviceSelected? onAudioOutputSelected;

  /// Called when the camera changes, with null for the system default.
  ///
  /// This is where a lobby restarts its preview on the new camera, and where
  /// an in-call switcher tells the call about it.
  final StreamMediaDeviceSelected? onVideoInputSelected;

  bool _hasEnumerated = false;

  /// Whether the platform has reported its devices yet.
  ///
  /// Until it has, the lists are empty because nothing has been asked, not
  /// because there is nothing — so a control that disables itself for want of
  /// a device has to wait for this or it flashes an error on startup.
  bool get hasEnumerated => _hasEnumerated;

  List<RtcMediaDevice> _audioInputs = const [];
  List<RtcMediaDevice> _audioOutputs = const [];
  List<RtcMediaDevice> _videoInputs = const [];

  /// The microphones the platform reports.
  List<RtcMediaDevice> get audioInputs => _audioInputs;

  /// The speakers the platform reports.
  ///
  /// Empty on platforms that route audio themselves, which is most of iOS and
  /// Android — there is nothing to pick from, and a speaker section built from
  /// this should be omitted rather than shown empty. Note that
  /// [RtcMediaDeviceNotifier] synthesises an earpiece on iOS, so this is not
  /// reliably empty there.
  List<RtcMediaDevice> get audioOutputs => _audioOutputs;

  /// The cameras the platform reports.
  List<RtcMediaDevice> get videoInputs => _videoInputs;

  RtcMediaDevice? _selectedAudioInput;
  RtcMediaDevice? _selectedAudioOutput;
  RtcMediaDevice? _selectedVideoInput;

  /// The picked microphone, or null for the system default.
  RtcMediaDevice? get selectedAudioInput => _selectedAudioInput;

  /// The picked speaker, or null for the system default.
  RtcMediaDevice? get selectedAudioOutput => _selectedAudioOutput;

  /// The picked camera, or null for the system default.
  RtcMediaDevice? get selectedVideoInput => _selectedVideoInput;

  /// Picks [device] as the microphone, or the system default when null.
  Future<void> selectAudioInput(RtcMediaDevice? device) async {
    if (device?.id == _selectedAudioInput?.id) return;

    _selectedAudioInput = device;
    notifyListeners();
    await onAudioInputSelected?.call(device);
  }

  /// Picks [device] as the speaker, or the system default when null.
  Future<void> selectAudioOutput(RtcMediaDevice? device) async {
    if (device?.id == _selectedAudioOutput?.id) return;

    _selectedAudioOutput = device;
    notifyListeners();
    await onAudioOutputSelected?.call(device);
  }

  /// Picks [device] as the camera, or the system default when null.
  Future<void> selectVideoInput(RtcMediaDevice? device) async {
    if (device?.id == _selectedVideoInput?.id) return;

    _selectedVideoInput = device;
    notifyListeners();
    await onVideoInputSelected?.call(device);
  }

  void _handleDeviceChange(List<RtcMediaDevice> devices) {
    _hasEnumerated = true;
    _audioInputs = devices.ofKind(RtcMediaDeviceKind.audioInput);
    _audioOutputs = devices.ofKind(RtcMediaDeviceKind.audioOutput);
    _videoInputs = devices.ofKind(RtcMediaDeviceKind.videoInput);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

extension on List<RtcMediaDevice> {
  List<RtcMediaDevice> ofKind(RtcMediaDeviceKind kind) =>
      where((device) => device.kind == kind).toList(growable: false);
}
