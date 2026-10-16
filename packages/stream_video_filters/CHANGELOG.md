## 1.7.1

- Updated `stream_video` dependency to [`1.7.1`](https://pub.dev/packages/stream_video/changelog).

## 1.7.0

### ✅ Added

- `StreamVideoEffectsManager.unregisterAllFilters()` to release native effect processors when filters are no longer needed, e.g. before leaving the call.

### 🔄 Changed

- Virtual background filters now blur the background while the background image is still loading, and keep blurring it if the image cannot be loaded, instead of sending the raw camera frame.
- [Android] Migrated the Android module to AGP's built-in Kotlin. The module no longer applies the Kotlin Gradle Plugin (KGP), whose application Android Gradle Plugin 9.0 removed — apps on AGP 9 failed to build because of it.
- Increased minimum Flutter version to 3.44.0, which is required for the built-in Kotlin migration: from 3.44 Flutter applies the Kotlin Gradle Plugin to plugin modules that no longer declare it, keeping AGP 8 builds working.
- [Android] Added the Stream Maven repository (`https://stream-io-repo.com`) to the Android build repositories.

### 🐞 Fixed

- [iOS] Improved performance and stability of background blur and virtual background filters.

## 1.6.0

- Updated `stream_video` dependency to [`1.6.0`](https://pub.dev/packages/stream_video/changelog).

## 1.5.0

- Updated `stream_video` dependency to [`1.5.0`](https://pub.dev/packages/stream_video/changelog).

## 1.4.3

- Updated `stream_video` dependency to [`1.4.3`](https://pub.dev/packages/stream_video/changelog).

## 1.4.2

- Increased minimum Flutter version to 3.38.1.

## 1.4.1

- Sync version with `stream_video_flutter` 1.4.1

## 1.4.0

- Sync version with `stream_video_flutter` 1.4.0

## 1.3.3

- Sync version with `stream_video_flutter` 1.3.3

## 1.3.2

- Sync version with `stream_video_flutter` 1.3.2

## 1.3.1

- Sync version with `stream_video_flutter` 1.3.1

## 1.3.0

- Sync version with `stream_video_flutter` 1.3.0

## 1.2.4

- Sync version with `stream_video_flutter` 1.2.4

## 1.2.3

- Sync version with `stream_video_flutter` 1.2.3

## 1.2.2

- Sync version with `stream_video_flutter` 1.2.2

## 1.2.1

- Sync version with `stream_video_flutter` 1.2.1

## 1.2.0

- Fixed unnecessary video filter reapplication when camera track is disabled.

## 1.1.0

- Sync version with `stream_video_flutter` 1.1.0

## 1.0.2

- Sync version with `stream_video_flutter` 1.0.2

## 1.0.1

- Sync version with `stream_video_flutter` 1.0.1

## 1.0.0

✅ Added

- Extracted video filters from `stream_video_flutter` package. To apply filters follow the [documentation](https://getstream.io/video/docs/flutter/guides/noise-cancellation/).

✨ Improvements

- [Android] Enhanced video filter performance to deliver smoother frame rates during application.
