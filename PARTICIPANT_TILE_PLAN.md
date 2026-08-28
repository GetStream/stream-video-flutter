# Participant tile redesign (v2)

Worktree `/Users/renefloor/Documents/github/stream-video-flutter-worktrees/worktree-v2`, branch
`feat/participant-tile`.

## Context

`StreamParticipantTile` landed in `fa3e6d05` as the first component using the
`StreamX` / `StreamXProps` / `DefaultStreamX` + component-factory shape, but it still renders the old
visuals and still reads `StreamCallParticipantThemeData` — a hand-written, all-non-nullable theme
whose `of()` replaces instead of merging, which carries three grid-layout fields the tile never
reads, whose `copyWith` takes stale `dominantSpeaker*` parameter names, and whose `merge` silently
drops `pausedVideoIndicatorColor`.

Three things change together:

1. **Visuals** — match the design-system participant tile and floating self-view.
2. **API shape** — bring video in line with `stream_core_flutter`: nullable `@themeGen` theme data,
   `InheritedTheme` with a merging `of()`, one `Style` object instead of ~18 loose colour props,
   defaults resolved in the widget from `StreamTheme` tokens.
3. **More menu** — the tile has none. Add a configurable icon + label + callback action list so
   integrators can wire pin / block / kick / mute themselves. The SDK ships no built-in actions and
   hides the button when the list is empty.

**Migration is cheaper than it looks.** `StreamParticipantTile`, `StreamParticipantTileProps` and
`streamVideoComponentBuilders` are all new in the unreleased `## Upcoming (next major)` section, so
their visual params can be *deleted* rather than deprecated. Only `StreamCallParticipant`,
`StreamCallParticipantThemeData` and `StreamLocalVideoThemeData` carry a compatibility obligation,
and all three keep working through a bridge.

## Decisions taken

| Question | Decision |
|---|---|
| Theme migration | New `StreamParticipantTileThemeData` / `Theme` / `Style`; old classes stay compiling but `@Deprecated`, bridged forward |
| More-menu actions | Props only: `actions` plus `actionsBuilder(context, participant)` |
| Factory slots | Placeholder, video, participant label, connection-quality indicator, **user avatar** |
| Grid spacing fields | New `StreamCallParticipantsGridThemeData`, read by `CallParticipantsGridView` itself |
| Speaking vs mic icon | Sound indicator always visible; a microphone icon only while muted (per the design thread, 2026-08-28) |

Per repo convention this plan gets copied to the repo root as a tracked markdown file with a todo
checklist, and each phase below is committed (not pushed) as it lands.

## Design tokens (Figma — authoritative)

Tile (`26756:3649`): radius **20**; speaking border **2px** `accent/primary`; video-off background
`surface-subtle` `#f6f8fa` with a **1px** `border/core/default` hairline and a centred **80px**
avatar with a 2px white ring.
Bottom toolbar: 56 tall, padding 12, gap 12 — `[label pill] … [32px round indicator]`.
Label pill: `overlay-dark-strong` `rgba(26,27,37,0.75)` + backdrop blur 12.5, radius 12, padding
L12/R4/V4, gap 8; name 13/16; optional 20px camera-off icon; 24px sound-indicator box (radius 8).
Top toolbar: padding 4 — "more" button top-left (secondary solid small, 32px visual, 20px icon,
48px hit target); reaction emoji top-right at inset 12, **48px** (today: 24px, top-center).
Floating self-view (`24212:75616`): 140×228, radius **12**, 1px `rgba(26,27,37,0.1)`, drop shadow,
bottom toolbar with **only** the connection indicator.

