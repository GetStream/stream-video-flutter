# Design switcher in dogfooding (v2)

Add a **Design** picker to the settings window's Theme tab. It restyles the
whole app, including core, chat and video components, as one of:

| Design | Package | Source |
| --- | --- | --- |
| Stream (default) | — | what ships today |
| shad | [`shad`](https://pub.dev/packages/shad) (serverpod.dev, 1.0.x) | new; chat's `shadcn_ui` design as a reference only |
| Yaru | `yaru` | port from chat `demo/xp_dart` |
| Fluent | `fluent_ui` + `fluentui_system_icons` | port from chat `demo/xp_dart` |
| Liquid Glass | `liquid_glass_widgets` | chat's theme and icons; builders rewritten on `liquid_glass_widgets` |
| Material 3 Expressive | `m3e_collection` (or a subset of its packages) | new, chat has no M3E |

Base branch: `v2`. This is samples-only work, so commits are `chore(samples)` and nothing goes in the SDK packages.
Reference: [chat `master...demo/xp_dart`](https://github.com/GetStream/stream-chat-flutter/compare/master...demo/xp_dart).

## How it works (same as chat)

The SDK already has the hooks this needs. No core, chat or video changes are planned:

- **`StreamTheme`** (a `ThemeExtension`) sets each design's colors, text theme
  (font), radius and **icons** (`StreamIcons.copyWith`). Chat and video both read
  it, so this one theme restyles all three layers.
- **`StreamComponentBuilders`** replaces core widgets with the design library's
  own widgets: `button`, `splitButton`, `checkbox`, `toggleSwitch`, `textInput`,
  `progressBar` and `loadingSpinner`. The chat (`streamChatComponentBuilders`)
  and video (`streamVideoComponentBuilders`, e.g. `DogfoodingParticipantTile`)
  extensions keep being passed through `extensions:`.
- **Scope wrapper**: libraries that read their own inherited theme
  (`ShadTheme`, `FluentTheme`) are wrapped in `MaterialApp.builder`, below
  `MaterialApp` so they can read the resolved brightness.

Pinned core versions: video v2 pins core `958a8d3`, which already contains the
`bd6e254` the chat demo was written against (6 commits newer, and none of them
touch the factory API). The chat code ports without API changes.

### What video and dogfooding use from core (v2 call counts)

`StreamButton` (video 15, dogfooding 25), `StreamTextInput` (dogfooding 5),
`StreamSnackbar` (1 / 3), `StreamModalWindow` (3 / 1), `StreamSheetHeader`,
`StreamListTile`, `StreamAvatar`, `StreamLoadingSpinner`,
`StreamContextMenuAction`, and **`StreamSplitButton`** (video 1:
`call_controls/device_split_buttons.dart`, the mic and camera buttons with a
device caret). Chat's in-call chat pulls in the rest.

## Accent color

The accent picker gets a new first choice, **Default**: no accent color of
its own, so each design keeps its own default color.

- `AppAccentColor` gets a `designDefault` value at the start. Its `brand()` is
  `null`, so `StreamTheme` falls back to its own blue. `blue` becomes a real
  choice that gives `StreamColors.blue` explicitly.
- Every other design maps `designDefault` to its own default color: shad zinc,
  Yaru orange, Fluent blue, Liquid Glass system blue, and the M3E baseline seed.
  The named colors map to each library's nearest palette (table below).
- The Default swatch shows the **active design's** default color, so the picker
  shows what you'll actually get. It's labelled "Default".
- Preferences: Default is the *absence* of the key, so users who never picked
  anything keep the current look. Blue, which used to clear the key, is now
  stored as `blue`. Nobody has `blue` stored today, so nothing needs migrating.
- l10n: `accentColorDefault` in `app_en.arb` / `app_nl.arb`.

| Accent | Stream | shad | Yaru (`YaruVariant`) | Fluent (`AccentColor`) | M3E (seed) |
| --- | --- | --- | --- | --- | --- |
| Default | null (blue) | Zinc | orange | blue | baseline |
| Blue | blue | Blue | blue | blue | blue |
| Purple | purple | Violet / custom `ShadAccentScheme` | purple | purple | purple |
| Violet | violet | Violet | magenta | magenta | violet |
| Red | red | Red | red | red | red |
| Yellow | yellow | Yellow | yellow? (check) | yellow | yellow |
| Lime | lime | custom `ShadAccentScheme` | olive | (custom) | lime |
| Green | green | Green | viridian | green | green |
| Cyan | cyan | custom `ShadAccentScheme` | prussianGreen? (check) | teal | cyan |

Where a library has no matching palette, the Stream swatch color is used as a
custom accent (shad `ShadAccentScheme`, Fluent `AccentColor.swatch`).

## The split button

Chat's demo has no split button, so each design gets a `splitButton` builder.
Every design that overrides `button` needs one: the default split button builds
its halves with `StreamButton.icon`, so without it the design's buttons end up
inside a Stream pill. The props are small: `leadingIcon`, `trailingIcon`,
`onLeadingPressed`, `onTrailingPressed`, `variant` (regular/destructive) and
two tooltips. The trailing half only fires a callback; the device menu stays
the SDK's.

Per design (APIs still to be checked against the pinned versions):

| Design | Approach |
| --- | --- |
| Fluent | `fluent_ui`'s `SplitButton`. It expects a `flyout`, so it may need the trailing half wired to `onTrailingPressed` instead. Fallback: two `IconButton`s in a `ButtonStyle`d container |
| Yaru | `YaruSplitButton` (primary press plus options press). Check the destructive variant |
| M3E | M3E has a split button in the spec. Use the `m3e_*` one if it exists, otherwise compose from M3E buttons with the inner-corner shape |
| shad | shad lists button group as "not yet available". Compose one: two `ShadIconButton`s in one bordered surface with a vertical `ShadSeparator` |
| Liquid Glass | Two glass halves in one glass pill. Check whether `liquid_glass_widgets` has a grouped or segmented button to build it from first |

## Phases

Commit after each phase (no push).

### Phase 0: setup
- [x] Branch off `v2` (name to confirm before pushing). Stacked on the chat 10.6.0 bump, which makes dialogs follow theme changes.
- [x] Add `shad`, `yaru`, `fluent_ui`, `fluentui_system_icons`, `liquid_glass_widgets` and the M3E packages to `dogfooding/pubspec.yaml`, and to melos `dependencies` if dogfooding is in the synced list.
- [x] `flutter pub get` on 3.47.4. Yaru stays on 10.2: 11 needs dbus 0.8, and `battery_plus` (via `stream_video`) holds it at 0.7. Check that resolution works with the git overrides for chat and core. shad pulls in `slang`, `intl`, `flutter_animate` and `lucide_icons_flutter`, so watch for `intl` clashes with `flutter_localizations`.
- [x] Not needed, as everything resolves under `>=3.44.0`. If an M3E package needs Flutter ≥ 3.47, bump `dogfooding/pubspec.yaml` to `flutter: ">=3.47.0"`. The legacy (3.44) CI job skips dogfooding, so nothing else is affected.
- [x] Not an issue: `m3e_collection` 0.3.7 doesn't pull in `m3e_core`, and only `fluent_ui` uses `material_ui`. It includes `split_button_m3e` and `button_group_m3e`. **Check the M3E risk:** `m3e_core` ≥ 1.1 is built on the standalone `material_ui` package. If its widgets read `material_ui`'s `Theme` rather than `flutter/material`'s, they won't see the app's `ThemeData`. If so, pin `m3e_core <1.1` or switch to `material_3_expressive`.

### Phase 1: the design setting, the Default accent and the Stream design
- [x] `AppDesign` enum in `dogfooding/lib/app/`. It starts with `stream` only; each design phase adds its own value, label and `defaultAccent`.
- [x] `AppPreferences`: `design` getter/setter (`_kDesignPref`); an unknown or missing value falls back to `stream`.
- [x] `AppDisplaySettings`: `design` + `setDesign`, like `themeMode`.
- [x] `AppAccentColor.designDefault` as described in [Accent color](#accent-color). The preference default changes from `blue` to `designDefault`, and `blue` is stored explicitly.
- [x] `theme_tab.dart`: a `SettingsSelect<AppDesign>` above the theme-mode select, each choice with a label, a short description and an icon. The Default swatch first in the accent picker, filled with the active design's default color.
- [x] l10n: `designTitle`, `designDescription`, one label per design, and `accentColorDefault`, in `app_en.arb` and `app_nl.arb`, then regenerate.
- [x] Tests: extend `app_display_settings_test.dart` for the persist and restore of `design`, and for the accent color (an empty preference gives Default, and `blue` survives a restart).

### Phase 2: design plumbing
- [x] A small `AppDesignSpec` interface in place of chat's three parallel `switch`es:
  `ThemeData theme(Brightness, AppAccentColor)`, `StreamComponentBuilders builders(extensions)`, `Widget wrap(BuildContext, Widget)`, `Color defaultAccent(Brightness)` (for the Default swatch).
- [x] `app_content.dart`: `_componentBuilders` stops being `late final` and is rebuilt when the design changes. `_buildTheme` delegates to the spec. The video theme overrides now in `_buildTheme` (call reactions, avatar, grid padding) are shared by every design.
- [x] `padToTapTarget`, `designColorScheme`, `designMaterialTheme` and `DesignLabeledField` live in `app/design/app_design_spec.dart`. Dogfooding depends on `stream_core_flutter` directly, because the split button is only exported from its experimental `video.dart`.
- [x] Widget test harness: for each design, pump a `StreamButton` (each type and style, icon-only and labelled), a `StreamSplitButton` (both variants, enabled and disabled), a `StreamTextInput`, a `StreamToggleSwitch`, a snackbar and a modal window. Assert no exceptions (a missing `ShadTheme`/`FluentTheme` ancestor would throw) and that the design's own split button widget is the one rendered.

### Phase 3: shad
Chat's `shadcn/` design is on a different package (`shadcn_ui`). shad started
from the same project, so the structure carries over but the API has to be
checked class by class. Use it as a reference, not a port.
- [x] Theme scope: a bare `ShadTheme` in `MaterialApp.builder`, plus `GlobalShadLocalizations.delegate`. Considered: inside the existing `MaterialApp`, go through shad's Material interop (`ShadApp.custom` with `shadMaterialThemeFrom(ShadTheme.of(context))`, from `package:shad/material.dart`), or a bare `ShadTheme` in `MaterialApp.builder`. Pick whichever keeps `MaterialApp.router` and our localization delegates as they are. Add `GlobalShadLocalizations` to the delegates if shad's widgets need it.
- [x] `ShadThemeData`: `ShadZincColorScheme`, with a picked accent as `primary`/`ring` instead of a named scheme per accent. Uses the default style preset.
- [x] Font: shad bundles none, so use Geist through `google_fonts` (`ShadTextTheme.fromGoogleFont`, and the same family in `StreamTheme.textTheme`). `google_fonts` is already a dogfooding dependency.
- [x] Icons: `LucideIcons` from `lucide_icons_flutter`. Chat's icon map came from `shadcn_ui`'s Lucide set, so check the names.
- [x] Builders: `ShadButton` / `ShadIconButton`, `ShadCheckbox`, `ShadSwitch`, `ShadInput`, `ShadProgress` (determinate and indeterminate) and `ShadSpinner` for `loadingSpinner`.
- [x] Composed `splitButton`, as shad has no button group yet.
- [ ] Optional: a `snackbar` builder on `ShadToast`, if the props fit (not done).

### Phase 4: Yaru
- [x] Port the theme, the icons (`YaruIcons`) and the builders. The Ubuntu font comes from `packages/yaru/Ubuntu`.
- [x] `splitButton` with `YaruSplitButton`.
- [x] Accent: the picked palette color is Yaru's `primaryColor` (orange for Default), rather than the nearest `YaruVariant`.

### Phase 5: Fluent
- [ ] Port the theme, the icons (`fluentui_system_icons`) and the builders. Add `FluentLocalizations.delegate` and the `FluentTheme` wrapper.
- [ ] `splitButton` with `SplitButton`.
- [ ] Map `AppAccentColor` to Fluent's `AccentColor`s.

### Phase 6: Liquid Glass
- [ ] Port the theme and the icons (`CupertinoIcons`) from chat. Rewrite the builders on `liquid_glass_widgets`' own widgets (glass buttons, switch, text field), which replaces chat's custom glass switch.
- [ ] `splitButton`: two glass halves in one glass pill. Check whether the package has a grouped or segmented button to build it from before composing it by hand.
- [ ] Setup: call `LiquidGlassWidgets.initialize()` in `main` (it preloads the shaders) and `LiquidGlassWidgets.wrap()` around the app, with a `brightnessResolver` so the glass follows `ThemeMode`. No Flutter GPU flags.
- [ ] Wrap the call controls in a `GlassBackdropGroup`, so the controls bar shares one backdrop read.
- [ ] Use the default (Standard) quality. Premium is only recommended for static surfaces, and the call controls sit over moving video.
- [ ] Default to `StreamSurfaceStyle.floating` while this design is active, as chat does.
- [ ] Glass over **video tiles** is the interesting case. Check frame times on a 6+ participant call (profile build).

### Phase 7: Material 3 Expressive
- [ ] Theme: `ColorScheme.fromSeed` from the accent color plus `m3e_design` tokens. `StreamTheme` takes the colors and the expressive radius.
- [ ] Icons: Material Symbols (rounded).
- [ ] Builders: M3E buttons (shape morphing on press), switch, progress (the wavy indicator for `progressBar` and `loadingSpinner`), and the split button.

### Phase 8: verification
- [ ] Run dogfooding (debug) on iOS, Android, macOS and web. For each design, check the lobby, the call screen (call controls and the **device split buttons** in both variants), the settings window, in-call chat and a snackbar. Light and dark, with Default and one named accent.
- [ ] Switching designs mid-call keeps the call and doesn't remount the call screen.
- [ ] `melos run analyze:error`, `format:verify` and the dogfooding tests.
- [ ] Screenshots of every design for the PR.

## Decisions

- Liquid Glass uses `liquid_glass_widgets`.
- The accent picker starts with Default, which leaves each design on its own default color.
- The shad design uses the `shad` package, not `shadcn_ui`.
- Windows XP (`xp_dart`, in chat's branch) is out of scope.
