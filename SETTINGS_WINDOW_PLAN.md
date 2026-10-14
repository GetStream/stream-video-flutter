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
| 2 | Device tab | `feat/flu-973-device-tab` |
| 3 | Effects tab | `feat/flu-973-effects-tab` |
| 4 | Settings, feedback and developer buttons in dogfooding | `feat/flu-973-settings-button` |
| 5 | Incoming video quality button | `feat/flu-973-incoming-quality-button` |
| 6a | An unset transcription language means English | `fix/flu-973-transcription-language-default` |
| 6 | Captions tab | `feat/flu-973-captions-tab` |
| 7 | Language tab (dogfooding) | `feat/flu-973-language-tab` |
| 8 | Theme tab (dogfooding) | `feat/flu-973-theme-tab` |
| 9 | Recordings tab | `feat/flu-973-recordings-tab` |

The two SDK tabs come before the dogfooding buttons, so that everything the
large-screen more menu holds has a new home by the time the menu goes.

## Progress

### 1. `StreamModalWindow`

- [x] `StreamModalWindow` and `StreamModalWindowTab`, sharing the header and
      surface with `StreamModalDialog`
- [x] `StreamModalWindowTheme`, registered on `StreamVideoTheme`
- [x] The sidebar collapses to icons below 560
- [x] Widget tests, including RTL and the collapsed sidebar
- [x] Goldens, light and dark, wide and collapsed, from the `update_goldens`
      workflow
- [x] Changelog

### 2. Device tab

- [x] Local preview, and the camera, microphone and speaker selects
- [x] Noise cancellation toggle
- [x] Incoming video quality select; `IncomingVideoQuality` moves into the SDK
- [x] Goldens of the content, light and dark; the `StreamSelectInput` golden
      changes too, as its label is now `headingXs`

### 3. Effects tab

- [x] Effects UI in the SDK, from optional lists of `StreamVideoFilter`s and
      `StreamVideoBackground`s; a list that isn't set drops its section
- [x] Dogfooding's lists over `StreamVideoEffectsManager`: three blur levels,
      grayscale and the background images (shown from step 4, only when
      supported)
- [x] Goldens of the content, light and dark

### 4. Settings, feedback and developer buttons in dogfooding

- [x] The settings button opens the window on large screens
- [x] Feedback and developer options buttons on the leading side of the bar,
      in non-production builds only
- [x] The tab list, in dogfooding, with the Device and Effects tabs
- [x] The large-screen more menu goes
- [ ] Checked on a device (part of the final test)

### 5. Incoming video quality button

- [x] The button and its menu
- [x] In the centre of the large bar in dogfooding
- [x] Golden of the closed button, light and dark

### 6a. An unset transcription language means English

- [x] `""` maps to `en`

### 6. Captions tab

- [ ] Captions switch
- [ ] Spoken language select, keeping the current caption and transcription
      modes on update

### 7. Language tab

- [ ] App locale select, saved in `AppPreferences`

### 8. Theme tab

- [ ] System, light and dark, saved in `AppPreferences`

### 9. Recordings tab

- [ ] Recordings list in the SDK, with loading and empty states
- [ ] Download from dogfooding

### Before opening PRs

- [ ] The full feature tested on a device
- [ ] Goldens updated through the `update_goldens` workflow
