# Making `stream_video` Jaspr-compatible — Experiment Plan

This is a large, multi-phase experiment tracked in git. The **Progress Checklist** at the bottom is the source of truth for status — tick items off as they land.

## Context

Jaspr is a pure-Dart web framework (component model like Flutter widgets; SSR/SSG/SPA; client code uses `package:web` + `dart:js_interop`). We want `stream_video` to power a Jaspr web app so a Jaspr user and a Flutter user can join the same call.

The blocker: although `stream_video` is described as the "low-level, Dart-only client," it is **not** Dart-only today — it declares `flutter: sdk: flutter`, an `environment: flutter:` constraint, depends on the Flutter WebRTC plugin `stream_webrtc_flutter`, and on six Flutter telemetry plugins. A pure-Dart web app (Jaspr) cannot depend on any package that transitively requires the Flutter SDK, so these must be removed from `stream_video` and re-provided per platform.

**Good news that makes this feasible:**
- The WebRTC stack is layered: `webrtc_interface` (pure-Dart abstract API) and `dart_webrtc` (pure-Dart, browser JS-interop, ships a Flutter-free `RTCVideoElement`/`HTMLVideoElement` renderer) are both reusable by Jaspr. `stream_webrtc_flutter` is only the Flutter plugin binding — and on web it literally re-exports `dart_webrtc`. `stream_video` already depends on `dart_webrtc` + `webrtc_interface`.
- `stream_video` already uses conditional-import patterns (`platform_detector`, `lifecycle`, `ws/connect`, `rtc_audio_api` all have web/io/stub variants) and already has an abstract `NetworkMonitor` interface and a `VideoEnvironmentCollector` test-override seam.

**Intended outcome:** `stream_video` becomes pure Dart; Flutter-specific implementations move into `stream_video_flutter` and are registered at init; a new `stream_video_jaspr` package provides Jaspr UI; a simplified `dogfooding_jaspr` app can do a real call with the existing Flutter dogfooding app.

**Approved approach:** vertical slice first (get a Jaspr↔Flutter call working ASAP), regression bar = `melos analyze` + existing unit tests + manual web/desktop smoke, and do the **full** telemetry/network decoupling (including the `internet_connection_checker_plus` → `NetworkMonitor` promotion) as part of this effort.

---

## Architecture: injectable platform providers with pure-Dart defaults

Create `packages/stream_video/lib/src/platform/` holding **abstract interfaces + a registry whose defaults are pure-Dart/web**. Each concern is an overridable singleton (mirroring the existing `PlatformInterface` idiom already used by `stream_video_flutter`):

```
// packages/stream_video/lib/src/platform/stream_video_platform.dart
abstract class StreamWebRtc { ... }            // engine globals + native factory + helper + initialize
abstract class NetworkMonitor { ... }          // promoted existing interface (internet checker)
abstract class DeviceStateProvider { ... }     // battery + thermal
abstract class EnvironmentInfoProvider { ... } // device/package/system info
abstract class AppLifecycleProvider { ... }    // app lifecycle (WidgetsBinding)
abstract class DisplayMetricsProvider { ... }  // physical screen size
```

Each exposes `static X instance = <PureDartDefault>();` + `static void register(X impl)`. `stream_video_flutter` registers all native (plugin-backed) implementations in a single `StreamVideoFlutter.ensureInitialized()`; web/Jaspr registers nothing and gets working defaults. Partial registration is safe — a forgotten provider degrades to its default rather than crashing. **Exception:** the WebRTC default asserts/throws on native platforms (via `CurrentPlatform`) so misconfiguration fails loud instead of silently no-op'ing.

`ensureInitialized()` must be wired into the existing native bootstrap path (the `StreamVideo` client construction as used by `stream_video_flutter`) so app authors don't need a new manual call.

---

## Phase 0 — Cosmetic quick-wins (low risk, no behavior change)

Independently shippable; shrinks the Flutter surface without yet removing the dependency.
- `debugPrint` → logger/`print` sink: `packages/stream_video/lib/src/logger/impl/console_logger.dart`, `webrtc/rtc_audio_api/rtc_audio_html.dart`.
- `@immutable` from `flutter/cupertino` → `package:meta` (already a dep): `models/call_status.dart`, `models/disconnect_reason.dart`.
- `VoidCallback` (`dart:ui`) → `void Function()`: `models/moderation_blur_config.dart`.
- Drop the vestigial `flutter/foundation` import in `webrtc/rtc_media_device/rtc_media_device_notifier.dart`.

## Phase 1 — Provider registry scaffold (purely additive)

