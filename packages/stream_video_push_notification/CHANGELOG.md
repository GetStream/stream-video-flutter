## Upcoming (major)

### ⚠️ Breaking

- `StreamVideoPushNotificationPlatform.activeCalls()` returns `Future<List<CallData>>`.
- `StreamVideoPushNotificationManager.removedStoredTokens` is removed.
- `StreamVideoPushNotificationManager.currentActiveCalls` is removed; read `StreamVideo.state.activeCalls`.
- `isAcceptedOnThisDevice` is no longer exported.
- [iOS] The public `Call` class is removed. Nothing public returned it, but native code that named the type no longer compiles.
- [iOS] `StreamVideoCallkitManager` and `EventCallbackHandler` are no longer public. `StreamVideoPushNotificationPlugin.showIncomingCall`, `startOutgoingCall` and `activeCalls` remain the way to reach CallKit from native code. For the manager's other public members, use instead:
  - `showIncomingCall(_:fromPushKit:completion:)`: `StreamVideoPushNotificationPlugin.showIncomingCall(data:fromPushKit:completion:)`.
  - `startCall` and `activeCalls`: the plugin's `startOutgoingCall` and `activeCalls`.
  - `getAcceptedCall()`: the plugin's `activeCalls()`, where the accepted call has `accepted: true`.
  - `endCall`, `endAllCalls`, `connectedCall`, `muteCall`, `holdCall` and `saveEndCall`: from Dart, `StreamVideoPushNotificationManager`'s `endCall` or `endCallByCid`, `endAllCalls`, `setCallConnected`, `muteCall` or `setCallMutedByCid`, `holdCall` and `reportCallEnded`. Natively, a `CXEndCallAction`, `CXSetMutedCallAction` or `CXSetHeldCallAction` through your own `CXCallController` reaches the plugin's provider as well.
  - `sendEventCustom`: none; use your app's own platform channel.
  - `initCallkitProvider`: none needed; the plugin sets up its provider when it registers.

### ⚠️ Deprecated

- [iOS] `StreamVideoPKDelegateManager` is renamed `VoIPPushRegistryHandler`. The old name still works as a deprecated alias with the same members, so an `AppDelegate` that calls `StreamVideoPKDelegateManager.shared.registerForPushNotifications()` compiles and rings unchanged, with a deprecation warning.
- `IOSPushConfiguration.audioSessionActive` and `IOSParams.audioSessionActive`, and on iOS `CallData.audioSessionActive` and `StreamVideoPushConfiguration.audioSessionActive`, have no effect: CallKit activates the audio session. `dart fix --apply` removes the Dart arguments.
- `supportsGrouping`, `supportsUngrouping` and `maximumCallsPerCallGroup` on `IOSPushConfiguration` and `IOSParams`, and on iOS on `CallData` and `StreamVideoPushConfiguration`, have no effect: CallKit is never offered a merge of calls. `dart fix --apply` removes them.

### 🐞 Fixed

- [iOS] The plugin no longer activates the audio session itself when it shows, answers or starts a call. The session it activated kept CallKit from activating its own, so WebRTC could run on a session CallKit did not own. CallKit now activates it.
- [iOS] A call put on hold by another app's call, such as a cellular call answered with Hold & Accept, gets its audio back when that call ends. CallKit takes it off hold even when the other side hung up, and if CallKit then gives the call no working audio session, the plugin ends and starts the call again with CallKit under a new uuid. Dart keeps the call's id and is not told, and the restart adds no entry to Recents. A call CallKit refuses to start again after four attempts is ended with `ActionCallEnded`.
- [iOS] A call ended from the CallKit screen while the app is in the background or behind the lock screen reaches the backend straight away. The plugin keeps the app running for up to 10 seconds after CallKit ends a call, so Dart can leave the call or cancel its ring before iOS suspends the app. Until now the other side kept ringing until the app was opened again.
- [iOS] While a VoIP push rings, `endCall` and `setCallConnected` for another call the plugin tracks, such as an outgoing call, act on that call. They used to act on the ringing call: connecting the outgoing call answered the ring, and ending it declined the ring and left the outgoing call on screen.
- [iOS] An outgoing call started with `startOutgoingCall` no longer affects the calls after it once it ended. An incoming ring shown later times out again, declining it sends `ActionCallDecline` instead of `ActionCallEnded`, and the next audio session activation no longer reports the ended call to CallKit as connecting.
- [iOS] CallKit no longer offers to merge calls, and a merge it asks for is refused. A merge used to be accepted although the calls stayed apart, so CallKit showed a conference that did not exist.
- [iOS] A call reported with only some CallKit options, from a VoIP push before Dart first sent its configuration or from native code, no longer offers Hold & Accept or a keypad. A missing option takes the same default as in `IOSPushConfiguration`: no holding, no DTMF, one call group.

