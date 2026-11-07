# stream_video_push_notification v2 refactor plan

Target branch: `v2`. Scope: the Dart layer, the iOS CallKit/PushKit native code and the Android native code of `stream_video_push_notification`, plus the pieces of `stream_video` and `stream_webrtc_flutter` the ringing flow leans on. Paths are relative to `packages/stream_video_push_notification/` unless they name another package.

This file is deleted by the last PR of the refactor, and the refactor is finished before the next release of the package.

Tickets this plan serves:

- FLU-1192: move the CallKit hold/resume audio fix to v2 and rebuild the native CallKit side around an explicit model.
- FLU-1174: remove the Firebase dependency from the package (stage 1: no Firebase in Dart; stage 2: native Android message delivery).
- FLU-1194 (related, not in scope, but the design leaves room for it): register outgoing ringing calls with CallKit out of the box.

Everything below was derived from the `v2` tree at `10fe57f67`, the SDK branch `fix/callkit-audio-engine-availability` and the webrtc branch `fix/ios-audio-engine-availability`.

---

## 1. Where the code stands today

### 1.1 Size and shape

| Layer | File | Lines | Problem |
|---|---|---|---|
| Dart | `lib/src/stream_video_push_notification.dart` | 747 | Manager = device registration + native command facade + coordinator-event sync + event broadcaster singleton + config defaults, all in one class whose constructor does I/O. |
| Dart | `lib/src/background_push_handler.dart` | 586 | Fully static handler; `_BackgroundSession` reaches into the handler's private statics; tests use real-time sleeps. |
| iOS | `StreamVideoCallkitManager.swift` | 796 (1,100+ on the fix branch) | Singleton `CXProviderDelegate` with call state spread across `data`, `answerCall`, `outgoingCall`, `isFromPushKit`, plus (on the fix branch) four hold-related sets and a `ResumeState` map. Two copies of `showIncomingCall`. Two pending-event queues (one here, one in `EventCallbackHandler`). |
| iOS | `StreamCallKitCallController.swift` | 258 | Transaction requester + call list + identity aliasing in one class. |
| Android | `IncomingCallNotificationManager.kt` | 782 | Notification builders, channels, PendingIntents, avatar loading, ringtone start and two permission dialogs; per-instance mutable builder state shared across calls. |
| Android | `StreamVideoPushNotificationPlugin.kt` | 474 | Process-wide singleton that is the MethodCallHandler for every engine; business logic (end/dismiss decisions) read straight from SharedPreferences; static event fan-out. |
| Android | `telecom/StreamTelecomManager.kt` | 504 | `object` with seven mutable collections; circular dependency with the broadcast receiver. |
| Android | `IncomingCallBroadcastReceiver.kt` | 296 | The real ringing state machine, but it pulls its collaborators from `StreamVideoPushNotificationPlugin.getInstance()`, which is null in a process no Flutter engine has attached to. |

### 1.2 Tests

- Dart: 8 test files, ~85 tests. `background_push_handler_test.dart` is strong; the manager's constructor subscriptions, `registerDevice`, params building, `dismissRingingCallByCid`, method-channel parsing and `_callDataFromJson` are untested. `RingingEventBroadcaster` is a singleton the tests flush with sleeps.
- iOS: no unit tests. The example app has an empty `RunnerTests` XCTest target already wired into the Xcode project.
- Android: no unit tests. `build.gradle` already configures `src/test/kotlin` and JUnit Platform; no test dependencies are declared.
- CI runs Dart tests only. No `xcodebuild test`, no `gradlew test`.

### 1.3 The things that must keep working (regression matrix)

These are the scenarios every native PR gets checked against on a device. They are listed once here and referenced by number from the PRs.

| # | Scenario | iOS | Android |
|---|---|---|---|
| R1 | Incoming ring, app in foreground; accept from native UI | CallKit | notification / full-screen |
| R2 | Incoming ring, app in background; accept | CallKit | notification |
| R3 | Incoming ring, app terminated (cold start from push); accept | PushKit before any Dart ran; `pendingEvents` flush; `verifyDisplayedIncomingCalls` | background isolate rings; `consumeAndAcceptActiveCall` after launch |
| R4 | Incoming ring on the lock screen; accept and decline | CallKit lock screen | full-screen intent activity |
| R5 | Decline from native UI | reject reaches backend | reject reaches backend |
| R6 | Caller cancels while ringing | native UI dismissed, no spurious decline/ended events | same |
| R7 | Ring times out (callee does nothing) | CallKit ends, `unanswered` in Recents | notification removed, ringtone and FGS stopped, Telecom call gone |
| R8 | Accepted on another device of the same user | this device's UI dismissed silently | same |
| R9 | Two rings back to back in one process; second ring while first call active | provider config refresh, correct ids | distinct notification ids |
| R10 | Mute/unmute from the native UI and from the app | CallKit mute stays in sync, no toggle loop | Telecom mute reaches the app |
| R11 | CallKit "Do Not Disturb" / block list filtered call | `ActionCallIncomingFailed` | n/a |
| R12 | Outgoing call started by the app through `startOutgoingCall` and `setCallConnected` | `CXStartCallAction`, `reportOutgoingCall` | Telecom outgoing |
| R13 | Hold by a cellular call, user ends the phone call on the iPhone (no headset) | audio back in both directions | n/a |
| R14 | Hold by a cellular call, other party ends the phone call | audio back (re-registration path) | n/a |
| R15 | R13 with a Bluetooth HFP headset | audio back (~2 s) | n/a |
| R16 | Speaker selected before hold stays selected after resume | yes | n/a |
| R17 | Audio received during hold is not replayed time-compressed on resume | yes | n/a |
| R18 | Ring arrives before the Flutter EventChannel listener is registered | no event lost | no event lost |
| R19 | Push token changes (VoIP, APNs, FCM) | device re-registered | device re-registered |
| R20 | Push arrives for a call that already ended/was answered (stale push) | no ring (`getCallRingingState`) | no ring |

