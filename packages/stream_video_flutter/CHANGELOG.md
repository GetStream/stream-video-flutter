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
- Fixes call ringing cancellation when app is terminated on iOS (requires additional setup - check Step 6 of the [APNS integration](https://getstream.io/video/docs/flutter/advanced/adding_ringing_and_callkit/#integrating-apns-for-ios)) in our documentation.
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