### 🔄 Changed

- `StreamVideoPushHandler.handleBackgroundMessage` builds a client that sets up no media.
- `IOSPushConfiguration.supportsDTMF` is off by default. The SDK sends no DTMF tones, so CallKit's keypad did nothing. An app that sends the digits itself from `ActionCallToggleDtmf` turns it on.
- [iOS] `ActionCallToggleGroup` is no longer sent.
- [iOS] `ActionCallAccept` and `ActionCallDecline` carry the call CallKit answered or ended, instead of the options last given to the plugin, which could belong to another call or be empty.
- [iOS] Only the first activation of a call's audio session applies its audio session options and reports an outgoing call as connecting. A later activation, such as a resume from hold, leaves the session as it is. Every activation now sends `ActionCallToggleAudioSession`, including after the call connected.
- [iOS] The plugin tells `stream_webrtc_flutter` when CallKit activates or deactivates the audio session, and when no call is left, so WebRTC's audio engine runs only while the app owns the session. It calls `FlutterWebRTCPlugin.audioEngineControl`, which reaches every registration of the WebRTC plugin, one per Flutter engine. The plugin now links `stream_webrtc_flutter` natively and needs `stream_webrtc_flutter` 5.0.0.
- [Android] The full-screen incoming call activity follows the redesigned ringing screen: the app surface instead of the blue `#0955fa`, a 104dp avatar, 64dp accept and decline buttons centred 80dp apart above the bottom, and the design system's `#00A46E` and `#D90D10` in place of the Material green and red. An app that sets `IncomingCallNotificationParams` keeps whatever it set.
- [Android] `IncomingCallNotificationParams.fullScreenTextColor` no longer defaults to white. Left unset, the caller's name, the handle under it and the action labels each take the colour the design gives them rather than all four being painted the same. Setting it still paints all four.
- [Android] `IncomingCallNotificationParams.fullScreenBackgroundColor` no longer defaults to `#0955fa` on the Dart side. The default is the plugin's own resource, so it can be overridden by an app's `colors.xml` as well as through the params.
- [Android] A malformed colour in `IncomingCallNotificationParams` is logged rather than silently ignored. It still falls back to the default.

  The heads-up notification is unchanged. From API 34 it is drawn by the platform's `NotificationCompat.CallStyle`, whose buttons and labels are the system's — `textAccept` and `textDecline` do not reach it. iOS ringing is CallKit, which is system UI throughout and has nothing to restyle.

### ✅ Added

- [iOS] `StreamVideoPushNotificationPlugin.showIncomingCall(data:fromPushKit:completion:)` runs `completion` once CallKit accepted or refused the call, for an app with its own PushKit delegate that calls PushKit's completion from it.
- Added `StreamVideoPushHandler.handleBackgroundMessage`, which simplifies the ringing setup by running a Stream ringing push through its whole background lifecycle from your Firebase background handler: it builds the client through the factory you give it, observes the ringing events a background isolate can act on, and disposes the client — along with whatever that factory set up — once the user has answered, declined, or let the call time out, or the ring has ended without them, such as when the caller cancels it. It replaces the setup and teardown each integration had to write by hand.
- [iOS] Added `IOSPushConfiguration.reportOutgoingCalls`, off by default. When on, a ringing call the current user starts is reported to CallKit as an outgoing call, which gives the caller the green call indicator, the proximity sensor and the call on the lock screen. The CallKit call is marked connected when the call connects and ends with it; ending it from CallKit while it still rings cancels the ring. A ring that arrives while the outgoing call still rings times out and is declined as it would be with no call; once the outgoing call connects, it does not time out and ending it is reported as `ActionCallEnded`. If CallKit refuses to start the call, for example because another call of the app is up, the call goes on without CallKit and the refusal is logged. Leave it off if your app already calls `startOutgoingCall` itself.

### 🐞 Fixed