---

## 2. Target design

### 2.1 Principles that keep the refactor safe

1. **Characterize, then move, then change.** Each stack starts with tests that pin today's behaviour. "Move" PRs split files and introduce types with zero behaviour change. "Change" PRs each change exactly one behaviour, with a test that fails before and passes after, and a reference to the matrix rows they affect.
2. **Freeze the channel contract until a PR explicitly changes it.** Method names, event names and payload keys between Dart, Swift and Kotlin stay as they are. A Dart test asserts that the Swift and Kotlin constants are exactly the Dart `Event` names each platform is expected to emit, plus Android's documented internal intent actions (the existing `incoming_call_failure_reason_test.dart` already parses Swift source this way). Contract changes are their own small PRs.
3. **Pure core, thin shell.** On every platform the state machine, identity mapping, payload parsing and policies are plain classes with no `Flutter`, `CallKit`, `android.*` dependency reachable without a protocol/interface, so they get unit tests. The shell (plugin class, `CXProviderDelegate`, `BroadcastReceiver`) is as thin as possible.
4. **One owner per piece of state.** Call state lives in one store per platform. Identity (app id vs CallKit uuid vs notification id) is mapped in that store, nowhere else.
5. **Hold behaviour stays off by default** (`supportsHolding: false`) until R13–R17 pass on device. Nothing in the refactor PRs turns it on.

### 2.2 iOS target layout

```
Sources/stream_video_push_notification/
  Plugin/
    StreamVideoPushNotificationPlugin.swift   FlutterPlugin registration only; public statics kept
    PushMethodCallRouter.swift                FlutterMethodCall -> typed PushCommand -> coordinator
    RingingEventSink.swift                    the single pending-event queue + EventChannel handler
  Model/
    CallKitCallOptions.swift                  today's CallData (parsing deduped, one parser)
    CallKitProviderOptions.swift              today's StreamVideoPushConfiguration + persistence
    PushChannelConstants.swift                event and method names
  CallKit/
    CallKitCall.swift                         per-call model with an explicit phase enum (2.3)
    CallKitCallStore.swift                    all calls; lookup by CallKit uuid OR app id
    CallKitTransactionRequester.swift         CXCallController wrapper + failed-end recovery
    CallKitProviderController.swift           CXProvider lifecycle, config refresh, report* calls,
                                              Recents suppression
    CallKitCoordinator.swift                  replaces StreamVideoCallkitManager; owns the above
    CallKitCoordinator+ProviderDelegate.swift CXProviderDelegate, translates actions to store events
    SystemCallObserver.swift                  protocol over CXCallObserver (other apps' calls)
  Audio/
    CallKitAudioSessionCoordinator.swift      the only AVAudioSession code; didActivate/didDeactivate
    WebRTCAudioEngineGate.swift               protocol: setAvailable, setCallKitSessionActive,
                                              onEngineStartFailed
    HoldRecoveryPolicy.swift                  when/how to re-register a resumed call (injectable clock)
  PushKit/
    VoIPPushRegistryHandler.swift             today's StreamVideoPKDelegateManager (public API kept)
    VoIPPayloadParser.swift                   payload dict -> CallKitCallOptions, pure
  APNs/                                       (FLU-1174)
    RemoteNotificationTokenHandler.swift      didRegisterForRemoteNotificationsWithDeviceToken
```

Public native API that apps call and that must survive (dogfooding uses it): `StreamVideoPKDelegateManager.shared.registerForPushNotifications()`, `StreamVideoPushNotificationPlugin.showIncomingCall/startOutgoingCall/activeCalls`. `StreamVideoCallkitManager.shared` is `@objc public` today; v2 allows removing it, but it is kept as a deprecated facade for one release of the stack and deleted in the last iOS PR.

### 2.3 The per-call model (replaces `answerCall` / `outgoingCall` / `data` / `isFromPushKit` and the hold sets)