Add the `platform/` interfaces + pure-Dart defaults and the `StreamVideoFlutter.ensureInitialized()` registration entrypoint in `stream_video_flutter`. Nothing consumes them yet → zero behavior change.

## Phase 2 — WebRTC standard-type swap (corrected: `webrtc_interface`, not `dart_webrtc`)

**First attempt (reverted):** swapping `stream_webrtc_flutter` → `dart_webrtc` imports directly does **not** work. `dart_webrtc`'s barrel (`lib/dart_webrtc.dart`) unconditionally exports JS-interop-only implementation classes (confirmed by reading the package source — no `dart.library.io` branch at all). Importing it directly in any file also compiled for native Flutter targets breaks native compilation (`flutter test` failed with `getProperty` isn't defined for the type 'RTCRtpCodecParameters'` — a dart2js/web-only JS-interop extension method that doesn't resolve on the VM). Caught immediately (336/336 → 54 passing/29 failing), reverted, confirmed green again.

**Corrected approach — target `webrtc_interface` instead, for the files that qualify.** `webrtc_interface` (already a `stream_video` dependency) is **pure abstract Dart with zero platform-specific code** — no `dart:js_interop`, no implementation, works identically on the VM and on web. Critically, several of its types are **concrete, constructible value classes** defined directly in the package itself (not just abstract interfaces needing a live implementation): `RTCSessionDescription`, `RTCIceCandidate`, `RTCRtpEncoding`, `RTCRtpTransceiverInit`, `RTCTrackEvent`, plus all the enums (`RTCIceConnectionState`, `RTCPeerConnectionState`, `RTCDegradationPreference`, …). The abstract "live object" types (`MediaStream`, `RTCPeerConnection`, `MediaStreamTrack`, `RTCRtpTransceiver`, …) are also safely usable **as type annotations** — polymorphism means a file that only refers to `MediaStream` as a parameter/return type never cares which concrete implementation (native plugin or `dart_webrtc`) is actually plugged in.

Auditing all 25 files that import `stream_webrtc_flutter`, the split is:
- **16 files use only types/concrete value-classes from `webrtc_interface`** — no factory globals, no plugin-only symbols: `call/session/call_session.dart`, `sfu/data/models/{sfu_model_mapper_extensions,sfu_publish_options,sfu_video_sender}.dart`, `telemetry/peer_connection_connect_reporter.dart`, `webrtc/codecs_helper.dart`, `webrtc/model/stats/rtc_stats_mapper.dart`, `webrtc/peer_connection.dart`, `webrtc/rtc_audio_api/{rtc_audio_html,rtc_audio_native,rtc_audio_stub}.dart`, `webrtc/rtc_parser.dart`, `webrtc/rtc_track/{rtc_remote_track,rtc_track}.dart`, `webrtc/traced_peer_connection.dart`, `webrtc/transceiver_cache.dart`. These swap straight to `import 'package:webrtc_interface/webrtc_interface.dart' as rtc;` — **no conditional barrel needed at all**, since there's no platform-specific implementation to get wrong. This is real, permanent, zero-risk decoupling progress: once `stream_webrtc_flutter` is eventually removed from the pubspec (Phase 3), these 16 files need no further change.
- **9 files need real concrete objects** (`rtc.createPeerConnection`, `rtc.navigator`/`mediaDevices`, `rtc.eventStream`) and/or genuinely plugin-only symbols (`NativePeerConnectionFactory`, `Helper`, `WebRTC.initialize`, Android audio enums, `RTCVideoRenderer`, `AndroidAudioConfiguration`) that exist in neither `webrtc_interface` alone: `call/call.dart`, `models/audio_configuration_policy.dart`, `webrtc/peer_connection_factory.dart`, `webrtc/rtc_manager.dart`, `webrtc/rtc_media_device/rtc_media_device_notifier.dart`, `webrtc/rtc_track/rtc_local_track.dart`, `webrtc/media/media_constraints.dart`, `stream_video.dart`, `telemetry/media_frame_reporter.dart`. These stay on `stream_webrtc_flutter` for now and get the full `StreamWebRtc` engine injection in Phase 3 (a conditional-import barrel alone isn't a separate step for these — the engine design subsumes it, since the web-side `DartWebRtcEngine` implementation lives in a file that's only ever reached on the web target, following the same `if (dart.library.io)`/`if (dart.library.js_interop)` file-selection pattern already used for `lifecycle_utils.dart`/`lifecycle_utils_io.dart`).

## Phase 3 — WebRTC engine injection (deepest structural work) → get the Jaspr call working (vertical slice)

The 9 files identified in Phase 2 (`call/call.dart`, `models/audio_configuration_policy.dart`, `webrtc/peer_connection_factory.dart`, `webrtc/rtc_manager.dart`, `webrtc/rtc_media_device/rtc_media_device_notifier.dart`, `webrtc/rtc_track/rtc_local_track.dart`, `webrtc/media/media_constraints.dart`, `stream_video.dart`, `telemetry/media_frame_reporter.dart`) use concrete factory globals (`createPeerConnection`, `navigator`/`mediaDevices`, `eventStream`) and/or genuinely plugin-only symbols (`NativePeerConnectionFactory`, `Helper`, `WebRTC.initialize`, Android audio enums, `RTCVideoRenderer`, `AndroidAudioConfiguration`) with no equivalent in `webrtc_interface` alone. These need the full `StreamWebRtc` engine injection — introduce `StreamWebRtc` owning these platform-varying globals:

```dart
abstract class StreamWebRtc {
  Future<RTCPeerConnection> createPeerConnection(Map cfg, Map constraints);
  StreamWebRtcHelper get helper;                 // wraps rtc.Helper
  StreamNativeFactory? createNativeFactory(...);  // null on web
  Future<void> initialize({bool refresh, Map options});  // wraps WebRTC.initialize
}
```

- **Web/Jaspr default `DartWebRtcEngine`** (in `stream_video`): `createPeerConnection` → dart_webrtc global; `helper` → no-op / `mediaDevices`-based; `createNativeFactory` → `null` (exactly today's web fallback in `peer_connection_factory.dart`); a lightweight headless "first frame" detector built on `dart_webrtc`'s `RTCVideoElement` (listen for the `canplay`/`loadeddata` DOM event) replacing `media_frame_reporter.dart`'s use of `RTCVideoRenderer`.
- **Native `FlutterWebRtcEngine`** (in `stream_video_flutter`): wraps `stream_webrtc_flutter`'s `createPeerConnection`, `Helper`, `WebRTC.initialize`, `NativePeerConnectionFactory`, and `RTCVideoRenderer`. Registered in `ensureInitialized()`.
- Replace plugin-only symbols with stream_video-defined interfaces routed through the engine:
  - `NativePeerConnectionFactory` → `StreamNativeFactory?` (methods `create`/`createPeerConnection`/`suspendAudio`/`resumeAudio`/`dispose`/`factoryId`).
  - `Helper` → `StreamWebRtcHelper` (`selectAudioOutput`, `switchCamera`, `selectAudioInput`, `setAppleAudioConfiguration`, `triggeriOSAudioRouteSelectionUI`, `pause/resumeAudioPlayout`, `regainAndroidAudioFocus`, `setiOSStereoPlayoutPreferred`).
  - `WebRTC.initialize` → `StreamWebRtc.initialize`. **Cross the boundary with `Map` payloads, not plugin enums** — `AudioConfigurationPolicy` already exposes `.getAndroidConfiguration().toMap()`, so plugin-only enums (`AndroidInterruptionSource`, `AndroidAudioAttributesUsageType/ContentType`) never enter `stream_video`.
  - `AndroidAudioConfiguration` (the deprecated `StreamVideoOptions.androidAudioConfiguration` field) → either drop with the deprecation, or re-type as a `stream_video`-defined equivalent converted to/from the plugin type only inside `FlutterWebRtcEngine`.
  - Device enumeration in `rtc_media_device_notifier.dart` → dart_webrtc `mediaDevices` (web) vs plugin (native) via the engine.

**Important given the Phase 2 lesson:** `DartWebRtcEngine`'s implementation file must itself be reached only via the established `if (dart.library.io)`/`if (dart.library.js_interop)` conditional-file-selection pattern (like `lifecycle_utils.dart`/`lifecycle_utils_io.dart`) — never imported unconditionally — so `dart_webrtc`'s JS-interop internals are never pulled into a native compile unit. `stream_video`'s pubspec keeps `stream_webrtc_flutter` declared until this phase's file-by-file migration is complete; once no file under `stream_video/lib` references it at all, **remove `stream_webrtc_flutter` from `stream_video`'s pubspec** (keeps `dart_webrtc` + `webrtc_interface`) — this is the step that actually unblocks a pure-Dart `dart pub get` for Jaspr.

**Vertical-slice checkpoint:** with the web WebRTC engine working, build the minimal `stream_video_jaspr` renderer + `dogfooding_jaspr` (Phases 6–7) *in parallel* and prove a real Jaspr↔Flutter call before finishing the telemetry cleanup. This de-risks the core unknown early.

## Phase 4 — Telemetry migration (full decoupling)

In increasing difficulty:
1. **`EnvironmentInfoProvider`** (`video_environment_collector.dart`) — already has an override seam. Default (web): browser info via `package:web`/`dart_webrtc`; native impl moves `DeviceInfoPlugin`/`PackageInfo`/`SysInfo` verbatim into `stream_video_flutter`.
2. **`DeviceStateProvider`** (battery + thermal in `call/stats/sfu_stats_reporter.dart`, `stats_reporter.dart`). Define a neutral `enum StreamThermalStatus` in `stream_video` (move `thermal_status_ext.dart` mapper with the native impl). Default = no-op stream + null battery; native = `Battery()` + `Thermal()`.
3. **`connectivity_plus`** removal — the `stream_video.dart` usage disappears when the `InternetConnection` construction moves into the native `NetworkMonitor` (step 4); replace the `health_monitor.dart` `checkConnectivity()` with `NetworkMonitor.currentStatus()`.
4. **`NetworkMonitor` promotion** (highest risk — full decoupling requested). Promote the existing `NetworkMonitor` interface to the domain type: add `Future<NetworkStatus> currentStatus()`, and replace every `InternetConnection`/`InternetStatus` parameter/field with `NetworkMonitor`/`NetworkStatus` in `call/call.dart` (incl. reconnection logic `_awaitNetworkAvailable`), `sfu/ws/sfu_ws.dart`, `call/session/call_session.dart`, `call/session/call_session_factory.dart`, `coordinator/open_api/coordinator_ws.dart`. Web default = periodic `http` HEAD checks (`http` already a dep). Native `PluginNetworkMonitor` (moves current `network_monitor_flutter.dart` into `stream_video_flutter`) preserves today's `InternetConnection`+connectivity behavior. **Public-API note:** `NetworkMonitorSettings.internetConnectionInstance` references the plugin type — deprecate it and add a `networkMonitor` field (or move that settings type into `stream_video_flutter`); confirm the API choice before touching. Add focused reconnection tests.

## Phase 5 — Lifecycle + display metrics, then drop the Flutter SDK dep

- **`AppLifecycleProvider`**: move `lifecycle/lifecycle_utils_io.dart` (the `WidgetsBinding`/`WidgetsBindingObserver` impl) into `stream_video_flutter`; default = empty stream. (The existing conditional-import stub already unblocks Jaspr/web; this makes the io target Flutter-free too.)
- **`DisplayMetricsProvider`** for `rtc_manager.dart:961` (`WidgetsBinding.instance.platformDispatcher.views.first.physicalSize`); default returns `null` → fall back to `track.getVideoDimension()`.
- Remove `flutter: sdk: flutter` and the `environment: flutter:` constraint from `stream_video/pubspec.yaml`; switch to an `sdk:`-only environment.
- Add a **pure-Dart resolution guard**: a minimal Dart-only package (or the Jaspr package) that `dart pub get`s against `stream_video` — fails if any Flutter dep leaks back into the graph. This is the definitive decoupling check.

---

## Phase 6 — New package `stream_video_jaspr`

Client-only (SPA) Jaspr components over the now-pure-Dart `stream_video`. Add to root `pubspec.yaml` `workspace:` list with `resolution: workspace`.

```
packages/stream_video_jaspr/
  pubspec.yaml            # jaspr, stream_video, dart_webrtc, web
  lib/stream_video_jaspr.dart          # barrel
  lib/src/renderer/video_track_renderer.dart   # THE core: mounts HTMLVideoElement
  lib/src/renderer/stream_video_view.dart      # participant+trackType → track, placeholder
  lib/src/call/stream_call_content.dart        # grid + controls, drives dynascale
  lib/src/call/call_state_builder.dart         # StateEmitter<CallState> → setState bridge
  lib/src/participants/participant_grid.dart
  lib/src/participants/participant_tile.dart
  lib/src/controls/{call_controls,toggle_microphone_button,toggle_camera_button,leave_button}.dart
  lib/src/styles/stream_video_styles.dart
