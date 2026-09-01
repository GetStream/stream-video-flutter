## Upcoming (next major)

### ✅ Added

- Split the call control button in two, matching the design system. `CallControlButton` carries the three tones a control can have — `CallControlState.positive`, `.neutral`, `.negative` — and covers the microphone and camera toggles, answering, declining and leaving. `CallFeatureButton` carries a `selected` flag and covers a feature that is off by default and prominent when on: screen sharing, closed captions, recording, and the members and chat panels. The split exists because the two paint differently: a turned-off control is destructive red, while a selected feature is accent blue.

  ```dart
  CallControlButton(
    icon: Icon(context.streamIcons.voiceFill),
    state: isMuted ? .negative : .neutral,
    onPressed: () => call.setMicrophoneEnabled(enabled: isMuted),
  )

  CallFeatureButton(
    icon: Icon(context.streamIcons.presentDesktopFill),
    selected: isScreenSharing,
    onPressed: toggleScreenShare,
  )
  ```
- Both buttons take a `showErrorBadge` flag, which draws a `StreamErrorBadge` on the top-end corner. It is independent of the tone and of whether the button can be pressed, so a control can be red, badged and still tappable — a microphone whose permission was refused, say. A button that simply cannot be used takes a null `onPressed`.
- The lobby theme follows the `@themeGen` pattern the other component themes use: `StreamLobbyViewThemeData` carries one nullable `StreamLobbyViewStyle`, every property of which means "no override", and `StreamLobbyViewTheme` is an `InheritedTheme` that merges with the ambient theme instead of replacing it. Overriding one property therefore leaves the rest alone. Defaults live in the widget and are derived from `StreamTheme`, so the lobby follows the design system without an app configuring anything.

- The lobby's preview is a `StreamParticipantTile` — the same component the call draws — so its surface, corner radius, name pill and placeholder avatar cannot drift from the tiles it leads to, and an app that themes its participant tiles themes the lobby too. The tile is handed its renderer directly, because the lobby's camera track is warmed up locally and never registered with the call, so the tile's usual lookup by session id would find nothing. Connection quality and reactions are switched off — there is no connection to rate and no reactions to receive before joining. The speaking outline is left on but never triggers yet: the in-call speaking state comes from the SFU, and a local microphone level pre-join is still to come. `StreamLobbyController.localParticipant` exposes the `CallParticipantState` this is built from.
- `StreamLobbyView` is rebuilt around `LobbyActions` and the lobby controller. It lays itself out per the window's `StreamScreenSize` — under 768px the controls sit below the preview, above it a short row is overlaid on the preview itself. A row of more than `StreamLobbyViewStyle.maxOverlaidControls` (3 by default) always sits below it instead: the overlaid row is centred on a preview whose bottom-start corner is already taken by the participant label, so a longer row runs into it, and the preview goes from a 370×264 aspect to a fixed 640×360 — while *which* actions are shown does not follow the screen: `actions` defaults to `LobbyActions.simple()` at every width, and choosing a richer preset for a roomier window is the host's call.

- Added `LobbyActions`, which says which controls a `StreamLobbyView` shows, in two lanes: **controls** are the icon buttons that turn the microphone and camera on and off, **settings** are the fields that pick which device to use. A lane whose list is empty is not drawn at all. Three presets — `.simple()` (toggles only), `.regular()` (toggles with a caret that picks the device) and `.full()` (toggles above a row of device fields) — each take `extraControls` and `extraSettings`, so a host adds one button or one field without respelling the list. `.custom()` shows exactly what it is given.

- Added the lobby's action widgets: `StreamLobbyMicrophoneToggle` and `StreamLobbyCameraToggle`, `StreamLobbyMicrophoneSplitButton` and `StreamLobbyCameraSplitButton` (a toggle with a caret that picks the device), `StreamLobbyMicrophoneSelect` and `StreamLobbyCameraSelect` for a settings row, and `StreamLobbyParticipantsControl`, which badges the number of people already in the call and opens the list. Each reads its state from `StreamLobbyScope`, so none of them has to be wired up at the call site. The split button and the select input open the same sections over the same controller, so a lobby showing both never disagrees with itself, and on Android and iOS both open a bottom sheet without either knowing it.
- Added lobby strings to the localizations, in English and Dutch: the device menu's section headings, its system-default option, the tooltips on the toggles and pickers, and the permission messages shown before a device can be named.

- Added `StreamMediaDevicesController`, which loads the available microphones, speakers and cameras and remembers which one is picked. It is what lets a split button on a toggle's caret and a select input in a settings row read and write one selection instead of each keeping their own. The controller owns *which* device is picked; its owner supplies *what picking it does*, through `onAudioInputSelected`, `onAudioOutputSelected` and `onVideoInputSelected` — the lobby hands in a camera restart, an in-call switcher would hand in the call's own setter, and neither widget has to know which it is driving.
- Added `StreamLobbyController` and `StreamLobbyScope`, holding everything the lobby knows before a call is joined: the warmed-up microphone and camera tracks, the devices they run on, the last failure per track, and who is already in the call. Lobby actions are handed to the view as a plain list of widgets, so they read this from the tree rather than taking callbacks through their constructors. Its `connectOptions` hands the tracks over as `TrackOption.provided` and carries the picked devices, so joining continues on the microphone and camera the user was previewing instead of opening a second pair.

- Added golden coverage for the lobby: each of the three `LobbyActions` presets swept across all three breakpoints, in both brightnesses. The sweep is what proves the two axes are independent — the preset decides which widgets exist, the width decides where the control row sits and how big the preview is.

- Added `StreamAdaptiveMenuAnchor`, which presents a list of `StreamMenuSection`s as an anchored context menu on desktop and web and as a bottom sheet on Android and iOS. A popup pinned to a 32px caret is awkward to hit with a thumb and out of place next to the rest of a phone's chrome, so the presentation follows the platform rather than the call site — nothing that uses it has to branch. Its builder receives a `StreamMenuHandle` with `isOpen`, `open()`, `close()` and `toggle()`, so the same builder drives both presentations. Pass `useSheet` to force one, and `matchAnchorWidth` to make the anchored menu exactly as wide as its anchor — which the lobby's device fields do, since a narrow popup under a wide field reads as belonging to something else.

- `StreamIcons` from the design system is now exported. It used to be hidden from the barrel because this package shipped a three-icon class of the same name; that class is gone, so `context.streamIcons` finally has a nameable type.

- Redesigned the participant tile onto the design system, and split its theme into one per component. The tile is now a 20px-radius surface with two toolbars: the overflow button and any live reaction at the top, the participant's name and connection quality at the bottom. `StreamParticipantTileTheme`, `StreamParticipantLabelTheme`, `StreamConnectionQualityIndicatorTheme` and `StreamCallParticipantsGridTheme` replace `StreamCallParticipantThemeData`; each has all-nullable properties, merges with the ambient theme instead of replacing it, and leaves defaults to the widget, which derives them from `StreamTheme`.
- Added an overflow menu to the participant tile. Supply `actions`, or `actionsBuilder` for a menu that depends on the participant, and the SDK renders them; supply nothing and the button is not drawn at all. `StreamParticipantTileAction` is an icon, a label and a callback, so what an action does — pinning, muting, blocking, removing — stays with the integrator:

  ```dart
  StreamParticipantTile(
    call: call,
    participant: participant,
    actionsBuilder: (context, participant) => [
      StreamParticipantTileAction(
        icon: context.streamIcons.pin,
        label: participant.isPinned ? 'Unpin' : 'Pin',
        onPressed: () => call.setParticipantPinnedLocally(
          sessionId: participant.sessionId,
          pinned: !participant.isPinned,
        ),
      ),
    ],
  )
  ```
- Added `StreamFloatingParticipantTile`, the draggable self-view as a component of its own, with `StreamFloatingParticipantTileTheme` for its size, corner radius, hairline and elevation. `StreamLocalVideo` now only positions it. Its shadow comes from `StreamElevation` through a `Material` rather than a hand-painted `BoxShadow`, and it is registered as `floatingParticipantTile` on `streamVideoComponentBuilders`.
- `StreamUserAvatar` is now built on the design system's `StreamAvatar`, and is replaceable through a `userAvatar` builder on `streamVideoComponentBuilders`. Its props carry the whole `UserInfo`, so a replacement can draw from fields the SDK never reads — a team badge, a role ring, an identicon from `extraData` — and because every avatar in the SDK routes through it, one registration changes the participant tile, the lobby, the participants list and the incoming and outgoing call screens together. Size, colors and border come from `StreamAvatarTheme`.
- Added `StreamParticipantVideo`, the video area of a tile, with a `participantVideo` builder for replacing it. A `videoRendererBuilder` passed to a single tile still wins over an app-wide one. A replacement is responsible for forwarding `onSizeChanged`, which is what drives dynascale — drop it and the call negotiates quality against stale dimensions.
- Added `StreamParticipantPlaceholder`, what a tile shows in place of video, with a `participantPlaceholder` builder for replacing it. It stands in for the participant rather than the video, so it is drawn whenever there is no picture — camera off, track not yet arrived, or paused.
- `StreamParticipantLabelStyle` takes a `showAudioIndicator`, defaulting to true. Turn it off where there is no speaking state to show — the lobby does, since nothing reports a local audio level before joining. A muted participant goes without one whatever it says.
- `StreamParticipantLabelStyle` takes a `minHeight`, defaulting to the height the sound indicator gives the pill — its own size plus the vertical padding — so a pill without one keeps that height and the same breathing room around its text rather than collapsing onto it. Its trailing inset follows the same rule: the indicator's box carries its own padding, so a pill drawing something else in its place insets that edge itself instead of letting a bare icon crowd it.
- Added `participantLabel` and `connectionQualityIndicator` to `streamVideoComponentBuilders`, so both can be replaced app-wide. `StreamParticipantLabel` and `StreamConnectionQualityIndicator` are exported for the first time, along with `StreamAudioIndicator`.
- Added component factory support, so the Stream Video UI components can be replaced app-wide instead of threading widget builders through the widget tree. Register the components you want to replace with `streamVideoComponentBuilders` and wrap your app in a `StreamComponentFactory`:

  ```dart
  class _MyAppState extends State<MyApp> {
    // Build the builders once and hold on to them: a newly created
    // StreamComponentBuilders is never equal to the previous one, so building
    // it inline rebuilds every Stream component below the factory whenever the
    // surrounding widget rebuilds.
    late final _componentBuilders = StreamComponentBuilders(
      extensions: streamVideoComponentBuilders(
        // Decorate the default, or return your own widget entirely.
        participantTile: (context, props) => DefaultStreamParticipantTile(
          props: props.copyWith(showParticipantLabel: false),
        ),
      ),
    );

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        builder: (context, child) => StreamComponentFactory(
          builders: _componentBuilders,
          child: child!,
        ),
        // ...
      );
    }
  }
  ```

  Every component follows the same shape: `StreamX` resolves the registered builder and falls back to `DefaultX`, which holds the default implementation. The parameters of `StreamX` are carried in a `StreamXProps`, exposed as `StreamX.props`, so a custom builder can read them and `copyWith` them to decorate the default rather than reimplement it.