```swift
struct CallKitCallIdentity {
    let appId: String            // the id Dart knows; never changes
    var callKitUUID: UUID        // the uuid CallKit currently knows; changes on re-registration
    var previousCallKitUUIDs: [UUID]
}

enum CallKitCallPhase {
    case ringing                     // reportNewIncomingCall succeeded, not answered
    case starting                    // CXStartCallAction pending (outgoing)
    case answering                   // CXAnswerCallAction fulfilled, no audio session yet
    case active                      // audio session activated at least once
    case held(HoldOrigin)            // .app (holdCall) or .otherCall (cellular call)
    case resumedAwaitingSession      // unheld, CallKit has not handed a usable session back
    case reRegistering(as: UUID, attempt: Int)
    case ended(CXCallEndedReason?)
}

final class CallKitCall {
    let identity: CallKitCallIdentity
    let direction: Direction          // .incoming / .outgoing
    let source: Source                // .pushKit / .app   (replaces isFromPushKit)
    let options: CallKitCallOptions
    var phase: CallKitCallPhase
    var isMuted: Bool
    var hasActivatedAudioSession: Bool   // explicit "first activation" flag
    var connectedAt: Date?
}
```

`CallKitCallStore` is the single owner of identity: `call(forCallKit:)`, `call(forAppId:)`, `rebind(call, to newUUID)`. Everything that today reads `reportedId(for:)`, `originalUUID`, `reportedId`, or the alias lookup in `callWithUUID` goes through it. All transitions are methods on the store that return the events to emit, so a test can drive `[.incomingReported, .answerPerformed, .audioActivated, .heldByOtherCall, .otherCallEnded, .audioDeactivated, ...]` and assert the phase and the emitted events without CallKit.

### 2.4 Audio session ownership and the WebRTC link

`CallKitAudioSessionCoordinator` is the only place that touches `AVAudioSession` during CallKit calls. It:

- applies the configured category/mode/sample-rate only on a call's first activation (`hasActivatedAudioSession == false`), never on a resume;
- never calls `setActive`; CallKit activates (this is the fix-branch behaviour, kept, but landed in its own PR so R1–R4 can be re-verified in isolation);
- drives WebRTC through `WebRTCAudioEngineGate`:
  - `didActivate` → `setCallKitSessionActive(true)` then `setAvailable(true)`
  - `didDeactivate` while calls remain → `setAvailable(false)` then `setCallKitSessionActive(false)`; with no calls left → `setAvailable(true)` (gate lifted, no activation to wait for)
  - `onEngineStartFailed` → forwarded to the store as an event (feeds `HoldRecoveryPolicy`).

Transport: the push plugin links `stream_webrtc_flutter` natively (podspec `s.dependency 'stream_webrtc_flutter'`, SPM `.package(path: "../stream_webrtc_flutter")`), exactly as `stream_video_flutter` and `stream_video_noise_cancellation` already do. On `v2` the webrtc plugin is vendored in the monorepo (`webrtc/stream_webrtc_flutter`), so the two sides land together. The webrtc plugin exposes an ObjC-visible `FlutterWebRTCAudioEngineControl` with the three calls; the gate's default implementation resolves `FlutterWebRTCPlugin.sharedSingleton` lazily and falls back to the existing `NotificationCenter` names when it is nil, so a cold-start ordering problem can never silently drop the gate. The NotificationCenter transport from the fix branch is therefore kept as a fallback, not as the design.

On the webrtc side the fix branch's `FlutterWebRTCPlugin.m` changes stay as they are (gate, manual-rendering drain, `setCallKitAudioSessionActive`, route-change `reason`), but "engine start failed" becomes a callback on the control object instead of a notification.

### 2.5 Hold/resume: what changes versus the fix branch

| Fix branch | This plan |
|---|---|
| `callsHeldForOtherCall`, `appRequestedHolds`, `resumes`, `reRegistrations` sets/maps | `phase == .held(.app)` / `.held(.otherCall)` / `.resumedAwaitingSession` / `.reRegistering` on the call |
| "first activation" inferred from `hasConnected \|\| hasStartedConnecting` | `hasActivatedAudioSession` set in `didActivate` |
| `originalUUID` / `reportedId` on `Call` + alias in `callWithUUID` | `CallKitCallIdentity` in the store; `rebind` on re-registration |
| retry at 0.5/1/2 s on `maximumCallGroupsReached` | `HoldRecoveryPolicy.nextAttempt(after:)` with an injectable clock; first retry is triggered by `SystemCallObserver` reporting zero other-app calls, the timed backoff is the fallback |
| Recents toggled at both start and end of the re-registration "in case" | `CallKitProviderController.withRecentsSuppressed { }` around whichever point the device experiment (3.3) shows CallKit reads the flag; the other toggle is removed |
| re-registration triggers scattered over `didDeactivate`, `didBecomeActive`, `engineStartFailed` | all three are store events; `HoldRecoveryPolicy` decides, in one place, whether a call in `.resumedAwaitingSession` is re-registered now, deferred until foreground, or given up |
| hold handler that re-requested the hold it was performing (event flood) | the delegate handler only mutates the store; requests to CallKit come from the coordinator, never from inside a `perform` callback |

