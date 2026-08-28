# stream-video-flutter

Melos monorepo for the Stream Video Flutter SDK.

| Package | What it is |
|---|---|
| `packages/stream_video` | Pure-Dart low-level client. No Flutter. |
| `packages/stream_video_flutter` | UI toolkit — widgets, themes, call screens. |
| `packages/stream_video_*` | Filters, noise cancellation, push notifications, screen sharing. |
| `dogfooding/` | The internal sample app. The first place a UI change gets tried. |

```bash
melos bootstrap          # after any pubspec change
melos run analyze        # dart analyze --fatal-infos, every package
melos run format
melos run generate:flutter   # build_runner, for *.g.theme.dart and friends
melos run test:all
```

## The design system lives in another repository

`stream_core_flutter` is the design system and is **not** in this repo. It is a
git dependency pinned in the root `pubspec.yaml`, so its source is at:

```text
~/.pub-cache/git/stream-core-flutter-<ref>/packages/stream_core_flutter
```

That checkout also carries `CLAUDE.md`, `STYLE_GUIDE.md` and `TESTING.md` at its
root. **`STYLE_GUIDE.md` is the authority for anything below** — this file only
records what is specific to the video repo, or what is easy to get wrong here.

Design comes from Figma, read through the Figma MCP. When a value looks like it
needs inventing, it usually already exists: pull the component and read its
geometry rather than deriving proportions from a size. Raw token values live in
the `design-system-tokens` repo, whose `build/flutter/` output is a useful
cross-check when a token seems to be missing from core.

## Theming

**Two theme systems coexist.** `StreamVideoTheme` is this repo's older,
hand-written `ThemeExtension`, with non-nullable sub-themes carrying hardcoded
defaults. `StreamTheme` is the design system's, and is what new code uses. New
component themes in this repo follow the core pattern but are still registered
on `StreamVideoTheme`, since video cannot add fields to `StreamTheme`.

A new component theme, as in `src/theme/components/`:

```dart
@themeGen
@immutable
class StreamWidgetThemeData with _$StreamWidgetThemeData {
  const StreamWidgetThemeData({this.style});
  final StreamWidgetStyle? style;   // every field nullable — no defaults here

  static StreamWidgetThemeData? lerp(a, b, t) =>
      _$StreamWidgetThemeData.lerp(a, b, t);
}

class StreamWidgetTheme extends InheritedTheme {
  static StreamWidgetThemeData of(BuildContext context) {
    final local = context.dependOnInheritedWidgetOfExactType<StreamWidgetTheme>();
    // Merges, so a subtree can override one property and inherit the rest.
    return StreamVideoTheme.of(context).widgetTheme.merge(local?.data);
  }
  // ...wrap(), updateShouldNotify()
}
```

Rules worth stating outright:

- **Never hand-roll `copyWith` / `merge` / `lerp` / `==` / `hashCode`** on a
  theme. `theme_extensions_builder` generates them into `*.g.theme.dart`.
- **Every theme field is nullable.** Null means "no override".
- **Defaults live in the widget**, as a `_StreamXStyleDefaults extends
  StreamXStyle` overriding getters non-nullably off `context.streamColorScheme`,
  `streamTextTheme`, `streamSpacing`, `streamRadius`, `streamElevation`.
  Type the local as the defaults class, not the style — declaring it as the base
  type throws away the non-null overrides.
- **Never let a defaults instance into a theme.** Generated `==` compares
  `runtimeType` and every getter is non-null, so merging one forces every field.
- **Generated `merge` is shallow.** A nested style is replaced wholesale, so a
  widget handing a sub-style to a child theme must merge it explicitly first.
- Naming: `<Component>ThemeData` for the top-level theme, `<Component>Style` for
  the visual style it carries.

## Components

Every replaceable component is a triple:

```dart
class StreamX extends StatelessWidget {
  StreamX({...}) : props = .new(...);
  final StreamXProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.videoComponentBuilder<StreamXProps>();
    return builder?.call(context, props) ?? DefaultStreamX(props: props);
  }
}
```

Register replacements through `streamVideoComponentBuilders`. Video is external
to core, so its builders go through the type-keyed `extensions` map rather than
named fields on `StreamComponentBuilders`.

Props carry data and decisions; appearance goes in the style object. A `show*`
toggle that an app sets globally *and* a call site overrides lives in both, with
the prop winning.

## Tokens

Read them from the context extensions — `context.streamColorScheme`,
`streamTextTheme`, `streamSpacing`, `streamRadius`, `streamElevation`,
`streamIcons` — not from `StreamVideoTheme.colorTheme` / `.textTheme`, which
belong to the older system.

One trap: the barrel re-exports core as
`export 'package:stream_core_flutter/core.dart' hide StreamIcons, StreamTextTheme;`.
A bare `StreamIcons` is therefore this repo's own three-icon class, while
`context.streamIcons` returns core's full set. Naming `StreamTextTheme` in a file
that also imports core directly is ambiguous — let the accessors infer instead.

Shadows come from `StreamElevation` through a `Material`, not a hand-painted
`BoxShadow`. Material clips with `PhysicalShape`, so draw borders in a
`DecoratedBox` outside it.

`src/widgets/design_system_candidates/` holds components that implement a design
the core package does not ship yet, staged to graduate to core later.

## Testing

Golden tests use `alchemist`, through `streamGoldenTest` and `TestWrapper` in
`test/test_utils/` — never a bare `MaterialApp`, or the snapshot picks up
Flutter's defaults instead of the pinned theme, platform and locale.

- Only `goldens/ci/*.png` is committed. `goldens/<platform>/` is local and
  gitignored, and is generated on first run — a fresh checkout fails until
  `flutter test --tags golden --update-goldens` has run once.
- Regenerate the committed ones by dispatching the `update_goldens` workflow
  from the branch, not locally: it runs on the same Linux host CI compares
  against.
- The CI capture path drops anything painted into an `Overlay`, so a menu,
  tooltip or dialog snapshots blank. Assert those in a widget test.
- `BackdropFilter` is a no-op under `flutter test`; a blurred surface snapshots
  as a flat fill.
- `pumpBeforeTest` defaults to `onlyPumpAndSettle`, which never returns against a
  repeating animation. Pump an explicit duration instead.

## Conventions

- Changelog entries go under `## Upcoming (next major)` in the affected
  package's `CHANGELOG.md`, using the `### ✅ Added` / `### ⚠️ Deprecated` /
  `### ⚠️ Breaking` / `### 🔄 Changed` headings already there.
- Deprecations pair `@Deprecated('Use X instead.')` with a transform in
  `lib/fix_data.yaml`, so `dart fix --apply` migrates call sites. A bulk `rename`
  is only safe when the old and new APIs accept the same parameters.
- Conventional Commit titles: `feat(ui):`, `fix(llc):`, `chore(repo):`.
