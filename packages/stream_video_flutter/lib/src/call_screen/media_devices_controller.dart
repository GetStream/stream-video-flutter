import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../stream_video_flutter.dart';

/// Applies a device the user picked. See
/// [StreamMediaDevicesController.onVideoInputSelected].
///
/// Throw to reject the selection: the controller puts the previous one back
/// and notifies, so a picker never claims a device the hardware refused.
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
    this.supportsSystemDefault = true,
  }) : _deviceNotifier = deviceNotifier ?? RtcMediaDeviceNotifier.instance {
    _subscription = _deviceNotifier.onDeviceChange.listen(_handleDeviceChange);
    // The notifier replays its last enumeration to a new listener, but only
    // once it has run one; this kicks the first.
    unawaited(_enumerate());
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
    // A Failure here means the call kept the device it had — a moderation
    // block, a missing send permission, a device another process grabbed — so
    // it is thrown to put the picker back where it was rather than leaving it
    // pointing at a device the call is not using.
    Future<void> apply(
      RtcMediaDevice? device,
      Future<Result<None>> Function(RtcMediaDevice) set,
    ) async {
      // Call has no "revert to the system default" setter, which is why
      // supportsSystemDefault is false below and no such row is offered.
      if (device == null) return;

      final result = await set(device);
      if (result case Failure(:final error)) {
        throw StateError('could not switch to ${device.id}: $error');
      }
    }

    return StreamMediaDevicesController(
      // Whatever the call is already running on is not knowable from here, so
      // the row for it is left out rather than shown wrongly.
      supportsSystemDefault: false,
      deviceNotifier: deviceNotifier,
      onAudioInputSelected: (device) => apply(device, call.setAudioInputDevice),
      onAudioOutputSelected: (device) =>
          apply(device, call.setAudioOutputDevice),
      onVideoInputSelected: (device) => apply(device, call.setVideoInputDevice),
    );
  }

  late final _logger = taggedLogger(tag: 'SV:MediaDevicesController');

  /// Runs the first enumeration, keeping hold of why it failed.
  ///
  /// The notifier only emits on the paths that found something, so a failure
  /// never reaches [_handleDeviceChange]: without this the lists would stay
  /// empty, [hasEnumerated] false, every picker inert, and nothing anywhere
  /// would say why.
  Future<void> _enumerate() async {
    final result = await _deviceNotifier.enumerateDevices();
    result.fold(
      onSuccess: (_) {},
      onFailure: (error, stackTrace) {
        if (_disposed) return;

        _logger.e(
          () => 'Could not list the available devices: $error\n$stackTrace',
        );
        _enumerationError = error;
        _hasEnumerated = true;
        notifyListeners();
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

  /// Whether a null selection — "let the platform pick" — can be applied.
  ///
  /// False where the owner has no way to hand control back, as a call does
  /// not: its device setters take a device. A menu built over such a
  /// controller leaves the system-default row out instead of offering a choice
  /// that would move the radio button without changing anything.
  final bool supportsSystemDefault;

  /// The id a platform gives the device it has picked for itself.
  ///
  /// Web reports one — Chrome lists it as "Default - <name>" — alongside the
  /// real devices, and it is a device like any other: picking it is what
  /// asking for the platform's choice looks like there. Platforms that report
  /// no such entry leave [selectedAudioInput] and its siblings null until
  /// something is picked.
  static const platformDefaultDeviceId = 'default';

  bool _hasEnumerated = false;
  bool _disposed = false;

  Object? _enumerationError;

  /// Why the platform could not be asked for its devices, or null.
  ///
  /// Distinct from an empty device list: the platform found nothing versus the
  /// platform could not be asked. A picker that is inert because of this
  /// should say so rather than blame permissions.
  Object? get enumerationError => _enumerationError;

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
  ///
  /// Where null cannot be shown — see [supportsSystemDefault] — this resolves
  /// to the platform's own choice instead, so a menu marks the device in use
  /// rather than marking nothing. An in-call menu had every row unselected
  /// until something was picked.
  RtcMediaDevice? get selectedAudioInput =>
      _selectedAudioInput ?? _platformDefaultIn(_audioInputs);

  /// The picked speaker, or null for the system default. As
  /// [selectedAudioInput] is.
  RtcMediaDevice? get selectedAudioOutput =>
      _selectedAudioOutput ?? _platformDefaultIn(_audioOutputs);

  /// The picked camera, or null for the system default. As
  /// [selectedAudioInput] is.
  RtcMediaDevice? get selectedVideoInput =>
      _selectedVideoInput ?? _platformDefaultIn(_videoInputs);

  /// The platform's own choice among [devices], where that is what null has
  /// to mean.
  ///
  /// Null while [supportsSystemDefault]: there the menu draws a row for "let
  /// the platform pick", so resolving null to a device would move the mark off
  /// it. Reflects the platform rather than changing anything — nothing is
  /// applied, because the platform is already using it.
  RtcMediaDevice? _platformDefaultIn(List<RtcMediaDevice> devices) {
    if (supportsSystemDefault) return null;

    for (final device in devices) {
      if (device.id == platformDefaultDeviceId) return device;
    }

    return null;
  }

  /// Picks [device] as the microphone, or the system default when null.
  Future<void> selectAudioInput(RtcMediaDevice? device) => _select(
    device: device,
    current: () => selectedAudioInput,
    assign: (it) => _selectedAudioInput = it,
    apply: onAudioInputSelected,
  );

  /// Picks [device] as the speaker, or the system default when null.
  Future<void> selectAudioOutput(RtcMediaDevice? device) => _select(
    device: device,
    current: () => selectedAudioOutput,
    assign: (it) => _selectedAudioOutput = it,
    apply: onAudioOutputSelected,
  );

  /// Picks [device] as the camera, or the system default when null.
  Future<void> selectVideoInput(RtcMediaDevice? device) => _select(
    device: device,
    current: () => selectedVideoInput,
    assign: (it) => _selectedVideoInput = it,
    apply: onVideoInputSelected,
  );

  /// Commits [device], then applies it.
  ///
  /// Published before the effect runs, so the picker responds to the tap, and
  /// put back if the effect rejects it, so it never names a device the
  /// hardware would not switch to.
  ///
  /// [current] is the resolved selection rather than the raw one, so tapping
  /// the row already marked does nothing — including the platform's own
  /// choice, which is already in use.
  Future<void> _select({
    required RtcMediaDevice? device,
    required RtcMediaDevice? Function() current,
    required void Function(RtcMediaDevice?) assign,
    required StreamMediaDeviceSelected? apply,
  }) async {
    final previous = current();
    if (device?.id == previous?.id) return;

    assign(device);
    notifyListeners();

    try {
      await apply?.call(device);
    } catch (e, stk) {
      _logger.e(() => 'Could not select device ${device?.id}: $e\n$stk');
      if (_disposed) return;

      assign(previous);
      notifyListeners();
    }
  }

  void _handleDeviceChange(List<RtcMediaDevice> devices) {
    _hasEnumerated = true;
    _enumerationError = null;
    _audioInputs = devices.ofKind(RtcMediaDeviceKind.audioInput);
    _audioOutputs = devices.ofKind(RtcMediaDeviceKind.audioOutput);
    _videoInputs = devices.ofKind(RtcMediaDeviceKind.videoInput);

    // A device the user picked can be unplugged. The system default is both
    // what the platform falls back to anyway and something a menu can draw a
    // selected row for, which a device that is gone is not.
    _selectedAudioInput = _stillPresent(_selectedAudioInput, _audioInputs);
    _selectedAudioOutput = _stillPresent(_selectedAudioOutput, _audioOutputs);
    _selectedVideoInput = _stillPresent(_selectedVideoInput, _videoInputs);

    notifyListeners();
  }

  /// [selected] as the list now describes it, or null once it is gone.
  ///
  /// Re-reads it from [available] rather than keeping the instance, so a
  /// device the platform has renamed — a label only arrives after permission —
  /// does not keep the stale one.
  RtcMediaDevice? _stillPresent(
    RtcMediaDevice? selected,
    List<RtcMediaDevice> available,
  ) {
    if (selected == null) return null;

    for (final device in available) {
      if (device.id == selected.id) return device;
    }

    _logger.d(() => 'Picked device ${selected.id} is gone; using the default');
    return null;
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}

extension on List<RtcMediaDevice> {
  List<RtcMediaDevice> ofKind(RtcMediaDeviceKind kind) =>
      where((device) => device.kind == kind).toList(growable: false);
}