```

**State bridge:** `CallStateBuilder` is a `StatefulComponent` that seeds from `call.state.value`, `listen`s in `initState`, `setState`s on each event, cancels in `dispose`. (`call.state` is `StateEmitter<CallState>` with `.value`/`.valueStream`/`.listen` — `packages/stream_video/lib/src/state_emitter.dart`.)

**DOM video-mount (the crux):** a `StatefulComponent` renders one stable empty host `div(key: GlobalNodeKey(), ...)`, then in `initState` appends `RTCVideoElement.htmlElement` (from `dart_webrtc`) as a manually-managed child and assigns `srcObject = track.mediaStream`. Because the `<video>` lives outside Jaspr's virtual tree, the reconciler never touches it → stable playback across rebuilds. Assign a stable Jaspr `Key` from `participant.uniqueParticipantKey + trackType` (parity with Flutter `video_renderer.dart`). Update `srcObject` in `didUpdateComponent`; clear + `remove()` in `dispose`.

**Dynascale (minimal):** on attach, call `call.updateSubscription(...)` with `RtcVideoDimension` from the host's `getBoundingClientRect()` × `devicePixelRatio`. Follow-up: `ResizeObserver`/`IntersectionObserver` via `dart:js_interop` for resize + off-screen `removeSubscription`.

**Parity reference:** `packages/stream_video_flutter/lib/src/renderer/video_renderer.dart`, and the `Call` API in `packages/stream_video/lib/src/call/call.dart` (`state`, `getTrack`, `join`, `getOrCreate`, `setCameraEnabled`, `setMicrophoneEnabled`, `leave`).

**First-cut scope:** local + remote camera tiles in a CSS grid, mic/camera toggle, leave. Defer: screenshare, spotlight/PiP, reactions, SSR.

## Phase 7 — New app `dogfooding_jaspr` (simplified)

Client SPA. Add to root `workspace:` list. **No** Google login, push notifications, or chat.

```
dogfooding_jaspr/
  pubspec.yaml            # jaspr (mode: client), stream_video, stream_video_jaspr, http, web
  web/index.html, web/main.dart      # runApp(App(), attachTo: 'body')
  lib/app.dart            # trivial login<->call router
  lib/config.dart         # host, environment (pronto), callType 'default'
  lib/services/token_service.dart    # GET /api/auth/create-token?environment=&user_id= → {token, apiKey}
  lib/services/video_client.dart     # StreamVideo(apiKey, user, initialToken) + connect()
  lib/screens/{login_screen,call_screen}.dart