- A mute from the CallKit screen applies to the call it was made on.
- [iOS] Taking a call off hold no longer marks it unmuted, so muting or unmuting from the app afterwards reaches the CallKit screen.
- [iOS] Answering one of two ringing calls from CallKit no longer reports the other one as accepted in `activeCalls`.
- [iOS] A ring that was already ended, for example because the caller cancelled it, no longer times out later and reports a second, unanswered end.
- `registerDevice` right after `connect`, and `unregisterDevice` on web and desktop, no longer throw.
- A failing push token read is logged instead of reported as an uncaught error.
- `unregisterDevice` always stops registering refreshed tokens.
- `unregisterDevice` deletes the registered push token from the backend even when the current token cannot be read.
- A registration still in flight when `unregisterDevice` runs no longer stores its token.

## Upcoming (minor)

### 🐞 Fixed

- A ringing event the package does not recognise is now ignored.
- [iOS] `setCallConnected` and `endCall` keep the call's options, so `configureAudioSession: false` is respected after the call connects and the plugin no longer reconfigures the audio session set up by WebRTC.
- [iOS] `setCallConnected` no longer answers an outgoing call, which reconfigured the audio session and emitted an accept event for the app's own call.
- [iOS] An outgoing call keeps its own options and `ActionCallStart` data when another call is started, shown, connected or ended while it is starting.
- [iOS] CallKit mute, hold, group and DTMF events report the call's uuid as it was started or shown with, instead of uppercased, so it matches the uuid in the call's other events.
- [iOS] Holding or resuming a call no longer requests the same hold again, which left the call switching between held and active until it ended.
- [iOS] Ungrouping a CallKit call no longer throws while the `ActionCallToggleGroup` event is decoded. The event now arrives with a null `callUUIDToGroupWith`.

## 1.7.2

### 🐞 Fixed

- [Android] Incoming calls keep their notification and ringtone after one of the app's Flutter engines detaches.

## 1.7.1

### 🐞 Fixed

- Fixed `unregisterDevice()` incorrectly trying to delete an APN device token when `registerApnDeviceToken` is `false`.

### 🔄 Changed

- [Android] Removed the unused `DISABLE_KEYGUARD` and `ACCESS_NOTIFICATION_POLICY` permissions.

## 1.7.0

### 🔄 Changed

- [Android] Migrated the Android module to AGP's built-in Kotlin. The module no longer applies the Kotlin Gradle Plugin (KGP), whose application Android Gradle Plugin 9.0 removed — apps on AGP 9 failed to build because of it.
- Increased minimum Flutter version to 3.44.0, which is required for the built-in Kotlin migration: from 3.44 Flutter applies the Kotlin Gradle Plugin to plugin modules that no longer declare it, keeping AGP 8 builds working.

## 1.6.0

### ✅ Added

- [iOS] Added `ActionCallIncomingFailed` and `IncomingCallFailureReason` to notify when the system blocks showing an incoming call (e.g. due to Do Not Disturb or block list). Listen via `onRingingEvent<ActionCallIncomingFailed>`.
- [Android] Added a Telecom integration for the ringing flow, which registers ringing calls with the platform's [Telecom stack](https://developer.android.com/develop/connectivity/telecom). This gives the call proper audio focus and a place in the system call state, and lets it be answered or hung up from a paired watch, a car head unit or a Bluetooth headset. The incoming call notification and full-screen ringing UI are unchanged. It is on by default on Android 17 and above, where ringing from a push no longer works reliably without it, and off below that, so existing integrations are unaffected. Configure it with `AndroidPushConfiguration(telecom: TelecomPushConfiguration(...))`.

### 🐞 Fixed

- Fixed an issue where `consumeIncomingCall` could create multiple `Call` instances for the same ringing flow, causing state conflicts and UI issues.
- [iOS] Fixed calls answered on the CallKit screen during a cold start or terminated state not being properly joined, or being incorrectly ended on the device. The SDK now reliably detects and joins answered calls in these scenarios.
- [iOS] Fixed the CallKit provider configuration being lost when a VoIP push woke the app before any Dart code had run, which dropped the configured ringtone, icon and Recents behaviour on a cold start.
- [Android] Fixed the incoming call ringtone being silently muted on Android 17. The ringtone is now played from a `phoneCall` foreground service, which Android 17's background audio hardening requires for audio played while no activity is visible.

