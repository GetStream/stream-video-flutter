# PR #1324 review fixes

Acting on the review of `feat/call-controls` (base `feat/lobby-view`). Phases are
committed one at a time, no pushing.

## Phase 1 — the blocker: a failed join leaves a device drawn as live

`_applyConnectOptions` logs a failed camera/microphone apply and drops it.
`setMicrophoneEnabled` only downgrades `_connectOptions` on success, so the
intent stays "on" forever, `trackEnabled` stays null forever, and
`_resolve` draws the unmuted glyph for the rest of the call while nothing is
captured. Pressing it calls `setMicrophoneEnabled(enabled: false)`, which fails
with `Track not found and enabled is false`, so the control is also dead.

Downgrading the connect option to `TrackOption.disabled()` when the apply fails
fixes both halves: the control draws muted (accurate — the device is off), and
pressing it now calls `setMicrophoneEnabled(enabled: true)`, which runs
`_createAndPublishTrack` and is a real retry.

- [x] `_applyConnectOptions` downgrades camera/microphone on a failed apply
- [x] Test in `stream_video` covering both devices
- [x] `stream_video` changelog entry

## Phase 2 — API corrections

- [ ] Export `device_control.dart` from the barrel (`CHANGELOG.md:210` already
      announces `trackEnabled` and `wantsOn`)
- [ ] `StreamLayoutButton`: `initialLayout` -> `layout`, drop the internal state,
      make it stateless (every caller already owns the mode) + `fix_data.yaml`
      parameter transform + breaking changelog note
- [ ] `CallControlBar`: `small` becomes named, `super.key` last
- [ ] `heightOf` takes `primary` and includes the bottom inset when set
- [ ] Delete `resolveSurfaceStyle` (zero callers, zero tests)
- [ ] Collapse the hand-copied style-resolution chains into one private static
- [ ] `assert` against an all-empty `CallControlBarLayout`

## Phase 3 — dogfooding

- [ ] Extract the `callControlsWidgetBuilder` closure into a method
- [ ] Error messages name the action, not a device switch (regression from base)
- [ ] Fix the shared-controller comment (`SettingsMenu` takes no controller)
- [ ] Fix the control count ("two extra controls" is one plus a caret)

## Phase 4 — enumeration failure is not "no hardware"

`reportsNo` is `hasEnumerated && devices.isEmpty`, and a throwing
`enumerateDevices()` sets `hasEnumerated` with the lists still empty. Both
controls go badged and inert with no reason and no retry.

- [ ] Distinguish an enumeration failure from an empty enumeration
- [ ] Give the in-call controls a way to surface/retry it

## Phase 5 — tests

- [ ] `stream_camera_button_test.dart` mirroring the microphone's groups
- [ ] `StreamMicrophoneSplitButton`'s call-driven path
- [ ] `stopTrackOnMute` (currently in zero tests)
- [ ] `primary` / SafeArea, with a non-zero bottom inset
- [ ] Responsive fallback as a widget test, not only `layoutFor`
- [ ] Make the disposal test actually observe disposal

## Phase 6 — comments and docs

- [ ] Remove the three hairline claims (the bar draws no top border)
- [ ] Fix `heightOf`'s "depends on the window" reason -> themed value
- [ ] Fix the `devices` doc: the split button always enumerates
- [ ] Fix the `onError` reason: `Failure.error` is `Object`; `VideoError` *is*
      exported and `enumerationError` is `StreamDeviceError?`
- [ ] Fix "no controller is built" -> nothing listens for devices
- [ ] Fix `.withDevices` "does its own muting"
- [ ] Lead `selectedAudioInput` with the behaviour, not the null case
- [ ] Strip refactor rationale from doc comments (recorded preference)
- [ ] Stale identifiers: `SV:SpeakerphoneOption`, `_ToggleSpeakerState`
- [ ] Dead `ignore_for_file` in `default_control_options.dart`
- [ ] Eight controls still say "call control option"
- [ ] Undocumented public fields on `StreamScreenShareButton`

## Phase 7 — changelog

- [ ] Compress the new entries to one sentence each (recorded preference)
- [ ] Fix the `:63`/`:65` self-contradiction

## Deliberately not done

- `CallControlBar` stays a plain `StatelessWidget` rather than gaining the
  Props/builder triple. It matches its neighbours (`CallControlButton`,
  `CallFeatureButton`, `CallAppBar`); recorded in the class doc instead.
- `screenSharingNotificationOptionsBuilder` is dead but dead on the base branch
  too, so it is not this PR's to remove.