```

Flow (mirrors `dogfooding/lib/di/injector.dart`, chat/push/google stripped): enter user id → fetch `{token, apiKey}` → `StreamVideo(...)` → `connect()` → `makeCall(callType: StreamCallType.defaultType(), id)` → `getOrCreate()` → `join()` → `StreamCallContent(call)`.

**CORS caveat:** the `/api/auth/create-token` endpoint must allow the dev origin (`http://localhost:<port>`). Support a hardcoded-token/apiKey fallback in `config.dart`/login for local testing (the `custom` environment path documents manual token generation).

---

## Interop (Flutter ↔ Jaspr in the same call)

Works when both clients share: same **apiKey** (both fetched from the same `/api/auth/create-token`), same **environment host** (`pronto.getstream.io`), same **call type** (`'default'`), same **call id**, compatible **token** (same backend). Both talk to the same coordinator + SFU through the same `stream_video` core; only the renderer differs.

---

## Verification

**Per-commit (regression bar):** `melos analyze` + `melos test` green (add provider fakes; focused reconnection tests for Phase 4.4). The **pure-Dart resolution guard** (Phase 5) is the definitive decoupling proof. Manual smoke on Flutter **web + desktop** after the WebRTC (Phase 3) and network-monitor (Phase 4.4) commits — flagged as the riskiest.

