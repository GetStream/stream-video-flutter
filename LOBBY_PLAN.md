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

The Call Control Button component set has a **`Split Button` variant property**
([27130:105808](https://www.figma.com/design/BJppI3JYlPy3XeEu5MZY1E/SDK-Design-System?node-id=27130-105808)): an 80×40 visual of two 32px halves with a 1px / 24px-tall separator. That is
precisely `StreamSplitButton.icon` from core, so the "regular" preset is a design variant,
not an invention.

Breakpoints — [Chat SDK Design, Screen Sizing](https://www.figma.com/design/Us73erK1xFNcB5EH3hyq6Y/Chat-SDK-Design?node-id=64-655): `< 768px` / `768–1279px` / `≥ 1280px`.

### Decisions taken

- **medium behaves like large** — controls overlay the feed at ≥768px, sit below it under 768px.
- **Migrate the lobby theme** to the `@themeGen` pattern.
- **Participants button opens a list**, and lives in the SDK so any preset can use it.
- **Break freely.** This is the v2 branch; changes go under `## Upcoming (next major)`
  with a `### ⚠️ Breaking` heading. Compare against `v2`, not `main`.

---

## Checklist

- [x] Plan written and committed
- [ ] Phase 1 — `StreamScreenSize` breakpoints
- [ ] Phase 2 — `StreamLobbyController` + `StreamLobbyScope`
- [ ] Phase 3 — control and setting widgets, device menu moved into the SDK
- [ ] Phase 4 — `LobbyActions` and its presets
- [ ] Phase 5 — `StreamLobbyView` rewrite, `StreamLobbyVideo` absorbed
- [ ] Phase 6 — lobby theme migrated to `@themeGen`
- [ ] Phase 7 — dogfooding uses the SDK lobby directly
- [ ] Phase 8 — tests, goldens, changelog

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

---

## Phase 2 — the lobby controller and scope

This is the load-bearing change. `LobbyActions` hands `List<Widget>` to the view, so the
action widgets cannot receive callbacks through their constructors — they have to read
state from context. Everything currently split across `_StreamLobbyVideoState`,
`_LobbyScreenState` and `_LobbyDeviceControlsState` moves into one object.

**New:** `src/call_screen/lobby_controller.dart`

```dart
class StreamLobbyController extends ChangeNotifier {
  StreamLobbyController({required this.call, StreamVideo? streamVideo});

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

  // devices — lifted from _LobbyDeviceControlsState (RtcMediaDeviceNotifier.instance)
  List<RtcMediaDevice> get audioInputs / audioOutputs / videoInputs;
  RtcMediaDevice? get selectedAudioInput / selectedAudioOutput / selectedVideoInput;
  Future<void> selectAudioInput(RtcMediaDevice? device);
  Future<void> selectAudioOutput(RtcMediaDevice? device);
  Future<void> selectVideoInput(RtcMediaDevice? device);  // stops + reopens the camera

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

1. `selectVideoInput` restarts the camera itself, so dogfooding's
   `key: ValueKey(_selectedVideoInputDevice?.id)` hack ([lobby_screen.dart:150](dogfooding/lib/screens/lobby_screen.dart:150)) goes away.
2. The track-ownership contract stays as documented at [lobby_video.dart:36-50](packages/stream_video_flutter/lib/src/call_screen/lobby_video.dart:36) —
   but now the controller is the single owner and `connectOptions` can hand warmed tracks
   over as `TrackOption.provided`, which `StreamLobbyView` never did.
3. `connectOptions` sets `audioInputDevice` / `audioOutputDevice` / `videoInputDevice`,
   which the SDK lobby currently drops on the floor ([lobby_view.dart:73-89](packages/stream_video_flutter/lib/src/call_screen/lobby_view.dart:73)).

Unit-test the controller against mocked `Call` / `RtcMediaDeviceNotifier` (extend
`test/src/mocks.dart`).

---

## Phase 3 — the control and setting widgets

**New:** `src/call_screen/lobby_actions/`. Every widget here reads `StreamLobbyScope.of(context)`
and takes no state in its constructor.

| Widget | Lane | Renders |
|---|---|---|
| `StreamLobbyMicrophoneToggle` | controls | `CallControlOption`, `state: .on/.off`, `.disabled` on error |
| `StreamLobbyCameraToggle` | controls | same, camera |
| `StreamLobbyMicrophoneSplitButton` | controls | `StreamSplitButton.icon` + device menu on the caret |
| `StreamLobbyCameraSplitButton` | controls | same, camera |
| `StreamLobbyParticipantsControl` | controls | `StreamButton.icon(icons.usersFill)` in a `StreamBadgeNotification`, opens the participant list |
| `StreamLobbyMicrophoneSelect` | settings | `StreamSelectInput` + device menu (Microphone + Speaker sections) |
| `StreamLobbyCameraSelect` | settings | `StreamSelectInput` + device menu (Camera section) |

Reuse, don't rewrite:

- The device menu is dogfooding's `_DeviceMenuAnchor` / `_DeviceMenuSection` / `_DeviceMenuItem`
  ([lobby_device_controls.dart:160-286](dogfooding/lib/widgets/lobby_device_controls.dart:160)) moved into the SDK as a shared
  `StreamLobbyDeviceMenu`, so the split button and the select input drive the same menu.
  Keep both comments that are load-bearing: the `MenuController.close()` note at
  [:205](dogfooding/lib/widgets/lobby_device_controls.dart:205), and the "platforms that route audio themselves" note at [:124](dogfooding/lib/widgets/lobby_device_controls.dart:124) — with the
  caveat that `RtcMediaDeviceNotifier` synthesises an iOS earpiece output
  ([rtc_media_device_notifier.dart:247](packages/stream_video/lib/src/webrtc/rtc_media_device/rtc_media_device_notifier.dart:247)), so verify the Speaker section really is empty on iOS.
- `StreamSelectInput`, `StreamContextMenuAnchor`, `StreamContextMenuHeading`,
  `StreamRadioIndicator` — already in `src/widgets/design_system_candidates/`.
- `StreamErrorBadge` / `StreamBadgeNotification` / `StreamAvatarStack` from core, all exported
  from `core.dart`. `StreamBadgeNotification` overlays its own `child` at `topEnd`; there is
  no green type, so the participants badge needs a `StreamBadgeNotificationTheme` with
  `primaryBackgroundColor: accentSuccess` — the same override trick `CallControlOption`
  already uses for `StreamButtonTheme` ([call_control_option.dart:25](packages/stream_video_flutter/lib/src/call_controls/call_control_option.dart:25)).

**`StreamSplitButton` is `@experimental` and is not exported from `core.dart`** — only from
`package:stream_core_flutter/video.dart`, which the video barrel does not re-export. The two
split-button files need an explicit `import 'package:stream_core_flutter/video.dart';` and
`// ignore_for_file: experimental_member_use`.

`StreamSelectInput` has no size variant; it implements the large/mobile density (16/12
padding, 20px icon, 16px text) and its dartdoc deliberately justifies that over the denser
web spec. **Use it as-is at every breakpoint** and leave the compact web density as a
separate follow-up — adding a size enum is a design-system change, not a lobby change.

---

## Phase 4 — `LobbyActions`

**New:** `src/call_screen/lobby_actions.dart`

```dart
class LobbyActions {
  const LobbyActions.custom({this.controls = const [], this.settings = const []});

  /// Mobile: mic + camera toggles, no device pickers.
  LobbyActions.simple({List<Widget> extraControls = const []})
      : controls = [const StreamLobbyMicrophoneToggle(),
                    const StreamLobbyCameraToggle(), ...extraControls],
        settings = const [];

  /// Mobile, with a caret on each toggle for picking the device.
  LobbyActions.regular({List<Widget> extraControls = const []}) ...

  /// Web: toggles plus a row of select inputs.
  LobbyActions.full({List<Widget> extraControls = const []}) ...

  /// Icon buttons that toggle the microphone and camera.
  final List<Widget> controls;

  /// Select inputs that pick which device to use.
  final List<Widget> settings;
}
```

The presets cannot be `const` because they splice `extraControls`; only `.custom` is.
`extraControls` is what lets dogfooding use a preset "with maybe some extra buttons"
rather than respelling the whole list.

---

## Phase 5 — rewrite `StreamLobbyView`

`StreamLobbyVideo` is absorbed: its track logic moves to the controller and its rendering
becomes a private `_LobbyPreview` inside the view. Delete
`src/call_screen/lobby_video.dart` and drop its barrel export ([stream_video_flutter.dart:52](packages/stream_video_flutter/lib/stream_video_flutter.dart:52)).

New constructor:

```dart
StreamLobbyView({
  required Call call,
  required ValueSetter<CallConnectOptions> onJoinCallPressed,
  LobbyActions? actions,        // null -> .simple() on small, .full() otherwise
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

Layout:

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

## Phase 6 — theme migration

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

## Phase 7 — dogfooding

`LobbyScreen` becomes a thin wrapper. Delete
[lobby_device_controls.dart](dogfooding/lib/widgets/lobby_device_controls.dart) entirely — it now lives in the SDK.

```dart
final isNativeMobile = CurrentPlatform.isAndroid || CurrentPlatform.isIos;

StreamLobbyView(
  call: widget.call,
  onJoinCallPressed: (options) =>
      widget.onJoinCallPressed(options, _videoEffectsManager),
  actions: isNativeMobile
      ? LobbyActions.regular(extraControls: extras)
      : LobbyActions.full(extraControls: extras),
)
```

where `extras` is `[const StreamLobbyParticipantsControl(), _BlurToggle(...)]` — the
participants button from the second screenshot, and the blur toggle currently injected
through `additionalActionsBuilder` ([lobby_screen.dart:176-206](dogfooding/lib/screens/lobby_screen.dart:176)). The blur toggle keeps
needing `_videoEffectsManager` and the current camera track; it reads the track from
`StreamLobbyScope.of(context).cameraTrack` and re-applies on change by listening to the
controller, replacing the `onCameraTrackSet` hook at [:169-174](dogfooding/lib/screens/lobby_screen.dart:169).

The dogfooding app bar (avatar + name + leave) stays in `LobbyScreen`; `StreamLobbyView`
provides the body. Drop the unused `flutter_svg` / `assets.dart` imports and the unread
`StreamLobbyViewTheme.of(context)` at [:104](dogfooding/lib/screens/lobby_screen.dart:104). Update the theme override in
[app_content.dart:368-382](dogfooding/lib/app/app_content.dart:368) to the new theme data.

---

## Phase 8 — tests and changelog

- Golden tests in a new `test/src/call_screen/goldens/{ci,macos}/` via `streamGoldenTest`
  + `TestWrapper`, covering `simple` / `regular` / `full` at small and large widths, light
  and dark. Pass explicit `constraints` — `StreamLobbyView` must **not** build its own
  `Scaffold` (it asserts under unbounded golden constraints), so the view returns a bare
  column and dogfooding supplies the `Scaffold`.
- Widget tests for anything in an `Overlay` — the device menu and the participants list
  snapshot blank in the CI capture path, so assert those with `expect`, not goldens.
- Regenerate committed goldens by dispatching the `update_goldens` workflow from this
  branch, not locally.
- `melos bootstrap` is not needed (no pubspec change); run `melos run generate:flutter`,
  `melos run analyze`, `melos run format`, `melos run test:all`.
- `packages/stream_video_flutter/CHANGELOG.md` under `## Upcoming (next major)`:
  `### ✅ Added` for `LobbyActions`, `StreamLobbyController`, `StreamScreenSize` and the
  device pickers; `### ⚠️ Breaking` for the removal of `StreamLobbyVideo` and the changed
  `StreamLobbyView` constructor; `### ⚠️ Deprecated` for the old theme.

Commit after each phase (no push), per the repo convention.

---

## Verification

1. `melos run analyze` clean, `melos run test:all` green.
2. Run dogfooding on macOS or Chrome — wide window shows toggles overlaid on the feed plus
   the two select inputs; the participants badge shows a count when a second client joins
   the same call; picking a camera swaps the preview without re-enabling a disabled camera.
3. Resize the window below 768px — the toggles drop below the feed, the settings row stays.
4. Run dogfooding on an iOS simulator — `regular` preset, split buttons, caret opens the
   device menu, no settings row, no Speaker section if the platform reports no outputs.
5. Join from the lobby and confirm the chosen mic/speaker/camera are the ones in use in the
   call, and that the mic/camera do not visibly restart on join (tracks handed over as
   `TrackOption.provided`).
6. Toggle blur in the lobby and confirm it survives a camera device switch and carries into
   the call.

## Open follow-ups (not in this plan)

- A compact/web density for `StreamSelectInput` (12/8 padding, 16px icon, 14px text).
- Graduating `StreamSplitButton` out of `@experimental` in core, and the
  `design_system_candidates/` widgets into core.