The two experiments the ticket lists (defer gate-on until the app is active; app-side `setActive(true)` after unhold with the new session bookkeeping) are run before the hold PR is written. If either removes the need for re-registration, `HoldRecoveryPolicy` shrinks to that rule and the re-registration code is not ported. The plan assumes the worst case (re-registration needed) for sizing.

### 2.6 Android target layout

```
kotlin/io/getstream/video/flutter/stream_video_push_notification/
  channel/
    StreamVideoPushNotificationPlugin.kt   FlutterPlugin + ActivityAware only
    PushMethodCallHandler.kt               per-engine; parses args, calls RingingController
    RingingEventDispatcher.kt              process-level; fans events out to every engine's sink
  core/
    RingingComponents.kt                   lazily built from applicationContext, engine-independent
    RingingCallRegistry.kt                 single typed call store (CallStore interface; prefs impl)
    RingingController.kt                   the state machine that lives in the receiver today
    RingingCall.kt / CallPayloadMapper.kt  one model, one map<->bundle<->event conversion
  notification/
    IncomingCallNotificationBuilder.kt     stateless, per call (CallStyle on 34+, RemoteViews below)
    MissedCallNotificationBuilder.kt
    NotificationChannels.kt
    AvatarLoader.kt                        the one URL/asset/header resolution
    RingtonePlayer.kt                      today's IncomingCallSoundPlayerManager
    IncomingCallForegroundService.kt
  ui/
    IncomingCallActivity.kt, TransparentActivity.kt, RippleRelativeLayout.kt
  permissions/
    NotificationPermissionFlow.kt, FullScreenIntentPermission.kt
  telecom/
    TelecomIntegration.kt                  class, takes TelecomCallRepository interface
    TelecomCallRepository.kt               takes a CallsManager factory
    (TelecomCall, TelecomCallAction, TelecomCallListener, TelecomConfig, AudioEndpointUtils unchanged)
  messaging/                               (FLU-1174)
    FirebaseTokenProvider.kt               stage 1
    StreamFirebaseMessagingService.kt      stage 2
    StreamPushMessageHandler.kt            stage 2, delegate helper for apps with their own service
```