**Jaspr app:** `dart pub global activate jaspr_cli`; from `dogfooding_jaspr/` run `jaspr serve` (SPA at `http://localhost:8080`). Grant camera/mic. If remote video doesn't render, verify `updateSubscription` got a non-empty `RtcVideoDimension` and `srcObject` was set after the `<video>` was appended.

**Cross-client call test (the acceptance criterion):**
1. Run Flutter dogfooding (pronto env), log in, join call id `interop-test`.
2. `jaspr serve`, open browser, log in as a different user, join `interop-test`.
3. Confirm: both participants appear in each other's grids; mic/camera toggles reflect across clients (via `CallState.callParticipants`); leaving from Jaspr removes that participant on the Flutter side; audio/video both flow.

---

## Effort / risk summary

| Work | Effort | Risk |
|---|---|---|
| Phase 0 cosmetic | XS | Very low |
| Phase 1 registry scaffold | S | Low |
| Phase 2 `webrtc_interface` swap (16 files) | M | Low (no platform-specific code to get wrong; verify via `flutter test`) |
| Phase 3 WebRTC engine injection (9 files + engine) | L | **High** (registration timing, native regressions — a naive `dart_webrtc` import swap already broke native tests once) |
| Phase 4.1–4.3 env/battery/thermal/connectivity | M | Low (graceful no-op) |
| Phase 4.4 NetworkMonitor promotion | L | **High** (reconnection logic + public API) |
| Phase 5 lifecycle/display + drop Flutter dep | S | Med (needs Dart-only resolution guard) |
| Phase 6 stream_video_jaspr | M | Med (DOM mount, dynascale) |
| Phase 7 dogfooding_jaspr | S | Low (CORS caveat) |

