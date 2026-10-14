# Settings window

Issue: [FLU-973](https://linear.app/stream/issue/FLU-973/full-settings-dialog).
The ticket has the design links, the React reference screenshots and the full
plan for each step. This file tracks the order of the stack and what is done.

On large screens, a settings button replaces the "more" menu button and opens a
modal window with a sidebar of tabs. Small and medium screens are unchanged.

## Decisions

- **The window is a design-system candidate.** `StreamModalWindow` lives in
  `stream_video_flutter` because chat has the same design. It has its own
  component theme, `StreamModalWindowTheme`, registered on `StreamVideoTheme`.
- **Tabs:** `StreamModalWindowTab(icon:, label:, builder:)`. The icon is
  required, because a collapsed sidebar shows only icons. `label` is a widget.
  `builder` is the only way to give a tab content; it runs inside the window,
  and only for the selected tab.
- **A narrow window:** below a width of 560 the sidebar collapses to icons, with
  the label as tooltip and semantics label. The window only opens on large
  screens, so this happens only when the app window is shrunk while it is open.
- **Ready-made SDK tabs:** Device, Effects, Captions and Recordings ship in
  `stream_video_flutter`. Language and Theme exist in dogfooding only.
- **Dogfooding defines its tab list**, the way it composes call controls.
- **The more menu on large screens:**
  - noise cancellation moves to the Device tab;
  - background filters move to the Effects tab;
  - incoming video quality moves to the Device tab, and also gets its own
    button in the centre of the bar;
  - feedback and the developer options become their own buttons on the leading
    side of the bar.
- **The Effects tab** is shown only when `videoEffectsManager.isSupported()` is
  true. Its UI is data-driven, because `stream_video_flutter` doesn't depend on
  `stream_video_filters`.
- **Captions:** only the spoken language is set, as React does; "Translate To"
  is left out. Automatic (`auto`) is one of the choices. The fix that maps an
  unset language to English (5a) is part of this stack and lands on `v2` only.
- **Recordings:** a new SDK list, not the one in `LivestreamEndedContent`. It
  takes an `onDownload` callback, and dogfooding opens the file's URL.

## The stack

Each step is a branch off the one before it; the first branches off `v2`. No PR
is opened until the whole feature has been tested. Tick a box in the step's own
commit.

| # | Step | Branch |
|---|---|---|
| 1 | `StreamModalWindow` candidate | `feat/flu-973-modal-window` |
| 2 | Settings button and window in dogfooding | `feat/flu-973-settings-button` |
| 3 | Device tab | `feat/flu-973-device-tab` |
| 3b | Incoming video quality button | `feat/flu-973-incoming-quality-button` |
| 4 | Effects tab | `feat/flu-973-effects-tab` |
| 5a | An unset transcription language means English | `fix/flu-973-transcription-language-default` |
| 5 | Captions tab | `feat/flu-973-captions-tab` |
| 6 | Language tab (dogfooding) | `feat/flu-973-language-tab` |
| 7 | Theme tab (dogfooding) | `feat/flu-973-theme-tab` |
| 8 | Recordings tab | `feat/flu-973-recordings-tab` |

## Progress

### 1. `StreamModalWindow`

- [ ] `StreamModalWindow` and `StreamModalWindowTab`, sharing the header and
      surface with `StreamModalDialog`
- [ ] `StreamModalWindowTheme`, registered on `StreamVideoTheme`
- [ ] The sidebar collapses to icons below 560
- [ ] Widget tests, including RTL and the collapsed sidebar
- [ ] Goldens, light and dark, wide and collapsed
- [ ] Changelog

### 2. Settings button and window in dogfooding

- [ ] The settings button opens the window on large screens
- [ ] Feedback and developer options buttons on the leading side of the bar
- [ ] The tab list, in dogfooding

### 3. Device tab

- [ ] Local preview, and the camera, microphone and speaker selects
- [ ] Noise cancellation toggle
- [ ] Incoming video quality select; `IncomingVideoQuality` moves into the SDK

### 3b. Incoming video quality button

- [ ] The button and its menu
- [ ] In the centre of the large bar in dogfooding

### 4. Effects tab

- [ ] Data-driven effects UI in the SDK
- [ ] Wired to `StreamVideoEffectsManager` in dogfooding; shown only when
      supported

### 5a. An unset transcription language means English

- [ ] `""` maps to `en`

### 5. Captions tab

- [ ] Captions switch
- [ ] Spoken language select, keeping the current caption and transcription
      modes on update

### 6. Language tab

- [ ] App locale select, saved in `AppPreferences`

### 7. Theme tab

- [ ] System, light and dark, saved in `AppPreferences`

### 8. Recordings tab

- [ ] Recordings list in the SDK, with loading and empty states
- [ ] Download from dogfooding

### Before opening PRs

- [ ] The full feature tested on a device
- [ ] Goldens updated through the `update_goldens` workflow
