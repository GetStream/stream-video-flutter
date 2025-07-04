## 0.10.0

🚧 (Android) Picture-in-Picture (PiP) Improvements - Breaking Change
* **Simplified Setup:** Introduced `StreamFlutterActivity` - extend it instead of `FlutterActivity` for automatic PiP support.
* **Automatic Activation:** PiP now triggers automatically when users press home button or background the app during calls.
* **Fixed Overlay Issues:** PiP view can no longer be overlapped by other widgets and will always display the correct video layout.
* **Migration Required:** In your `MainActivity`, remove the manual `onUserLeaveHint()` implementation and extend the MainActivity with `StreamFlutterActivity`. Previously required manually calling `PictureInPictureHelper.enterPictureInPictureIfInCall(this)` - now handled automatically.
* **Removed Deprecated Methods:** Removed the deprecated `setPictureInPictureEnabled` method from `StreamVideoFlutterPlatform`, `StreamVideoFlutterBackground`, and `MethodChannelStreamVideoFlutter` classes, and the deprecated `enterPictureInPictureIfInCall` method from `PictureInPictureHelper` (Android). PiP is now handled automatically by `StreamPictureInPictureAndroidView`.

🔄 Partial State Updates:

For a more detailed explanation check [the dedicated documentation](https://github.com/GetStream/stream-video-flutter/blob/main/packages/stream_video_flutter/docs/partial_state_update_changes.md).
* Added `call.partialState` for more specific and efficient state updates.
* Added callbacks in `StreamCallContainer`, `StreamCallContent`, `StreamIncomingCallContent`, and others that no longer return a state.
By (only) using these callbacks the root widgets will use more efficient partial state updates.
* Added `PartialCallStateBuilder` to help with making widgets that depend on `partialState`.
* Deprecated old callbacks

✅ Added
* Added `setMirrorVideo` method to `Call` class to control video mirroring for participants.
* Added `maxParticipantsExcludeOwner` and `maxParticipantsExcludeRoles` to Call limits settings, providing finer control over participant limits by allowing exclusion of call owners and specific roles from the maximum count.

🐞 Fixed
* Improved SFU error handling in Call flow and disconnect reason handling. The disconnected call state now accurately reflects the original cause of disconnection.
* Fixed an issue where rejecting a ringing call on one device would incorrectly end the call for all already connected participants.
* Enhanced fast reconnect mechanism with improved PeerConnection issue detection and recovery. The system now attempts multiple fast reconnects before falling back to a full call rejoin.
* Fixed simulcast video quality by correcting resolution calculations and layer selection for optimal video track display.
* Fixed an edge case where a call with the same CID as an incoming call is also an outgoing call to ensure the same Call instance is used.

## 0.9.6

✅ Added
* Added `handleCallInterruptionCallbacks` method to `RtcMediaDeviceNotifier` that provides an option to handle system audio interruption like incoming calls, or other media playing. See the [documentation](https://getstream.io/video/docs/flutter/advanced/handling-system-audio-interruptions/) for details.
* Improved the Picture-in-Picture (PiP) implementation for video calls
    * (iOS) Shows participant avatar instead of black screen when video track is disabled.
    * (iOS) Added overlay with participant name, microphone indicator and connection qualit indicator.
    * (iOS/Android) Added `sort` in `PictureInPictureConfiguration` that enables customization of PiP participant selection.

🐞 Fixed
* Fixed the handling of user blocking event to disconnect the blocked user with a proper reason.

## 0.9.5

✅ Added
* Introduced `extendBody` parameter in `StreamCallContent` that extends the participants view to the bottom edge of the scaffold when enabled.
* Introduced `allowMultipleActiveCalls` option in `StreamVideoOptions` enabling support for concurrent active calls. See the [documentation](https://getstream.io/video/docs/flutter/advanced/multiple-simultaneous-calls-support/) for details.

🐞 Fixed
* Enhanced permission update handling to only process events targeting the current user.
* Improved audio output device selection to prioritize external audio devices during call connection.

## 0.9.4

🐞 Fixed
* Resolved an issue where the screen share track would disappear when zoomed in.
* Fixed screen sharing layout issues on wide screens.
* Fixed `ScreenShareCallParticipantsContent` with Spotlight view on very wide windows.

✅ Added
* Introduced new builder parameters to `LivestreamPlayer` for enhanced customization:
    - `videoRendererBuilder`: Build a custom video renderer.
    - `videoPlaceholderBuilder`: Build a placeholder for the video renderer.
    - `livestreamHostsUnavailableBuilder`: Customize the UI when a livestream is connected but no hosts have video enabled.
    - `livestreamNotConnectedBuilder`: Customize the UI when the livestream is not connected.

## 0.9.3

✅ Added
* Introduced `callDurationStream` to the `Call` class. A `Stream<Duration>` that emits the current call duration.
* Added `createdByUser` property to the `CallState` for better tracking of the initiating user.
* Added `livestreamControlsBuilder` parameter to `LivestreamPlayer` allowing customisation of controls panel.

🐞 Fixed
* Resolved an issue where participants’ tracks would briefly disappear ("blink") or change location when many participants are in the call.
* Fixed a bug where subsequent screen sharing sessions did not end properly when terminated via the browser UI.

## 0.9.2

🐞 Fixed
* Fixed issue with the user feedback collection endpoint.

✅ Added
* Added `ring`, `audio`, `video`, `screenshare`, `session` and `frameRecordings` settings to `Call.getOrCreate()` method.
* Added `members` list parameter to `Call.getOrCreate()` method to allow assigning roles when creating a call.
* Added `session` and `frameRecordings` settings to `Call.update()` method.

🔄 Updated
* Updated `LivestreamPlayer` widget with a refreshed look and feel. Added `livestreamEndedBuilder` and `livestreamBackstageBuilder` for enhanced configuration options.

## 0.9.1

✅ Added
* Introduced camera focus and zoom control features:
  * New `Call.setZoom()` method to adjust the camera’s zoom level.
  * New `Call.focus()` method for setting focus and exposure points on the camera.

🐞 Fixed
* [Android] Fixes the device orientation detection when screen-sharing on some Android devices. 
* Addressed minor bugs and improved performance.

## 0.9.0

✅ Added
* Introducing noise cancellation support to enhance call audio quality. Implement this feature easily by following our [documentation](https://getstream.io/video/docs/flutter/guides/noise-cancellation/).
* Added `networkMonitorSettings` to `StreamVideoOptions` for configuring network monitoring, including customization of test URLs for connection checks.

🚧 (Breaking Changes)
* Enhanced the `onCallDisconnected` callback in `StreamCallContainer` to include a `CallDisconnectedProperties` parameter with detailed disconnection reason information.
* Improved `setScreenShareEnabled` method in `CallSession` class to return the screen sharing track.
* Relocated `callPreferences` property from `CallStateNotifier` to `CallState` for better state management.
* Increased minimum platform requirements
    * **Android:** Minimum SDK 21 (Android 5.0 Lollipop)
    * **iOS:** iOS 14.0 or higher

🐞 Fixed
* Enhanced fast reconnect flow for more reliable connection recovery during network interruptions.
* Resolved an issue where video tracks weren't properly subscribed when participants joined calls.
* Fixed multi-device support to properly handle when the same user joins from multiple devices.
* Corrected screen sharing source switching when changing between multiple sources.
* Fixed a bug where `CallPreferences` could be ignored when accepting a ringing call.
* (Android) Resolved compatibility issues with `battery_plus` plugin on older Android devices.
* (Web) Fixed screen sharing termination when using browser UI controls to stop sharing.
* (iOS) Synchronized CallKit microphone mute state with the actual call mute state.

## 0.8.4

🐞 Fixed
* (iOS) Fixed an issue where Picture-in-Picture (PiP) would not stop when bringing the app back to the foreground.

🔄 Changed
* Updated the `device_info_plus` dependency to support a wider range of versions and resolve potential conflicts.
* Deprecated the `setParticipantPinned()` method in the `Call` class — use `setParticipantPinnedLocally()` instead.
* Replaced the `isPinned` parameter in `CallParticipantState` with a `pin` object, which now differentiates between local and remote pinning.

✅ Added
* Introduced a `membersLimit` parameter in the `getOrCreate()` and `join()` methods of the `Call` class to limit the number of members included in the response.
* Added `setParticipantPinnedForEveryone()`, allowing users with the required permissions to pin participants for all. The `setParticipantPinned()` method has been replaced with `setParticipantPinnedLocally()`, which, as before, only pins participants locally.

🔄 Changed
* Update stream_webrtc_flutter and device_info_plus dependencies

## 0.8.3

✅ Added
* Introduced `CallParticipantState.audioLevels`, which stores the last 10 audio levels of a participant.
* Added `CallState.activeSpeakers` to retrieve a list of currently active speakers.
* Enhanced `observeCoreCallKitEvents()` in `StreamVideo` with a new `CallPreferences? preferences` parameter, allowing for configuration of the accepted call.
* Implemented localization support for the SDK's UI components. See the [documentation](https://getstream.io/video/docs/flutter/localization/) for details.
* Added the ability to customize the screen share selector on desktop devices. See the [updated documentation](https://getstream.io/video/docs/flutter/advanced/screen_sharing/) for details.

🐞 Fixed
* Resolved various issues related to screen sharing on desktop devices.

## 0.8.2

✅ Added 
* Added `CallPreferences? preferences` parameter to `consumeIncomingCall()` method in `StreamVideo` to make it possible to configure the consumed call.

🐞 Fixed
* Fixed remote participant roles array being empty after joining the call.
* Fixed and issue with `thermal` package throwing exception on Android 9 and lower.

## 0.8.1

✅ Added 
* Introduced the `onCallDisconnected` callback in `StreamCallContainer`, enabling customization of the default behavior, which invokes `Navigator.pop` upon call disconnection.
* Made `registerDevice()` and `unregisterDevice()` methods publicly available in `PushNotificationManager`.

## 0.8.0

* Updated minimum Flutter version to 3.27.4
    * Note: If you updated Flutter version and are using `flutterfire_cli` for push notifications you might need to reactivate it by running: `dart pub global activate flutterfire_cli`.

✅ Added
* Introduced `disposeAfterResolvingRinging()` and `consumeAndAcceptActiveCall()` methods in `StreamVideo` to simplify the ringing flow implementation.
    - Refer to the updated [Incoming Call Documentation](https://getstream.io/video/docs/flutter/advanced/incoming-calls/overview/) or the [Ringing Tutorial](https://getstream.io/video/sdk/flutter/tutorial/ringing/) for more details.

🔄 Changed
* Deprecated the `backgroundVoipCallHandler` parameter in `StreamVideoPushNotificationManager`, as it is no longer required for iOS ringing to function in a terminated state.

🐞 Fixed
* Center alignment of buttons in `StreamLobbyVideo` to support more screen sizes.
* **(Windows/Linux)** Fixes compilation issues caused by `stream_webrtc_flutter` package.

🚧 (Breaking) Picture-in-Picture (PiP) Improvements & Fixes
* **Fixed:** PiP not working on Android 15.
* **Fixed:** PiP not displaying other participants' screen sharing.
* **Added support for iOS 18 Multitasking Camera Access changes.** From **iOS 18**, you can easily enable camera usage while the app is in the background (e.g., for PiP). Refer to [Picture in Picture documentation](https://getstream.io/video/docs/flutter/advanced/picture_in_picture/) for details.
* Added `disablePictureInPictureWhenScreenSharing` configuration option to `PictureInPictureConfiguration`. When **true** (default), PiP is disabled if the local device is screen sharing.
* ❗ Breaking Change: `ignoreLocalParticipantVideo` parameter in `IOSPictureInPictureConfiguration` is replaced by `includeLocalParticipantVideo`. By default, local video **is enabled** and will appear in PiP mode if the iOS device supports **Multitasking Camera Access**.
* ❗ Breaking Change: `ignoreLocalParticipantVideo` parameter in `StreamPictureInPictureUiKitView` is also replaced by `includeLocalParticipantVideo`.

## 0.7.2

🐞 Fixed
* Resolved an issue where accepting a second call while already on a call would not open the call screen correctly. [#840](https://github.com/GetStream/stream-video-flutter/pull/840) and [#834](https://github.com/GetStream/stream-video-flutter/pull/834)
* **(Web)** Fixed web compilation issues. [#832](https://github.com/GetStream/stream-video-flutter/pull/832)
* **(Web)** Addressed an issue where `battery_plus` and `thermal` packages were erroneously called on web. [#837](https://github.com/GetStream/stream-video-flutter/pull/837)
* **(iOS)** Fixed an issue where Picture-in-Picture mode was not ended when the call ended. [#840](https://github.com/GetStream/stream-video-flutter/pull/840)
* **(iOS)** Resolved an issue where CallKit calls sometimes were not terminated when the Stream call ended. [#840](https://github.com/GetStream/stream-video-flutter/pull/840)
* **(iOS)** Fixed a missing app icon on the CallKit screen when the app was in a terminated state. [#841](https://github.com/GetStream/stream-video-flutter/pull/841)

🔄 Changed
* Deprecated the `handleVoipPushNotification()` method in the `StreamVideo` class. Use `handleRingingFlowNotifications()` instead.

## 0.7.1

🐞 Fixed
* Resolved an issue where media tracks were not being disabled or enabled correctly. [#828](https://github.com/GetStream/stream-video-flutter/pull/828)
* Fixed a problem causing anonymous users to fail when connecting and joining calls. [#827](https://github.com/GetStream/stream-video-flutter/pull/827)

## 0.7.0

🚧 Breaking changes
* The package is now compatible with Gradle 8. The minimum required Java version is now 17. [#820](https://github.com/GetStream/stream-video-flutter/pull/820)
* Updated the `flutter_callkit_incoming` package to version 2.5.0, which also requires Java 17. [#820](https://github.com/GetStream/stream-video-flutter/pull/820)
* The `resolution` parameter of `Call.setPreferredIncomingVideoResolution()` method changed type from `VideoResolution` to `VideoDimension`.
* The `Call.onPermissionRequest` callback changed the event type passed as an argument from `CoordinatorCallPermissionRequestEvent` to `StreamCallPermissionRequestEvent`

✅ Added
* Added out-of-the-box support for blur background filters and image filters. As well as the option to create custom video filters. For complete documentation of those features please check [here.](https://getstream.io/video/docs/flutter/advanced/apply-video-filters/) [#799](https://github.com/GetStream/stream-video-flutter/pull/799)
* Added support for Closed Captions. [#796](https://github.com/GetStream/stream-video-flutter/pull/796)
     * Listen to the `Call.closedCaptions` stream to overlay captions during your call.
     * Use `CallPreferences` to configure: 
         * `closedCaptionsVisibilityDurationMs` for controlling how long captions are displayed.
         * `closedCaptionsVisibleCaptions` for managing the number of captions in the display queue.
     * Easily enable or disable captions with the `ToggleClosedCaptionsOption` widget.
     * Learn More:
         * Check the [guide](https://getstream.io/video/docs/flutter/closed-captions/) for integration steps.
         * Explore the [cookbook](https://getstream.io/video/docs/flutter/ui-cookbook/closed-captions/) for UI tips.
* Dynamic codec negotiation during calls. [#811](https://github.com/GetStream/stream-video-flutter/pull/811)

🐞 Fixed
* Fixed issues when ending the call while in Picture in Picture mode on Android. [#822](https://github.com/GetStream/stream-video-flutter/pull/822)
* Fixes rejecting ringing call when CallEnd, instead of CallDecline, event is triggered by CallKit during ringing. [#824](https://github.com/GetStream/stream-video-flutter/pull/824)

## 0.6.1

* Updated minimum Flutter version to 3.24.5

✅ Added
* Added the `call.collectUserFeedback()` method which allows users to send call quality rating. These ratings are visible on the Dashboard and are aggregated in call stats for easy tracking. For a sample implementation, please refer to the [documentation](https://getstream.io/video/docs/flutter/user-rating/).
* Added device thermal status reporting to better optimize call quality.
* Added the `StreamVideoPushNotificationManager.ensureFullScreenIntentPermission()` method. This resolves an issue on some Android 14 devices where full-screen notifications would not appear due to missing permissions.
You can now invoke this method to show a settings screen, allowing users to enable the required permission if it's not already enabled.

🐞 Fixed
* Resolved an issue where CallKit calls would not connect when accepted while the screen was locked.
* Fixed a bug where the Android foreground service would not stop when the app was killed, keeping the call connection active.

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