**Highest-risk mitigations:** wire `ensureInitialized()` into the existing native bootstrap so no new app call is needed; make the WebRTC default throw (not no-op) on native platforms; decide the `NetworkMonitorSettings` public-API change before touching it; keep every commit green under `melos analyze` + tests.

---

## Progress Checklist

Tick items as they land. Each phase should keep `melos analyze` + tests green.

### Phase 0 — Cosmetic quick-wins ✅ (done)
- [x] Replace `debugPrint` in `console_logger.dart` and `rtc_audio_html.dart`
- [x] Replace `@immutable` (flutter/cupertino) with `package:meta` in `call_status.dart`, `disconnect_reason.dart`
- [x] Replace `VoidCallback` (dart:ui) with `void Function()` in `moderation_blur_config.dart`
- [x] Remove vestigial `flutter/foundation` import in `rtc_media_device_notifier.dart`

Verified: `dart analyze packages/stream_video` and `packages/stream_video_flutter` clean (no new issues); `flutter test` in `packages/stream_video` — 336/336 passing.

### Phase 1 — Provider registry scaffold ✅ (done)
- [x] Create `packages/stream_video/lib/src/platform/` with 4 provider interfaces + pure-Dart defaults: `DeviceStateProvider`, `EnvironmentInfoProvider`, `AppLifecycleProvider`, `DisplayMetricsProvider` (barrel: `stream_video_platform.dart`)
- [x] Add `StreamVideoFlutter.ensureInitialized()` registration entrypoint in `stream_video_flutter` (`lib/src/platform/`), with native impls wrapping `battery_plus`+`thermal`, `device_info_plus`+`package_info_plus`+`system_info2`, and `WidgetsBinding` (lifecycle + display metrics)
- [x] Wire `ensureInitialized()` into the dogfooding app's bootstrap (`dogfooding/lib/di/injector.dart`)

Note: `StreamWebRtc` (WebRTC engine) is deferred to Phase 3, and the `NetworkMonitor` promotion is deferred to Phase 4, as those need the deeper structural work described there — scoping Phase 1 to the 4 telemetry/lifecycle providers avoided half-built abstractions. Used direct `Provider.instance = ...` field assignment rather than a separate `register()` method (equivalent, simpler, avoids a lint). Also had to export `video_environment.dart` and `lifecycle/lifecycle_state.dart` from the main `stream_video.dart` barrel since the new provider interfaces reference those types in their public contracts.

Verified: `dart analyze` clean on `stream_video`, `stream_video_flutter` (pre-existing generated-file warnings only), and `dogfooding`; full test suites green (336 + 5 tests).

### Phase 2 — WebRTC standard-type swap (corrected: `webrtc_interface`) ✅ (done)
- [x] ~~Swap `stream_webrtc_flutter as rtc` → `dart_webrtc as rtc` directly~~ — **reverted**: `dart_webrtc`'s implementation classes are unconditionally JS-interop-only (no native/VM branch), so a direct swap breaks `flutter test` immediately (336/336 → 54 passing/29 failing, `getProperty` isn't defined for `RTCRtpCodecParameters`). Confirmed by reading `dart_webrtc`'s barrel export — no `dart.library.io` conditional at all. All 18 touched files reverted to `stream_webrtc_flutter`; re-verified 336/336 green before proceeding.
- [x] Swap the 16 qualifying files (types/value-classes only — see Phase 2 write-up above) to `import 'package:webrtc_interface/webrtc_interface.dart' as rtc;` — no conditional barrel needed, `webrtc_interface` has zero platform-specific code
- [x] `flutter test` green (native/VM) — this is the step that broke before with `dart_webrtc`; re-verified: 336/336 passing
- [x] `dart analyze` clean on `stream_video`, `stream_video_flutter` (pre-existing generated-file warnings only), `dogfooding`

`stream_video_flutter` full test suite also re-verified green (5/5). These 16 files now have zero remaining Flutter-plugin coupling and need no further change in Phase 3/5 — real, permanent decoupling progress banked early.