- Added `StreamParticipantTile`, the participant tile as a replaceable component: register a `participantTile` builder to replace it, or use `DefaultStreamParticipantTile` for the default implementation.

### 🐞 Fixed

- The lobby no longer lists someone twice. `getOrCreate` returns a snapshot of the session while the event subscription is already live, so a join already reflected in that snapshot still arrives as a `ParticipantJoined` event — and the lobby appended it blindly. Participants are now upserted by session id, which leaves a genuine second session of the same user (a phone and a laptop) listed separately, as it should be. A join event for the local user is ignored, matching the snapshot, which always filtered them out.

- Documented on `StreamLobbyVideo.onCameraTrackSet` and `onMicrophoneTrackSet` that the track becomes the caller's to stop. The widget deliberately does not stop tracks it has handed over: they may be passed to the call as a `TrackOption.provided`, and would otherwise be killed as the lobby is left.

### ⚠️ Deprecated

- `CallControlOption` is deprecated in favour of `CallControlButton` and `CallFeatureButton`, and has been restored to the shape it has in the last release: it takes `iconColor`, `disabledIconColor`, `elevation`, `backgroundColor`, `disabledBackgroundColor`, `shape` and `padding`, and draws an `ElevatedButton` styled from `StreamCallControlsTheme`. Code written against the released SDK keeps compiling and keeps looking the way it did. Migrating is manual rather than a `dart fix`: neither replacement takes per-instance colours, so a rename would drop whatever the call site passed. Map `state`-free call sites and the old `on` state onto `CallControlButton(state: .neutral)`, `off` onto `.negative`, `positive` onto `.positive` for a control or `CallFeatureButton(selected: true)` for a feature, `negative` onto `.negative`, and `disabled` onto `CallControlButton(state: .negative, showErrorBadge: true)`.
- `StreamCallParticipantThemeData` and `StreamCallParticipantTheme` are deprecated. Their properties now live in `StreamParticipantTileThemeData`, `StreamParticipantLabelThemeData`, `StreamConnectionQualityIndicatorThemeData` and `StreamCallParticipantsGridThemeData`. A theme passed to `StreamVideoTheme(callParticipantTheme: ...)` is still applied — in full, so a tile styled the old way keeps looking the way it did. Stop passing it to pick up the redesign, and pass a theme in the new shape to replace it outright. The translation runs in that factory only: setting `callParticipantTheme` through `copyWith`, or wrapping a subtree in the `StreamCallParticipantTheme` widget, changes the field without restyling anything.
- `StreamCallParticipant` is deprecated in favour of `StreamParticipantTile`, matching the component name in the design system. It keeps its own full parameter list and now only wraps `DefaultStreamParticipantTile`. Swapping the name is a manual migration rather than a `dart fix`: `StreamParticipantTile` replaces the visual parameters with a single `style:` (see the Breaking entry below), so a rename would drop whatever a call site passed. `dart fix --apply` does still strip the parameters that no longer have any effect.

### ⚠️ Breaking

- `StreamLobbyViewThemeData`'s properties are replaced by a single `style:` taking a `StreamLobbyViewStyle`. `backgroundColor` and `cardBackgroundColor` are gone — the lobby paints no background of its own now that it builds no `Scaffold`, and the preview's fill comes from `StreamParticipantTileTheme` along with the rest of the tile, with `previewTileStyle` to make the preview differ from the call's tiles. `previewBorderColor` and `previewBorderWidth` are gone too: the ring around the preview is the tile's speaking outline, which the tile draws itself. `userAvatarTheme` and `participantAvatarTheme` are gone with them; size and colour the avatars through `StreamAvatarTheme`. `participantListHeight` went with the participants card, and `optionOffBackgroundColor` / `optionOffIconColor` were already read by nothing.

- `StreamLobbyVideo` is removed. Its track handling moved into `StreamLobbyController` and its rendering into `StreamLobbyView`, which now draws the preview itself.
- `StreamLobbyView` builds no `Scaffold` or `AppBar` of its own, so it can be embedded in a screen that already has one — wrap it in whatever chrome the app needs. `onCloseTap` is therefore gone, along with `backgroundColor`, `cardBackgroundColor`, `userAvatarTheme` and `participantAvatarTheme`; appearance comes from the theme, and extra buttons from `LobbyActions`. It gains `actions`, `title`, `subtitle`, `joinButtonLabel` and `controller`.
- The lobby's card listing who is already in the call is gone, and `StreamLobbyParticipantsView` with it. `StreamLobbyParticipantsControl` replaces it: a badge with the number waiting, opening the list on tap.
- The lobby's hardcoded English moved into the localizations, so the heading, subheading and join button follow the app's locale. Pass `title`, `subtitle` or `joinButtonLabel` to override them.

- Every icon the SDK draws now resolves from the design system's icon set through `context.streamIcons`, instead of from Material. A microphone is `voiceFill` / `voiceOffFill`, a camera `videoFill` / `videoOffFill`, hanging up `phoneDownFill`, answering `phoneFill`, screen sharing `presentDesktopFill`, captions `captionFill`, recording `recordingFill` / `recordingStopFill`. The one exception is the livestream fullscreen toggle, whose cross-fade needs two distinct glyphs where the design system ships only `fullscreenFill`.
- The `IconData` parameters on the control widgets — `enabledMicrophoneIcon`, `disabledCameraIcon`, `icon` on `LeaveCallOption` and the rest — are now nullable and default to null, resolving from `context.streamIcons` at build time. Passing an icon still works; the defaults could not stay in the constructor because reading the theme needs a context.
- This package's own three-icon `StreamIcons` class and its bundled font are removed. It was never exported from the barrel, and its `grid`, `spotlight` and `fullscreen` are covered by `context.streamIcons.gridFill`, `.speakerLeftFill` and `.fullscreenFill`.
- The dead colour parameters on `ToggleMicrophoneOption`, `ToggleCameraOption`, `ToggleRecordingOption`, `ToggleClosedCaptionsOption` and `ToggleScreenShareOption` (`enabled*IconColor`, `disabled*IconColor`, `enabled*BackgroundColor`, `disabled*BackgroundColor`) are removed. They stopped having any effect when those widgets moved onto `StreamButton`, so dropping them changes nothing at runtime. Run `dart fix --apply`.
- The participant tile follows the redesigned design system. Its corner radius is 20 (was 0 on mobile and 12 on desktop), the speaking outline is 2px (was 4px), a tile showing no video draws a hairline over a subtle surface instead of a solid grey fill, the placeholder avatar is 80px with a white ring, and the name and connection quality indicator share one 48px toolbar along the bottom.
- The participant name can no longer overlap the connection quality indicator. The two were independent `Stack` children aligned to opposite corners; they are now laid out in a single row, so a long name ellipsizes rather than running underneath. As a consequence `StreamCallParticipantThemeData.participantLabelAlignment` and `connectionLevelAlignment` no longer have any effect, and the same parameters on `StreamCallParticipant` are accepted and ignored. Run `dart fix --apply` to drop them.
- The tile now sheds chrome on tiles too small to carry it, rather than overflowing: the name goes first, then the name pill, then the connection quality indicator. The pill is measured against what this participant makes it draw, so a muted camera-off participant loses it earlier than a plain one. The overflow button and the reaction are dropped on a tile too small to carry them beside each other, or too short for the top toolbar to clear the bottom one. A spotlight thumbnail or a floating self-view will show less than a full-size tile does.
- The name pill draws one of the sound indicator and the microphone icon, never both. While the participant's microphone is open the sound indicator is shown, animating only while they are speaking; muting replaces it with a microphone icon. There is no unmuted icon, so `enabledMicrophoneColor` on `StreamCallParticipant` has no effect — run `dart fix --apply` to drop it. The pill's state icons are 16px (were 20px) and sit `spacing.xxs` apart as one group after the name, which `StreamParticipantLabelStyle.indicatorSpacing` sets.
- The connection quality indicator colors each level apart — `accentError`, `accentWarning`, `accentSuccess` — where it previously painted every lit bar one color. `connectionLevelActiveColor` maps onto all three, so an app that set it still gets one flat color.
- `StreamParticipantTile`'s visual parameters (`backgroundColor`, `borderRadius`, `userAvatarTheme`, `speakerBorder*`, `participantLabel*`, `audioLevelIndicatorColor`, `*MicrophoneColor`, `pausedVideoIndicatorColor`, `connectionLevel*`) are replaced by a single `style:` taking a `StreamParticipantTileStyle`. `StreamParticipantTile` was introduced in this same unreleased version, so there is no deprecation period; `StreamCallParticipant` keeps its full parameter list.
- The floating self-view is 140x228 with a 12px radius (was 125x150 with a 16px radius), a noticeably taller aspect. It shows only the connection quality indicator: the name pill, speaking outline and overflow button are suppressed at that size. It is configured through `StreamFloatingParticipantTileThemeData`. `StreamLocalVideo`'s own deprecated parameters still win where they are given, but `StreamLocalVideoThemeData` is no longer read at all — an app that sized the self-view through that theme has to move to `StreamFloatingParticipantTileThemeData` or to the parameters. `StreamLocalVideo.userAvatarTheme` is likewise accepted and ignored; run `dart fix --apply` to drop it.
- `StreamUserAvatar` is always circular and sized from `StreamAvatarSize`. Its `constraints`, `borderRadius`, `initialsTextStyle`, `initialsBackground`, `selected`, `selectionColor`, `selectionThickness` and the `imageBuilder` / `placeholderBuilder` / `errorBuilder` / `fallbackBuilder` parameters are gone, along with the typedefs for those builders. A `StreamUserAvatarTheme` still sizes and colors the avatars beneath it — its constraints round up to the nearest `StreamAvatarSize`, and anything above the largest lands on `xxl` at 80px — but a `StreamAvatarTheme` takes precedence, and is what new code should use.
- `StreamVideoTheme.callParticipantTheme` is nullable and no longer populated by `fromColorAndTextTheme`. Reading it returns `null` unless an app set one.
- The participants grid reads its `padding`, `mainAxisSpacing` and `crossAxisSpacing` from `StreamCallParticipantsGridThemeData` rather than taking them from the participant theme through `StreamCallParticipants`. The gap between tiles defaults to 8 where it was 16: the grid widgets defaulted to 16 and nothing passed the participant theme's spacing down, so only the outer padding was themeable. Set `mainAxisSpacing` and `crossAxisSpacing` on the new theme to keep the wider gap.
- `StreamCallParticipantThemeData.copyWith` accepted `showDominantSpeakerBorder`, `dominantSpeakerBorderThickness` and `dominantSpeakerBorderColor` for fields named `showSpeakerBorder`, `speakerBorderThickness` and `speakerBorderColor`, so the field names — the only names discoverable from the class — were a compile error. The parameters now match the fields. Run `dart fix --apply`.
- `StreamCallParticipantThemeData.merge` dropped `pausedVideoIndicatorColor`, and `StreamVideoTheme.merge` dropped `callControlsTheme` and `localVideoTheme`. All three are fixed, so themes that set those values now take effect where they previously did not.
- Requires the `StreamColorScheme.backgroundOverlayDarkStrong` color added in `stream_core_flutter`.
- Call control buttons (`CallControlOption` and the widgets built on it) are now rendered with the shared `StreamButton` from `stream_core_flutter` instead of a raw Material `ElevatedButton`, and are styled by state rather than by colour. `CallControlOption` now takes a `state` — `CallControlState.on` (the default), `off`, `positive`, `negative` or `disabled` — next to `icon` and `onPressed`, and its per-button styling parameters (`iconColor`, `disabledIconColor`, `backgroundColor`, `disabledBackgroundColor`, `elevation`, `shape`, `padding`) are removed. Appearance now comes from the button styling in `StreamTheme` rather than from `StreamCallControlsThemeData`'s `optionElevation`/`optionShape`/`optionPadding` and `optionOff*` colours, so controls that relied on those look different: every control is now the same size — the accept/decline buttons of the incoming and outgoing call controls are no longer enlarged — an `off` control uses the destructive style instead of a custom colour, and a `disabled` control additionally shows an error badge.
- The colour parameters on the built-in toggle options — `enabled*IconColor`, `disabled*IconColor`, `enabled*BackgroundColor` and `disabled*BackgroundColor` on `ToggleCameraOption`, `ToggleMicrophoneOption`, `ToggleRecordingOption`, `ToggleClosedCaptionsOption` and `ToggleScreenShareOption` — are still accepted but no longer have any effect. Each option now passes a `CallControlState` down instead, so its colours come from the theme's button styling.
- `StreamCallContentThemeData.callContentBackgroundColor` is now nullable and defaults to `null`, which resolves to the design system's `backgroundApp` colour instead of the hard-coded `0xFF272A30`. Set it explicitly to keep a fixed background.
- `CallAppBar` now defaults to `elevation: 0` (was `1`), and its background falls back to the design system's `backgroundApp` colour instead of `StreamVideoTheme`'s `colorTheme.barsBg`.
- You must now provide a `StreamTheme` to your app for the Stream Video UI components to be styled correctly. Add it as a `ThemeData` extension on the `MaterialApp` you wrap the Stream Video widgets with:

  ```dart
  MaterialApp(
    theme: ThemeData(brightness: Brightness.light).copyWith(
      extensions: [
        StreamTheme.light(),
        StreamVideoTheme.light(),
      ],
    ),
    // ...
  );
  ```

  When no `StreamTheme` is found in the widget tree, components fall back to a default theme derived from the ambient `Brightness`, so add your own `StreamTheme` to control their look.

