# Lobby unification: `LobbyActions`, breakpoints, one lobby for SDK + dogfooding

The two lanes are called **controls** (icon buttons that toggle mic/camera) and
**settings** (select inputs that pick a device) throughout.

## Context

There are two lobbies in this repo and they overlap badly.

`StreamLobbyView` (SDK, [lobby_view.dart](packages/stream_video_flutter/lib/src/call_screen/lobby_view.dart)) fetches the call, shows who is already in it, and hardcodes a
`Column` of headings + `StreamLobbyVideo` + a Material `ElevatedButton`. It has **no device
pickers at all**.

`LobbyScreen` (dogfooding, [lobby_screen.dart](dogfooding/lib/screens/lobby_screen.dart)) re-implements the outer screen from scratch, embeds the same
`StreamLobbyVideo`, and adds the parts the SDK lacks — device pickers
([lobby_device_controls.dart](dogfooding/lib/widgets/lobby_device_controls.dart)) and a background-blur toggle — through
`additionalActionsBuilder`. It does **not** show participants already in the call.

Neither matches the current Figma, which specifies two distinct control groups and a
layout that changes with screen size. Neither has any notion of a breakpoint — nothing in
this repo or in `stream_core_flutter` does.

Three things the lobby needs are not lobby-specific, and each is built once here:

- **The call control button carries too many meanings.** `CallControlState` has five
  values ([call_control_option.dart:77](packages/stream_video_flutter/lib/src/call_controls/call_control_option.dart:77)) that conflate two different components in
  Figma: a control that is on/off/destructive (mic, camera, accept, decline) and a
  feature that is selected or not (screen share, captions, recording, and the members
  and chat panels). They split into `CallControlButton` and `CallFeatureButton`.
- **Device pickers need shared logic.** The split button on a toggle's caret and the
  select input in the settings lane pick from the same lists and write the same
  selection. That belongs in one controller, not duplicated per widget.
- **A menu is an anchored popup on desktop and a bottom sheet on phones.** Both device
  widgets need that choice, and so will the participants list and any future overflow
  menu, so it is one adaptive component rather than a branch inside each widget.

**Outcome:** one `StreamLobbyView` in the SDK that takes a `LobbyActions(controls, settings)`
value describing which controls to show, lays them out per the design's breakpoints, and
is complete enough that dogfooding uses it directly with two extra buttons.

### What the design actually says

