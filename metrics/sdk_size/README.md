# SDK size

Measures how much each SDK adds to a release app, and how large each package's
pub.dev archive is. The `sdk_size` workflow runs this on every pull request and
reports it in two comments, `## SDK Size` and `## Size Breakdown`. Pushes to
`main` and `v2` store the numbers as that branch's benchmark in
`GetStream/stream-internal-metrics`.

## How it works

Every folder under `variants/` is one app. `measure.dart` creates an empty app
with `flutter create --empty`, adds the variant's `dependencies.yaml` and
`main.dart`, copies the root `pubspec.lock`, and builds a release with
`--analyze-size`:

- Android: an arm64 APK.
- iOS: `Runner.app`, built with `--no-codesign`.

Each variant's size is what it adds on top of `baseline`, an empty
`MaterialApp`. A variant's `main.dart` has to use the SDK the way an app would.
Otherwise tree shaking removes the Dart code, and only the native libraries are
counted.

The archive size is the `Total compressed archive size` that
`flutter pub publish --dry-run` reports for each publishable package.

## Running it locally

From the repository root:

```bash
dart run metrics/sdk_size/tool/measure.dart --platform android
```

```bash
dart run metrics/sdk_size/tool/measure.dart --platform ios --variant stream_video_flutter
```

```bash
dart run metrics/sdk_size/tool/measure.dart --platform pub
```

Results are written to `build/sdk_size/results`. To drill down to single
functions, open a file from `build/sdk_size/results/analysis/` in the DevTools
App Size tool:

```bash
dart devtools
```

The tool's Diff tab compares two analysis files, for example a `main` build
against a `v2` build. The CI runs upload these files as the
`sdk-size-analysis-<platform>` artifacts.

To print the report without commenting or pushing, run the lane outside CI. It
needs read access to `GetStream/stream-internal-metrics`:

```bash
cd metrics/sdk_size && bundle install && BASE_BRANCH=main bundle exec fastlane sdk_size
```

## README badges

The size badges in the root `README.md` show a benchmark from
`GetStream/stream-internal-metrics`:

- `stream_video`: what the LLC adds to an empty app.
- `stream_video_flutter`: what the UI adds on top of `stream_video`.
- `stream_video_push_notification` and `stream_video_screen_sharing`: their
  pub.dev archive size.

They are updated for each release, on the release branch, by the
`update_size_badges` workflow:

```bash
gh workflow run update_size_badges.yml --ref release/v<version> -f base_branch=main
```

## Adding a variant

Add a folder under `variants/` with:

- a `dependencies.yaml` that lists the packages, indented as under
  `dependencies:`. Every package in `packages/` is resolved from its path.

  ```yaml
    stream_video: any
  ```

- a `main.dart` that uses them.