The key structural fix is `RingingComponents`: the receiver, the service and the activities get the registry, notification controller and ringtone player from it, built from the application context, so they work in a process no Flutter engine has attached to (today's decline-after-process-death bug).

### 2.7 Dart target layout

```
lib/src/
  manager/
    stream_video_push_notification_manager.dart   composition root, implements PushNotificationManager
    push_device_registrar.dart                    tokens, prefs cache, createDevice/deleteDevice
    push_token_source.dart                        abstract VoIP/APNs/FCM token + refresh stream
    native_call_controller.dart                   params building (once), activeCalls parsing (once),
                                                  show/end/dismiss/mute/hold pass-throughs
    ringing_sync_observer.dart                    coordinator events + StreamVideo state -> native end/dismiss
    ringing_event_broadcaster.dart                instance, injectable, suppression per type+cid
  background_push_handler.dart                    StreamVideoPushHandler: the static entry point apps
                                                  call, over one router per isolate (A-5 makes it take
                                                  a Map<String, dynamic>)
  background/
    background_push_router.dart                   routing: app isolate vs own session vs existing client
    background_session.dart                       instance (today's _BackgroundSession)
    ring_ledger.dart                              pendingRings / endedRings bookkeeping, pure
  config/  (existing configuration + params files, unchanged until A-6)
```

`StreamVideoPushNotificationManager.create(...)` keeps its signature. The `PNManagerProvider` typedef keeps taking `CoordinatorClient` for now; dropping it (so core can stop exporting `coordinator_client.dart`) is listed as optional work because it changes a core public type.

---

## 3. The PR stacks

Four stacks. Stacks A (Dart), B (iOS) and C (Android) are independent of each other after stack 0 and can be reviewed in parallel. Stack D (Firebase) has one PR per platform in the middle of B and C and finishes in A. Estimated review size is the net diff excluding pure file moves and generated code.

Suggested cadence: one "move" PR and one "change" PR per platform in flight at a time; never two PRs touching the same file open at once.

### Stack 0: foundations

**0-1. Channel contract pinned**
`test/push_channel_contract_test.dart` asserts Dart `Event` names against `StreamVideoIncomingCallConstants.swift` and `IncomingCallConstants.kt`, and lists every method name each platform handles. Fix the unhandled `StateError` an unknown event name raises in `_receiveRingingEvent` (`Event.values.firstWhere` without `orElse` → log and drop). ~150 lines. Dart only. No behaviour change beyond not crashing.

**0-2. Android unit-test harness**
Add JUnit 5, MockK, Robolectric to `android/build.gradle` test scope; a melos script `test:android:push` running `gradlew :stream_video_push_notification:testDebugUnitTest` from the example app; a CI step. First characterization tests: `Data` constructor vs `fromBundle` defaults (documents the known inconsistencies as `@Ignore`d expectations or as "current behaviour" assertions), `TelecomConfig`, `AudioEndpointUtils`, `Data` Jackson round trip. ~300 lines, all tests and build files.

**0-3. iOS unit-test harness**
Use the example app's existing `RunnerTests` target with `@testable import stream_video_push_notification`; a CI job (`xcodebuild test`, iOS simulator, macOS runner, path-filtered to the package). First characterization tests: `CallData(args:)` with and without the `ios` sub-map, `StreamVideoPushConfiguration` persist/load drops `headers`, `incomingCallErrorCode`, `getHandleType`, `getAudioSessionMode`, `VoIP payload → CallData` (extracted first as a pure function in this PR, since today it sits inline in `handleIncomingCall`). ~350 lines.

### Stack A: Dart

**A-1. Broadcaster and parsing extracted (move)**
`RingingEventBroadcaster` becomes an injectable instance owned by the manager (singleton kept as a thin default for one release). One `CallData.fromJson` (delete the manager's copy, which lacks `endedBySystem`). One `StreamVideoPushParams.from(configuration, ...)` builder replacing the three copies in `showIncomingCall`/`showMissedCall`/`startOutgoingCall`. Tests for the broadcaster no longer sleep. ~-150/+250 lines.

**A-2. `PushDeviceRegistrar` extracted (move + one fix)**
Token caching, `createDevice`/`deleteDevice`, APN token handling move out of the manager behind `PushTokenSource` (still backed by Firebase and the VoIP method channel in this PR). The `late SharedPreferences` race is fixed by awaiting the prefs inside the registrar (the only behaviour change; today `unregisterDevice` can throw `LateInitializationError` off-mobile and `registerDevice` right after `create` can hit it on mobile). `unregister_device_test.dart` moves to the registrar and loses the `ClientState` implementation import. ~-200/+300 lines.

**A-3. `NativeCallController` and `RingingSyncObserver` extracted (move)**
The manager keeps only composition and the `PushNotificationManager` interface. `RingingSyncObserver` takes `StreamVideo`, the coordinator event stream and the controller; it is tested with fake streams and a fake clock for the suppression window. `ActionCallToggleMute` handling starts using the event's uuid to find the call (via `activeCalls`) instead of "first ringing-flow call"; documented as a change. ~-250/+350 lines.

**A-4. Background handler split (move)**
`RingLedger` (pure) and `BackgroundSession` (instance) extracted; `StreamVideoPushHandler` keeps its static entry point and delegates to one `BackgroundPushRouter` instance held in a static. Existing tests are ported to fake time (`FakeAsync`), removing `grace*6`/`grace*20` sleeps. ~-200/+300 lines plus test churn.

**A-5. Firebase stage 1, Dart part (change; depends on D-1, D-2)**
`handleBackgroundMessage` takes `Map<String, dynamic>`; `PushTokenSource` implementations call the new native methods (`getPushToken`, `onPushTokenRefresh` events); `firebase_core` and `firebase_messaging` leave the pubspec, with `stream_video_flutter`, `stream_webrtc_flutter` and `uuid` (unused). Tests off the Firebase fakes. Changelog (Breaking), README. ~-250/+150 lines.

**A-6. Ring-end policy consolidated (change)**
The manager's `subscribeToEvents` currently re-implements what core does in `RingingFlowCoordinatorImpl._onRingingCancelled`, `CallRingingController._leaveAnsweredElsewhere` and `CallConnectionCoordinator._releaseUnjoined`, with a global 500 ms suppression. This PR makes core the single owner: the sync observer keeps only the parts core cannot do (dismissing the native UI when a call is accepted on this device from the app, the participant-count-zero case if `dropIfAloneInRingingFlow` does not cover it), and suppression becomes per `(type, cid)` instead of global. Needs the Android C-8 "explicit end reasons" to land first, otherwise Android still reports a remote cancel as a DECLINE. R5, R6, R8, R9 re-verified on both platforms. ~-200/+150 lines, tests in core and push.

Optional, after A-6: `PNManagerProvider` takes `StreamVideo` only; delete the v1 deprecated forwarders in `StreamVideo` and the `fix_data.yaml` entries, delete `CallEvent`/`BackgroundVoipCallHandler`. Each a tiny PR.

### Stack B: iOS

**B-1. File split and dedupe (move)**
Split `StreamVideoCallkitManager.swift` by extension into `+MethodCalls`, `+ProviderDelegate`, `+AudioSession`, `+Events` files with no code change; merge the two `showIncomingCall` overloads into one with an optional completion; one pending-event queue (`RingingEventSink`), delete the manager's `pendingEvents`; one `ios`-sub-map-or-top-level parser shared by `CallData` and `StreamVideoPushConfiguration`; `PushMethodCallRouter` parses arguments into a `PushCommand` enum and the manager handles typed commands. Characterization tests from 0-3 keep passing. ~-300/+350 lines across 8 files.

**B-2. `CallKitCallStore` and identity (move)**
`CallKitCall` with `identity`, `direction`, `source` and a `phase` enum covering today's states only (`ringing`, `starting`, `answering`, `active`, `ended`); `CallKitCallStore` replaces `calls`, `pendingOutgoingCalls`, `reportedId(for:)` and the aliasing. `StreamCallKitCallController` shrinks to `CallKitTransactionRequester`. The manager's `data`, `answerCall`, `outgoingCall`, `isFromPushKit` are replaced by store queries (`store.call(forAppId:)`, `store.pushKitCall`). Every delegate method becomes "look up, apply transition, emit returned events". Store transition tests cover R1, R3, R5, R7, R9, R12 as event sequences. ~-400/+550 lines. This is the largest PR of the stack and the one to review slowest; it changes no wire behaviour.

**B-3. `CallKitAudioSessionCoordinator` (move + the explicit first-activation flag)**
All `AVAudioSession` code and `didActivate`/`didDeactivate` move to the coordinator; `hasActivatedAudioSession` replaces the `hasConnected || hasStartedConnecting` inference; `WebRTCAudioEngineGate` protocol introduced with the NotificationCenter implementation (no-op observer on the webrtc side until W-1). ~-120/+200 lines.

**B-4. CallKit activates the session, not the plugin (change)**
`configureAudioSession` stops calling `setActive`. One-line behaviour change kept alone so R1–R4 and R12 can be re-verified and the PR reverted on its own if a plain-ringing regression shows up (the ticket flags this as unverified). ~10 lines.

**W-1. webrtc: audio engine gate and CallKit session forwarding (change, `webrtc/stream_webrtc_flutter`)**
Port of `fix/ios-audio-engine-availability` (iOS and macOS copies; `darwin_parity_test` keeps them identical) with "engine start failed" exposed as a callback on `FlutterWebRTCAudioEngineControl` next to the notification; route-change `reason` added to `onAudioRouteChange`. Changelog entries under the unreleased 5.0.0 that v2 already carries. ~+600 lines (×2 for macOS, parity-checked).

**B-5. Native link to the webrtc plugin (change; depends on W-1)**
Podspec and SPM dependency on `stream_webrtc_flutter`; `WebRTCAudioEngineGate` default implementation calls the control object directly and falls back to notifications when `sharedSingleton` is nil. `didActivate`/`didDeactivate` gate the engine (today's R1–R4 behaviour unchanged, since the gate is lifted whenever no call remains). Dogfooding Pods+SPM CI job covers the link. ~+120 lines.

**B-6. Hold and resume (change; after the spike in 3.3)**
`.held(origin)`, `.resumedAwaitingSession`, `.reRegistering` phases; `SystemCallObserver` protocol over `CXCallObserver`; `HoldRecoveryPolicy` with injected clock and retry policy; `CallKitProviderController.withRecentsSuppressed`; the hold delegate handler no longer re-requests holds. Tests drive R13–R15 as store event sequences (`heldByOtherCall → otherCallEnded → unheldPerformed → audioDeactivated → recovery → startPerformed(newUUID) → audioActivated`). `supportsHolding` default stays `false`. ~+450 lines, of which ~200 are tests.

**B-7. Dart side of hold (change, `stream_video`)**
`AudioRouteChangedEvent.reason` and `AudioRouteChangeReason`, and the "re-apply the user's output on a system reconfiguration" rule. Per the ticket, v2's device/output model should own that decision: place the rule in the v2 output-device controller rather than in `Call`'s route-change handler. R16. ~+80 lines.

**B-8. Public facade cleanup (change)**
Delete `StreamVideoCallkitManager.shared`, rename `StreamVideoPKDelegateManager` to `VoIPPushRegistryHandler` with a deprecated typealias, remove `sendEventCustom`, `showMissCallNotification` no-op case, `requestNotificationPermission` no-op case from the iOS router. Changelog (Breaking). ~-100 lines.

Optional B-9 (FLU-1194, not in this plan's scope): with `direction == .outgoing` and `.starting` already modelled, registering outgoing ringing calls out of the box is a `RingingSyncObserver` change plus `setCallConnected` on `CallStatusConnected`, behind an option.

### Stack C: Android

**C-1. Dead code and dependency cleanup (change, mechanical)**
Remove: duplicated public API on the plugin (`showIncomingNotification`, `showMissCallNotification`, `startCall`, `endCall`, `endAllCalls`, `sendEventCustom` static+instance), `showIncomingCallSilently`, `getIntentHeldByCell`/`UnHeldByCell`, `getTimeOutPendingIntent`, `getHangupPendingIntent`, `Utils.backToForeground/pxToDp/getScreenHeight`, `TelecomCall.None/Unregistered`, unused constants, `Data.isOnHold/audioRoute/isMuted`, the `localbroadcastmanager` dependency. Declare the real dependency on `stream_video_flutter`'s `CircleTransform` or copy the 20-line class in. `isMuted` returns the stored value instead of `true`. ~-350 lines.

**C-2. One model, one mapper, one store (move)**
`RingingCall` replaces `Data`; `CallPayloadMapper` is the only map↔Bundle↔event-map conversion (today in `Call.kt`, `sendEventFlutter` and two Dart copies); constructor and `fromBundle` defaults unified (document the two that differ, `showCallbackButton`, `isImportant`, and pick the value `sendEventFlutter` sends today so Dart sees no change). `SharedPreferencesUtils` becomes `CallStore` (interface) + `PrefsCallStore` with one synchronized read-modify-write and `apply()`; Jackson stays for now. Tests: mapper round trips, store concurrency. ~-250/+300 lines.

**C-3. Engine-independent `RingingComponents` and `RingingController` (move + one fix)**
The receiver's state machine moves to `RingingController`; receiver, service, `IncomingCallActivity` and `TransparentActivity` obtain the controller from `RingingComponents.get(context)`. Fix: a decline or accept in a process with no engine now clears the notification, ringtone, store and Telecom state (R5 after process death). `IncomingCallActivity`'s double accept path collapses to one. ~-200/+350 lines.

**C-4. Notification layer split (move)**
`IncomingCallNotificationManager` → `IncomingCallNotificationBuilder` (stateless, per call), `MissedCallNotificationBuilder`, `NotificationChannels`, `AvatarLoader` (the six copies of URL/asset/header resolution become one), `NotificationPermissionFlow`, `FullScreenIntentPermission`. `ImageLoaderProvider` stops capturing the first call's headers in a global interceptor (headers are already per request). `RingtonePlayer` unregisters its screen-off receiver before registering. R1, R2, R4, R9 (two notifications at once keep their own avatar and id). ~-600/+650 lines; large but mechanical, review file by file.

**C-5. Plugin split (move)**
`StreamVideoPushNotificationPlugin` keeps `FlutterPlugin`/`ActivityAware`; `PushMethodCallHandler` is created per engine with its own context/activity; `RingingEventDispatcher` fans out to every engine. `addRequestPermissionsResultListener` is removed on detach; `onRequestPermissionsResult` returns `true` only for its own request code. ~-250/+300 lines.

**C-6. `TelecomIntegration` as a class (move)**
`StreamTelecomManager` object → `TelecomIntegration(repository, controller)`; `TelecomCallRepository` takes a `CallsManager` factory; the circular dependency with the receiver becomes a listener interface. Tests for the pending-action queue (disconnect wins over register), hold-echo suppression and `onHoldChangeFailed` rollback. ~-150/+300 lines.

**C-7. Hold on Android is either wired or removed (change)**
Today `holdCall` echoes a hold event and asks Telecom; `ActionCallToggleHold` has no Dart consumer; the plugin's own echo and Telecom's suppression contradict each other. Decision for v2: keep the Telecom-driven `ActionCallToggleHold` (a watch or car can put the call on hold) and remove the plugin-side echo; Dart's `RingingSyncObserver` maps it to `call.setAudioOutputEnabled`/mic muting as the existing iOS mute mapping does. Small. ~-30/+60 lines.

**C-8. Explicit end reasons and a native timeout (change)**
`dismissRingingCall(reason: remoteCancelled | answeredElsewhere | missed)` intent and event replace the `EXTRA_KEEP_SYSTEM_CALL`/`endedBySystem` overloads; a native ring timeout (`Handler` in the FGS / `AlarmManager` fallback) fires `ACTION_CALL_TIMEOUT`, clears everything and disconnects Telecom with `MISSED`; `showMissCallNotification` ends the ring fully. This is what lets Dart drop `_dropEndedRings` and the global suppression in A-6. Contract change: the new event name is added to 0-1's contract test and to Dart in the same PR. R6, R7, R8. ~+250/-100 lines.

### Stack D: Firebase (FLU-1174)

**D-1. iOS APNs token natively (change; lands after B-1)**
`RemoteNotificationTokenHandler` registers through `registrar.addApplicationDelegate`, calls `registerForRemoteNotifications()` only when `initData` carries `registerApnDeviceToken: true`, stores the token in `UserDefaults` next to the VoIP one, answers `getPushToken(kind: apns)` and emits `DID_UPDATE_PUSH_TOKEN(kind: apns)`. Device check next to `firebase_messaging`'s swizzling (ticket item). ~+120 lines.

**D-2. Android FCM token natively (change; lands after C-5)**
`FirebaseTokenProvider` reads `FirebaseMessaging.getInstance().token`, guarded by `FirebaseApp.getApps(context).isNotEmpty()` (logs and returns null otherwise); `com.google.firebase:firebase-messaging` in the plugin's `build.gradle` (BoM-aligned with FlutterFire's current pin); answers `getPushToken(kind: fcm)`; re-read on each `registerDevice`. ~+90 lines.

**A-5** then removes Firebase from Dart (listed in stack A).

**D-3. Stage 2 design doc and spike (no code merge)**
Decide the two open points before coding: (a) killed-app ring handling — native-first ring from Kotlin (`RingingController.showIncoming` straight from the FCM data, as the RN SDK's `CallService` does), then start the Dart background isolate from a registered callback handle for backend-side effects (reject, cancel, timeout) so time-to-ring does not depend on Dart start-up; (b) coexistence — `StreamFirebaseMessagingService` is `open`, `StreamPushMessageHandler.onMessageReceived(context, data): Boolean` for apps with their own service, and a documented `tools:node="remove"` recipe for `firebase_messaging`'s service when the app wants ours as the single handler. Output: a short design section appended to this plan plus the PR list for D-4…D-6.

**D-4. `StreamFirebaseMessagingService` + native ring (change)**
Service in the plugin manifest; `onMessageReceived` → `StreamPushMessageHandler` → `RingingController.showIncoming` for a Stream ringing payload, else no-op; `onNewToken` → store + event. Requires C-3 (the engine-independent controller). ~+250 lines.

**D-5. Headless Dart isolate for backend effects (change)**
Callback-handle registration from Dart (`StreamVideoPushHandler.registerBackgroundHandler`), isolate start from the service when the app process has no engine, reusing A-4's `BackgroundPushRouter`. ~+300 lines across Kotlin and Dart.

**D-6. Docs, dogfooding, size measurement**
Dogfooding drops `firebase_messaging` for ringing; README and migration guide; FLU-899 size app confirms the iOS size drop.

---

## 4. Order, parallelism and dependencies

```
0-1 ─┬─ A-1 ─ A-2 ─ A-3 ─ A-4 ─────────────── A-5 ─────────────── A-6
     │                                         ▲                   ▲
0-3 ─┼─ B-1 ─ B-2 ─ B-3 ─ B-4 ─ B-5 ─ B-6 ─ B-7 ─ B-8              │
     │              │     ▲       ▲  │                             │
     │              └ D-1 ┘      W-1 └ spike (3.3)                 │
0-2 ─┴─ C-1 ─ C-2 ─ C-3 ─ C-4 ─ C-5 ─ C-6 ─ C-7 ─ C-8 ────────────┘
                                   │
                                   └ D-2 ─── (D-3 → D-4 → D-5 → D-6 after A-5 and C-8)
```

- Stacks A, B, C run in parallel after their harness PR. Within a stack, PRs are stacked on each other and merged bottom-up.
- A-5 (Dart Firebase removal) waits for D-1 and D-2. A-6 waits for C-8.
- B-6 waits for the hold spike (3.3) and for W-1/B-5.
- D-4…D-6 are a second phase; they start after the refactor stacks are merged so the messaging service builds on the engine-independent controller and the split handler.

Rough totals: 27 PRs, median net diff ~250 lines, the two largest (B-2, C-4) ~550 and ~650 lines. Each PR has a "Resolves/Part of FLU-…" line.

### 4.1 Per-PR checklist (goes into each PR description)

- Which matrix rows (R1–R20) the PR can affect, and the device(s) they were run on.
- "Move" or "change", and for a change: the one behaviour that changed and the test that pins it.
- Contract: unchanged / changed (and 0-1's test updated).
- For native PRs: `melos run test:android:push` / `xcodebuild test` output; for B-5 and later: dogfooding Pods+SPM job green.

### 4.2 The hold spike (before B-6)

Run on the iPhone 17 Pro setup from the ticket, with B-5 merged (gate and session forwarding in place, no re-registration):

1. Defer `setAvailable(true)` until `UIApplication.shared.applicationState == .active` when `didActivate` arrives in the background. Pass criterion: R13 and R15 get audio without re-registration.
2. After an unhold with no `didActivate`, call `AVAudioSession.setActive(true)` from the coordinator with the WebRTC session bookkeeping now forwarded. Pass criterion: R14 gets audio.
3. Check whether CallKit reads `includesCallsInRecents` at call start or at call end (register, end, inspect Recents) so B-6 toggles it at one point only.

Outcomes feed B-6's `HoldRecoveryPolicy`: each experiment that passes removes a trigger from the policy; if both pass, re-registration is not ported.

---

## 5. Risks and how the plan contains them

| Risk | Containment |
|---|---|
| A "move" PR silently changes behaviour on a cold-start path nobody runs locally | 0-2/0-3 characterization tests before any move; R3 and R18 are mandatory device checks on every iOS and Android move PR. |
| B-2 (store) is big | It is the only PR of its size on iOS; its tests are event-sequence tests a reviewer can read as a spec; it changes no method/event payloads. |
| `configureAudioSession` without `setActive` regresses plain ringing | Alone in B-4, 10 lines, revertable without touching anything else. |
| webrtc and push plugin ship out of step | Both live in the monorepo on `v2`; every package on v2 already requires `^5.0.0`, the version W-1's changes ship in; the dogfooding Pods+SPM job builds the native link. |
| Hold still needs re-registration after the spike | The design (2.5) already models it; `HoldRecoveryPolicy` is the only place timing lives, with a fake clock in tests. `supportsHolding` stays off by default. |
| Dart consolidation (A-6) drops a ring-end path that only one platform relied on | A-6 is last, after C-8 gives Android explicit reasons; R5–R9 are re-run on both platforms; core's existing ringing tests (`ringing_flow_coordinator_test`, `ringing_cancelled_by_caller_test`, `call_accepted_on_this_device_test`) must stay green. |
| Firebase stage 1 breaks apps that pass `RemoteMessage` | Breaking change documented; migration is `message.data`; one-line fix. |
| Stage 2 collides with apps' own FCM service | D-3 decides the coexistence API before code; the delegate helper and the `tools:node="remove"` recipe are documented together. |
