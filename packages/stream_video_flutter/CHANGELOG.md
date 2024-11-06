## 0.6.0

This release introduces a major rework of the join/reconnect flow in the Call class to support Reconnect V2, enhancing reconnection handling across various scenarios. Most updates are within the internals of the Call class, though some changes are outward-facing, including a few breaking changes.

🔄 Changed
* `Call.reject()` method will now always call `Call.leave()` method internally.

🚧 Breaking changes
* Removed the deprecated `Call.joinLobby()` method.
* The `maxDuration` and `maxParticipants` parameters of `Call.getOrCreate()` are now combined into the `StreamLimitsSettings? limits` parameter.

🔄 Dependency updates
* Updated Firebase dependencies to resolve Xcode 16 build issues.

✅ Added
* Added the `registerPushDevice` optional parameter (default is `true`) to the `StreamVideo.connect()` method,allowing the prevention of automatic push token registration.
* Added `participantCount` and `anonymousParticipantCount` to `CallState` reflecting the current number of participants in the call.
* Introduced the `watch` parameter to `Call.get()` and `Call.getOrCreate()` methods (default is `true`). When set to `true`, this enables the `Call` to listen for coordinator events and update its state accordingly, even before the call is joined (`Call.join()`).
* Added support for `targetResolution` setting set on the Dashboard to determine the max resolution the video stream.
* Introduced new API methods to give greater control over incoming video quality. `Call.setPreferredIncomingVideoResolution()` allows you to manually set a preferred video resolution, while `Call.setIncomingVideoEnabled()` enables or disables incoming video. For more details, refer to the [documentation](https://getstream.io/video/docs/flutter/manual-video-quality-selection/).

🐞 Fixed
* Automatic push token registration by `StreamVideo` now stores registered token in `SharedPreferences`, performing an API call only when the token changes.
* Fixed premature ringing termination issues.
* Resolved issues where ringing would not end when the caller terminates the call in an app-terminated state.
* Fixed issue with call not ending in some cases when only one participant is left and `dropIfAloneInRingingFlow` is set to `true`.

## 0.5.5

🐞 Fixed
* Migrated from `internet_connection_checker` to `internet_connection_checker_plus` due to [license issues](https://github.com/github/dmca/blob/master/2024/09/2024-09-04-internet-connection-checker-plus.md).
* `callAppBarBuilder` in `StreamCallContent` can now return null in order to hide the app bar.
* `backgroundColor` field in `StreamCallControls` is now correctly applied.

## 0.5.4

🐞 Fixed
* Fixed an issue where active call foreground service was recreated after being stopped when ringing call was declined and in-app incoming screen was displayed.

🚧 Breaking changes
* The regular push notification handling has been removed from iOS, providing more control over the implementation. VoIP push notifications will continue to be handled as before. For more details, refer to the [documentation](https://getstream.io/video/docs/flutter/push-notifications/).

* Dependency updates
    * **Flutter SDK** constraint updated to >=3.22.0 (**Dart SDK** to >=3.4.0 <4.0.0)
    * **internet_connection_checker** updated from ^1.0.0+1 to ^2.0.0
    * **rxdart** updated from ^0.27.7 to ^0.28.0
    * **web** updated from ^0.5.1 to ^1.0.0
    * **web_socket_channel** updated from ^2.4.0 to ^3.0.1
    * **firebase_core updated** from ^2.15.1 to ^3.4.0
    * **firebase_messaging** updated from ^14.5.0 to ^15.1.1
    * **share_plus** updated from ^7.1.0 to ^10.0.2
    * **json_annotation** updated from ^4.8.0 to ^4.9.0

## 0.5.3

🐞 Fixed
* Improved video quality for a smoother experience.
* Resolved an issue where the participant's state showed an empty roles list.
* Fixed a bug that caused the CallKit ringing notification to continue after a call was accepted.

## 0.5.2

🐞 Fixed
* Fixed CallKit integration on iOS when app is in a terminated state. It now correctly openes the app when the call is accepted.
* Fixed `onLeaveCallTap` callback in `StreamCallContent`. It's now correctly handled.
* (Android) Prevented the app from crashing when microphone permission is not granted and actove call foreground services is started. The service will now not start if no permission is granted.
* (Android) Marked the active call notification channel's lockscreen visibility as public to ensure it shows when the Android device is locked.

🔄 Changed
* `SortParam` changed to `SortParamRequest` in `queryMembers()` method inside `Call` and `StreamVideo` class

## 0.5.1

✅ Added
* Added `backstage` parameter to `call.getOtCreate()` method with backstage settings. For more information, refer to the [documentation](https://getstream.io/video/docs/flutter/joining-and-creating-calls/#backstage-setup)
    * Ability to join call in advance with `joinAheadTimeSeconds` parameter (part of `StreamBackstageSettings`)
* Added `startsAt` parameter to `call.getOtCreate()` method
* Added `maxDuration` and `maxParticipants` parameters to `call.getOtCreate()` method
* Added `video` parameter to `call.getOtCreate()`, `call.getCall()` and `call.join()` methods. This parameter is used to distinguish between audio-only and video calls for ringing purposes.
    * ❗Important❗ the `video` parameter is `false` by default. If you want your call to be treated as a video call while ringing set it to `true`.
* Added `streamVideo` paramter to `StreamLobbyView` and `StreamLobbyVideo` widgets provide a custom `StreamVideo` instance.

🐞 Fixed
* Fixed reaction dismissal: Sent and received reactions are now correctly dismissed after a 5-second timeout (configurable in `CallPreferences`).
* Fixed the cancel button behavior in the screen-sharing notification on Android. It will now correctly stop the screen-sharing process.
* Fixed the issue with the cancel button in the call-in-progress notification was not stopping the call.
* Fixed the connection quality updates for other call participants.
* Fixed an issue where declining a ringing call when the app was in a terminated state did not stop the ringing on the caller's end.

## 0.5.0

✅ Added
* Picture in Picture (PiP) is now also supported on iOS. For more information, refer to the [documentation](https://getstream.io/video/docs/flutter/advanced/picture_in_picture/)

🐞 Fixed
* Fixed an issue where the microphone was being muted when the app was running in the background on Android versions greater than 14.

🚧 Breaking changes
* The implementation of `BroadcastSampleHandler`, used for `broadcast` screen-sharing mode on iOS is now moved from `stream_video_flutter` package to a separate [stream_video_screen_sharing](https://pub.dev/packages/stream_video_screen_sharing) package.
Migration steps:
- Add `stream_video_screen_sharing` dependency to your `pubspec.yaml` file
- Replace the import in `SampleHandler.swift` file from `stream_video_flutter` to `stream_video_screen_sharing`
- Replace the dependancy added to the extension target in `Podfile` file from `stream_video_flutter` to `stream_video_screen_sharing`

For complete screen-sharing guide please refer to the [documentaiton](https://getstream.io/video/docs/flutter/advanced/screen_sharing/)

* Previously deprecated `String` `type` parameters in `makeCall()` and `getCallRingingState()` methods are now removed. Use `StreamCallType` `callType` parameter now.
* Previously deprecated `events` and `coordinatorEvents` streams are now removed from `Call` class. Use `callEvents` instead.

## 0.4.4

✅ Added
* Added `watch` parameter to `StreamVideo.queryCalls()` method, allowing you to subscribe to queried call events.  For more information, refer to the [documentation](https://getstream.io/video/docs/flutter/querying-calls/).
* Introduced `listRecordings()` to `StreamVideo` object, enabling you to query call recordings using a provided call CID.

🔄 Changed
* The default constructor for `StreamCallType` is now deprecated. Instead, use the `StreamCallType.defaultType()` factory constuctor.

🐞 Fixed
* Improved the quality of screen sharing. It now correctly respects the parameters set in `ScreenSharingConstraints` to adjust the quality. 
* The `FloatingViewAlignment` enum is now properly exported in the `stream_video_flutter` package.

## 0.4.3

🐞 Fixed
* Fixed reconnection flow.
* Fixed compilation errors on web.
* Fixed screen-sharing not working on some versions of Android.
* Fixed accepting incoming call during another call (or outgoing call).
* Fixed CallKit incoming push label and Android accept call button icons for audio-only calls.

✅ Added
* Added support for missed calls. Push notifications and `CallMissedEvent` event will be sent now when the user misses the call.
* Added support for call transcription [check transcription cookbook](https://getstream.io/video/docs/flutter/ui-cookbook/transcriptions/)
    * Added `startTranscription()`, `stopTranscription()` and `listTranscriptions()` methods to `Call` class.
* Added option to take a screenshot during the call [check screenshot documentation](https://getstream.io/video/docs/flutter/screenshots/)
    * Added `takeScreenshot()` method to `Call` class.
* Added `recordingExternalStorage` optional param to `call.startRecording()` method.
* Added `requestScreenSharePermission()` method to `Call` class that ensures correct permissions are given for screen-sharing on Android.

🔄 Changed
* Changed `role` member to `roles`, to reflect the possibility of the user having multiple roles, in `CallParticipantState` and `CallMember`.
* Changed `SortParamRequest` to `SortParam`.

🔄 Changed some of the signatures
* `listRecordings()` method in PermissionsManager doesn't require `sessionId` param now.
* `setParticipantPinned()` method in `Call` and `CallSession` now requires `sessionId`, `userId`, and `pinned` params instead of `SetParticipantPinned` action.
* `updateViewportVisibility()` method in `CallSession` now requires `visibilityChange` param instead of `UpdateViewportVisibility` action.
* `setSubscriptions()` and `updateSubscription()` methods in `CallSession` now require a list of `subscriptionChanges` param instead of a list of `SetSubscription` actions.
* Added optional `reason` param to `reject()` method in `Call` class.

Removed
* Removed `updateSubscriptions` method from `Call`.

## 0.4.2

✅ Added
* Added `ClientDetails` to SFU's `join` request.

🐞 Fixed
* Tweaked SFU events handling to ensure there is no gap in handling them.
* Fixed camera and microphone toggling on incoming/outgoing screen.
* Fixed screen sharing not working when camera track was enabled.
* Fixed issues with video freezing sometimes.

## 0.4.1

🚧 Build breaking changes
* Bumped `connectivity_plus` dependency to `6.0.3` 

> Note, that this changes the plugin requirements:
> - compileSDK 34 for Android part
> - Java 17 for Android part
> - Gradle 8.4 for Android part

🐞 Fixed
* Added foreground service type to service declaration in AndroidManifest

## 0.4.0

🚧 Breaking changes
* Updated minimum supported dart SDK version to `3.3.0` (which requires min Flutter SDK `3.19.0`)

* Updated `flutter_webrtc` to 0.10.4

🐞 Fixed
* Fixed an issue where subscriber offer events might be missed causing missing video/audio tracks for call participants.
* Fixed speakerphone/earpiece switching on iOS.
* User is now diconnected immedietaly when leaving the call.

## 0.3.9
* Reverted `flutter_webrtc` dependency version back to `0.9.47` to fix the compilation issues for web in Flutter 3.19.

## 0.3.8

🐞 Fixed
* Fixed application of initial call configuration (via `CallConnectOptions`) and default settings from Stream Dashboard
* Default camera facing is now applied from Dashboard settings (was ignored previously)

✅ Added
* `audioOutputDevice`, `audioInputDevice` and `cameraFacingMode` added to `CallConnectOptions`
* Optional `connectOptions` parameter added to `call.join()` method as a preferred way of setting initial call configuration - check out our [documentation](https://getstream.io/video/docs/flutter/initial-call-configuration/) for more info

## 0.3.7
* Updated minimum supported SDK version to Flutter 3.16

✅ Added

* Added `mirrorMode` parameter to `CameraConstraints`, which determines whether the camera for the given track should be mirrored or not. When set as `defaultMode` the mirroring is set as true, when `facingMode` is set to `user` and false when facingMode is set to `environment`.

🐞 Fixed

* Fixed an issue that might break screen sharing functionality.
* Fixed an issue that caused output audio device not being set correctly.
* Fixed an issue that still caused constant notification sound being triggered during the call on Android.
* Fixed an issue that blocked volume adjastment during the call on Android.

## 0.3.6
✅ Added

* Added `callEvents` stream to `Call` that replaces `events` and `coordinatorEvents` streams (both are now deprecated).
* Added `callBackgroundBuilder` to `StreamOutg/oingCallContent`.

🚧 Breaking changes

* Removed the `callCid` parameter requirement from `sendCustomEvent()` method in `Call` class.

🐞 Fixed

* Fixed an issue that caused an empty Call participants list in CallState during ringing.
* Fixed an issue that caused constant notification sound being triggered during the call on Android.
* Disabled camera mirroring when using back camera and when screensharing.

## 0.3.5
✅ Added

* Added `keepConnectionsAliveWhenInBackground` to `StreamVideoOptions` to allow keeping websocket connections and event subscribtions open when app is in the background (false by default).
* Added support for Picture in Picture feature to Android - check out our [documentation](https://getstream.io/video/docs/flutter/advanced/picture_in_picture/) for more info
* Added usage statictics reporting

🐞 Fixed

* Fixed handling of default audio output device setting from Stream dashboard 
* Fixed handling of default camera/microphone state setting from Stream dashboard
* Fixed an issue where call could sometimes loose participants state
* Fixed an issue in `LobbyView` where camera/microphone state selected would not be correctly applied into the call

## 0.3.4

* Fixed the size of the LeaveCall aciton button in `CallAppBar`
* Added `showLeaveCallAction` property to `CallAppBar`

## 0.3.3

🚧 UI changes to SDK components

* `CallParticipantsLabel` - removed internal padding, it sticks to the corner of the video frame by default now
* Extracted `StreamLobbyVideo` widget from `StreamLobbyView` that can be easly reused in custom layout
* `CallAppBar`
    - `LeaveCallOption` moved from default call controls to `CallAppBar`
    - Participants button removed from `CallAppBar` together with `onParticipantsInfoTap` and `participantsInfoBuilder` properties
    - Layout Mode button removed from `CallAppBar` together with `onLayoutModeChanged` property. You can use new `ToggleLayoutOption` instead in custom layout anywhere
* `ToggleLayoutOption` added
* Components related to participants menu item from `CallAppBar` are removed: `CallParticipantsInfoItem`, `StreamCallParticipantsInfoMenu` and `CallParticipantsInfoOptions`
* `StreamCallParticipantsInfoMenuTheme` is removed

Other changes:
* Added `StreamCallType` class that replaces depricated String `type` parameter
* Exapanded `CallStats` class with more structured WebRTC statistics as `stats` field
* Changed `raw` statistics in `CallStats` to be of a Map<Stirng, dynamic> type
* Added `publisherStats`, `subsciberStats` and `latencyHistory` to the `CallState` that hold some of the processed statistcs 

Bug fixes
* Fixes incoming call behavior when both CallKit and Stream incoming screen component is used 
* Fixes the issue on Android that caused missed call notification when ringing with reused call id

## 0.3.2

🐞 Fixed

* Various fixes to call ringing and push notifications.
- Fixes call ringing cancellation when app is terminated on iOS (requires additional setup - check Step 6 of the [APNS integration](https://getstream.io/video/docs/flutter/advanced/ringing_and_callkit/#integrating-apns-for-ios)) in our documentation.
- Fixes late push notification handling on Android, where already ended call was ringing if the device was offline and the push was delivered with a delay.
- Fixes call ringing cancellation when caller timed out while calling
* Fixed action tap callback on Android call notification.
* Fixed background image for incoming/outgoing call screens when `participant.image` is invalid.
* Fixes possible crashes for Android SDKs versions <26.
* Fixed screen sharing on iOS when screen sharing mode was switched between `in-app` and `broadcast`.
* Changed the version range of `intl` package to >=0.18.1 <=0.19.0 because it was causing isses with other packages.

✅ Added

* Added `custom` field to `CallParticipantState` with custom user data.

## 0.3.1

* Important: Fixes crash for CallKit on iOS.
* Added support for SFU migration to improve video resilience.
* Fixes for streaming flags in `CallState` (backstage, broadcasting, recording).

## 0.3.0

🚧 Breaking changes 

* The functionality from `stream_video_flutter_background` is now merged into `stream_video_flutter`. You no longer have to use the background plugin.
* Removed the `incomingCallerNameOverride` and `incomingCallerHandlerOverride` from `StreamVideoPushParams` in favor of the new `callerCustomizationCallback` in `StreamVideoPushNotificationManager`.

✅ Added

* Added `LivestreamPlayer` - a in-built widget that allows you to easily view livestreams.
* Added screen sharing functionality and related toggle option for both Android and iOS. Check [our documentation](https://getstream.io/video/docs/flutter/) for more details
* Exposed call coordinator events through the `coordinatorEvents` stream in the `Call` class.
* Added `StreamCallContentTheme` to video theme.
* `callerCustomizationCallback` to `StreamVideoPushNotificationManager` that allow dynamic customization of CallKit call screen.

Example usage:

```dart
pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
    ...
    callerCustomizationCallback: ({required callCid, callerHandle, callerName}) =>
          CallerCustomizationResponse(name: "Customized $callerName"),
    ),
```

* Added a `includeUserDetails` field to determine if user details should be passed to backend when connecting user.
* Added `team`, `notify`, and `custom` properties to `getOrCreate()` for `Call`.

🐞 Fixed

* Added Apple audio configuration to make audio work in silent mode.
* Fixed ringing call cancellation issues.

## 0.2.0

✅ Added

* `removeMembers` and `updateCallMembers` to `Call`
* `incomingCallerNameOverride` and `incomingCallerHandlerOverride` to `StreamVideoPushParams` to allow customization of CallKit call screen
* `participantsAvatarBuilder` and `participantsDisplayNameBuilder` to `StreamOutgoingCallContent` and `StreamIncomingCallContent` to allow customiztion of Incoming and Outgoing call screens

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

🔄 Changed

Breaking changes 🚧
* renamed `inviteUsers` to `addMembers` in `Call`
* renamed parameter name in `getOrCreateCall` from `participantIds` to `memberIds`

## 0.1.1

* Fixed call join bug
* Fixed CallKit call not ending bug
* Anonymous users can no longer connect to WS
* Users can no longer join a call twice
* Fixed landscape call control visibility

## 0.1.0

* Aligned SDK initialization with other SDKs
* Fixed callkit and push implementation for SDK
* Added parsing for CallPermissions
* Fix duplicate participants in call
* Hide debug stats in production
* Display call participants in lobby view
* General bug fixes and improvements

## 0.0.4

* Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0

## 0.0.3

* Fixed track subscription bug

## 0.0.2

* Updates for backend
* Support for reactions

## 0.0.1+1

* Fixed README

## 0.0.1

* Initial beta release of Stream Video 🚀
