# PR #1320 review fixes

Findings from the review of `feat/lobby-view`, minus the two rejected ones
(marker interfaces for `StreamLobbyActions`' lanes; a preset discriminant).
Commit after each phase, no push.

Decisions taken where the review left a choice, so the work is unblocked:

- The hot-mic fix keeps the surgical shape (ownership stays recoverable after
  `dispose`) rather than redesigning the protocol into `takeConnectOptions()`.
  Noted as a follow-up, not done here.
- `StreamMediaDeviceSelected` keeps its throw-to-reject contract rather than
  moving to `FutureOr<bool>`. The contract is made true instead.
- `.simple()` / `.regular()` keep `extraSettings`; their docs are what change.

## Phase 1 — Rene's review comments

- [x] Revert `MinimumOSVersion` in `dogfooding/ios/Flutter/AppFrameworkInfo.plist`
- [x] `menuDirection: .up` at both `call_screen.dart` call sites, `.down` for the
      `device_split_buttons.dart` defaults
- [x] Drop the three redundant `PartialCallStateBuilder` type arguments
- [x] Delete the five narrating comments in `call_screen.dart`; the `onTap` one is
      also wrong (the SDK list *is* what shows when `_channel == null`)
- [x] `StreamParticipantsControl` -> `StreamParticipantsButton`
- [x] `StreamLobbyParticipantsControl` -> `StreamLobbyParticipantsButton`
- [x] Screen-share icon follows the platform: `presentMobileFill` on mobile, at
      `screen_share_call_participants_content.dart` and
      `toggle_screen_sharing_option.dart` (+ the two doc lines)

## Phase 2 — Track ownership and device races

- [ ] Hot mic: `dispose()` keeps the track references when handed over,
      `reclaimTracks()` stops them if the controller is already disposed,
      `_onJoinCallPressed` awaits and guards the host callback, drop the
      `mounted` gate, add a re-entry guard
- [ ] `_restartCamera`: `track.stop()` in its own try/catch so `_openCamera()`
      always runs
- [ ] Camera race: an open records the device id it opened, and reconciles
      against `devices.selectedVideoInput` afterwards; a failed open rejects so
      `_select` puts the picker back
- [ ] `_applyCallDefaults` sets rather than toggles, and skips a device the user
      has already touched
- [ ] `_select`: a selection epoch, so a rejected switch cannot clobber a newer one
- [ ] `_select`: reject `null` when `!supportsSystemDefault`
- [ ] `StreamAdaptiveMenuAnchor.open()` guards on `_isOpen` and `mounted`

## Phase 3 — Making failures visible

- [ ] Typed device error carrying `permissionDenied | deviceBusy | noDevice |
      unknown` plus cause and stack trace
- [ ] `lobby_device_selects.dart` says what is actually known instead of
      asserting a permission verdict; new l10n strings in `en` and `nl`
- [ ] `enumerationError` distinguishes "asked and found nothing" from "could not
      ask", stops self-clearing, and reaches the UI
- [ ] `fetchError` reaches the UI, or its doc stops promising it does
- [ ] `onError` on the fetch and event subscriptions
- [ ] `isOpeningMicrophone` / `isOpeningCamera`, and a second tap during an open
      is no longer swallowed
- [ ] `dispose()`'s unawaited `stop()` calls log their failures
- [ ] dogfooding: `_remove` reverts `_enabled` like `_apply` does; `debugPrint`
      -> `taggedLogger`; snackbars carry the reason
- [ ] `toggle_speakerphone_option.dart`'s `catch (_) {}`

## Phase 4 — Encapsulation and API polish

- [ ] `StreamLobbyController.devices` -> private field + getter
- [ ] `final class StreamLobbyScope`
- [ ] `Stream` prefix: `CallControlButton`, `CallFeatureButton`,
      `CallControlTone`, `LobbyDeviceMenus` (+ `fix_data.yaml`)
- [ ] `StreamLobbyActions`: `==` / `hashCode`, and honest preset docs
- [ ] `StreamLobbyViewStyle` constructor asserts
- [ ] Controller built in `initState`, not from `build()`
- [ ] `StreamLobbyView.call` documented as needing a stable instance
- [ ] `microphoneMissing` / `cameraMissing`: a muted device does not lock out

## Phase 5 — Comments and docs

- [ ] The class overview orphaned onto `LobbyAudioTrackOpener` (missing blank line)
- [ ] Same in `lobby_view_test.dart`, where the sweep essay lands on `_widths`
- [ ] Delete the green-badge comment (wrong: the default badge is blue)
- [ ] "Every getter is non-null" -> true statement about `previewTileStyle`
- [ ] Delete the `BlurToggle` snippet in `app_features.dart` (references a
      private widget in another file)
- [ ] Six refactor-rationale comments out
- [ ] Deduplicate the repeated rationale (badging x5, reads-not-creates x5,
      overlaid-row x4, capitalization x3, `_LobbyScreen` doc x3)
- [ ] Doc inaccuracies: `hasEnumerated`, `microphoneMissing`'s summary and
      "retryable", the adaptive menu's "and web", "Above 768px" vs `!isSmall`,
      `maxOverlaidControls` on small, `supportsSystemDefault`'s two reasons,
      the labels-vs-empty-lists mismatch, `_noDeviceFor`, `flip_camera_option`
- [ ] Comment lines over 80 columns; backticks that should be `[]` links

## Phase 6 — Tests

- [ ] The device-notifier double returns what the real one does (an empty
      enumeration is a `Failure`, and it emits before returning)
- [ ] `lobby_view_test.dart`'s "owns and disposes a controller" actually asserts
- [ ] Weak assertions: the disposed-devices test, the mic `stop()` verify
- [ ] `tone` / `selected` asserted for each refactored control option, and the
      incoming and outgoing controls get tests
- [ ] Camera restart: switches device with a live track, passes the picked id,
      stays off when off, and the double-switch race
- [ ] Hand-over wiring: `tracksHandedOver` after a join, and the refused-join path
- [ ] `joinEnabled: false`
- [ ] `open()` twice, and `close()` while closed
- [ ] `facingMode` -> `mirror` / `CameraPosition`
- [ ] New behaviour from phases 2-3: typed errors, the epoch, null rejection,
      the opening getters

## Phase 7 — Changelog

- [ ] Delete the two stale duplicate `StreamLobbyViewThemeData` entries
- [ ] Move the breaking entries out of `### ✅ Added`
- [ ] Fold intra-branch history into the entries that introduce the final API
- [ ] One short sentence per entry
- [ ] Entries for everything added above
