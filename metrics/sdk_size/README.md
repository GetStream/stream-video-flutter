# SDK size

Measures how much each SDK adds to a release app, and how large each package's
pub.dev archive is. The `sdk_size` workflow runs this on every pull request and
reports it in two comments, `## SDK Size` and `## Size Breakdown`. Pushes to
`main` store the numbers as the benchmark in `GetStream/stream-internal-metrics`.

## How it works

Every folder under `variants/` is one app. `measure.dart` creates an empty app
with `flutter create --empty`, adds the variant's `dependencies.yaml` and
`main.dart`, and builds a release with `--analyze-size`:

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

## Adding a variant

Add a folder under `variants/` with:

- a `dependencies.yaml` that lists the packages, for example `  stream_video: any`.
  Every package in `packages/` is resolved from its path.
- a `main.dart` that uses them.