### 🔄 Changed

- [Android] The plugin now compiles against Java 17, matching the other Stream Video Flutter packages, and adds `androidx.core:core-telecom` and `org.jetbrains.kotlinx:kotlinx-coroutines-android` as dependencies.
- [Android] The plugin now explicitly declares `BLUETOOTH_CONNECT` permission for clarity. It's optional and only needed for Bluetooth features on API 31+. Only the active Bluetooth device will appear if not granted.

## 1.5.0

- Updated `stream_video` dependency to [`1.5.0`](https://pub.dev/packages/stream_video/changelog).

## 1.4.3

### 🐞 Fixed

- Fixed the incoming call UI (CallKit on iOS) ringing for a call whose ringing flow was already resolved before the push was delivered.

## 1.4.2

- Increased minimum Flutter version to 3.38.1.

## 1.4.1

### 🐞 Fixed

- [Android] Fixed a crash in `TransparentActivity` when the activity is recreated with a null intent action (e.g. after process death or restore from recents) ([#1256](https://github.com/GetStream/stream-video-flutter/pull/1256)).

## 1.4.0

- Sync version with `stream_video_flutter` 1.4.0

## 1.3.3

- Sync version with `stream_video_flutter` 1.3.3

## 1.3.2

- Sync version with `stream_video_flutter` 1.3.2

## 1.3.1

### 🐞 Fixed

- [iOS] Fixed race condition where push notification events could be lost if the Flutter EventChannel listener wasn't registered yet.

## 1.3.0

- Sync version with `stream_video_flutter` 1.3.0

## 1.2.4

- Sync version with `stream_video_flutter` 1.2.4

## 1.2.3

### ✅ Added

- Added `includesCallsInRecents` to iOS push configuration to control whether CallKit calls appear in Recents.

### 🐞 Fixed

- [iOS] Fixed CallKit event suppression to avoid repeated mute toggle loops.
- [Android] Fixed issues when accepting incoming calls from detached state (app exited via back button).
- [Android] Fixed incoming call notifications not showing when the app is in a detached state (e.g., after pressing the back button).

## 1.2.2

- Sync version with `stream_video_flutter` 1.2.2

## 1.2.1

🐞 Fixed

- [iOS/macOS] Fixed crash when VoIP push is received before Flutter fully initializes from the terminated state.

## 1.2.0

- Sync version with `stream_video_flutter` 1.2.0

## 1.1.0

- Sync version with `stream_video_flutter` 1.1.0

## 1.0.2

🐞 Fixed

- Fixed incoming call timeout handling.
  - Use `streamVideo.observeCoreRingingEventsForBackground()` instead of `streamVideo.observeCallDeclinedRingingEvent()` in `firebaseMessagingBackgroundHandler` to support all necessary events.

## 1.0.1

- Sync version with `stream_video_flutter` 1.0.1

## 1.0.0

### 🚧 Breaking changes

#### CallKit/Ringing

This release removes the dependency on `flutter_callkit_incoming`, resulting in several breaking changes to CallKit and ringing functionality:

- **CallKit/ringing configuration:** The initialization process is updated. Replace the `pushParams` parameter in `StreamVideoPushNotificationManager` with the new `pushConfiguration` field (`StreamVideoPushConfiguration`).
- **Parameter renaming:** The `nameCaller` parameter has been standardized and renamed to `callerName` across all relevant locations.
- **Removed properties:**
  - The deprecated `callerCustomizationCallback` and `backgroundVoipCallHandler` have been fully removed from `StreamVideoPushNotificationManager`.
  - The previously used `appName` field in `pushParams` has been removed as it was deprecated. On iOS, the app’s product name from build settings is now used instead.
- **API renames and type changes**
  - `onCallKitEvent` is now `onRingingEvent`
  - `observeCoreCallKitEvents` is now `observeCoreRingingEvents`
  - `observeCallAcceptCallKitEvent` is now `observeCallAcceptRingingEvent`
  - `observeCallDeclinedCallKitEvent` is now `observeCallDeclinedRingingEvent`
  - `observeCallEndedCallKitEvent` is now `observeCallEndedRingingEvent`
  - The `CallKitEvent` type is now `RingingEvent`

---

### 🍏 **Swift Package Manager (SPM)**

- Added Swift Package Manager (SPM) support for iOS.
  > [!IMPORTANT]  
  > Flutter's iOS SPM is experimental and disabled by default. You can enable it via `flutter config --enable-swift-package-manager`. Flutter will fall back to CocoaPods for plugins that don't support SPM. See the [Flutter SPM docs](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers).

## 0.11.2

- Sync version with `stream_video_flutter` 0.11.2

## 0.11.1

- Sync version with `stream_video_flutter` 0.11.1

## 0.11.0

🚧 Build breaking changes

> **Important:** This release includes breaking changes for Android development.
>
> **Android Requirements:**
>
> - Minimum compileSDK 36
> - Android Gradle Plugin >=8.12.1
> - Gradle wrapper >=8.13
> - Kotlin 2.2.0

- Updated minimum Flutter version to 3.32.0
- Updated minimum supported Dart SDK version to 3.8.0

## 0.10.4

- Sync version with `stream_video_flutter` 0.10.4

## 0.10.3

- Sync version with `stream_video_flutter` 0.10.3

## 0.10.2

🔄 Dependency updates

- Updated `flutter_callkit_incoming` dependency to version 2.5.7. That version contains Android 14 compatibility fixes for ringing notifications and lock screen handling.

## 0.10.1

✅ Added

- Added support for customization of display name for ringing notifications by providing `display_name` custom data to the call. See the [documentation](https://getstream.io/video/docs/flutter/advanced/incoming-calls/customization/#display-name-customization) for details.

## 0.10.0

- Sync version with `stream_video_flutter` 0.10.0

## 0.9.6

- Sync version with `stream_video_flutter` 0.9.6

## 0.9.5

- Sync version with `stream_video_flutter` 0.9.5

## 0.9.4

- Sync version with `stream_video_flutter` 0.9.4

## 0.9.3

- Sync version with `stream_video_flutter` 0.9.3

## 0.9.2

- Sync version with `stream_video_flutter` 0.9.2

## 0.9.1

- Sync version with `stream_video_flutter` 0.9.1

## 0.9.0

🐞 Fixed

- (iOS) Synchronized CallKit microphone mute state with the actual call mute state.

## 0.8.4

- Sync version with `stream_video_flutter` 0.8.4

## 0.8.3

- Sync version with `stream_video_flutter` 0.8.3

## 0.8.2

- Sync version with `stream_video_flutter` 0.8.2

## 0.8.1

- Sync version with `stream_video_flutter` 0.8.1

## 0.8.0

- Updated minimum Flutter version to 3.27.4
  - Note: If you updated Flutter version and are using `flutterfire_cli` for push notifications you might need to reactivate it by running: `dart pub global activate flutterfire_cli`.

🐞 Fixed

- **(Windows/Linux)** Fixes compilation issues caused by `stream_webrtc_flutter` package.

## 0.7.2

🐞 Fixed

- Resolved an issue where accepting a second call while already on a call would not open the call screen correctly.
- **(iOS)** Resolved an issue where CallKit calls sometimes were not terminated when the Stream call ended.
- **(iOS)** Fixed a missing app icon on the CallKit screen when the app was in a terminated state.

## 0.7.1

- Sync version with `stream_video_flutter` 0.7.1

## 0.7.0

🚧 Breaking changes

- The package is now compatible with Gradle 8. The minimum required Java version is now 17.
- Updated the `flutter_callkit_incoming` package to version 2.5.0, which also requires Java 17.

🐞 Fixed

- Fixes rejecting ringing call when CallEnd, instead of CallDecline, event is triggered by CallKit during ringing.

## 0.6.1

- Updated minimum Flutter version to 3.24.5

✅ Added

- Added the `StreamVideoPushNotificationManager.ensureFullScreenIntentPermission()` method. This resolves an issue on some Android 14 devices where full-screen notifications would not appear due to missing permissions.
  You can now invoke this method to show a settings screen, allowing users to enable the required permission if it's not already enabled.

🐞 Fixed

- Resolved an issue where CallKit calls would not connect when accepted while the screen was locked.

## 0.6.0

🔄 Dependency updates

- Updated firebase dependencies to fix Xcode 16 build issues

## 0.5.5

- Sync version with `stream_video_flutter` 0.5.5

## 0.5.4

- Dependency updates
  - **Flutter SDK** constraint updated to >=3.22.0 (**Dart SDK** to >=3.4.0 <4.0.0)
  - **json_annotation** updated from ^4.8.0 to ^4.9.0
  - **firebase_core updated** from ^2.15.1 to ^3.4.0
  - **firebase_messaging** updated from ^14.5.0 to ^15.1.1

## 0.5.3

- Sync version with `stream_video_flutter` 0.5.3

## 0.5.2

🐞 Fixed

- Fixed CallKit integration on iOS when app is in a terminated state. It now correctly openes the app when the call is accepted.

## 0.5.1

- Sync version with `stream_video_flutter` 0.5.1

## 0.5.0

🐞 Fixed

- Fixed an issue where the microphone was being muted when the app was running in the background on Android versions greater than 14.

## 0.4.4

- Sync version with `stream_video_flutter` 0.4.4

## 0.4.3

✅ Added

- CallKit now displays appropriate video and audio call labels.

## 0.4.2

- Sync version with `stream_video_flutter` 0.4.2

## 0.4.1

- Sync version with `stream_video_flutter` 0.4.1

## 0.4.0

🚧 Breaking changes

- Updated minimum supported dart SDK version to `3.3.0` (which requires min Flutter SDK `3.19.0`)

## 0.3.9

- Sync version with `stream_video_flutter` 0.3.9

## 0.3.8

- Sync version with `stream_video_flutter` 0.3.8

## 0.3.7

- Updated minimum supported SDK version to Flutter 3.16

## 0.3.6

- Sync version with `stream_video_flutter` 0.3.6

## 0.3.5

- Sync version with `stream_video_flutter` 0.3.5

## 0.3.4

- Sync version with `stream_video_flutter` 0.3.4

## 0.3.3

- Added `StreamCallType` class that replaces depricated String `type` parameter

## 0.3.2

🐞 Fixed

- Various fixes to call ringing and push notifications.

* Fixes call ringing cancellation when app is terminated on iOS (requires additional setup - check Step 6 of the [APNS integration](https://getstream.io/video/docs/flutter/advanced/ringing_and_callkit/#integrating-apns-for-ios)) in our documentation.
* Fixes late push notification handling on Android, where already ended call was ringing if the device was offline and the push was delivered with a delay.
* Fixes call ringing cancellation when caller timed out while calling

- Fixed action tap callback on Android call notification.

## 0.3.1

- Important: Fixes crash for CallKit on iOS.

## 0.3.0

✅ Added

- `callerCustomizationCallback` to `StreamVideoPushNotificationManager` that allow dynamic customization of CallKit call screen.

Example usage:

```dart
pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
    ...
    callerCustomizationCallback: ({required callCid, callerHandle, callerName}) =>
          CallerCustomizationResponse(name: "Customized $callerName"),
    ),
```

🐞 Fixed

- Fixed ringing call cancellation issues.

🚧 Breaking changes

- Removed the `incomingCallerNameOverride` and `incomingCallerHandlerOverride` from `StreamVideoPushParams` in favor of the new `callerCustomizationCallback` in `StreamVideoPushNotificationManager`.

## 0.2.0

✅ Added

- `incomingCallerNameOverride` and `incomingCallerHandlerOverride` to `StreamVideoPushParams` to allow customization of CallKit call screen
- `participantsAvatarBuilder` and `participantsDisplayNameBuilder` to `StreamOutgoingCallContent` and `StreamIncomingCallContent` to allow customiztion of Incoming and Outgoing call screens

Example usage:

```dart
StreamCallContainer(
   ...
   outgoingCallBuilder: (context, call, callState) =>
           StreamOutgoingCallContent(
               call: call,
               callState: callState,
               participantsDisplayNameBuilder:
                   (context, call, callState, participants) => your widget here,
           ),
)
```

🐞 Fixed

- App icon in CallKit screen is now visible in dedicated button when correctly configured.

## 0.1.1

- Aligned version with other Stream Video packages

## 0.1.0

- Added helper class for iOS native push initialization
- Fixes for iOS CallKit implementation
- Fixes for Android ringing implementation
- Added event listeners for call state changes

## 0.0.4

- Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0
- Updated `stream_video` dependency to [`0.0.3`](https://pub.dev/packages/stream_video/changelog).

## 0.0.3

- Adds ability to update provider names for Firebase and APNS

## 0.0.2

- Updates for backend

## 0.0.1

- Initial beta release of Stream Video 🚀