The sound indicator is **always** shown: animated while speaking, resting as three dots otherwise
(the design's `speaking=false` variant is a flat 10x2 strip). A microphone icon appears **only** while
muted — there is no unmuted counterpart, since the sound indicator already reports whether anything is
coming through. Confirmed on the design thread for node `413:38917`; an earlier reading of that node
had the two treated as alternatives.

### Token coverage — verified against `design-system-tokens`

Everything resolves to a real semantic token. Confirmed exact matches: `radius.xxl/lg/md/max`,
`spacing.xxs/xs/sm/md`, `accentPrimary`, `backgroundSurfaceSubtle`, `borderDefault`,
`borderOnInverse` (the white avatar ring), `elevation.level2`, and:

- **`textOnAccent` is white in both schemes.** It resolves to `chrome[0]` in light and
  `chrome[1000]` in dark, and the chrome swatch inverts between schemes, so both are `0xFFFFFFFF`.
  Matches Figma's `text/on-accent`. No special handling for the dark pill.
- **The floating self-view's border is `borderOpacitySubtle`**, which core already has at exactly
  `0x1A1A1B25` (light) / `0x33FFFFFF` (dark) — the design's `rgba(26,27,37,0.1)`. Figma genuinely
  uses two different border tokens: the tile's video-off state takes the opaque
  `border/core/default` `#d5dbe1`, while the floating view takes the translucent
  `border/core/opacity-subtle`, which reads better sitting on top of video. Following Figma here.
- Name text 13/16 → `textTheme.metadataDefault` (13/16 iOS, 12/16 Android — accept the delta).
- The `#ebeef1` button fill comes from `StreamButton.icon(style: .secondary, type: .solid,
  size: .small)` — do not hardcode it.

**One token is genuinely missing from `stream_core_flutter`:
`background/core/overlay-dark-strong`** (`#1a1b25bf` light, `#000000bf` dark). It is a literal value
in `design-system-tokens`, and core's `backgroundOverlayDark` is 25% / 50% — too light. Added in
Phase 0.

The `indicator/*` set needs **no new tokens**: in `design-system-tokens` all four are aliases, so
they resolve straight off the existing colour scheme.

| Design token | Resolves to | light | dark |
|---|---|---|---|
| `indicator/great` | `colorScheme.accentSuccess` | `#00A46E` | `#00C384` |
| `indicator/fair` | `colorScheme.accentWarning` | `#F26D10` | `#FA922B` |
| `indicator/poor` | `colorScheme.accentError` | `#D90D10` | `#FC526A` |
| `indicator/speaking` | `colorScheme.brand.shade300` | `#78A8FF` | `#005FFF` |

Still a change worth making: today the connection indicator paints every lit bar one colour, but the
design defines **poor / fair / great** as distinct colours. The style therefore exposes a colour per
level rather than a single `activeColor`, and the speaking bars take `brand.shade300`.

All of the above was verified by resolving the real `StreamColorScheme` in both brightnesses and
comparing against Figma — including `textOnAccent` (white in both) and `borderOpacitySubtle`
(`0x1A1A1B25`), the two values I had initially flagged as gaps in error.

---

## Phase 0 — `stream_core_flutter` tokens

Done in `/Users/renefloor/Documents/github/stream-core-flutter`, already on branch
`feat/participant-tile`:

- Add `backgroundCoreOverlayDarkStrong` to
  `lib/src/theme/primitives/internal/tokens/{light,dark}/stream_tokens.dart`.
- Expose it on `StreamColorScheme` as `backgroundOverlayDarkStrong`, threaded through `.light()`,
  `.dark()`, `raw` and the generated `copyWith` / `lerp` (`.fromSeed()` delegates, so it needs no
  change), plus a CHANGELOG entry under core's `## Upcoming`.
- Nothing else. The `indicator/*` colours are aliases and need no token; a wholesale resync of
  core's token file against `design-system-tokens` (roughly 60 constants behind) is a separate
  chore.

**Status: done** — committed on `stream-core-flutter@feat/participant-tile` as
`feat(ui): add backgroundOverlayDarkStrong color`. `dart analyze` is clean and the generated
`.g.theme.dart` picked the field up.

Develop the video side against a **path** `dependency_override` on the root `pubspec.yaml`
pointing at that checkout, then switch back to a git `ref` once the core change is merged and
before this branch is opened for review.

---

## Phase 1 — Bug fixes (land first, standalone)

The bridge is only correct on top of these:

- `StreamCallParticipantThemeData.copyWith` takes `showDominantSpeakerBorder` /
  `dominantSpeakerBorderThickness` / `dominantSpeakerBorderColor` for fields named
  `showSpeakerBorder` / `speakerBorderThickness` / `speakerBorderColor`. Same in
  `debugFillProperties`.
- `StreamCallParticipantThemeData.merge` drops `pausedVideoIndicatorColor`.
- `stream_video_theme.dart:405` — `callControlsTheme: callControlsTheme.merge(callControlsTheme)`
  is a self-merge, so `other`'s value is discarded.
- `StreamVideoTheme.merge` omits `localVideoTheme` entirely (it is in `copyWith` and `lerp`).

## Phase 2 — Codegen setup

`packages/stream_video_flutter/pubspec.yaml`: `theme_extensions_builder_annotation: ^7.1.0`
(dependency), `theme_extensions_builder: ^7.2.0` (dev). Add both to the root `pubspec.yaml`'s
`melos.command.bootstrap.dependencies` so bootstrap syncs them. No `build.yaml` needed
(`auto_apply: dependents`, `build_to: source`); `.g.theme.dart` files are committed. Verify
`melos run generate:flutter`, and add a CI check that regeneration is a no-op.

## Phase 3 — New themes

Five files under `src/theme/components/` (mirroring core, and keeping generated themes visually
separate from the legacy hand-written ones), plus a `components.dart` barrel exported from
`themes.dart`. Each follows `stream_avatar_theme.dart` / `stream_app_bar_theme.dart` exactly:
`@themeGen @immutable` data class with **all fields nullable**, a `static lerp` delegating to
`_$X.lerp`, and an `InheritedTheme` with `wrap()` and a merging `of()`:

```dart
static StreamParticipantTileThemeData of(BuildContext context) {
  final local = context.dependOnInheritedWidgetOfExactType<StreamParticipantTileTheme>();
  return StreamVideoTheme.of(context).participantTileTheme.merge(local?.data);
}
```

| File | Classes |
|---|---|
| `participant_tile_theme.dart` | `StreamParticipantTileTheme`, `…ThemeData` (holds only `style`), `StreamParticipantTileStyle`, `StreamParticipantPlaceholderStyle` (carries a core `StreamAvatarThemeData?`, which is itself nullable-fielded and themeGen'd, so it merges and lerps properly) |
| `participant_label_theme.dart` | `StreamParticipantLabelTheme`, `…ThemeData`, `StreamParticipantLabelStyle` |
| `connection_quality_indicator_theme.dart` | `StreamConnectionQualityIndicatorTheme`, `…ThemeData`, `…Style` (`size`, `backgroundColor`, `iconSize`, `poorColor`, `fairColor`, `greatColor`, `inactiveColor`; defaults `accentError` / `accentWarning` / `accentSuccess`) |
| `floating_participant_tile_theme.dart` | `StreamFloatingParticipantTileTheme`, `…ThemeData`, `…Style` |
| `call_participants_grid_theme.dart` | `StreamCallParticipantsGridTheme`, `…ThemeData` (flat: `padding`, `mainAxisSpacing`, `crossAxisSpacing`) |

`StreamParticipantTileStyle` fields, grouped: surface (`videoFit`, `backgroundColor`,
`borderRadius`, `border`, `speakingBorder`), visibility (`showSpeakerBorder`,
`showParticipantLabel`, `showConnectionQualityIndicator`, `showMoreButton`, `showReaction`), bottom
toolbar (`height`, `padding`, `spacing`), top toolbar (`height`, `padding`, `moreButtonStyle`,
`reactionSize`, `reactionInset`), nested (`placeholderStyle`, `labelStyle`,
`connectionQualityIndicatorStyle`).

`speakerBorderThickness` + `speakerBorderColor` collapse into one `BoxBorder? speakingBorder`.
`StreamFloatingParticipantTileStyle` composes rather than inherits: `size`, `padding`,
`borderRadius`, `border`, `elevation`, `shadowColor`, `initialAlignment`, `enableSnapping`, and a
`tileStyle` merged over the ambient tile style — the floating view owns drag/snap/elevation state
that is meaningless on a grid tile.

Defaults live in the widget as `class _StreamXStyleDefaults extends StreamXStyle` overriding getters
non-nullably off `context.streamColorScheme` / `streamTextTheme` / `streamRadius` / `streamSpacing`
/ `streamElevation` — the `_StreamAppBarStyleDefaults` shape. Never hand-roll
`copyWith`/`merge`/`lerp`/`==`/`hashCode`.

## Phase 4 — `StreamVideoTheme` wiring + legacy bridge

Add the five themes as **non-nullable fields with empty `const` defaults in `raw`** (core's
`StreamTheme` does the same; defaults rather than `required` keeps `StreamVideoTheme.raw` source
compatible), threaded through the factory, `copyWith`, `merge` and `lerp`.

**Delete the `callParticipantTheme` block from `fromColorAndTextTheme`.** Those concrete values move
into `_StreamParticipantTileStyleDefaults`, which reads the context and therefore tracks dark mode —
and drops the `isDesktopDevice` platform branch currently evaluated *outside* the widget tree.

Two bridge seams:

- **Factory** — a supplied `callParticipantTheme` is translated by four `to…ThemeData()` methods and
  merged *under* any explicitly passed new theme. Same for `localVideoTheme` →
  `floatingParticipantTileTheme`.
- **Widget** — `StreamCallParticipantTheme` becomes a `StatelessWidget` that inserts the four new
  themes plus a private `_LegacyCallParticipantTheme` so `.of(context)` still resolves. `const
  StreamCallParticipantTheme(data:…, child:…)` keeps compiling; only subclassing or a direct
  `dependOnInheritedWidgetOfExactType<StreamCallParticipantTheme>()` breaks.

**Distinguishing intent.** The legacy fields are non-nullable with hardcoded defaults, so
`StreamCallParticipantThemeData(borderRadius: 16)` also carries nineteen old defaults. Translate
only fields that **differ from `const StreamCallParticipantThemeData()`**, so a customer who set one
field gets their override *plus* the redesign rather than being frozen into the old look. Documented
caveat: explicitly setting a value equal to the old default is indistinguishable and picks up the
new default.

Full mapping table goes in the changelog; the notable rows are `participantLabelAlignment` and
`connectionLevelAlignment` (**no equivalent** — both are fixed slots of one toolbar row),
`speakerBorderThickness`+`Color` → `speakingBorder`, `localVideoWidth`+`Height` → `size`, and
`connectionLevelActiveColor` → all three of `poorColor`/`fairColor`/`greatColor` (the indicator now
colours per level, so a legacy override is bridged as a flat colour across the three). The legacy
`userAvatarTheme` (a `StreamUserAvatarThemeData`) is translated into the placeholder's core
`StreamAvatarThemeData` — size, border and initials style carry across; anything with no
`StreamAvatar` equivalent is dropped and listed in the changelog.

## Phase 5 — Leaf components

Each gets the `StreamX` / `StreamXProps` / `DefaultStreamX` / `_StreamXStyleDefaults` quartet, reads
**its own** theme (fixing the four widgets that currently reach into
`StreamVideoTheme.of(context).callParticipantTheme`), and gets a factory slot:

- **`stream_user_avatar.dart` — simplified onto core's `StreamAvatar`, and given its own factory
  slot.** Today it is a bespoke 250-line widget (`CachedNetworkImage` + `_ImageUserAvatar` +
  `_InitialsUserAvatar` + a hand-rolled selection ring) that does *not* wrap `StreamAvatar`. It
  becomes the standard triple — `StreamUserAvatar` / `StreamUserAvatarProps` /
  `DefaultStreamUserAvatar` — whose default implementation is just core's `StreamAvatar`
  (`imageUrl: user.image`, `placeholder: (context) => Text(initials)`, palette colours from
  `colorScheme.avatarPalette`). That deletes all four private classes and the selection machinery.

  The design's 2px white ring then comes free: `StreamAvatar` already has `showBorder` (default
  `true`) and a themeable `StreamAvatarThemeData.border`, so the tile scopes
  `StreamAvatarTheme(data: StreamAvatarThemeData(size: .xxl, border: Border.all(color:
  colorScheme.borderOnInverse, width: 2)))` — `StreamAvatarSize.xxl` is exactly the design's 80px,
  and nothing is hand-drawn.

  `StreamUserAvatarProps` carries the whole **`UserInfo`** (`id`, `name`, `role`, `image`, `teams`,
  `extraData`) rather than pre-resolved avatar arguments, matching how chat's `messageLeading` slot
  hands over the whole `Message`. An integrator registering `userAvatar` can therefore render a
  completely different avatar from fields the SDK never looks at — a team badge from `teams`, a
  role ring, an identicon from `extraData`. Because every avatar in the SDK routes through it, one
  registration changes the tile, the lobby, the incoming/outgoing screens and the participant list
  at once. Add a widget test asserting exactly that: one registered `userAvatar` builder reaches
  both the tile placeholder and the lobby.

  This also makes `StreamUserAvatarThemeData` deprecable in favour of core's
  `StreamAvatarThemeData` — which is nullable-fielded and themeGen'd, so it merges and lerps
  properly. Bridge it the same way as the other legacy themes.

- `participant_placeholder.dart` — the video-off state of a tile: a centred
  `StreamUserAvatar(user: participant.toUserInfo())` inside the scoped `StreamAvatarTheme`. Kept as
  a slot of its own even though the avatar is now replaceable, because "what fills a tile when
  there is no video" is a different decision from "how a user is drawn" — an integrator may want a
  blurred last frame, initials on a colour, or a logo.
- `participant_video.dart` — wraps `StreamVideoRenderer`.
- `participant_label.dart` — rewritten into the triple; **newly exported**.
- `indicators/connection_quality_indicator.dart` — rewritten; **newly exported**.

Both label and indicator are unexported today, so reshaping their constructors (including dropping
`StreamParticipantLabel.fromParticipant`) is not a public break — but they *must* be exported now,
since registering their factory slot needs their `Props` and `Default` types to be nameable.
`audio_indicator.dart` / `audio_level_indicator.dart` stay internal.

`streamVideoComponentBuilders` gains `participantPlaceholder`, `participantVideo`,
`participantLabel`, `connectionQualityIndicator` and `userAvatar`. **Precedence**, documented on the
props: a per-instance `videoRendererBuilder` / `videoPlaceholderBuilder` beats a registered slot,
which beats `DefaultStreamX`.

Label internals:

```dart
ClipRRect(                                  // its own clip — without it the BackdropFilter
  borderRadius: radius.lg,                  // blurs everything up to the tile's ClipRRect
  child: _MaybeBlur(                        // blurSigma null/0 builds NO BackdropFilter at all
    sigma: style.blurSigma,                 // 12.5
    child: DecoratedBox(
      decoration: BoxDecoration(color: style.backgroundColor),
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,                // core's StreamAvatar clamps for the same reason
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 4, 4, 4),
          child: Row(mainAxisSize: .min, spacing: spacing.xs, children: [
            if (showName)
              Flexible(child: Text(participant.name,
                  maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis)),
            if (!participant.isVideoEnabled)
              Icon(context.streamIcons.videoOffFill, size: 20),
            StreamAudioIndicator(...),      // 24px box, radius 8
          ]),
        ),
      ),
    ),
  ),
)
```

The sound indicator is a permanent 24x24 box holding a 10px glyph, so the pill keeps its shape as
someone starts and stops talking. It animates around its centre line while speaking and collapses to
three dots otherwise. The muted state adds a `voiceOffFill` icon ahead of it; there is no unmuted
icon.

## Phase 6 — The tile

```text
ClipRRect(borderRadius)                     // Android RTCVideoView is a platform view; a
└ Container(                                // BoxDecoration alone cannot round it
    decoration: BoxDecoration(color: backgroundColor, borderRadius: …),
    foregroundDecoration: BoxDecoration(    // rings paint OVER the video: no inset,
      borderRadius: …,                      // and toggling isSpeaking repaints without relayout
      border: speaking ? speakingBorder : (hasVideo ? null : border),
    ),
    child: Stack(fit: expand, children: [
      StreamParticipantVideo(...),          // NO RepaintBoundary here — see risks
      if (showMore || showReaction)
        PositionedDirectional(top: 0, start: 0, end: 0, child: RepaintBoundary(
          Padding(spacing.xxs, Row(crossAxisAlignment: start, children: [
            if (showMore) _MoreMenuButton(actions),
            const Spacer(),
            if (showReaction) Padding(spacing.xs, _ReactionIndicator(size: 48)),
          ])))),
      if (showLabel || showIndicator)
        PositionedDirectional(start: 0, end: 0, bottom: 0, child:
          Padding(spacing.sm, Row(crossAxisAlignment: end, children: [
            Expanded(child: Align(alignment: AlignmentDirectional.centerStart,
                child: showLabel ? StreamParticipantLabel(...) : const SizedBox.shrink())),
            if (showIndicator) ...[
              SizedBox(width: spacing.sm),
              RepaintBoundary(child: StreamConnectionQualityIndicator(...)),
            ],
          ]))),
    ]))
```

**Why the overlap is gone.** The label and the indicator are siblings in one `Row`, not two `Align`s
in a `Stack`. `Expanded(child: Align(start))` caps the label region at exactly
`width − 12 − 12 − 32 − 12` by construction, and the `Text` inside carries
`maxLines: 1, softWrap: false, overflow: ellipsis`, so it truncates instead of sliding under.
`Flexible` + `Spacer` would **not** work — both are flex children, so `RenderFlex` would split the
free space and cap the pill at half the row. `Align` also handles the label-less floating self-view
without a conditional, and `AlignmentDirectional` / `PositionedDirectional` give RTL for free.

No hard-coded toolbar heights: `12 + max(pill, 32) + 12 = 56` falls out naturally, so text scaling
grows the toolbar rather than clipping it. The bottom toolbar must collapse to zero height when
neither slot shows — the livestream skin and the floating view both depend on it.

**Density ladder.** Private constants with the arithmetic in a comment, resolved from the tile's own
`LayoutBuilder` constraints (the same tile is a 340px desktop cell, a ~150px spotlight thumbnail and
a 140px floating view):

| tier | width | name | pill | indicator | more | reaction |
|---|---|---|---|---|---|---|
| `full` | ≥ 152 | ✔ | ✔ | ✔ | ✔ | ✔ |
| `compact` | ≥ 108 | ✘ | ✔ | ✔ | ✔ | ✔ (32px) |
| `minimal` | ≥ 56 | ✘ | ✘ | ✔ | ✘ | ✘ |
| `bare` | — | ✘ | ✘ | ✘ | ✘ | ✘ |

Degradation: name ellipsizes → name dropped, pill becomes a 32px mic square → pill dropped,
indicator only → both toolbars dropped. Never clipped, never a `RenderFlex` overflow.
`LayoutBuilder` is safe at the tile root — `TileView`, the mobile grid, the spotlight `AspectRatio`
and `FloatingViewContainer` all pass bounded constraints and none ask for intrinsics.

**Sub-style hand-off.** Generated `merge` is *shallow*, so nested styles are replaced wholesale. The
tile must merge each sub-style explicitly, then scope it — the `StreamAppBarStyle.leadingStyle`
pattern, so a label supplied by a custom factory builder still picks up the tile's styling:

```dart
final labelStyle = StreamParticipantLabelTheme.of(context).style?.merge(style?.labelStyle)
    ?? style?.labelStyle;
// …
StreamParticipantLabelTheme(
  data: StreamParticipantLabelThemeData(style: labelStyle),
  child: StreamParticipantLabel(participant: participant),
)
```

**The reaction moves out of the renderer builder.** Today it is built inside the default
`videoRendererBuilder`, so any custom renderer silently loses reactions. Moving it to the top
toolbar fixes that; the emoji catalogue lookup stays on `callControlsTheme.callReactions`.

## Phase 7 — More menu

```dart
@immutable
class StreamParticipantTileAction {
  const StreamParticipantTileAction({
    required this.icon, required this.label, required this.onPressed,
    this.isDestructive = false, this.enabled = true,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool enabled;
}

typedef StreamParticipantTileActionsBuilder =
    List<StreamParticipantTileAction> Function(BuildContext, CallParticipantState);
```

Plain, const-constructible data. Resolution:
`props.actionsBuilder?.call(context, participant) ?? props.actions ?? const []` — empty ⇒ no button
at all. Deliberately **no assert** that only one is set: `copyWith` is the sanctioned "decorate the
default" path and an assert would make `copyWith(actionsBuilder: …)` throw over existing `actions`.

The menu reuses `StreamContextMenuAnchor` wrapping core's `StreamContextMenu` /
`StreamContextMenuAction` (which already has `label`, `leading`, `onTap`, `enabled`,
`isDestructive`). The trigger is `StreamButton.icon(style: .secondary, type: .solid, size: .small)`
with `context.streamIcons.moreHorizontal`, wrapped in core's `StreamTapTargetPadding` for the
32-visual/48-target split.

Three things the anchor needs, in a small stateful `_MoreMenuButton`:

- **Close on tap.** `StreamContextMenuAction` only auto-dismisses inside a `PopupRoute`; a
  `MenuAnchor` panel is an `OverlayPortal`, so `onTap` must call `controller.close()` itself.
- **Close on scroll.** The grid is a `PageView` and the spotlight bar a `ListView`; without a
  `Scrollable.maybeOf(context)?.position.isScrollingNotifier` listener the panel floats free of its
  tile.
- **Close on participant change** in `didUpdateWidget`, so a menu can't act on the wrong person.

The panel renders in the root `Overlay` above the tile's clip and is screen-clamped, so a 200px menu
on a 140px floating tile needs no special handling.

## Phase 8 — Floating self-view and call sites

`StreamFloatingParticipantTile` renders through `Material(elevation: streamElevation.level2, shape:
RoundedRectangleBorder(radius.lg, side: 1px @10% ink))` — elevation in dp, not the hand-painted
`BoxShadow(blur 4, spread 2)` at `local_video.dart:96-104`. `StreamLocalVideo` delegates to it.
`StreamLocalVideoThemeData` is deprecated and bridged; note the aspect change 125×150 → 140×228
(0.83 → 0.61) in the changelog, it is a large visual difference.

Call sites to update: `regular_call_participants_content.dart` (stop passing grid spacing),
`call_participants_grid_view.dart` (read the grid theme; delete the now-dead `_kDefaultSpacing = 16`
— `RegularCallParticipantsContent` always overrode it with 8, so default to `spacing.xs`),
`livestream_content.dart:214` (`backgroundColor:` → `style:`), `livestream_hosts.dart`,
`screen_share_call_participants_content.dart`, `call_participants.dart`, and
`android_pip_overlay.dart` (pass `showParticipantLabel: false`,
`showConnectionQualityIndicator: false`, no actions — the density `bare` tier is the safety net, not
the mechanism).

`StreamCallParticipant` keeps all 24 parameters and synthesizes the style **in `build`**, not in the
initializer, because `speakerBorderThickness` without `speakerBorderColor` needs the context-backed
default to fill the gap. `participantLabelAlignment` / `connectionLevelAlignment` are accepted and
documented as having no effect — the same treatment the toggle-option colour params already got in
this release.

## Phase 9 — Migration aids, docs, dogfooding

**`fix_data.yaml` — one hazard to fix first.** The existing bulk
`StreamCallParticipant` → `StreamParticipantTile` rename (lines 6-14) becomes actively harmful:
after this change `StreamParticipantTile` no longer accepts the visual parameters, so a blind rename
turns working code into compile errors. Narrow it to fire only when none of those arguments are
present, or remove it and document the rename manually. Then add: the three `copyWith` parameter
renames, the leaf renames (`enabledMicrophoneColor` → `microphoneOnColor`, etc.), and
`removeParameter` for the two dead alignment params. Splitting one class into four and folding two
fields into a `BoxBorder` are **not** expressible as data-driven fixes — they go in the changelog.
Add a `test_fixes/` directory (none exists yet; melos's `test:fixes` filters on `dirExists`).

`CHANGELOG.md` under `## Upcoming (next major)`, using this repo's existing emoji headings. Cover:
the redesign and its concrete metric changes; the five new themes; the five factory slots; the more
menu; the deprecations and the bridge's known caveat; the grid-spacing move; the three merge/copyWith
bug fixes now taking effect where they previously did not; and that migrated theme data no longer
implements `Diagnosticable`, so its properties leave the widget inspector.

`dogfooding/lib/app/app_content.dart:383-408` is the in-repo canary — it sets `borderRadius: 16`,
`speakerBorderColor`, `backgroundColor`, `userAvatarTheme`, `audioLevelIndicatorColor`,
`participantLabelTextStyle` and the three grid values, exercising most of the bridge. Verify it
visually before merging, then migrate it to the new themes and add a worked `actionsBuilder` using
the real LLC APIs (`setParticipantPinnedLocally`, `setParticipantPinnedForEveryone`, `blockUser`,
`removeMembers`, `muteUsers`).

**`CLAUDE.md` (new, repo root)** — the design-system rules that had to be dug out of the core
checkout, so the next session doesn't repeat the archaeology:

- `stream_core_flutter` is a git dependency; its source, `CLAUDE.md`, `STYLE_GUIDE.md` and
  `TESTING.md` live under `~/.pub-cache/git/stream-core-flutter-<ref>/` at the ref pinned in the root
  `pubspec.yaml`. That style guide is the authority.
- Themes: `@themeGen` + `_$X` mixin + `part '*.g.theme.dart'`; **all fields nullable**; defaults in
  the widget via `_XStyleDefaults extends XStyle`; never hand-roll
  `copyWith`/`merge`/`lerp`/`==`/`hashCode`; `<Component>ThemeData` top-level vs `<Component>Style`
  nested; `InheritedTheme` with a **merging** `of()` and a `wrap()`; generated `merge` is **shallow**.
- Components: the `StreamX` / `StreamXProps` / `DefaultStreamX` triple; video registers factory
  builders through the type-keyed `extensions` map because it is external to core.
- Tokens: read `context.streamColorScheme` / `streamTextTheme` / `streamSpacing` / `streamRadius` /
  `streamElevation` / `streamIcons` — **not** legacy `StreamVideoTheme.colorTheme/textTheme`. Note
  the two coexisting theme systems and which one new code uses.
- Elevation via `StreamElevation` + `Material`, not `BoxShadow`; borders in a `DecoratedBox` outside
  the `Material` (it clips with `PhysicalShape`).
- The barrel re-exports core `hide StreamIcons, StreamTextTheme`, so bare `StreamIcons` is video's
  own three-icon class while `context.streamIcons` returns core's.
- `src/widgets/design_system_candidates/` holds components staged to graduate to core.
- Testing: alchemist, `TestWrapper` + `streamGoldenTest`, only `goldens/ci` is committed, regenerate
  via the `update_goldens` workflow rather than locally, and `Overlay` content snapshots blank.
- Changelog under `## Upcoming (next major)`; deprecations pair `@Deprecated` with a `fix_data.yaml`
  transform and `dart fix --apply`.
- Figma MCP is the design source; `melos run generate:flutter` for codegen.

---

## Tests

Widget tests under `test/src/call_participants/`, each stubbing the renderer as the existing tests
already do:

- **Overlap sweep** (the regression test for the whole change) — 60-character name at widths
  `[400, 320, 240, 200, 160, 152, 130, 108, 90, 64, 56, 40]`; assert `tester.takeException()` is
  null at each, and `getRect(label).right <= getRect(indicator).left - 12` wherever both render.
- **Ellipsis fires** — at 160px, `RenderParagraph.didExceedMaxLines` is true and the label width is
  ≤ `tileWidth - 68`.
- **Density** — 130px drops the name, 90px drops the pill, 40px drops both toolbars.
- **More menu** — hidden for null / empty `actions` and for an `actionsBuilder` returning empty;
  shown otherwise; tap opens it; tapping an item fires the callback **and closes the menu**;
  `actionsBuilder` wins over `actions` and receives the right participant.
- **Audio branches** — the three cases, and specifically *"a muted speaking participant shows the
  mic icon, not the level bars"*, which is the assertion protecting the deviation from Figma.
- **Factory slots** — each of the five resolves its builder, falls back to `DefaultStreamX`, and
  yields to a per-instance builder where one exists.
- **Theme** — a local `StreamParticipantTileTheme` merges over the global instead of replacing it;
  nested sub-styles reach the label and indicator.
- **Bridge** — field-by-field over the diff-against-defaults logic, plus a tile built from
  dogfooding's exact legacy `StreamCallParticipantThemeData`.
- **PiP** — `AndroidPipOverlay` renders no label, no indicator, no more button.
- **Deprecated wrapper** — `StreamCallParticipant` still compiles with all 24 params and a custom
  `speakerBorderColor` reaches the `foregroundDecoration`.

Golden tests via `streamGoldenTest`, one PNG per brightness under `goldens/ci`:
`participant_tile_golden_test.dart` (default, speaking, muted, video-off, long name, with actions,
with reaction, compact, minimal, `textScaleFactor: 2.0`), `participant_label_golden_test.dart`,
`connection_quality_indicator_golden_test.dart`, `floating_participant_tile_golden_test.dart`
(140×228).

Two things to get right or these hang / mislead:

- `streamGoldenTest` defaults to `pumpBeforeTest: onlyPumpAndSettle`, which **never settles** against
  the audio-level indicator's repeating controller — every speaking scenario would time out. Pass an
  explicit two-step pump; the controller always starts at 0, so it stays deterministic.
- `BackdropFilter` is a **no-op under `flutter test`** (nothing is composited behind the stubbed
  renderer), so the goldens show a flat 75% fill. Comment it, or the next person "fixes" a blur that
  was never broken.

The open menu is **not** golden-tested — the CI capture path drops `Overlay` content.

## Risks

1. **A `RepaintBoundary` between the video and the label pill silently kills the blur.** The filter
   samples the enclosing layer's backdrop; a boundary makes that backdrop empty. Boundaries go
   *around* the top toolbar, the indicator, and the animated bars inside the pill — never between the
   renderer and the pill. Easiest thing to get wrong in review.
2. **The pill needs its own `ClipRRect`**, or the filter blurs the whole tile.
3. **Blur cost** — one `saveLayer` per pill per frame: 6 on a mobile page, up to 49 on desktop.
   Mitigated by blurring only the pill and by `blurSigma: null` building no `BackdropFilter` at all
   (a sigma-0 filter still costs the layer).
4. **`_StreamXStyleDefaults` instances must never enter a theme.** Generated `==` compares
   `runtimeType`, `canMerge` is `true`, and every getter is non-null — merging one would force every
   field. Keep them local to `build`.
5. **`onSizeChanged` drives dynascale** (`call.updateSubscription`). A replaced `participantVideo`
   builder that forgets to forward it silently degrades quality negotiation for the whole call.
   Document loudly on the props, or lift the `VisibilityDetector` into the tile.
6. **The legacy `userAvatarTheme` bridge cannot lerp.** `StreamUserAvatarThemeData` exposes an
   instance `lerp(other, t)` rather than a static one, so on a nullable field the generator falls
   back to `t < 0.5 ? a : b`. This only affects the deprecation bridge — the new placeholder style
   carries a core `StreamAvatarThemeData`, which lerps properly.
7. **`StreamVideoTheme.raw` must keep defaults** for the five new fields, or adding them is a source
   break for anyone constructing `raw` directly.
8. **The connection indicator gains per-level colours.** One blue `connectionLevelActiveColor` on a
   black box becomes a dark chip whose bars are red / orange / green from `accentError` /
   `accentWarning` / `accentSuccess`. The legacy field has no single equivalent; the bridge sets all
   three to the old value so an explicit override still lands as a flat colour. The mapping most
   likely to generate a support ticket — call it out clearly in the changelog.
9. **`StreamCallParticipantTheme.of` changes from replace to merge.** With the non-nullable legacy
   data the two coincide, but the bridged new themes genuinely merge. One changelog sentence.
10. **Text scaling** — at 2.0 the pill is ~40px tall; clamped to 1.3 inside the pill, with a golden
    locking the result.
11. `Row(spacing:)` needs Flutter ≥ 3.27; the package pins `>=3.38.1`.

## Verification

```bash
melos bootstrap
melos run generate:flutter
melos run analyze
melos run format
cd packages/stream_video_flutter && flutter test
```

Before opening for review: confirm the root `pubspec.yaml` points `stream_core_flutter` back at a
git `ref` (the merged core commit), not the local path used during development, and re-run
`melos bootstrap`.

Then run the dogfooding app, join a call with several participants, and check a long name against
the indicator, the speaking border, the video-off avatar, the more menu, and the floating self-view.
`melos run update:goldens` renders `goldens/<platform>/` for local review; the committed
`goldens/ci/*.png` are regenerated by dispatching the `update_goldens` workflow from the branch,
never committed from a local run.

---

## Progress

- [x] **Phase 0** — `stream_core_flutter` token (`backgroundOverlayDarkStrong`) + local path override
- [x] **Phase 1** — bug fixes: legacy `copyWith` param names, `merge` dropping `pausedVideoIndicatorColor`, `StreamVideoTheme.merge` self-merge + missing `localVideoTheme`
- [x] **Phase 2** — codegen setup (`theme_extensions_builder`, plus a `build.yaml` scoping it to `lib/`+`test/`)
- [x] **Phase 3** — five new `@themeGen` themes under `src/theme/components/`
- [x] **Phase 4** — legacy bridge (factory only; `copyWith` and the deprecated widget are documented as inert)
- [x] **Phase 5** — `StreamUserAvatar`, placeholder, video, label, connection indicator (triples, slots, exported)
- [x] **Phase 6** — the tile: new layout, density ladder, no-overlap toolbar
- [x] **Phase 7** — more menu (`StreamParticipantTileAction`, `actionsBuilder`)
- [x] **Phase 8** — floating self-view + call sites
- [x] **Phase 9** — `fix_data.yaml`, CHANGELOG, dogfooding, root `CLAUDE.md`
- [x] **Tests** — overlap sweep, density, menu, audio branches, slots, bridge
- [x] **Goldens** — tile, long-name sweep, label, indicator, floating
- [ ] **Wrap-up** — core merged, `pubspec.yaml` back to a git ref, `melos bootstrap`
