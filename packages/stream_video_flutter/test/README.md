# Tests

## Golden (snapshot) tests

Golden tests use [`alchemist`](https://pub.dev/packages/alchemist). Two variants of
every snapshot exist:

| Variant                | Where it runs | Committed?                                  |
| ---------------------- | ------------- | ------------------------------------------- |
| `goldens/ci/*.png`     | CI (Linux)    | Yes — this is what a PR is checked against  |
| `goldens/<platform>/*` | your machine  | No — `.gitignore`d, host font rendering     |

The committed CI variant has its text obscured: every glyph is a black bar, so
the goldens don't churn on Flutter upgrades that shift text layout. Review a
visual change against your local `goldens/<platform>/` PNGs, which render text
for real.

Write snapshots with `streamGoldenTest` from
[`test_utils/goldens.dart`](test_utils/goldens.dart) rather than alchemist's
`goldenTest` directly. It renders the widget inside
[`TestWrapper`](test_utils/test_wrapper.dart), which pins everything a snapshot
could otherwise pick up from the host: the debug banner is off, the platform is
Android, the locale is `en`, and the Stream themes are installed the way an app
installs them.

```dart
for (final brightness in Brightness.values) {
  streamGoldenTest(
    'StreamRadioIndicator fills when selected and outlines when it is not',
    fileName: 'stream_radio_indicator',
    brightness: brightness,
    builder: () => GoldenTestGroup(children: [...]),
  );
}
```

### Updating goldens

Locally, to see what your change looks like:

```bash
melos run update:goldens
```

That writes the platform variant, which is not committed. **Regenerate the
committed goldens with the [`update_goldens`](../../../.github/workflows/update_goldens.yml)
workflow**, dispatched from your PR branch: it runs on the same Linux image CI
compares against and pushes a `chore: update goldens` commit back to the branch.
Goldens generated on macOS carry host-specific font rendering and fail on CI.

### Don't snapshot through an overlay

Menus, tooltips and dialogs paint into the app's `Overlay`, and the capture
Alchemist uses for obscured CI goldens drops overlay content: the snapshot comes
out blank instead of failing, so the test passes no matter what the menu looks
like.

Snapshot the content widget directly, pumped like any other widget, rather than
through the route or anchor that shows it. When that isn't possible — the panel
of a `StreamContextMenuAnchor`, say, is built internally — assert its metrics in
a widget test instead, as
[`stream_context_menu_anchor_test.dart`](src/widgets/design_system_candidates/stream_context_menu_anchor_test.dart)
does.