### Phase 3 — WebRTC engine injection (vertical slice) ✅ (done)
- [x] Define `StreamWebRtc` + `StreamWebRtcHelper` + `StreamNativeFactory` interfaces for the remaining 9 files (`call.dart`, `audio_configuration_policy.dart`, `peer_connection_factory.dart`, `rtc_manager.dart`, `rtc_media_device_notifier.dart`, `rtc_local_track.dart`, `media_constraints.dart`, `stream_video.dart`, `media_frame_reporter.dart`)
- [x] `DartWebRtcEngine`'s implementation file is reached only via `if (dart.library.js_interop)` conditional-file selection (`stream_web_rtc_default.dart` throwing stub as the io/native default, `stream_web_rtc_default_web.dart` as the web override) — never imports `dart_webrtc` unconditionally
- [x] Web/Jaspr default `DartWebRtcEngine` in `stream_video`, incl. a headless first-frame detector on `dart_webrtc`'s `RTCVideoElement` (`onCanPlay`, replacing `media_frame_reporter.dart`'s `RTCVideoRenderer` use)
- [x] Native `FlutterWebRtcEngine` in `stream_video_flutter`, registered in `ensureInitialized()`
- [x] Route `NativePeerConnectionFactory`, `Helper` (11 methods), `WebRTC.initialize`, device enumeration through the engine (Map payloads, no plugin enums)
- [x] `AndroidAudioConfiguration`/`AppleAudioConfiguration` — full public-API redesign: new neutral `StreamAndroidAudioConfiguration`/`StreamAppleAudioConfiguration` + enum mirrors in `models/audio_configuration.dart`; `AudioConfigurationPolicy`'s public API now returns these instead of the plugin types (confirmed zero external usage of the affected `.custom()` params before changing)
- [x] WebRTC default throws (`UnsupportedError` via `noSuchMethod`) on any platform where nothing registered a `StreamWebRtc`
- [x] Removed `stream_webrtc_flutter` from `stream_video/pubspec.yaml`'s main `dependencies:` — kept only in `dev_dependencies:` since the test suite's `flutter_test_config.dart` needs a native-backed `StreamWebRtc` (stream_video's tests can't depend on `stream_video_flutter`, which would be a package cycle)
- [x] `dart analyze` clean on all 3 packages; full test suites green (336 + 5); **Flutter web build succeeded** (`flutter build web`) — confirms `stream_web_rtc_default_web.dart`'s `dart_webrtc` integration actually compiles under a real web/dart2js toolchain, not just `dart analyze`. Native macOS build hit a pre-existing, unrelated CocoaPods/Firebase version conflict (not caused by this work) — not fixed, out of scope.

Also fixed along the way: `globals.dart`'s `androidWebRTCVersion`/`iosWebRTCVersion` (previously read from the plugin) are now literal strings — a small, contained leftover for Phase 4 to route through `EnvironmentInfoProvider` properly instead.

