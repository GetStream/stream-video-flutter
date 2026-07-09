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

## Phase 2 — WebRTC standard-type swap (behavior-neutral)

In the ~13 `src/webrtc/**` files, swap `import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;` → `import 'package:dart_webrtc/dart_webrtc.dart' as rtc;` (dart_webrtc re-exports all of `webrtc_interface`). Standard types (`MediaStream`, `RTCPeerConnection`, `RTCSessionDescription`, `RTCRtpTransceiver`, `RTCDegradationPreference`, …) then resolve against the interface; native concrete classes implement it, so objects flow through unchanged. **Keep `stream_webrtc_flutter` in pubspec for now** — native globals still come from it. Run full `melos analyze`/`test` here.

Key files: `webrtc/peer_connection.dart`, `peer_connection_factory.dart`, `rtc_manager.dart`, `media/media_constraints.dart`, `rtc_track/*`.

## Phase 3 — WebRTC engine injection (deepest structural work) → get the Jaspr call working (vertical slice)

Introduce `StreamWebRtc` owning the platform-varying globals that are **not** in `dart_webrtc`/`webrtc_interface`:

```dart
abstract class StreamWebRtc {
  Future<RTCPeerConnection> createPeerConnection(Map cfg, Map constraints);
  StreamWebRtcHelper get helper;                 // wraps rtc.Helper
  StreamNativeFactory? createNativeFactory(...);  // null on web
  Future<void> initialize({bool refresh, Map options});  // wraps WebRTC.initialize
}
```

- **Web/Jaspr default `DartWebRtcEngine`** (in `stream_video`): `createPeerConnection` → dart_webrtc global; `helper` → no-op / `mediaDevices`-based; `createNativeFactory` → `null` (exactly today's web fallback in `peer_connection_factory.dart`).
- **Native `FlutterWebRtcEngine`** (in `stream_video_flutter`): wraps `stream_webrtc_flutter`'s `createPeerConnection`, `Helper`, `WebRTC.initialize`, and `NativePeerConnectionFactory`. Registered in `ensureInitialized()`.
- Replace plugin-only symbols with stream_video-defined interfaces routed through the engine:
  - `NativePeerConnectionFactory` → `StreamNativeFactory?` (methods `create`/`createPeerConnection`/`suspendAudio`/`resumeAudio`/`dispose`/`factoryId`).
  - `Helper` → `StreamWebRtcHelper` (`selectAudioOutput`, `switchCamera`, `selectAudioInput`, `setAppleAudioConfiguration`, `triggeriOSAudioRouteSelectionUI`, `pause/resumeAudioPlayout`, `regainAndroidAudioFocus`, `setiOSStereoPlayoutPreferred`).
  - `WebRTC.initialize` → `StreamWebRtc.initialize`. **Cross the boundary with `Map` payloads, not plugin enums** — `AudioConfigurationPolicy` already exposes `.getAndroidConfiguration().toMap()`, so plugin-only enums (`AndroidInterruptionSource`, `AndroidAudioAttributesUsageType/ContentType`) never enter `stream_video`.
  - Device enumeration in `rtc_media_device_notifier.dart` → dart_webrtc `mediaDevices` (web) vs plugin (native) via the engine.

Then **remove `stream_webrtc_flutter` from `stream_video`'s pubspec** (keeps `dart_webrtc` + `webrtc_interface`).

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
| Phase 2 WebRTC type swap | M (~13 files) | Low–med (compile-surfaced) |
| Phase 3 WebRTC engine injection | L | **High** (registration timing, native regressions) |
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

### Phase 1 — Provider registry scaffold
- [ ] Create `packages/stream_video/lib/src/platform/stream_video_platform.dart` with the 6 provider interfaces + pure-Dart defaults
- [ ] Add `StreamVideoFlutter.ensureInitialized()` registration entrypoint in `stream_video_flutter`
- [ ] Wire `ensureInitialized()` into the native `StreamVideo` bootstrap path

### Phase 2 — WebRTC standard-type swap
- [ ] Swap `stream_webrtc_flutter as rtc` → `dart_webrtc as rtc` across the ~13 `src/webrtc/**` files
- [ ] `melos analyze` + `melos test` green (native behavior unchanged, `stream_webrtc_flutter` still in pubspec)

### Phase 3 — WebRTC engine injection (vertical slice)
- [ ] Define `StreamWebRtc` + `StreamWebRtcHelper` + `StreamNativeFactory` interfaces
- [ ] Web/Jaspr default `DartWebRtcEngine` in `stream_video`
- [ ] Native `FlutterWebRtcEngine` in `stream_video_flutter`, registered in `ensureInitialized()`
- [ ] Route `NativePeerConnectionFactory`, `Helper`, `WebRTC.initialize`, device enumeration through the engine (Map payloads, no plugin enums)
- [ ] Make WebRTC default throw on native platforms if unregistered
- [ ] Remove `stream_webrtc_flutter` from `stream_video/pubspec.yaml`
- [ ] `melos analyze` + tests green; Flutter web/desktop smoke

### Phase 4 — Telemetry migration (full decoupling)
- [ ] `EnvironmentInfoProvider` (device/package/system info) — web default + native impl moved
- [ ] `DeviceStateProvider` (battery + thermal) + neutral `StreamThermalStatus` enum
- [ ] Remove `connectivity_plus` from `stream_video`
- [ ] Promote `NetworkMonitor` (add `currentStatus()`); replace `InternetConnection`/`InternetStatus` across `call.dart`, `sfu_ws.dart`, `call_session*.dart`, `coordinator_ws.dart`
- [ ] Web `HttpNetworkMonitor` default + native `PluginNetworkMonitor` moved to `stream_video_flutter`
- [ ] Resolve `NetworkMonitorSettings.internetConnectionInstance` public-API change (deprecate/add field)
- [ ] Reconnection tests + Flutter web/desktop smoke

### Phase 5 — Lifecycle + display metrics + drop Flutter dep
- [ ] `AppLifecycleProvider` — move `lifecycle_utils_io.dart` into `stream_video_flutter`
- [ ] `DisplayMetricsProvider` for `rtc_manager.dart` screen size
- [ ] Remove `flutter: sdk: flutter` + `environment: flutter:` from `stream_video/pubspec.yaml`
- [ ] Add pure-Dart resolution guard (Dart-only `dart pub get` against `stream_video`)

### Phase 6 — `stream_video_jaspr` package
- [ ] Create package + add to root `workspace:` list; `dart pub get`
- [ ] `CallStateBuilder` (StateEmitter → setState bridge)
- [ ] `VideoTrackRenderer` (GlobalNodeKey host + append `RTCVideoElement.htmlElement`)
- [ ] `StreamVideoView` (track selection + placeholder) + minimal dynascale on attach
- [ ] `ParticipantTile` / `ParticipantGrid`
- [ ] `CallControls` (mic / camera / leave)
- [ ] `StreamCallContent` (grid + controls)

### Phase 7 — `dogfooding_jaspr` app
- [ ] Scaffold app + add to root `workspace:` list
- [ ] Token service (`/api/auth/create-token`) + hardcoded-token fallback for CORS
- [ ] Login screen (user id) + connect
- [ ] Call screen (`makeCall` → `getOrCreate` → `join` → `StreamCallContent`)
- [ ] `jaspr serve` runs and joins a call

### Acceptance
- [ ] Cross-client call: Flutter dogfooding ↔ `dogfooding_jaspr` in the same call, both see/hear each other, mic/camera/leave reflected across clients