### ✅ Added

- Added `StreamSelectInput`, `StreamContextMenuAnchor`, `StreamContextMenuHeading` and `StreamRadioIndicator`. These are design-system candidates: they implement components from the Stream design system that `stream_core_flutter` does not ship yet, and live in `src/widgets/design_system_candidates` until they graduate to core. `StreamSelectInput` is the select field (label, leading widget, value or placeholder, caret) with the design's hover/focus rings and disabled, error and active states; `StreamContextMenuAnchor` anchors a `StreamContextMenu` to a widget and sizes its items like the design's menu; `StreamContextMenuHeading` labels a section inside such a menu; `StreamRadioIndicator` marks the selected entry of a group.

### 🔄 Changed

- The lobby preview (`StreamLobbyVideo`) now scales with the space it is given instead of being a fixed 280px-tall card in a 420px-wide column: it allows up to 640px of width and derives its height from the available width, capped at 360px.
- `StreamLobbyView` is restyled onto the design system — its typography, spacing and icons come from `StreamTheme`, and the close action is a ghost `StreamButton` instead of a Material `IconButton`.
- Requires `stream_core_flutter` 0.5.0 for the button styles, error badge and theme accessors the components above use.

## 1.4.3

### 🐞 Fixed

- Fixed duplicate publisher tracks: concurrent enable/publish calls of the same type (e.g. a double camera enable racing the join flow) could create two senders for the same track type, which the SFU rejects with a forced rejoin loop. A publish now claims its `(trackType, publishOptionId)` before creating the sender, so a concurrent one reuses that sender instead of adding a second, and a repeated enable joins the media acquisition already in flight rather than opening the camera twice.
- Fixed the incoming call UI (CallKit on iOS) ringing for a call whose ringing flow was already resolved before the push was delivered.
- Fixed the publisher announcing a stale track `mid` after a renegotiation or publish retry. It's now resolved from the current peer-connection state so the SFU can reliably match the track to its media.
- Serialized remote-description and ICE-candidate handling so a candidate arriving mid-negotiation can no longer be dropped.
- Fixed an issue where republishing could reuse a cached publisher transceiver without renegotiating.
- Fixed a `FormatException` when sending requests if the application name (or other device/app info) contains non-ASCII characters. Values included in the `X-Stream-Client` header are now sanitized to valid header characters.

## 1.4.2

### ✅ Added

- Added `VideoFit.adaptive`, which picks between `cover` and `contain` based on the video's own orientation: landscape/square video fills the tile while portrait/tall video is letterboxed so the whole frame stays visible.
- [iOS] `Call.state.audioOutputDevice` now stays in sync with the active native audio route when the output changes outside of `Call.setAudioOutputDevice` (e.g. via the native route-selection UI, or when the system re-routes on device connect/disconnect).
- Added client-side call join telemetry (`ClientEventReporter`).

### 🔄 Changed

- Increased minimum Flutter version to 3.38.1.
- Participant video fit now defaults per-platform when not explicitly set: `VideoFit.adaptive` on web and desktop (so portrait feeds such as phone cameras are shown in full instead of being cropped) and `VideoFit.cover` on mobile. Set `videoFit` explicitly on `StreamCallParticipantThemeData` (or the renderer widgets) to override.

## ⚠️ Breaking

- The `Sort` and `Filter` typedefs in `call_participants.dart` have been renamed to `CallParticipantSort` and `CallParticipantFilter` respectively.


## 1.4.1

### 🐞 Fixed