### Phase 4 — Telemetry migration (full decoupling) ✅ (done)
- [x] `EnvironmentInfoProvider` (device/package/system info) — web default + native impl moved (done in Phase 1's scaffold; consumed via `video_environment_manager.dart`, replacing the deleted `video_environment_collector.dart`)
- [x] `DeviceStateProvider` (battery + thermal) + neutral `StreamThermalStatus` enum — consumed in `stats_reporter.dart`/`sfu_stats_reporter.dart`, deleted the internal `_ThermalMonitor` class
- [x] Remove `connectivity_plus`/`internet_connection_checker_plus`/`battery_plus`/`thermal`/`device_info_plus`/`package_info_plus`/`system_info2` from `stream_video`'s pubspec `dependencies:` (moved to `stream_video_flutter`, which already needed most; added the two missing network ones)
- [x] Promote `NetworkMonitor` (added `currentStatus`, `checkInterval`, `setIntervalAndResetTimer`); replaced `InternetConnection`/`InternetStatus` across `call.dart`, `sfu_ws.dart`, `call_session*.dart`, `coordinator_ws.dart`, `coordinator_client_open_api.dart`
- [x] Web `HttpNetworkMonitor`/`NetworkMonitorFactory` default (periodic `http` HEAD polling) + native `FlutterNetworkMonitorFactory` (wraps `InternetConnection`+`Connectivity`) moved to `stream_video_flutter`; deleted `core/network_monitor_flutter.dart`
- [x] Resolved `NetworkMonitorSettings.internetConnectionInstance` — replaced with a `networkMonitor` field of the new neutral type
- [x] Reconnection tests pass (`call_reconnect_stability_test.dart`, 8 tests) + full `stream_video` suite (336/336) + `stream_video_flutter` suite (5/5)

Found and fixed along the way: bulk test-helper migration needed a `registerFallbackValue(Duration.zero)` (mocktail's `any()` on `setIntervalAndResetTimer(Duration)` had no fallback registered) — a one-line fix once diagnosed via the failing-test stack trace.

### Phase 5 — Lifecycle + display metrics + drop Flutter dep ✅ (done)
- [x] `AppLifecycleProvider` — `lifecycle_utils.dart` now delegates to `AppLifecycleProvider.instance.appState`; deleted `lifecycle_utils_io.dart` (its `WidgetsBinding` implementation already existed in `stream_video_flutter`'s `FlutterAppLifecycleProvider` from Phase 1, just needed the io file's direct `package:flutter` import removed and the conditional import in `stream_video.dart` dropped)
- [x] `DisplayMetricsProvider` for `rtc_manager.dart`'s screen-share sizing — same story, `FlutterDisplayMetricsProvider` already existed from Phase 1
- [x] Removed `flutter: sdk: flutter` from `stream_video/pubspec.yaml`'s `dependencies:` (kept `environment: flutter:` and `flutter_test`/`stream_webrtc_flutter` as **dev_dependencies only** — dev deps don't leak into consumers' resolution, so this alone is sufficient to keep `stream_video`'s own `flutter test` working while unblocking every downstream Dart-only consumer)
- [x] **Definitive pure-Dart resolution guard, done for real**: `jaspr build` on `dogfooding_jaspr` is the guard — it failed three times in sequence as each remaining Flutter/native leak surfaced, each fixed in turn:
  1. `dart:ui`/`sky_engine` FFI crash in jaspr_builder's VM-mode style-extraction pass — caused by `flutter: sdk: flutter` still being a regular (non-dev) dependency; fixed by the pubspec change above.
  2. `dart_webrtc`'s JS-interop internals (`.toJS`/`getProperty<T>`) failing to compile under the same VM-mode pass — caused by `stream_video_jaspr`'s `video_track_renderer.dart`/`stream_video_view.dart` importing `dart_webrtc`/`package:web` **unconditionally**; fixed by extracting a `StreamVideoElement` abstraction gated behind `if (dart.library.js_interop)` (mirroring `stream_web_rtc.dart`'s existing pattern) and switching `package:web` → `package:universal_web` (already conditionally-safe).
  3. Two unconditional `dart:io` leaks in `stream_video`'s public barrel: `src/logger/impl/file_logger.dart` (moved wholesale to `stream_video_flutter/lib/src/platform/`, a genuinely native-only feature) and the generated `open_api/video/coordinator/api.dart`/`api_client.dart`/`product_video_api.dart` (`HttpStatus`/`SocketException`/`TlsException`/`IOException` — replaced with local int constants and dropped the three redundant specific catches, marked `// MANUAL_EDIT` per the repo's existing convention for hand-patched generated files).
  4. Also missing: `dogfooding_jaspr`'s `build_web_compilers` dev dependency (without it, `jaspr build` silently skips the actual `dart compile js` step with only a warning, producing no `main.client.dart.js`).
- [x] `jaspr build` now succeeds end-to-end: real `dart compile js` run, ~2MB `main.client.dart.js` + `main.css` + `index.html` produced in `build/jaspr/`.

### Phase 6 — `stream_video_jaspr` package ✅ (done, pending live cross-client verification)
- [x] Package created + added to root `workspace:` list; resolves and analyzes clean
- [x] `CallStateBuilder` (StateEmitter → setState bridge)
- [x] `VideoTrackRenderer` (GlobalNodeKey host + append video element) — refactored this session behind a `StreamVideoElement` interface (`video_element.dart` / `_default.dart` / `_default_web.dart`) so `dart_webrtc` is never imported unconditionally
- [x] `StreamVideoView` (track selection + placeholder) + minimal dynascale on attach
- [x] `ParticipantTile` / `ParticipantGrid`
- [x] `CallControls` (mic / camera / leave)
- [x] `StreamCallContent` (grid + controls)
- [x] `dart analyze` clean; builds successfully as part of `dogfooding_jaspr`'s `jaspr build`

### Phase 7 — `dogfooding_jaspr` app ✅ (build verified, live call test pending)
- [x] Scaffolded app + added to root `workspace:` list
- [x] Token service (`/api/auth/create-token`) + config for `pronto` env
- [x] Login screen (user id) + connect
- [x] Call screen (`makeCall` → `getOrCreate` → `join` → `StreamCallContent`)
- [x] `jaspr build` succeeds (see Phase 5 for the chain of fixes this required)
- [ ] `jaspr serve` manual smoke + actual join

### Acceptance
- [ ] Cross-client call: Flutter dogfooding ↔ `dogfooding_jaspr` in the same call, both see/hear each other, mic/camera/leave reflected across clients — **not yet run**; the build now succeeds so this is the immediate next step
