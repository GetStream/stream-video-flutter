## Upcoming

### 🔄 Changed

- [Android] Migrated the Android module to AGP's built-in Kotlin. The module no longer applies the Kotlin Gradle Plugin (KGP), whose application Android Gradle Plugin 9.0 removed — apps on AGP 9 failed to build because of it.
- Increased minimum Flutter version to 3.44.0, which is required for the built-in Kotlin migration: from 3.44 Flutter applies the Kotlin Gradle Plugin to plugin modules that no longer declare it, keeping AGP 8 builds working.

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