- Fixed an issue where ringing a member during an ongoing call could prematurely end the call if they declined.
- Fixed an issue where a failed call accept attempt left the CallKit call active on iOS.
- Improved reconnect flow reliability: fixed several issues that could cause reconnection to stall or silently fail, including delayed disconnect detection on broken connections and reconnect strategy hints being dropped while a reconnect was already in progress.
- Fixed fast reconnect escalating to rejoin after every single failure regardless of attempt count or connection health. Escalation now follows the same backoff and strategy-promotion logic used by all other reconnect modes.
- Fixed `X-Stream-Client` header and SFU `ClientDetails` being sent with stale or incomplete device/app info.
- Fixed incoming calls being locally rejected after accept when the coordinator WebSocket event arrived before the HTTP response ([#1254](https://github.com/GetStream/stream-video-flutter/issues/1254)).
- Fixed an Android crash when the push notification `TransparentActivity` is recreated with a null intent action (e.g. after process death or restore from recents) ([#1256](https://github.com/GetStream/stream-video-flutter/pull/1256)).
- [Android] Fixed a crash in `TransparentActivity` when the activity is recreated with a null intent action (e.g. after process death or restore from recents) ([#1256](https://github.com/GetStream/stream-video-flutter/pull/1256)).

## 1.4.0

Each call now owns an isolated native `PeerConnectionFactory`. This fixes cross-call audio interference, sibling-call microphone capture loss, and noise cancellation failing to engage during lobby preview.

### ✅ Added

- Added `Call.ensureNativeFactory()`, which returns the per-call native `NativePeerConnectionFactory`. Use it to pin pre-join media (e.g. lobby-preview tracks created via `RtcLocalTrack.camera(nativeFactory: …)`) to the same factory the call uses after joining.
- Added a per-call `audioConfigurationPolicy` override on `DefaultCallPreferences`. It falls back to `StreamVideoOptions.audioConfigurationPolicy` when null.
- The publisher now respects the SFU `degradationPreference` for video quality, falling back to `maintain-framerate` when it is unspecified.

### 🐞 Fixed

- Fixed connection flickering that caused the rejoin flow to fail in some cases.
- Added safety nets and recovery for cases where the publisher connection fails to establish after a reconnection (e.g. the SFU answer is lost or ICE stays in the `new` state).
- Fixed sibling-call audio capture being silently broken when another concurrently active call ended (e.g. a 1:1 ringing call ending alongside a running livestream, or a previous ringing call ending before a new one was accepted).
- Fixed a sibling call's audio breaking when a ringing 1:1 call ended via `dropIfAloneInRingingFlow` (the remote party hung up first). `Call.end()` and `Call.leave()` now share a single `_disconnect` cleanup path.
- Made the audio processor teardown in `Call._clear` multi-call aware. The audio processor is owned by `StreamVideo` rather than by an individual `Call`, so disabling it during one call's teardown silently dropped noise cancellation on any other still-active call. `_clear` now stops the global processor only when no other active call is configured to use `NoiseCancellationSettingsMode.autoOn`.
- Fixed noise cancellation breaking on iOS after the rejoin reconnection flow.
- Fixed a potential iOS crash on call end when noise cancellation was active.
- [WASM] Fixed integer stats fields failing to parse, where JS numbers arrive as `double`.

### 🔄 Changed

- [iOS/Android] Each call now also owns an isolated native `AudioDeviceModule`. Previously, all calls shared the global ambient factory. This per-call isolation is what enables clean multi-call audio. Integrators building tracks directly should pass `nativeFactory: await call.ensureNativeFactory()` to the `RtcLocalTrack.*` constructors.

## 1.3.3

### 🐞 Fixed

- Fixed `TranscriptionSettingsResponse.fromJson` crashing with a null check error when the backend returns an empty string for the `language` field.

### 🔄 Changed

- Improved disconnect/reject reason propagation.

### ✅ Added

- Support server-side pinning on participant join. When the SFU sends `isPinned: true` on a `ParticipantJoined` event, the participant is now automatically pinned.
- Added `hintHighScaleLivestreamPublisher` parameter to `Call.join()` to allow marking the participant as publishing to a large audience.

## 1.3.2

### 🐞 Fixed

- Fixed `consumeAndAcceptActiveCall` auto-accepting incoming calls on Android when the user opens the app without pressing the Accept button on the notification. The method now only consumes calls that the user explicitly accepted.
- Fixed coordinator REST API calls failing permanently when the JWT token expires.
- Fixed iOS Picture-in-Picture window not dismissing when the call ends during PiP mode.
- Fixed `CallDiagnosticsContent` throwing `failed to call super.dispose` when the widget was disposed while awaiting stats subscription cancellation.

### 🔄 Changed

- Regenerated OpenAPI models to match the latest backend schema.
- Fixed broadcasting status updates not being wired through to call state.
- Updated conditional imports to support WASM.

### ⚠️ Deprecated

- `StreamHlsSettings.qualityTracks` (`List<String>`) is deprecated — use `StreamHlsSettings.qualities` (`List<StreamVideoQuality>`) instead.

### ✨ Refactor

- Refactored call control options to use `PartialCallStateBuilder` for reactive state updates instead of one-shot `call.state.value` reads.

## 1.3.1

### 🐞 Fixed

- Reverted iOS audio session release on call leave ([#1155](https://github.com/GetStream/stream-video-flutter/pull/1155)) due to reports of broken audio playout on some iOS sessions.
- Improved SFU join, recovery and migration logic to reduce failed joins with reconnect loops when joining full or shutting-down SFU
- Fixed race condition in `Call.join` when another connect is already in progress, with proper timeout handling.
- Fixed `consumeAndAcceptActiveCall` to ensure the coordinator WS is connected before consuming incoming calls during cold start.

## 1.3.0

### ✅ Added

- Added video moderation support by providing `VideoModerationConfig` in `CallPreferences`. Check [cookbook](https://getstream.io/video/docs/flutter/ui-cookbook/call-moderation/) for more details.
- Added HiFi audio mode for high-fidelity scenarios such as live music, podcasts, and professional streaming. Use `SfuAudioBitrateProfile` to select an audio quality profile before joining a call:
  - `SfuAudioBitrateProfile.voiceStandard` – Standard voice (64 kbps, default)
  - `SfuAudioBitrateProfile.voiceHighQuality` – High-quality voice (128 kbps)
  - `SfuAudioBitrateProfile.musicHighQuality` – HiFi music mode (128 kbps, audio processing disabled)
- Added stereo playout (iOS and Android) and capture (Android only) support with new `audioConfigurationPolicy` in `StreamVideoOptions`. Includes predefined policies:
  - `AudioConfigurationPolicy.broadcaster()` – Mono playout with voice processing enabled (default)
  - `AudioConfigurationPolicy.viewer()` – Stereo playout with voice processing disabled, ideal for passive listeners
  - `AudioConfigurationPolicy.hiFi()` – Stereo capture and playout with voice processing disabled, ideal for hosts streaming high-fidelity audio
  - `AudioConfigurationPolicy.custom()` – Full control over platform-specific audio settings with optional `basePolicy` fallback
- Added `RtcMediaDeviceNotifier.reinitializeAudioConfiguration()` to switch audio configuration policy at runtime (must be called before starting a call).

See the [documentation](https://getstream.io/video/docs/flutter/guides/camera-and-microphone/high-fidelity-audio/) for details.

### ⚠️ Deprecated

- Deprecated `androidAudioConfiguration` in `StreamVideoOptions`. Use `audioConfigurationPolicy` instead.

### 🐞 Fixed

- Added handling for SFU `iceRestart` event — the client now correctly performs ICE restart and renegotiation when instructed by the SFU, improving fast reconnect reliability.
- Added PeerConnection SDP rollback on failed remote answer to prevent the publisher from getting stuck in an inconsistent signaling state.
- When `dropIfAloneInRingingFlow` is set to true in `CallPreferences` the call will now end when the last participant leaves the call.

## 1.2.4

### 🐞 Fixed

- [Web] Fixed an issue with call being stuck during Connecting state.

## 1.2.3

### ⚡ Performance

- Improved `call.leave()` performance

### ✅ Added

- Added `includesCallsInRecents` to iOS push configuration to control whether CallKit calls appear in Recents.

### 🐞 Fixed

- Fixed race condition where remote tracks could arrive before participant join events, causing track state to be lost.
- Improved reconnection reliability:
  - Added exponential backoff with jitter to fast reconnect attempts.
  - Fixed fast reconnect deadline check to correctly trigger fallback to rejoin.
  - Fixed network availability verification during subsequent fast reconnect attempts.
  - Added `reconnectReason` to reconnect details for sfu logs.
  - Fixed race condition where automatic ICE restart could interfere with fast reconnect, causing subscriber video to not recover.
- [iOS] Fixed audio session not being released when leaving a call, which prevented other audio packages from using the microphone.
- [iOS] Fixed CallKit event suppression to avoid repeated mute toggle loops.
- [Android] Fixed issues when accepting incoming calls from detached state (app exited via back button).
- [Android] Fixed incoming call notifications not showing when the app is in a detached state (e.g., after pressing the back button).
- [Android] Fixed video flickering in Skia renderer by scoping renderer keys with prefix and using stable participant-based keys.

## 1.2.2

### 🐞 Fixed

- [Android] Fixed WebSocket/WebRTC connections persisting after app is killed from recents. Foreground services now properly terminate and leave calls when the app task is removed.

## 1.2.1

### ✅ Added

- Added default sorting preset for Picture-in-Picture mode to prioritize the most relevant participant.

### 🐞 Fixed

- [Android] Fixed screen share notification tap not opening the app.
- [Android] Improved screen sharing foreground service reliability:
  - Added proper synchronization to ensure the foreground service is fully started before initiating media projection.
  - `startScreenSharingNotificationService` now returns a boolean indicating success/failure, preventing screen share attempts when the service fails to start.
- [iOS/macOS] Fixed crash when VoIP push is received before Flutter fully initializes from the terminated state.

## 1.2.0

### ✅ Added

- [Android] Added support for screen audio sharing. To enable it set `captureScreenAudio` to true in `ScreenShareConstraints`. See [documentation](https://getstream.io/video/docs/flutter/advanced/screen_sharing/#screen-audio-sharing) for more details.

### 🐞 Fixed

- Fixed unnecessary video filter reapplication when camera track is disabled.
- [Android] Fixed an issue where the camera freezes for person using screen sharing without PiP enabled.
- [Android] Fixed active foreground service not being started when notification permission is denied.

## 1.1.0

### ✅ Added

- Added `pipTrackPriority` parameter to `PictureInPictureConfiguration` to control whether screen sharing or camera track is preferred in PiP mode. When set to `camera`, the camera track is preferred, but screen share will still be shown as a fallback if the camera is disabled.
- Added multiple-host and screen sharing support in `LivestreamPlayer` and `LivestreamContent`.
  - New flags: `showMultipleHosts`, `layoutMode`, `screenShareMode`.
  - New builders: `livestreamHostsParticipantBuilder` and `livestreamHostsParticipantsFilter` to customize how hosts are selected and rendered.
- Added `videoFit` parameter in `LivestreamPlayer` to control contain/cover behavior when not in fullscreen.
- Livestream reconnect UI customization:
  - `LivestreamPlayer`/`LivestreamContent`: added `livestreamFastReconnectingOverlayBuilder` to customize the UI shown during fast reconnect.
  - `LivestreamContent`: `livestreamNotConnectedBuilder` provides `isMigrating`/`isReconnecting` flags to tailor messaging when not connected.
- Call screen reconnect UI customization:
  - `StreamCallContent`: added `callFastReconnectingOverlayBuilder` to render a custom overlay while fast reconnecting.
  - `StreamCallContent`: `callNotConnectedBuilder` now exposes `CallNotConnectedProperties` with `isMigrating`/`isReconnecting` to customize the not-connected/reconnecting view.

### 🐞 Fixed

- Fixed ANR (Application Not Responding) issue on Android that could happen when starting screen share service.
- Fixed crash on Android versions below API 31 when disabling Picture-in-Picture mode.

### ⚡ Performance

- Improved `call.join()` performance - reduced join time by optimizing WebRTC setup and deferring non-critical operations.
- Improved SFU allocation reliability.

## 1.0.2

🐞 Fixed

- Fixed incoming call timeout handling.
  - Use `streamVideo.observeCoreRingingEventsForBackground()` instead of `streamVideo.observeCallDeclinedRingingEvent()` in `firebaseMessagingBackgroundHandler` to support all necessary events.

## 1.0.1

### ✅ Added

- Added support for changing the camera target resolution during an ongoing call using the `call.setCameraTargetResolution()` method.

#### LivestreamPlayer Improvements

- Added support for Picture in Picture (PiP) mode, configurable via the `pictureInPictureConfiguration` parameter. For platform-specific setup, refer to the [documentation](https://getstream.io/video/docs/flutter/advanced/picture_in_picture/).
- Introduced the `joinBehaviour` parameter, allowing control over whether and when the `LivestreamPlayer` automatically connects the user to a call.
- Added the `showRecordingsWhenEnded` parameter to `LivestreamPlayer`, which enables you to show or hide the recordings list in the default livestream ended UI.
- Refactored `LivestreamPlayer` to leverage `call.partialState` for more efficient state management. New builder methods have been introduced to accommodate this change, and some previous builder methods are now deprecated.

## 1.0.0

### 🚧 Breaking changes

#### CallKit/Ringing

This release removes the dependency on `flutter_callkit_incoming`, resulting in several breaking changes to CallKit and ringing functionality:

- **CallKit/ringing configuration:** The initialization process is updated. Replace the `pushParams` parameter in `StreamVideoPushNotificationManager` with the new `pushConfiguration` field (`StreamVideoPushConfiguration`).
- **Parameter renaming:** The `nameCaller` parameter has been standardized and renamed to `callerName` across all relevant locations.
- **Removed properties:**
  - The deprecated `callerCustomizationCallback` and `backgroundVoipCallHandler` have been fully removed from `StreamVideoPushNotificationManager`.
  - The previously used `appName` field in `pushParams` has been removed as it was deprecated. On iOS, the app’s product name from build settings is now used instead.
- **API renames and type changes**
  - `onCallKitEvent` is now `onRingingEvent`
  - `observeCoreCallKitEvents` is now `observeCoreRingingEvents`
  - `observeCallAcceptCallKitEvent` is now `observeCallAcceptRingingEvent`
  - `observeCallDeclinedCallKitEvent` is now `observeCallDeclinedRingingEvent`
  - `observeCallEndedCallKitEvent` is now `observeCallEndedRingingEvent`
  - The `CallKitEvent` type is now `RingingEvent`

#### Video Filter

- The video filters feature, which enables blur and virtual backgrounds during calls, has been moved to a new package: `stream_video_filters`. To use video filters, add the package to your `pubspec.yaml` and update your relevant imports.

#### Deprecated members

- Removed deprecated APIs and parameters. Migrate as follows:
  - `StreamVideo.muteVideoWhenInBackground` → `StreamVideo.options.muteVideoWhenInBackground`
  - `StreamVideo.muteAudioWhenInBackground` → `StreamVideo.options.muteAudioWhenInBackground`
  - Default `StreamCallType()` constructor → `StreamCallType.defaultType()`
  - `Call.setParticipantPinned()` → `Call.setParticipantPinnedLocally()` (local-only pin)
  - Removed deprecated `startRtmpBroadcasts` parameter from `Call.goLive()`
  - Removed `localParticipant` parameter from `AddReactionOption` constructor
  - Removed multiple deprecated builder callbacks in favor of [callbacks that don't provide the state object](https://github.com/GetStream/stream-video-flutter/pull/983); corresponding state object parameters in affected widgets have been removed.
  - Deprecated `androidAudioAttributesUsageType` and `androidAudioAttributesContentType` parameters in `RtcMediaDeviceNotifier.handleCallInterruptionCallbacks()`

---

### 🍏 **Swift Package Manager (SPM)**

- Added Swift Package Manager (SPM) support for iOS.
  > [!IMPORTANT]  
  > Flutter's iOS SPM is experimental and disabled by default. You can enable it via `flutter config --enable-swift-package-manager`. Flutter will fall back to CocoaPods for plugins that don't support SPM. See the [Flutter SPM docs](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers).

### ✨ Improvements

- [Android] Significantly improved video filter performance, resulting in smoother frame rates during calls.

### ✅ Added

- Added `Call.ring()` to ring specific members of an existing call. Example: `call.ring(userIds: ['<userId>'], video: true)`. Sends a ringing/VoIP push to the users’ devices. Users must already be members - use `call.addMembers()` first if needed.
- Added `RtcMediaDeviceNotifier.pauseAudioPlayout()` / `RtcMediaDeviceNotifier.resumeAudioPlayout()` to mute and restore remote playback with platform-specific handling for iOS/macOS and Android.
- [Android] Enhanced interruption handling via `RtcMediaDeviceNotifier.handleCallInterruptionCallbacks()`.
- [Android] Added `RtcMediaDeviceNotifier.regainAndroidAudioFocus()` to request audio focus when it was lost without automatic regain.

### 🐞 Fixed

- [iOS] Resolved an issue in Picture in Picture where video tracks might remain disabled after returning the app to the foreground.
- [iOS] Addressed a problem where Picture in Picture was not exited properly if the call ended during PiP mode.
- [iOS] Fixed a bug where quickly backgrounding the app right after ending a call could still activate PiP mode.
- Resolved an issue that could cause the StreamVideo instance to be disposed prematurely before ringing events were fully processed when handling ringing notifications in the terminated state.

## 0.11.2

🐞 Fixed

- [Web] Fixed setting input audio/video device passed by `CallConnectOptions` as well as switching those devices during the call.
- [Web] Fixed changing the output audio device during the call.
- [Android/iOS] Fixed an issue where screen sharing was not stopped correctly when canceled via the system UI on Android or iOS.
- [iOS] Improved broadcast extension handling — the app now waits for the broadcast picker selection before actually starting screen sharing.
- Resolved an issue where the camera wouldn’t flip correctly if the back camera was selected initially.
- Fixed an issue where `callMembers` collection wasn't reflecting the actual members list after starting the call session.
- Fixed an issue with initials creation when multicharacter symbols were used in a user name.

✅ Added

- [Web] Added `checkIfAudioOutputChangeSupported()` to the `Call` class to check whether the browser supports changing the audio output device.

## 0.11.1

🔄 Changed

- The `byParticipantSource` participant sorting now accepts a list of sources. The default sorting for `speaker` and `livestream` presets now include other ingress sources.
- Updated the renderscript dependency on Android to support 16kb page size.

## 0.11.0

🚧 Build breaking changes

> **Important:** This release includes breaking changes for Android development.
>
> **Android Requirements:**
>
> - Minimum compileSDK 36
> - Android Gradle Plugin >=8.12.1
> - Gradle wrapper >=8.13
> - Kotlin 2.2.0

- Updated minimum Flutter version to 3.32.0
- Updated minimum supported Dart SDK version to 3.8.0

🚧 Breaking changes

- **`Call.stats` payload structure changed**
  - **Before:** `({ CallStats publisherStats, CallStats subscriberStats })`
  - **Now:** `({ PeerConnectionStatsBundle publisherStatsBundle, PeerConnectionStatsBundle subscriberStatsBundle })`
  - The record field names and element types have changed to provide more detailed WebRTC statistics

- **Stats-related fields removed from `CallState`**
  - Removed: `publisherStats`, `subscriberStats`, `latencyHistory`
    - For periodic WebRTC stats: Use `call.stats` stream
    - For latest aggregated metrics: Use `call.statsReporter?.currentMetrics`

- **Dependency updates**
  - Updated most dependencies to their latest versions to ensure compatibility and security

✅ Added

- New `call.statsReporter` property provides access to `currentMetrics`
- Battery level tracking now available via `call.statsReporter?.currentMetrics`
- Device thermal status monitoring for better call quality optimization

🔄 Changed

- `Call.stats` record field names and types updated as noted in breaking changes section

🐞 Fixed

- Fixed leave call operation failures when parsing custom data encounters issues
- [Android] Fixed custom Android audio configuration application for participants joining calls
- [Android] Fixed video rendering issue where background textures were incorrectly blended with video content on devices using Impeller rendering engine

## 0.10.4

✅ Added

- Extended `CallParticipantState` with `participantSource`. This indicates the participant's source channel (e.g., WebRTC, RTMP, WHIP) and can be used in filtering and sorting criteria.
- Livestream sorting preset now prioritises RTMP sources in layout sorting.
- Automatic SFU-driven pausing of inbound video to save bandwidth and prevent visual artifacts:
  - New `SfuClientCapability.subscriberVideoPause` (on by default). Control via `Call.enableClientCapabilities()` / `Call.disableClientCapabilities()`.
  - New `SfuInboundStateNotificationEvent` notifies when inbound tracks are paused or resumed.
  - `CallParticipantState.pausedTracks` and `CallParticipantState.isTrackPaused()` let you check which tracks are currently paused.
- Added capability to remove a participant from a call via `call.kickUser()`. Requires the `kick-user` permission.

🐞 Fixed

- Multitasking camera on iOS is now enabled only once and kept enabled. This fixes potential errors when quickly toggling camera.

## 0.10.3

🐞 Fixed

- Handled SFU stats reporting failures gracefully

✅ Added

- Added option to configure android audio configuration when initializing `StreamVideo` instance by providing `androidAudioConfiguration` to `StreamVideoOptions`.

## 0.10.2

✅ Added

- Added support for setting video filters before the video track is created by listening for local participant state changes and applying the filters once the video is enabled.
- Added support for setting video filters on a specific video track before the local participant is available — useful for scenarios like lobby previews with a temporary video track.
- Introduced the `reconnectTimeout` option in `CallPreferences`, allowing you to set the maximum duration the SDK will attempt to reconnect to a call before giving up.

🔄 Changed

- Deprecated `callRejoinTimeout` in `RetryConfig`, instead added `networkAvailabilityTimeout` to `CallPreferences` to control how long the SDK waits for network connectivity to be restored during reconnection attempts before timing out.

🔄 Dependency updates

- Updated `flutter_callkit_incoming` dependency to version 2.5.7. That version contains Android 14 compatibility fixes for ringing notifications and lock screen handling.

🐞 Fixed

- (Android) CircleTransform Argument type mismatch on Bitmap.Config?
- Sorting of participants after screen sharing stopped.
- Fixed an issue where video filters were cleared after toggling the camera.
- (Windows) Fixed `DtlsSrtpKeyAgreement` audio constraint parameter mapping

## 0.10.1

🐞 Fixed

- (iOS) Fixed Picture-in-Picture (PiP) issue where remote participants joining during active PiP mode would not have their video tracks displayed properly.
- (iOS) Fixed a visual issue where the Picture-in-Picture view displayed an empty container when participant name and microphone indicator settings were disabled.
- Fixed an issue where the last reaction was removed too fast when a user sends multiple reactions quickly after each other.
- Fixed an issue where toggling camera enabled quickly could cause AVCaptureMultiCamSession to crash.
- Fixed an issue where the default camera selection would occasionally be incorrect even when properly configured.
- Fixed an issue where changing the audio input device while muted from the start of a call would not apply the new device when unmuting. The selected device will now be correctly set upon unmuting.

✅ Added

- Added support for customization of display name for ringing notifications by providing `display_name` custom data to the call. See the [documentation](https://getstream.io/video/docs/flutter/advanced/incoming-calls/customization/#display-name-customization) for details.

## 0.10.0

🚧 (Android) Picture-in-Picture (PiP) Improvements - Breaking Change

- **Simplified Setup:** Introduced `StreamFlutterActivity` - extend it instead of `FlutterActivity` for automatic PiP support.
- **Automatic Activation:** PiP now triggers automatically when users press home button or background the app during calls.
- **Fixed Overlay Issues:** PiP view can no longer be overlapped by other widgets and will always display the correct video layout.
- **Migration Required:** In your `MainActivity`, remove the manual `onUserLeaveHint()` implementation and extend the MainActivity with `StreamFlutterActivity`. Previously required manually calling `PictureInPictureHelper.enterPictureInPictureIfInCall(this)` - now handled automatically.
- **Removed Deprecated Methods:** Removed the deprecated `setPictureInPictureEnabled` method from `StreamVideoFlutterPlatform`, `StreamVideoFlutterBackground`, and `MethodChannelStreamVideoFlutter` classes, and the deprecated `enterPictureInPictureIfInCall` method from `PictureInPictureHelper` (Android). PiP is now handled automatically by `StreamPictureInPictureAndroidView`.

🔄 Partial State Updates:

For a more detailed explanation check [the dedicated documentation](https://github.com/GetStream/stream-video-flutter/blob/main/packages/stream_video_flutter/doc/partial_state_update_changes.md).

- Added `call.partialState` for more specific and efficient state updates.
- Added callbacks in `StreamCallContainer`, `StreamCallContent`, `StreamIncomingCallContent`, and others that no longer return a state.
  By (only) using these callbacks the root widgets will use more efficient partial state updates.
- Added `PartialCallStateBuilder` to help with making widgets that depend on `partialState`.
- Deprecated old callbacks

✅ Added

- Added `setMirrorVideo` method to `Call` class to control video mirroring for participants.
- Added `maxParticipantsExcludeOwner` and `maxParticipantsExcludeRoles` to Call limits settings, providing finer control over participant limits by allowing exclusion of call owners and specific roles from the maximum count.

🐞 Fixed

- Improved SFU error handling in Call flow and disconnect reason handling. The disconnected call state now accurately reflects the original cause of disconnection.
- Fixed an issue where rejecting a ringing call on one device would incorrectly end the call for all already connected participants.
- Enhanced fast reconnect mechanism with improved PeerConnection issue detection and recovery. The system now attempts multiple fast reconnects before falling back to a full call rejoin.
- Fixed simulcast video quality by correcting resolution calculations and layer selection for optimal video track display.
- Fixed an edge case where a call with the same CID as an incoming call is also an outgoing call to ensure the same Call instance is used.

## 0.9.6

✅ Added

- Added `handleCallInterruptionCallbacks` method to `RtcMediaDeviceNotifier` that provides an option to handle system audio interruption like incoming calls, or other media playing. See the [documentation](https://getstream.io/video/docs/flutter/advanced/handling-system-audio-interruptions/) for details.
- Improved the Picture-in-Picture (PiP) implementation for video calls
  - (iOS) Shows participant avatar instead of black screen when video track is disabled.
  - (iOS) Added overlay with participant name, microphone indicator and connection qualit indicator.
  - (iOS/Android) Added `sort` in `PictureInPictureConfiguration` that enables customization of PiP participant selection.

🐞 Fixed

- Fixed the handling of user blocking event to disconnect the blocked user with a proper reason.

## 0.9.5

✅ Added

- Introduced `extendBody` parameter in `StreamCallContent` that extends the participants view to the bottom edge of the scaffold when enabled.
- Introduced `allowMultipleActiveCalls` option in `StreamVideoOptions` enabling support for concurrent active calls. See the [documentation](https://getstream.io/video/docs/flutter/advanced/multiple-simultaneous-calls-support/) for details.

🐞 Fixed

- Enhanced permission update handling to only process events targeting the current user.
- Improved audio output device selection to prioritize external audio devices during call connection.

## 0.9.4

🐞 Fixed

- Resolved an issue where the screen share track would disappear when zoomed in.
- Fixed screen sharing layout issues on wide screens.
- Fixed `ScreenShareCallParticipantsContent` with Spotlight view on very wide windows.

✅ Added

- Introduced new builder parameters to `LivestreamPlayer` for enhanced customization:
  - `videoRendererBuilder`: Build a custom video renderer.
  - `videoPlaceholderBuilder`: Build a placeholder for the video renderer.
  - `livestreamHostsUnavailableBuilder`: Customize the UI when a livestream is connected but no hosts have video enabled.
  - `livestreamNotConnectedBuilder`: Customize the UI when the livestream is not connected.

## 0.9.3

✅ Added

- Introduced `callDurationStream` to the `Call` class. A `Stream<Duration>` that emits the current call duration.
- Added `createdByUser` property to the `CallState` for better tracking of the initiating user.
- Added `livestreamControlsBuilder` parameter to `LivestreamPlayer` allowing customisation of controls panel.

🐞 Fixed

- Resolved an issue where participants’ tracks would briefly disappear ("blink") or change location when many participants are in the call.
- Fixed a bug where subsequent screen sharing sessions did not end properly when terminated via the browser UI.

## 0.9.2

🐞 Fixed

- Fixed issue with the user feedback collection endpoint.

✅ Added

- Added `ring`, `audio`, `video`, `screenshare`, `session` and `frameRecordings` settings to `Call.getOrCreate()` method.
- Added `members` list parameter to `Call.getOrCreate()` method to allow assigning roles when creating a call.
- Added `session` and `frameRecordings` settings to `Call.update()` method.

🔄 Updated

- Updated `LivestreamPlayer` widget with a refreshed look and feel. Added `livestreamEndedBuilder` and `livestreamBackstageBuilder` for enhanced configuration options.

## 0.9.1

✅ Added

- Introduced camera focus and zoom control features:
  - New `Call.setZoom()` method to adjust the camera’s zoom level.
  - New `Call.focus()` method for setting focus and exposure points on the camera.

🐞 Fixed

- [Android] Fixes the device orientation detection when screen-sharing on some Android devices.
- Addressed minor bugs and improved performance.

## 0.9.0

✅ Added

- Introducing noise cancellation support to enhance call audio quality. Implement this feature easily by following our [documentation](https://getstream.io/video/docs/flutter/guides/noise-cancellation/).
- Added `networkMonitorSettings` to `StreamVideoOptions` for configuring network monitoring, including customization of test URLs for connection checks.

🚧 (Breaking Changes)

- Enhanced the `onCallDisconnected` callback in `StreamCallContainer` to include a `CallDisconnectedProperties` parameter with detailed disconnection reason information.
- Improved `setScreenShareEnabled` method in `CallSession` class to return the screen sharing track.
- Relocated `callPreferences` property from `CallStateNotifier` to `CallState` for better state management.
- Increased minimum platform requirements
  - **Android:** Minimum SDK 21 (Android 5.0 Lollipop)
  - **iOS:** iOS 14.0 or higher

🐞 Fixed

- Enhanced fast reconnect flow for more reliable connection recovery during network interruptions.
- Resolved an issue where video tracks weren't properly subscribed when participants joined calls.
- Fixed multi-device support to properly handle when the same user joins from multiple devices.
- Corrected screen sharing source switching when changing between multiple sources.
- Fixed a bug where `CallPreferences` could be ignored when accepting a ringing call.
- (Android) Resolved compatibility issues with `battery_plus` plugin on older Android devices.
- (Web) Fixed screen sharing termination when using browser UI controls to stop sharing.
- (iOS) Synchronized CallKit microphone mute state with the actual call mute state.

## 0.8.4

🐞 Fixed

- (iOS) Fixed an issue where Picture-in-Picture (PiP) would not stop when bringing the app back to the foreground.

🔄 Changed

- Updated the `device_info_plus` dependency to support a wider range of versions and resolve potential conflicts.
- Deprecated the `setParticipantPinned()` method in the `Call` class — use `setParticipantPinnedLocally()` instead.
- Replaced the `isPinned` parameter in `CallParticipantState` with a `pin` object, which now differentiates between local and remote pinning.

✅ Added

- Introduced a `membersLimit` parameter in the `getOrCreate()` and `join()` methods of the `Call` class to limit the number of members included in the response.
- Added `setParticipantPinnedForEveryone()`, allowing users with the required permissions to pin participants for all. The `setParticipantPinned()` method has been replaced with `setParticipantPinnedLocally()`, which, as before, only pins participants locally.

🔄 Changed

- Update stream_webrtc_flutter and device_info_plus dependencies

## 0.8.3

✅ Added

- Introduced `CallParticipantState.audioLevels`, which stores the last 10 audio levels of a participant.
- Added `CallState.activeSpeakers` to retrieve a list of currently active speakers.
- Enhanced `observeCoreCallKitEvents()` in `StreamVideo` with a new `CallPreferences? preferences` parameter, allowing for configuration of the accepted call.
- Implemented localization support for the SDK's UI components. See the [documentation](https://getstream.io/video/docs/flutter/localization/) for details.
- Added the ability to customize the screen share selector on desktop devices. See the [updated documentation](https://getstream.io/video/docs/flutter/advanced/screen_sharing/) for details.

🐞 Fixed

- Resolved various issues related to screen sharing on desktop devices.

## 0.8.2

✅ Added

- Added `CallPreferences? preferences` parameter to `consumeIncomingCall()` method in `StreamVideo` to make it possible to configure the consumed call.

🐞 Fixed

- Fixed remote participant roles array being empty after joining the call.
- Fixed and issue with `thermal` package throwing exception on Android 9 and lower.

## 0.8.1

✅ Added

- Introduced the `onCallDisconnected` callback in `StreamCallContainer`, enabling customization of the default behavior, which invokes `Navigator.pop` upon call disconnection.
- Made `registerDevice()` and `unregisterDevice()` methods publicly available in `PushNotificationManager`.

## 0.8.0

- Updated minimum Flutter version to 3.27.4
  - Note: If you updated Flutter version and are using `flutterfire_cli` for push notifications you might need to reactivate it by running: `dart pub global activate flutterfire_cli`.

✅ Added

- Introduced `disposeAfterResolvingRinging()` and `consumeAndAcceptActiveCall()` methods in `StreamVideo` to simplify the ringing flow implementation.
  - Refer to the updated [Incoming Call Documentation](https://getstream.io/video/docs/flutter/advanced/incoming-calls/overview/) or the [Ringing Tutorial](https://getstream.io/video/sdk/flutter/tutorial/ringing/) for more details.

🔄 Changed

- Deprecated the `backgroundVoipCallHandler` parameter in `StreamVideoPushNotificationManager`, as it is no longer required for iOS ringing to function in a terminated state.

🐞 Fixed

- Center alignment of buttons in `StreamLobbyVideo` to support more screen sizes.
- **(Windows/Linux)** Fixes compilation issues caused by `stream_webrtc_flutter` package.

🚧 (Breaking) Picture-in-Picture (PiP) Improvements & Fixes

- **Fixed:** PiP not working on Android 15.
- **Fixed:** PiP not displaying other participants' screen sharing.
- **Added support for iOS 18 Multitasking Camera Access changes.** From **iOS 18**, you can easily enable camera usage while the app is in the background (e.g., for PiP). Refer to [Picture in Picture documentation](https://getstream.io/video/docs/flutter/advanced/picture_in_picture/) for details.
- Added `disablePictureInPictureWhenScreenSharing` configuration option to `PictureInPictureConfiguration`. When **true** (default), PiP is disabled if the local device is screen sharing.
- ❗ Breaking Change: `ignoreLocalParticipantVideo` parameter in `IOSPictureInPictureConfiguration` is replaced by `includeLocalParticipantVideo`. By default, local video **is enabled** and will appear in PiP mode if the iOS device supports **Multitasking Camera Access**.
- ❗ Breaking Change: `ignoreLocalParticipantVideo` parameter in `StreamPictureInPictureUiKitView` is also replaced by `includeLocalParticipantVideo`.

## 0.7.2

🐞 Fixed

- Resolved an issue where accepting a second call while already on a call would not open the call screen correctly. [#840](https://github.com/GetStream/stream-video-flutter/pull/840) and [#834](https://github.com/GetStream/stream-video-flutter/pull/834)
- **(Web)** Fixed web compilation issues. [#832](https://github.com/GetStream/stream-video-flutter/pull/832)
- **(Web)** Addressed an issue where `battery_plus` and `thermal` packages were erroneously called on web. [#837](https://github.com/GetStream/stream-video-flutter/pull/837)
- **(iOS)** Fixed an issue where Picture-in-Picture mode was not ended when the call ended. [#840](https://github.com/GetStream/stream-video-flutter/pull/840)
- **(iOS)** Resolved an issue where CallKit calls sometimes were not terminated when the Stream call ended. [#840](https://github.com/GetStream/stream-video-flutter/pull/840)
- **(iOS)** Fixed a missing app icon on the CallKit screen when the app was in a terminated state. [#841](https://github.com/GetStream/stream-video-flutter/pull/841)

🔄 Changed

- Deprecated the `handleVoipPushNotification()` method in the `StreamVideo` class. Use `handleRingingFlowNotifications()` instead.

## 0.7.1

🐞 Fixed

- Resolved an issue where media tracks were not being disabled or enabled correctly. [#828](https://github.com/GetStream/stream-video-flutter/pull/828)
- Fixed a problem causing anonymous users to fail when connecting and joining calls. [#827](https://github.com/GetStream/stream-video-flutter/pull/827)

## 0.7.0

🚧 Breaking changes

- The package is now compatible with Gradle 8. The minimum required Java version is now 17. [#820](https://github.com/GetStream/stream-video-flutter/pull/820)
- Updated the `flutter_callkit_incoming` package to version 2.5.0, which also requires Java 17. [#820](https://github.com/GetStream/stream-video-flutter/pull/820)
- The `resolution` parameter of `Call.setPreferredIncomingVideoResolution()` method changed type from `VideoResolution` to `VideoDimension`.
- The `Call.onPermissionRequest` callback changed the event type passed as an argument from `CoordinatorCallPermissionRequestEvent` to `StreamCallPermissionRequestEvent`

✅ Added

- Added out-of-the-box support for blur background filters and image filters. As well as the option to create custom video filters. For complete documentation of those features please check [here.](https://getstream.io/video/docs/flutter/advanced/apply-video-filters/) [#799](https://github.com/GetStream/stream-video-flutter/pull/799)
- Added support for Closed Captions. [#796](https://github.com/GetStream/stream-video-flutter/pull/796)
  - Listen to the `Call.closedCaptions` stream to overlay captions during your call.
  - Use `CallPreferences` to configure:
    - `closedCaptionsVisibilityDurationMs` for controlling how long captions are displayed.
    - `closedCaptionsVisibleCaptions` for managing the number of captions in the display queue.
  - Easily enable or disable captions with the `ToggleClosedCaptionsOption` widget.
  - Learn More:
    - Check the [guide](https://getstream.io/video/docs/flutter/closed-captions/) for integration steps.
    - Explore the [cookbook](https://getstream.io/video/docs/flutter/ui-cookbook/closed-captions/) for UI tips.
- Dynamic codec negotiation during calls. [#811](https://github.com/GetStream/stream-video-flutter/pull/811)

🐞 Fixed

- Fixed issues when ending the call while in Picture in Picture mode on Android. [#822](https://github.com/GetStream/stream-video-flutter/pull/822)
- Fixes rejecting ringing call when CallEnd, instead of CallDecline, event is triggered by CallKit during ringing. [#824](https://github.com/GetStream/stream-video-flutter/pull/824)

## 0.6.1

- Updated minimum Flutter version to 3.24.5

✅ Added

- Added the `call.collectUserFeedback()` method which allows users to send call quality rating. These ratings are visible on the Dashboard and are aggregated in call stats for easy tracking. For a sample implementation, please refer to the [documentation](https://getstream.io/video/docs/flutter/user-rating/).
- Added device thermal status reporting to better optimize call quality.
- Added the `StreamVideoPushNotificationManager.ensureFullScreenIntentPermission()` method. This resolves an issue on some Android 14 devices where full-screen notifications would not appear due to missing permissions.
  You can now invoke this method to show a settings screen, allowing users to enable the required permission if it's not already enabled.

🐞 Fixed

- Resolved an issue where CallKit calls would not connect when accepted while the screen was locked.
- Fixed a bug where the Android foreground service would not stop when the app was killed, keeping the call connection active.

## 0.6.0

This release introduces a major rework of the join/reconnect flow in the Call class to support Reconnect V2, enhancing reconnection handling across various scenarios. Most updates are within the internals of the Call class, though some changes are outward-facing, including a few breaking changes.

🔄 Changed

- `Call.reject()` method will now always call `Call.leave()` method internally.

🚧 Breaking changes

- Removed the deprecated `Call.joinLobby()` method.
- The `maxDuration` and `maxParticipants` parameters of `Call.getOrCreate()` are now combined into the `StreamLimitsSettings? limits` parameter.

🔄 Dependency updates

- Updated Firebase dependencies to resolve Xcode 16 build issues.

✅ Added

- Added the `registerPushDevice` optional parameter (default is `true`) to the `StreamVideo.connect()` method,allowing the prevention of automatic push token registration.
- Added `participantCount` and `anonymousParticipantCount` to `CallState` reflecting the current number of participants in the call.
- Introduced the `watch` parameter to `Call.get()` and `Call.getOrCreate()` methods (default is `true`). When set to `true`, this enables the `Call` to listen for coordinator events and update its state accordingly, even before the call is joined (`Call.join()`).
- Added support for `targetResolution` setting set on the Dashboard to determine the max resolution the video stream.
- Introduced new API methods to give greater control over incoming video quality. `Call.setPreferredIncomingVideoResolution()` allows you to manually set a preferred video resolution, while `Call.setIncomingVideoEnabled()` enables or disables incoming video. For more details, refer to the [documentation](https://getstream.io/video/docs/flutter/manual-video-quality-selection/).

🐞 Fixed

- Automatic push token registration by `StreamVideo` now stores registered token in `SharedPreferences`, performing an API call only when the token changes.
- Fixed premature ringing termination issues.
- Resolved issues where ringing would not end when the caller terminates the call in an app-terminated state.
- Fixed issue with call not ending in some cases when only one participant is left and `dropIfAloneInRingingFlow` is set to `true`.

## 0.5.5

🐞 Fixed

- Migrated from `internet_connection_checker` to `internet_connection_checker_plus` due to [license issues](https://github.com/github/dmca/blob/master/2024/09/2024-09-04-internet-connection-checker-plus.md).
- `callAppBarBuilder` in `StreamCallContent` can now return null in order to hide the app bar.
- `backgroundColor` field in `StreamCallControls` is now correctly applied.

## 0.5.4

🐞 Fixed

- Fixed an issue where active call foreground service was recreated after being stopped when ringing call was declined and in-app incoming screen was displayed.

🚧 Breaking changes

- The regular push notification handling has been removed from iOS, providing more control over the implementation. VoIP push notifications will continue to be handled as before. For more details, refer to the [documentation](https://getstream.io/video/docs/flutter/push-notifications/).

- Dependency updates
  - **Flutter SDK** constraint updated to >=3.22.0 (**Dart SDK** to >=3.4.0 <4.0.0)
  - **internet_connection_checker** updated from ^1.0.0+1 to ^2.0.0
  - **rxdart** updated from ^0.27.7 to ^0.28.0
  - **web** updated from ^0.5.1 to ^1.0.0
  - **web_socket_channel** updated from ^2.4.0 to ^3.0.1
  - **firebase_core updated** from ^2.15.1 to ^3.4.0
  - **firebase_messaging** updated from ^14.5.0 to ^15.1.1
  - **share_plus** updated from ^7.1.0 to ^10.0.2
  - **json_annotation** updated from ^4.8.0 to ^4.9.0

## 0.5.3

🐞 Fixed

- Improved video quality for a smoother experience.
- Resolved an issue where the participant's state showed an empty roles list.
- Fixed a bug that caused the CallKit ringing notification to continue after a call was accepted.

## 0.5.2

🐞 Fixed

- Fixed CallKit integration on iOS when app is in a terminated state. It now correctly openes the app when the call is accepted.
- Fixed `onLeaveCallTap` callback in `StreamCallContent`. It's now correctly handled.
- (Android) Prevented the app from crashing when microphone permission is not granted and actove call foreground services is started. The service will now not start if no permission is granted.
- (Android) Marked the active call notification channel's lockscreen visibility as public to ensure it shows when the Android device is locked.

🔄 Changed

- `SortParam` changed to `SortParamRequest` in `queryMembers()` method inside `Call` and `StreamVideo` class

## 0.5.1

✅ Added

- Added `backstage` parameter to `call.getOtCreate()` method with backstage settings. For more information, refer to the [documentation](https://getstream.io/video/docs/flutter/joining-and-creating-calls/#backstage-setup)
  - Ability to join call in advance with `joinAheadTimeSeconds` parameter (part of `StreamBackstageSettings`)
- Added `startsAt` parameter to `call.getOtCreate()` method
- Added `maxDuration` and `maxParticipants` parameters to `call.getOtCreate()` method
- Added `video` parameter to `call.getOtCreate()`, `call.getCall()` and `call.join()` methods. This parameter is used to distinguish between audio-only and video calls for ringing purposes.
  - ❗Important❗ the `video` parameter is `false` by default. If you want your call to be treated as a video call while ringing set it to `true`.
- Added `streamVideo` paramter to `StreamLobbyView` and `StreamLobbyVideo` widgets provide a custom `StreamVideo` instance.

🐞 Fixed

- Fixed reaction dismissal: Sent and received reactions are now correctly dismissed after a 5-second timeout (configurable in `CallPreferences`).
- Fixed the cancel button behavior in the screen-sharing notification on Android. It will now correctly stop the screen-sharing process.
- Fixed the issue with the cancel button in the call-in-progress notification was not stopping the call.
- Fixed the connection quality updates for other call participants.
- Fixed an issue where declining a ringing call when the app was in a terminated state did not stop the ringing on the caller's end.

## 0.5.0

✅ Added

- Picture in Picture (PiP) is now also supported on iOS. For more information, refer to the [documentation](https://getstream.io/video/docs/flutter/advanced/picture_in_picture/)

🐞 Fixed

- Fixed an issue where the microphone was being muted when the app was running in the background on Android versions greater than 14.

🚧 Breaking changes

- The implementation of `BroadcastSampleHandler`, used for `broadcast` screen-sharing mode on iOS is now moved from `stream_video_flutter` package to a separate [stream_video_screen_sharing](https://pub.dev/packages/stream_video_screen_sharing) package.
  Migration steps:

* Add `stream_video_screen_sharing` dependency to your `pubspec.yaml` file
* Replace the import in `SampleHandler.swift` file from `stream_video_flutter` to `stream_video_screen_sharing`
* Replace the dependancy added to the extension target in `Podfile` file from `stream_video_flutter` to `stream_video_screen_sharing`

For complete screen-sharing guide please refer to the [documentaiton](https://getstream.io/video/docs/flutter/advanced/screen_sharing/)

- Previously deprecated `String` `type` parameters in `makeCall()` and `getCallRingingState()` methods are now removed. Use `StreamCallType` `callType` parameter now.
- Previously deprecated `events` and `coordinatorEvents` streams are now removed from `Call` class. Use `callEvents` instead.

## 0.4.4

✅ Added

- Added `watch` parameter to `StreamVideo.queryCalls()` method, allowing you to subscribe to queried call events. For more information, refer to the [documentation](https://getstream.io/video/docs/flutter/querying-calls/).
- Introduced `listRecordings()` to `StreamVideo` object, enabling you to query call recordings using a provided call CID.

🔄 Changed

- The default constructor for `StreamCallType` is now deprecated. Instead, use the `StreamCallType.defaultType()` factory constuctor.

🐞 Fixed

- Improved the quality of screen sharing. It now correctly respects the parameters set in `ScreenSharingConstraints` to adjust the quality.
- The `FloatingViewAlignment` enum is now properly exported in the `stream_video_flutter` package.

## 0.4.3

🐞 Fixed

- Fixed reconnection flow.
- Fixed compilation errors on web.
- Fixed screen-sharing not working on some versions of Android.
- Fixed accepting incoming call during another call (or outgoing call).
- Fixed CallKit incoming push label and Android accept call button icons for audio-only calls.

✅ Added

- Added support for missed calls. Push notifications and `CallMissedEvent` event will be sent now when the user misses the call.
- Added support for call transcription [check transcription cookbook](https://getstream.io/video/docs/flutter/ui-cookbook/transcriptions/)
  - Added `startTranscription()`, `stopTranscription()` and `listTranscriptions()` methods to `Call` class.
- Added option to take a screenshot during the call [check screenshot documentation](https://getstream.io/video/docs/flutter/screenshots/)
  - Added `takeScreenshot()` method to `Call` class.
- Added `recordingExternalStorage` optional param to `call.startRecording()` method.
- Added `requestScreenSharePermission()` method to `Call` class that ensures correct permissions are given for screen-sharing on Android.

🔄 Changed

- Changed `role` member to `roles`, to reflect the possibility of the user having multiple roles, in `CallParticipantState` and `CallMember`.
- Changed `SortParamRequest` to `SortParam`.

🔄 Changed some of the signatures

- `listRecordings()` method in PermissionsManager doesn't require `sessionId` param now.
- `setParticipantPinned()` method in `Call` and `CallSession` now requires `sessionId`, `userId`, and `pinned` params instead of `SetParticipantPinned` action.
- `updateViewportVisibility()` method in `CallSession` now requires `visibilityChange` param instead of `UpdateViewportVisibility` action.
- `setSubscriptions()` and `updateSubscription()` methods in `CallSession` now require a list of `subscriptionChanges` param instead of a list of `SetSubscription` actions.
- Added optional `reason` param to `reject()` method in `Call` class.

Removed

- Removed `updateSubscriptions` method from `Call`.

## 0.4.2

✅ Added

- Added `ClientDetails` to SFU's `join` request.

🐞 Fixed

- Tweaked SFU events handling to ensure there is no gap in handling them.
- Fixed camera and microphone toggling on incoming/outgoing screen.
- Fixed screen sharing not working when camera track was enabled.
- Fixed issues with video freezing sometimes.

## 0.4.1

🚧 Build breaking changes

- Bumped `connectivity_plus` dependency to `6.0.3`

> Note, that this changes the plugin requirements:
>
> - compileSDK 34 for Android part
> - Java 17 for Android part
> - Gradle 8.4 for Android part

🐞 Fixed

- Added foreground service type to service declaration in AndroidManifest

## 0.4.0

🚧 Breaking changes

- Updated minimum supported dart SDK version to `3.3.0` (which requires min Flutter SDK `3.19.0`)

- Updated `flutter_webrtc` to 0.10.4

🐞 Fixed

- Fixed an issue where subscriber offer events might be missed causing missing video/audio tracks for call participants.
- Fixed speakerphone/earpiece switching on iOS.
- User is now diconnected immedietaly when leaving the call.

## 0.3.9

- Reverted `flutter_webrtc` dependency version back to `0.9.47` to fix the compilation issues for web in Flutter 3.19.

## 0.3.8

🐞 Fixed

- Fixed application of initial call configuration (via `CallConnectOptions`) and default settings from Stream Dashboard
- Default camera facing is now applied from Dashboard settings (was ignored previously)

✅ Added

- `audioOutputDevice`, `audioInputDevice` and `cameraFacingMode` added to `CallConnectOptions`
- Optional `connectOptions` parameter added to `call.join()` method as a preferred way of setting initial call configuration - check out our [documentation](https://getstream.io/video/docs/flutter/initial-call-configuration/) for more info

## 0.3.7

- Updated minimum supported SDK version to Flutter 3.16

✅ Added

- Added `mirrorMode` parameter to `CameraConstraints`, which determines whether the camera for the given track should be mirrored or not. When set as `defaultMode` the mirroring is set as true, when `facingMode` is set to `user` and false when facingMode is set to `environment`.

🐞 Fixed

- Fixed an issue that might break screen sharing functionality.
- Fixed an issue that caused output audio device not being set correctly.
- Fixed an issue that still caused constant notification sound being triggered during the call on Android.
- Fixed an issue that blocked volume adjastment during the call on Android.

## 0.3.6

✅ Added

- Added `callEvents` stream to `Call` that replaces `events` and `coordinatorEvents` streams (both are now deprecated).
- Added `callBackgroundBuilder` to `StreamOutg/oingCallContent`.

🚧 Breaking changes

- Removed the `callCid` parameter requirement from `sendCustomEvent()` method in `Call` class.

🐞 Fixed

- Fixed an issue that caused an empty Call participants list in CallState during ringing.
- Fixed an issue that caused constant notification sound being triggered during the call on Android.
- Disabled camera mirroring when using back camera and when screensharing.

## 0.3.5

✅ Added

- Added `keepConnectionsAliveWhenInBackground` to `StreamVideoOptions` to allow keeping websocket connections and event subscribtions open when app is in the background (false by default).
- Added support for Picture in Picture feature to Android - check out our [documentation](https://getstream.io/video/docs/flutter/advanced/picture_in_picture/) for more info
- Added usage statictics reporting

🐞 Fixed

- Fixed handling of default audio output device setting from Stream dashboard
- Fixed handling of default camera/microphone state setting from Stream dashboard
- Fixed an issue where call could sometimes loose participants state
- Fixed an issue in `LobbyView` where camera/microphone state selected would not be correctly applied into the call

## 0.3.4

- Fixed the size of the LeaveCall aciton button in `CallAppBar`
- Added `showLeaveCallAction` property to `CallAppBar`

## 0.3.3

🚧 UI changes to SDK components

- `CallParticipantsLabel` - removed internal padding, it sticks to the corner of the video frame by default now
- Extracted `StreamLobbyVideo` widget from `StreamLobbyView` that can be easly reused in custom layout
- `CallAppBar`
  - `LeaveCallOption` moved from default call controls to `CallAppBar`
  - Participants button removed from `CallAppBar` together with `onParticipantsInfoTap` and `participantsInfoBuilder` properties
  - Layout Mode button removed from `CallAppBar` together with `onLayoutModeChanged` property. You can use new `ToggleLayoutOption` instead in custom layout anywhere
- `ToggleLayoutOption` added
- Components related to participants menu item from `CallAppBar` are removed: `CallParticipantsInfoItem`, `StreamCallParticipantsInfoMenu` and `CallParticipantsInfoOptions`
- `StreamCallParticipantsInfoMenuTheme` is removed

Other changes:

- Added `StreamCallType` class that replaces depricated String `type` parameter
- Exapanded `CallStats` class with more structured WebRTC statistics as `stats` field
- Changed `raw` statistics in `CallStats` to be of a Map<Stirng, dynamic> type
- Added `publisherStats`, `subsciberStats` and `latencyHistory` to the `CallState` that hold some of the processed statistcs

Bug fixes

- Fixes incoming call behavior when both CallKit and Stream incoming screen component is used
- Fixes the issue on Android that caused missed call notification when ringing with reused call id

## 0.3.2

🐞 Fixed

- Various fixes to call ringing and push notifications.

* Fixes call ringing cancellation when app is terminated on iOS (requires additional setup - check Step 6 of the [APNS integration](https://getstream.io/video/docs/flutter/advanced/ringing_and_callkit/#integrating-apns-for-ios)) in our documentation.
* Fixes late push notification handling on Android, where already ended call was ringing if the device was offline and the push was delivered with a delay.
* Fixes call ringing cancellation when caller timed out while calling

- Fixed action tap callback on Android call notification.
- Fixed background image for incoming/outgoing call screens when `participant.image` is invalid.
- Fixes possible crashes for Android SDKs versions <26.
- Fixed screen sharing on iOS when screen sharing mode was switched between `in-app` and `broadcast`.
- Changed the version range of `intl` package to >=0.18.1 <=0.19.0 because it was causing isses with other packages.

✅ Added

- Added `custom` field to `CallParticipantState` with custom user data.

## 0.3.1

- Important: Fixes crash for CallKit on iOS.
- Added support for SFU migration to improve video resilience.
- Fixes for streaming flags in `CallState` (backstage, broadcasting, recording).

## 0.3.0

🚧 Breaking changes

- The functionality from `stream_video_flutter_background` is now merged into `stream_video_flutter`. You no longer have to use the background plugin.
- Removed the `incomingCallerNameOverride` and `incomingCallerHandlerOverride` from `StreamVideoPushParams` in favor of the new `callerCustomizationCallback` in `StreamVideoPushNotificationManager`.

✅ Added

- Added `LivestreamPlayer` - a in-built widget that allows you to easily view livestreams.
- Added screen sharing functionality and related toggle option for both Android and iOS. Check [our documentation](https://getstream.io/video/docs/flutter/) for more details
- Exposed call coordinator events through the `coordinatorEvents` stream in the `Call` class.
- Added `StreamCallContentTheme` to video theme.
- `callerCustomizationCallback` to `StreamVideoPushNotificationManager` that allow dynamic customization of CallKit call screen.

Example usage:

```dart
pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
    ...
    callerCustomizationCallback: ({required callCid, callerHandle, callerName}) =>
          CallerCustomizationResponse(name: "Customized $callerName"),
    ),
```

- Added a `includeUserDetails` field to determine if user details should be passed to backend when connecting user.
- Added `team`, `notify`, and `custom` properties to `getOrCreate()` for `Call`.

🐞 Fixed

- Added Apple audio configuration to make audio work in silent mode.
- Fixed ringing call cancellation issues.

## 0.2.0

✅ Added

- `removeMembers` and `updateCallMembers` to `Call`
- `incomingCallerNameOverride` and `incomingCallerHandlerOverride` to `StreamVideoPushParams` to allow customization of CallKit call screen
- `participantsAvatarBuilder` and `participantsDisplayNameBuilder` to `StreamOutgoingCallContent` and `StreamIncomingCallContent` to allow customiztion of Incoming and Outgoing call screens

Example usage:

```dart
StreamCallContainer(
   ...
   outgoingCallBuilder: (context, call, callState) =>
           StreamOutgoingCallContent(
               call: call,
               callState: callState,
               participantsDisplayNameBuilder:
                   (context, call, callState, participants) => your widget here,
           ),
)
```

🔄 Changed

Breaking changes 🚧

- renamed `inviteUsers` to `addMembers` in `Call`
- renamed parameter name in `getOrCreateCall` from `participantIds` to `memberIds`

## 0.1.1

- Fixed call join bug
- Fixed CallKit call not ending bug
- Anonymous users can no longer connect to WS
- Users can no longer join a call twice
- Fixed landscape call control visibility

## 0.1.0

- Aligned SDK initialization with other SDKs
- Fixed callkit and push implementation for SDK
- Added parsing for CallPermissions
- Fix duplicate participants in call
- Hide debug stats in production
- Display call participants in lobby view
- General bug fixes and improvements

## 0.0.4

- Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0

## 0.0.3

- Fixed track subscription bug

## 0.0.2

- Updates for backend
- Support for reactions

## 0.0.1+1

- Fixed README

## 0.0.1

- Initial beta release of Stream Video 🚀