Figma — [Lobby page](https://www.figma.com/design/BJppI3JYlPy3XeEu5MZY1E/SDK-Design-System?node-id=27259-7637), three variants (`Default` / `Mic & Camera Off` / `Error`):

| Variant | Node | Controls | Settings |
|---|---|---|---|
| `Mobile / Lobby` | `27259:7636` | **below** the feed | none |
| `Web / Lobby`, `Size=sm` (368px) | `27259:8382` | **below** the feed | mic + camera select row |
| `Web / Lobby`, `Size=lg` (640px) | `27259:7963` | **overlaid** bottom-center on the feed | mic + camera select row |

Geometry, resolved to core tokens:

- Root `Column`, gap `spacing.xxl` (32).
- Preview block `Column`, gap `spacing.sm` (12) small / `spacing.md` (16) large.
- Tile: `radius.xxl` (20), 2px `accentPrimary` border, aspect `370/264` small, `640×360` large.
- Overlaid controls sit ~14px above the tile's bottom edge, i.e. just clear of the
  participant-label toolbar band (56px tall).
- Control row: centered, gap `spacing.xs` (8), 40px circular buttons.
- Settings row: two `Expanded` fields, gap `spacing.xs` (8).
- The `Error` variant is a `StreamErrorBadge` on the button's top-end corner — `CallControlOption`
  already does exactly this in `_MaybeBadged` ([call_control_option.dart:53](packages/stream_video_flutter/lib/src/call_controls/call_control_option.dart:53)).

The two button components, read through the Figma MCP:

| Component | Variant | Tokens |
|---|---|---|
| [Call Control Button](https://www.figma.com/design/BJppI3JYlPy3XeEu5MZY1E/SDK-Design-System?node-id=26493-62595) `26493:62595` | `Turned Off=False` | `button/secondary/bg` `#ebeef1`, `button/secondary/text` `#1a1b25` |
| | `Turned Off=True` | `button/destructive/bg` `#d90d10`, `text/on-accent` `#ffffff` |
| [Call Feature Button](https://www.figma.com/design/BJppI3JYlPy3XeEu5MZY1E/SDK-Design-System?node-id=27617-118948) `27617:118948` | `Selected=False` | `button/secondary/bg` `#ebeef1` |
| | `Selected=True` | `button/primary/bg` `#005fff`, `button/primary/text-on-accent` `#ffffff` |
| | `State=Disabled` | `background/utility/disabled` `#ebeef1`, `text/disabled` `#a3acba` |

Both are `button/visual-height/md` (40) with a 48px hit target and a `icon/size/md` (20)
icon — i.e. `StreamButton.icon` at `StreamButtonSize.medium`, which is what
`CallControlOption` already renders. The difference that matters: a **selected feature**
is accent **blue**, while a **turned-off control** is destructive **red**. One widget
with a union state cannot express both without lying about one of them.

The Call Control Button component set also has a **`Split Button` variant property**
([27130:105808](https://www.figma.com/design/BJppI3JYlPy3XeEu5MZY1E/SDK-Design-System?node-id=27130-105808)): an 88×48 visual of two 32px halves with a 1px separator. That is
precisely `StreamSplitButton.icon` from core, so the "regular" preset is a design variant,
not an invention.

Breakpoints — [Chat SDK Design, Screen Sizing](https://www.figma.com/design/Us73erK1xFNcB5EH3hyq6Y/Chat-SDK-Design?node-id=64-655): `< 768px` / `768–1279px` / `≥ 1280px`.

### Decisions taken

- **medium behaves like large** — controls overlay the feed at ≥768px, sit below it under 768px.
- **Layout adapts, the preset does not.** `StreamScreenSize` stays and drives the view's
  own layout, but `StreamLobbyView.actions` defaults to `LobbyActions.simple()` at every
  width. Choosing a richer preset for a wider window is a host decision, demonstrated in
  dogfooding rather than baked into the SDK.
- **The bottom sheet on Android and iOS is a platform contract, not a parameter.** Every
  menu the lobby opens picks its own presentation; no call site branches on platform.
- **`CallControlOption` is kept as a deprecated shim** with exactly the API it has on
  `v2` (`icon`, `state`, `onPressed`), delegating to the new buttons, so nothing outside
  this repo breaks at once.
- **Only `context.streamIcons`.** No `Icons.*` from Material and no bare `StreamIcons`
  from this repo's own three-icon class survive in the code this plan touches.
- **Migrate the lobby theme** to the `@themeGen` pattern.
- **Participants button opens a list**, and lives in the SDK so any preset can use it.
- **Break freely.** This is the v2 branch; changes go under `## Upcoming (next major)`
  with a `### ⚠️ Breaking` heading. Compare against `v2`, not `main`.

---

## Checklist

- [x] Plan written and committed
- [x] Phase 1 — `StreamScreenSize` breakpoints
- [x] Phase 2 — `CallControlButton` + `CallFeatureButton`, icons off Material
- [x] Phase 3 — `StreamAdaptiveMenuAnchor`
- [ ] Phase 4 — `StreamMediaDevicesController`, `StreamLobbyController`, `StreamLobbyScope`
- [ ] Phase 5 — control and setting widgets
- [ ] Phase 6 — `LobbyActions` and its presets
- [ ] Phase 7 — `StreamLobbyView` rewrite, `StreamLobbyVideo` absorbed
- [ ] Phase 8 — lobby theme migrated to `@themeGen`
- [ ] Phase 9 — dogfooding uses the SDK lobby directly
- [ ] Phase 10 — tests, goldens, changelog

Commit after each phase (no push), per the repo convention.

---

## Phase 1 — breakpoints

**New:** `packages/stream_video_flutter/lib/src/utils/screen_size.dart`, exported from the
barrel next to the existing `device_segmentation.dart` (which is platform-based, not
size-based — the two are complementary, keep both).

```dart
enum StreamScreenSize {
  small,   // < 768
  medium,  // 768 – 1279
  large;   // >= 1280

  static const smallMaxWidth = 768.0;
  static const mediumMaxWidth = 1280.0;

  static StreamScreenSize fromWidth(double width) => switch (width) {
    < smallMaxWidth => .small,
    < mediumMaxWidth => .medium,
    _ => .large,
  };

  bool get isSmall => this == .small;
}

extension StreamScreenSizeContext on BuildContext {
  StreamScreenSize get streamScreenSize =>
      StreamScreenSize.fromWidth(MediaQuery.sizeOf(this).width);
}
```

Off `MediaQuery.sizeOf` — a breakpoint is a property of the window, and using the widget's
own constraints would make an embedded lobby report `small` on a desktop. Widget test only,
no golden.

Note for Phase 10: because this reads `MediaQuery`, a golden that wants a particular
breakpoint has to override `MediaQuery.size`; sizing the alchemist surface alone does not
move it.

---

## Phase 2 — the call control button splits in two

`CallControlState` currently carries five values that mean three different things
([call_control_option.dart:77](packages/stream_video_flutter/lib/src/call_controls/call_control_option.dart:77)): a semantic tone (`on`/`off`/`positive`/`negative`), a
selection (`positive` doing double duty for "screen share is active"), and an error
condition (`disabled`, which is really "destructive plus a badge" and has nothing to do
with the button being non-interactive).

This phase lands before the lobby widgets because they are built on the result, and it
touches the whole `call_controls/` tree, so it is worth committing on its own.

**New:** `src/call_controls/call_control_button.dart`

```dart
/// The tone of a call control: mic, camera, accept, decline, leave.
enum CallControlState { positive, neutral, negative }

class CallControlButton extends StatelessWidget {
  const CallControlButton({
    super.key,
    required this.icon,
    this.state = .neutral,
    this.showErrorBadge = false,
    this.onPressed,
  });
}
```

`neutral -> .secondary`, `negative -> .destructive`, `positive -> .primary` under the
local `StreamButtonTheme` override that repaints `primary.solid.backgroundColor` with
`colorScheme.accentSuccess` — lifted verbatim from
[call_control_option.dart:25-34](packages/stream_video_flutter/lib/src/call_controls/call_control_option.dart:25), so `positive` stays green.

`showErrorBadge` is orthogonal to the tone and reuses `_MaybeBadged`
([call_control_option.dart:53](packages/stream_video_flutter/lib/src/call_controls/call_control_option.dart:53)). A button that genuinely cannot be pressed is
`onPressed: null`, which `StreamButton` already renders as disabled.

**New:** `src/call_controls/call_feature_button.dart`

```dart
/// A feature that is off by default and prominent when on: screen share,
/// closed captions, recording, the members and chat panels.
class CallFeatureButton extends StatelessWidget {
  const CallFeatureButton({
    super.key,
    required this.icon,
    this.selected = false,
    this.showErrorBadge = false,
    this.onPressed,
  });
}
```

`selected ? .primary : .secondary`, and **no** `accentSuccess` override — selected is the
accent blue Figma specifies. That single difference is why these are two widgets.

### The deprecated shim

`src/call_controls/call_control_option.dart` keeps `CallControlOption` with the API it
has on `v2` — `icon`, `state`, `onPressed` — under
`@Deprecated('Use CallControlButton or CallFeatureButton instead.')`. The five old values
move to a `CallControlOptionState` declared in the same file, so the name
`CallControlState` is free for the three-value enum. The shim's `build` delegates:

| `CallControlOption(state:)` | delegates to |
|---|---|
| `.on` | `CallControlButton(state: .neutral)` |
| `.off` | `CallControlButton(state: .negative)` |
| `.positive` | `CallControlButton(state: .positive)` |
| `.negative` | `CallControlButton(state: .negative)` |
| `.disabled` | `CallControlButton(state: .negative, showErrorBadge: true)` |

**No `fix_data.yaml` rename.** The `state` parameter changes type, so a bulk rename would
turn working code into a compile error — the same reasoning already written down for
`StreamCallParticipant` at [fix_data.yaml:6-16](packages/stream_video_flutter/lib/fix_data.yaml:6). The CHANGELOG carries the mapping.

### Re-pointing the call sites

| File | Becomes |
|---|---|
| [toggle_microphone_option.dart:55](packages/stream_video_flutter/lib/src/call_controls/controls/toggle_microphone_option.dart:55), [toggle_camera_option.dart:53](packages/stream_video_flutter/lib/src/call_controls/controls/toggle_camera_option.dart:53) | `CallControlButton(state: enabled ? .neutral : .negative)` |
| [leave_call_option.dart:28](packages/stream_video_flutter/lib/src/call_controls/controls/leave_call_option.dart:28), [outgoing_call_controls.dart:58](packages/stream_video_flutter/lib/src/call_screen/outgoing_call/outgoing_call_controls.dart:58) | `CallControlButton(state: .negative)` |
| [incoming_call_controls.dart:48,:53](packages/stream_video_flutter/lib/src/call_screen/incoming_call/incoming_call_controls.dart:48) | `.negative` decline, `.positive` accept |
| [toggle_screen_sharing_option.dart:65](packages/stream_video_flutter/lib/src/call_controls/controls/toggle_screen_sharing_option.dart:65) | `CallFeatureButton(selected: enabled)` |
| [toggle_closed_captions_option.dart:50](packages/stream_video_flutter/lib/src/call_controls/controls/toggle_closed_captions_option.dart:50) | `CallFeatureButton(selected: enabled)` |
| [toggle_recording_option.dart:50](packages/stream_video_flutter/lib/src/call_controls/controls/toggle_recording_option.dart:50) | `CallFeatureButton(selected: enabled)` |
| `add_reaction_option`, `flip_camera_option`, `toggle_speakerphone_option`, `toggle_layout_option` | `CallControlButton` (neutral) |
| [call_screen.dart:289](dogfooding/lib/screens/call_screen.dart:289) | `CallFeatureButton(selected: _moreMenuVisible)` |

`toggle_screen_sharing_option` is the clearest win: it currently says
`enabled ? .positive : .on`, painting an active screen share **green** where Figma wants
accent blue.

`toggle_speakerphone_option` and `toggle_layout_option` stay neutral controls — they cycle
through modes rather than being off-by-default features, and neither passes a state today.

### Icons come off Material

Every icon in the files this phase touches resolves from `context.streamIcons`. The
per-widget icon parameters currently default to Material constants in the constructor
([toggle_microphone_option.dart:15](packages/stream_video_flutter/lib/src/call_controls/controls/toggle_microphone_option.dart:15) and friends); those defaults become `null` and are
resolved in `build`, because a `context.streamIcons` lookup needs a context and so cannot
be a constructor default.

| Was | Becomes |
|---|---|
| `Icons.mic_rounded` / `Icons.mic_off_rounded` | `voiceFill` / `voiceOffFill` |
| `Icons.videocam_rounded` / `Icons.videocam_off_rounded` | `videoFill` / `videoOffFill` |
| `Icons.call_end_rounded` | `phoneDownFill` |
| `Icons.call_rounded` | `phoneFill` |
| `Icons.screen_share` / `Icons.stop_screen_share` | `presentDesktopFill` |
| `Icons.closed_caption_rounded` / `..._disabled_rounded` | `captionFill` |
| `Icons.video_file_outlined` / `Icons.video_file_rounded` | `recordingFill` / `recordingStopFill` |
| `Icons.flip_camera_ios_rounded` | `cameraFlipFill` |
| `Icons.add_reaction_outlined` | `emojiAddFill` |
| `Icons.volume_up_rounded` / `Icons.volume_off_rounded` | `audio` / `mute` |
| `StreamIcons.grid` / `StreamIcons.spotlight` | `gridFill` / `speakerLeftFill` |

That empties `src/theme/stream_icons.dart` of its only two consumers
([toggle_layout_option.dart:39-40](packages/stream_video_flutter/lib/src/call_controls/controls/toggle_layout_option.dart:39)), so the class and its bundled font are deprecated
here and dropped. Remember the barrel trap from `CLAUDE.md`: a bare `StreamIcons` is this
repo's class, `context.streamIcons` is core's.

Sweep the rest of the SDK in the same commit, since it is mechanical and leaves no
Material icons behind: `livestream_info.dart`, `livestream_speakerphone_option.dart`,
`overlay_app_bar.dart`, `call_app_bar.dart`, `screen_share_call_participants_content.dart`,
`call_participants_grid_view.dart:293,:312`, `call_diagnostics_content.dart`. Use
`eyeFill`, `fullscreenFill`, `arrowLeft`, `chevronLeft` / `chevronRight`, `share`, `xmark`.

---

## Phase 3 — the adaptive menu

**New:** `src/widgets/design_system_candidates/stream_adaptive_menu_anchor.dart`, next to
`StreamContextMenuAnchor`. Deliberately generic over "sections of single-choice options"
rather than device-specific, so the participants list and any future overflow menu reuse
it.

```dart
class StreamMenuOption {
  const StreamMenuOption({
    required this.label,
    required this.selected,
    required this.onSelected,
  });
}

class StreamMenuSection {
  const StreamMenuSection({required this.heading, required this.options});
}

/// Opens [sections] as an anchored context menu on desktop and web, and as a
/// bottom sheet on Android and iOS, where a popup anchored to a 32px caret is
/// awkward to hit and out of place.
class StreamAdaptiveMenuAnchor extends StatefulWidget {
  const StreamAdaptiveMenuAnchor({
    super.key,
    required this.sections,
    required this.builder,   // (BuildContext, StreamMenuHandle) -> Widget
    this.title,              // sheet header title; unused by the anchored menu
    this.useSheet,           // null -> CurrentPlatform.isAndroid || CurrentPlatform.isIos
  });
}
```

`StreamMenuHandle` exposes `isOpen`, `open()`, `close()` and `toggle()`. That is the whole
contract: the split button's caret and the select input's body pass the same `builder` and
neither knows which presentation it got. `useSheet` is an escape hatch for tests and
embedders, not a knob the lobby sets.

- **Anchored branch** — today's `_DeviceMenuAnchor` body, moved from dogfooding:
  `StreamContextMenuAnchor` + `StreamContextMenuAction.sectioned` +
  `StreamContextMenuHeading` + `StreamRadioIndicator`
  ([lobby_device_controls.dart:213-238](dogfooding/lib/widgets/lobby_device_controls.dart:213)). Keep the comment at
  [:205](dogfooding/lib/widgets/lobby_device_controls.dart:205): a `MenuAnchor` overlay is not a `PopupRoute`, so
  `StreamContextMenuAction` does not pop and `MenuController.close()` has to be called by
  hand.
- **Sheet branch** — core's `showStreamSheet` (`components/sheet/stream_sheet.dart:165`,
  exported from `core.dart:57`) with a `StreamSheetHeader(title:)` and one
  `StreamListTile(selected:, leading: StreamRadioIndicator(...), title: Text(label),
  onTap:)` per option. `StreamListTile` is exported from `core.dart:54` and already has a
  `selected` prop. Headings reuse `StreamContextMenuHeading`. `Navigator.pop` closes it,
  so none of the manual controller dance applies.

`isOpen` has to be true for both branches, because `StreamSelectInput.expanded` draws the
caret rotation off it and the field would otherwise look shut while a sheet is up.

---

## Phase 4 — the device controller, the lobby controller and the scope

This is the load-bearing change. `LobbyActions` hands `List<Widget>` to the view, so the
action widgets cannot receive callbacks through their constructors — they have to read
state from context. Everything currently split across `_StreamLobbyVideoState`,
`_LobbyScreenState` and `_LobbyDeviceControlsState` moves into two objects.

**New:** `src/call_screen/media_devices_controller.dart`

```dart
/// Loads the available input and output devices and remembers which one is
/// picked. Shared by every widget that offers a device choice — the split
/// button on a toggle's caret and the select input in the settings lane read
/// and write the same instance.
class StreamMediaDevicesController extends ChangeNotifier {
  StreamMediaDevicesController({
    RtcMediaDeviceNotifier? deviceNotifier,   // defaults to .instance
    this.onAudioInputSelected,                // Future<void> Function(RtcMediaDevice?)?
    this.onAudioOutputSelected,
    this.onVideoInputSelected,
  });

  List<RtcMediaDevice> get audioInputs;
  List<RtcMediaDevice> get audioOutputs;
  List<RtcMediaDevice> get videoInputs;

  RtcMediaDevice? get selectedAudioInput;     // null == system default
  RtcMediaDevice? get selectedAudioOutput;
  RtcMediaDevice? get selectedVideoInput;

  Future<void> selectAudioInput(RtcMediaDevice? device);
  Future<void> selectAudioOutput(RtcMediaDevice? device);
  Future<void> selectVideoInput(RtcMediaDevice? device);
}
```

The three `on*Selected` hooks are what make it reusable: the controller owns *which device
is picked*, its owner supplies *what picking it does*. `StreamLobbyController` passes its
camera restart into `onVideoInputSelected`; an in-call caller would pass the equivalent on
`Call`. Widgets only ever call `controller.selectVideoInput(...)`, which is what makes the
split button and the select input interchangeable.

Discovery is lifted from `_LobbyDeviceControlsState`
([lobby_device_controls.dart:56-96](dogfooding/lib/widgets/lobby_device_controls.dart:56)): subscribe to
`RtcMediaDeviceNotifier.onDeviceChange`, kick `enumerateDevices()` on construction,
partition by `RtcMediaDeviceKind`. Carry the note at [:124](dogfooding/lib/widgets/lobby_device_controls.dart:124) about platforms that route
audio themselves reporting no outputs — with the caveat that `RtcMediaDeviceNotifier`
synthesises an iOS earpiece output
([rtc_media_device_notifier.dart:247](packages/stream_video/lib/src/webrtc/rtc_media_device/rtc_media_device_notifier.dart:247)), so verify the Speaker section really is
empty on iOS.

**New:** `src/call_screen/lobby_controller.dart`

```dart
class StreamLobbyController extends ChangeNotifier {
  StreamLobbyController({required this.call, StreamVideo? streamVideo});

  /// Device lists and the current selection. Owned and disposed here.
  StreamMediaDevicesController get devices;

  // tracks — logic lifted verbatim from lobby_video.dart:85-128
  RtcLocalAudioTrack? get microphoneTrack;
  RtcLocalCameraTrack? get cameraTrack;
  bool get microphoneEnabled;   // == microphoneTrack != null
  bool get cameraEnabled;
  Future<void> toggleMicrophone();
  Future<void> toggleCamera();

  // last failure per track, drives the Error variant's badge
  Object? get microphoneError;
  Object? get cameraError;

  // labels are only populated once getUserMedia succeeded
  bool get hasMicrophonePermission;
  bool get hasCameraPermission;

  // participants already in the call — lifted from lobby_view.dart:110-166
  List<CallParticipant> get participants;
  Map<String, CallUser> get users;

  CallConnectOptions get connectOptions;
}
```

**New:** `src/call_screen/lobby_scope.dart` — `StreamLobbyScope extends
InheritedNotifier<StreamLobbyController>` with `static StreamLobbyController of(BuildContext)`
and a `maybeOf`. `StreamLobbyView` creates and owns the controller (disposing it in
`dispose`), and accepts an optional `controller` so a host can drive it.

Three things this fixes for free:

1. The camera restart lives in `onVideoInputSelected`, so dogfooding's
   `key: ValueKey(_selectedVideoInputDevice?.id)` hack ([lobby_screen.dart:150](dogfooding/lib/screens/lobby_screen.dart:150)) goes away.
2. The track-ownership contract stays as documented at [lobby_video.dart:36-50](packages/stream_video_flutter/lib/src/call_screen/lobby_video.dart:36) —
   but now the controller is the single owner and `connectOptions` can hand warmed tracks
   over as `TrackOption.provided`, which `StreamLobbyView` never did.
3. `connectOptions` sets `audioInputDevice` / `audioOutputDevice` / `videoInputDevice` from
   `devices`, which the SDK lobby currently drops on the floor ([lobby_view.dart:73-89](packages/stream_video_flutter/lib/src/call_screen/lobby_view.dart:73)).

Unit-test both controllers against mocked `Call` / `RtcMediaDeviceNotifier` (extend
`test/src/mocks.dart`); the notifier already has a `@visibleForTesting` setter.

---

## Phase 5 — the control and setting widgets

**New:** `src/call_screen/lobby_actions/`. Every widget here reads `StreamLobbyScope.of(context)`
and takes no state in its constructor.

| Widget | Lane | Renders |
|---|---|---|
| `StreamLobbyMicrophoneToggle` | controls | `CallControlButton`, `state: enabled ? .neutral : .negative`, `showErrorBadge` on error |
| `StreamLobbyCameraToggle` | controls | same, camera |
| `StreamLobbyMicrophoneSplitButton` | controls | `StreamSplitButton.icon`; the caret opens a `StreamAdaptiveMenuAnchor` |
| `StreamLobbyCameraSplitButton` | controls | same, camera |
| `StreamLobbyParticipantsControl` | controls | `StreamButton.icon(icons.usersFill)` in a `StreamBadgeNotification`, opens the participant list |
| `StreamLobbyMicrophoneSelect` | settings | `StreamSelectInput` inside a `StreamAdaptiveMenuAnchor` (Microphone + Speaker sections) |
| `StreamLobbyCameraSelect` | settings | same, Camera section |

The split button and the select input are two anchors over **one** set of sections, built
once from `StreamLobbyScope.of(context).devices`. Neither owns list state, neither owns
selection, and neither knows whether it will show a popup or a sheet — that is the point
of Phases 3 and 4.

Reuse, don't rewrite:

- `StreamSelectInput`, `StreamContextMenuAnchor`, `StreamContextMenuHeading`,
  `StreamRadioIndicator` — already in `src/widgets/design_system_candidates/`.
- `StreamErrorBadge` / `StreamBadgeNotification` / `StreamAvatarStack` from core, all exported
  from `core.dart`. `StreamBadgeNotification` overlays its own `child` at `topEnd`; there is
  no green type, so the participants badge needs a `StreamBadgeNotificationTheme` with
  `primaryBackgroundColor: accentSuccess` — the same override trick `CallControlButton`
  uses for `StreamButtonTheme`.

**`StreamSplitButton` is `@experimental` and is not exported from `core.dart`** — only
from `package:stream_core_flutter/video.dart`, which the video barrel does not re-export.
The two split-button files need an explicit `import 'package:stream_core_flutter/video.dart';`
and `// ignore_for_file: experimental_member_use`.

`StreamSelectInput` has no size variant; it implements the large/mobile density (16/12
padding, 20px icon, 16px text) and its dartdoc deliberately justifies that over the denser
web spec. **Use it as-is at every breakpoint** and leave the compact web density as a
separate follow-up — adding a size enum is a design-system change, not a lobby change.

---

## Phase 6 — `LobbyActions`

**New:** `src/call_screen/lobby_actions.dart`

```dart
class LobbyActions {
  const LobbyActions.custom({this.controls = const [], this.settings = const []});

  /// Mic + camera toggles, no device pickers.
  LobbyActions.simple({
    List<Widget> extraControls = const [],
    List<Widget> extraSettings = const [],
  })  : controls = [
          const StreamLobbyMicrophoneToggle(),
          const StreamLobbyCameraToggle(),
          ...extraControls,
        ],
        settings = [...extraSettings];

  /// A caret on each toggle for picking the device.
  LobbyActions.regular({
    List<Widget> extraControls = const [],
    List<Widget> extraSettings = const [],
  }) ...

  /// Toggles plus a row of select inputs.
  LobbyActions.full({
    List<Widget> extraControls = const [],
    List<Widget> extraSettings = const [],
  }) ...

  /// Icon buttons that toggle the microphone and camera.
  final List<Widget> controls;

  /// Select inputs that pick which device to use.
  final List<Widget> settings;
}
```

Every preset takes **both** extension points, so a host adds one field or one button
without respelling the whole preset. `.simple`'s settings lane is empty by default but no
longer forced empty. A lane renders nothing when its list ends up empty, so
`.simple()` still draws no settings row.

The presets cannot be `const` because they splice the extras; only `.custom` is.

---

## Phase 7 — rewrite `StreamLobbyView`

`StreamLobbyVideo` is absorbed: its track logic moves to the controller and its rendering
becomes a private `_LobbyPreview` inside the view. Delete
`src/call_screen/lobby_video.dart` and drop its barrel export ([stream_video_flutter.dart:52](packages/stream_video_flutter/lib/stream_video_flutter.dart:52)).

New constructor:

```dart
StreamLobbyView({
  required Call call,
  required ValueSetter<CallConnectOptions> onJoinCallPressed,
  LobbyActions? actions,        // null -> LobbyActions.simple(), at every width
  VoidCallback? onCloseTap,
  Widget? title,
  Widget? joinButtonLabel,
  StreamLobbyController? controller,
  StreamVideo? streamVideo,
});
```

`cardBackgroundColor`, `userAvatarTheme`, `participantAvatarTheme`, `backgroundColor` and
`additionalActionsBuilder` are removed — appearance moves to the theme, extra buttons move
to `LobbyActions`.

Layout — the breakpoint drives geometry only, never which actions exist:

```
StreamLobbyScope
└ Column(spacing: spacing.xxl)
  ├ preview block  Column(spacing: isSmall ? spacing.sm : spacing.md)
  │  ├ Stack
  │  │  ├ tile: AspectRatio(370/264) small, 640×360 large;
  │  │  │        radius.xxl, 2px accentPrimary border, VideoTrackRenderer
  │  │  │        or StreamUserAvatar placeholder, StreamParticipantLabel bottom-start
  │  │  └ if (!isSmall && controls.isNotEmpty)  bottom-center control row
  │  ├ if (isSmall && controls.isNotEmpty)      centered control row
  │  └ if (settings.isNotEmpty)                 Row of Expanded settings
  └ join button — full width small, 400 large
```

Both lanes are omitted entirely when their list is empty, as asked.

Also clean up while here: the hardcoded English at [lobby_view.dart:217-224](packages/stream_video_flutter/lib/src/call_screen/lobby_view.dart:217) and [:251](packages/stream_video_flutter/lib/src/call_screen/lobby_view.dart:251)
moves to `lib/src/l10n/arb/stream_video_flutter_en.arb` (which has no lobby keys today),
and the `ElevatedButton` at [:261](packages/stream_video_flutter/lib/src/call_screen/lobby_view.dart:261) becomes a `StreamButton`.

---

## Phase 8 — theme migration

`src/theme/lobby_view_theme.dart` is legacy: non-nullable fields with hardcoded defaults,
hand-rolled `copyWith`/`lerp`/`==`/`merge`, and a plain `InheritedWidget` whose `of()` does
not merge ([lobby_view_theme.dart:220](packages/stream_video_flutter/lib/src/theme/lobby_view_theme.dart:220)).

Replace with `src/theme/components/lobby_view_theme.dart` following
`participant_label_theme.dart` exactly:

- `StreamLobbyViewThemeData` — `@themeGen @immutable`, one nullable
  `StreamLobbyViewStyle? style`, generated `lerp` in `*.g.theme.dart`.
- `StreamLobbyViewStyle` — every field nullable: `previewBorderRadius`,
  `previewBorderColor`, `previewBorderWidth`, `previewBackgroundColor`,
  `smallAspectRatio`, `largePreviewSize`, `sectionSpacing`, `laneSpacing`,
  `overlayControlInset`, `joinButtonMaxWidth`, `userAvatarTheme`, `participantAvatarTheme`.
- `_StreamLobbyViewStyleDefaults extends StreamLobbyViewStyle` in the widget file, non-null
  getters off `context.streamColorScheme` / `streamSpacing` / `streamRadius`. Type the local
  as the **defaults** class, and never let a defaults instance reach a theme.
- `StreamLobbyViewTheme extends InheritedTheme` with the merging
  `StreamVideoTheme.of(context).lobbyViewTheme.merge(local?.data)` pattern.

Deprecate the old class per convention (`@Deprecated` + a `lib/fix_data.yaml` transform),
and register the new field on `StreamVideoTheme`. Then `melos run generate:flutter`.

`optionOffBackgroundColor` / `optionOffIconColor` are dead — nothing reads them. Drop them.

Also fix [lobby_participants_view.dart:21-23](packages/stream_video_flutter/lib/src/call_screen/lobby_participants_view.dart:21), which reads the legacy
`StreamVideoTheme.of(context).textTheme/colorTheme` instead of the context accessors.

---

## Phase 9 — dogfooding

`LobbyScreen` becomes a thin wrapper. Delete
[lobby_device_controls.dart](dogfooding/lib/widgets/lobby_device_controls.dart) entirely — it now lives in the SDK.

```dart
// A demo of picking a preset for the window, not something the SDK does for you:
// StreamLobbyView defaults to LobbyActions.simple() at every width.
final size = context.streamScreenSize;

StreamLobbyView(
  call: widget.call,
  onJoinCallPressed: (options) =>
      widget.onJoinCallPressed(options, _videoEffectsManager),
  actions: switch (size) {
    .small => LobbyActions.regular(extraControls: extras),
    _ => LobbyActions.full(extraControls: extras),
  },
)
```

where `extras` is `[const StreamLobbyParticipantsControl(), _BlurToggle(...)]` — the
participants button from the second screenshot, and the blur toggle currently injected
through `additionalActionsBuilder` ([lobby_screen.dart:176-206](dogfooding/lib/screens/lobby_screen.dart:176)). The blur toggle keeps
needing `_videoEffectsManager` and the current camera track; it reads the track from
`StreamLobbyScope.of(context).cameraTrack` and re-applies on change by listening to the
controller, replacing the `onCameraTrackSet` hook at [:169-174](dogfooding/lib/screens/lobby_screen.dart:169). It becomes a
`CallFeatureButton(selected: _blurEnabled)`, which is exactly the case Phase 2 introduced
that class for.

On Android and iOS the caret and the select input open bottom sheets with no code here
saying so — that is Phase 3 doing its job.

The dogfooding app bar (avatar + name + leave) stays in `LobbyScreen`; `StreamLobbyView`
provides the body. Drop the unused `flutter_svg` / `assets.dart` imports and the unread
`StreamLobbyViewTheme.of(context)` at [:104](dogfooding/lib/screens/lobby_screen.dart:104). Update the theme override in
[app_content.dart:368-382](dogfooding/lib/app/app_content.dart:368) to the new theme data.

---

## Phase 10 — tests and changelog

### Lobby goldens — every variant at every breakpoint

New `test/src/call_screen/lobby_view_golden_test.dart` with `goldens/{ci,macos}/`. **One
golden group per `LobbyActions` preset**, each swept across the three screen sizes, light
and dark:

| Group | Preset | Widths |
|---|---|---|
| `lobby_view_simple` | `LobbyActions.simple()` | 375, 900, 1440 |
| `lobby_view_regular` | `LobbyActions.regular()` | 375, 900, 1440 |
| `lobby_view_full` | `LobbyActions.full()` | 375, 900, 1440 |

That is 3 presets × 3 widths × 2 brightnesses. The sweep is what proves the two
independent axes really are independent: the preset decides *which* widgets exist, the
width decides *where* the control row sits and how big the tile is — a `simple` lobby at
1440 must still overlay its controls, and a `full` lobby at 375 must still stack them
below the feed and keep its settings row.

Two mechanics to get right, both easy to get wrong:

- `StreamScreenSize` reads `MediaQuery.sizeOf`, so each case wraps the subject in a
  `MediaQuery` with the target `size`. Sizing the alchemist surface alone leaves the view
  reporting whatever the test surface says and every case snapshots identically.
- `StreamLobbyView` must **not** build its own `Scaffold` — it asserts under unbounded
  golden constraints. The view returns a bare column; dogfooding supplies the `Scaffold`.

Drive them from a fake `StreamLobbyController` so the goldens do not need a live `Call`,
a real `RtcMediaDeviceNotifier`, or a video track: seed it with a fixed device list, a
fixed selection and a fixed participant list so the snapshots are deterministic.

### Everything else

- Goldens for `CallControlButton` (all three states, plus `showErrorBadge` and
  `onPressed: null`) and `CallFeatureButton` (selected/unselected × enabled/disabled).
  Neither sits in an `Overlay`, so both snapshot fine.
- Widget test for `StreamAdaptiveMenuAnchor`: under `TargetPlatform.android` opening the
  handle pushes a `StreamSheetRoute` and shows a `StreamListTile` per option; under
  `.macOS` it opens a `MenuAnchor` overlay with `StreamContextMenuAction`s. Assert with
  `expect`, not goldens — the CI capture path drops `Overlay` content, and a sheet
  snapshots blank the same way.
- Widget test that `StreamLobbyMicrophoneSplitButton` and `StreamLobbyMicrophoneSelect`
  driven by the same `StreamMediaDevicesController` both reflect a selection made through
  the other. That is the shared-logic requirement, asserted rather than assumed.
- Unit tests for `StreamMediaDevicesController` (enumeration, partitioning, the
  `on*Selected` hooks firing) and `StreamLobbyController` (toggles, `connectOptions`).
- Widget test for `StreamScreenSize`.
- Regenerate committed goldens by dispatching the `update_goldens` workflow from this
  branch, not locally.
- `melos bootstrap` is not needed (no pubspec change); run `melos run generate:flutter`,
  `melos run analyze`, `melos run format`, `melos run test:all`.
- `packages/stream_video_flutter/CHANGELOG.md` under `## Upcoming (next major)`:
  - `### ✅ Added` — `CallFeatureButton`, `LobbyActions`, `StreamLobbyController`,
    `StreamMediaDevicesController`, `StreamAdaptiveMenuAnchor`, `StreamScreenSize`, the
    device pickers.
  - `### ⚠️ Breaking` — `CallControlState` drops to three values, with the migration
    table from Phase 2 spelled out; `StreamLobbyVideo` removed; `StreamLobbyView`
    constructor changed.
  - `### ⚠️ Deprecated` — `CallControlOption`, `CallControlOptionState`, this repo's
    `StreamIcons`, the old lobby theme.

Commit after each phase (no push), per the repo convention.

---

## Verification

1. `melos run analyze` clean, `melos run test:all` green.
2. `grep -rn 'Icons\.' packages/stream_video_flutter/lib | grep -v streamIcons` returns
   nothing, and `StreamIcons.` appears only in the deprecated class itself.
3. Run dogfooding on macOS or Chrome — wide window shows toggles overlaid on the feed plus
   the two select inputs; the participants badge shows a count when a second client joins
   the same call; picking a camera swaps the preview without re-enabling a disabled camera;
   both the caret and the select input open the anchored menu.
4. Resize the window below 768px — the toggles drop below the feed, the settings row stays.
5. Run dogfooding on an iOS simulator and an Android emulator — `regular` preset, split
   buttons, and the caret **and** the select input both open a bottom sheet with a drag
   handle and the same radio rows. No Speaker section if the platform reports no outputs.
6. Turn on screen share, closed captions and recording — each turns accent **blue**, while
   a muted mic and a disabled camera stay **red**, and the decline button stays red while
   accept stays green.
7. Join from the lobby and confirm the chosen mic/speaker/camera are the ones in use in the
   call, and that the mic/camera do not visibly restart on join (tracks handed over as
   `TrackOption.provided`).
8. Toggle blur in the lobby and confirm it survives a camera device switch and carries into
   the call.

## Open follow-ups (not in this plan)

- A compact/web density for `StreamSelectInput` (12/8 padding, 16px icon, 14px text).
- Graduating `StreamSplitButton` out of `@experimental` in core, and the
  `design_system_candidates/` widgets — `StreamAdaptiveMenuAnchor` included — into core.
- An in-call device switcher built on `StreamMediaDevicesController`, replacing
  dogfooding's `settings_menu/audio_output_menu_item.dart`.
