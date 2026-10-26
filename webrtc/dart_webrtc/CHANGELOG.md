# Changelog

--------------------------------------------
[1.8.2] - 2026-09-04

fix: add OpenHarmony to isMobile detection for HarmonyOS WebView
feat: remove package:js usage for full wasm compatibility
refactor: wrap transform fn to return a JSPromise
fix: casting fails as value is a dart value

[1.8.1] - 2026-03-26

* Fix wasm-safe transfer lists for frame cryptor worker messages.
* Fix scalabilityMode.

[1.8.0] - 2026-03-16

* Add enum KeyDerivationAlgorithm to KeyProviderOptions.

[1.7.0] - 2026-01-22

* feat: Priority control APIs.

[1.6.0] - 2025-09-13

* feat: data packet cryptor.

[1.5.3+hotfix.5] - 2025-08-11

* fixed E2EE bug for Chrome rejoin.

[1.5.3+hotfix.4] - 2025-07-29

* fixed E2EE issue for Chrome.

[1.5.3+hotfix.3] - 2025-07-24

* fixed E2EE issue for Chrome.

[1.5.3+hotfix.2] - 2025-04-25

* fix bug for dc.onMessage.

[1.5.3+hotfix.1] - 2025-04-25

* add getter override for dc.bufferedAmountLowThreshold.

[1.5.3] - 2025-03-24

* add getBufferedAmount for DC.

[1.5.2+hotfix.1] - 2025-02-23.

* remove platform_detect.

[1.5.2] - 2025-02-23.

* fix stats for web.

[1.5.1] - 2025-02-15

* fix E2EE for firefox.

[1.5.0] - 2025-02-13

* remove js_util.

[1.4.10] - 2024-012-16

* fix compiler errors.

[1.4.9] - 2024-09-04

* bump web version to 1.0.0.

[1.4.8] - 2024-07-12

* fix: missing streamCompleter complete for getUserMedia.
* fix: RTCPeerConnectionWeb.getRemoteStreams.

[1.4.7] - 2024-07-12

* fix: MediaStreamTrack.getSettings.

[1.4.6+hotfix.1] - 2024-06-07

* Wider version dependencies for js/http.

[1.4.6] - 2024-06-05

* chore: bump version for js and http.
* fix: decrypting audio when e2ee.
* fix: translate audio constraints for web.
* fix: missing fault tolerance, better worker reports and a increased timeout for worker tasks.
* fix type cast exception in getConstraints()

[1.4.5] - 2024-05-13

* fix: negotiationNeeded listener.
* fix: fix type cast exception in getConstraints().

[1.4.4] - 2024-04-24

* fix: datachannel message parse for Firefox.
* fix: tryCatch editing mediaConstraints #34

[1.4.3] - 2024-04-18

* fix: do not fail if removing constraint fails

[1.4.2] - 2024-04-15

* fix.

[1.4.1] - 2024-04-12

* remove RTCConfiguration convert.

[1.4.0] - 2024-04-09

* Fixed bug for RTCConfiguration convert.

[1.3.3] - 2024-04-09

* Fix DC data parse.

[1.3.2] - 2024-04-09

* Fix error when constructing RTCDataChannelInit.

[1.3.1] - 2024-04-08

* Add keyRingSize/discardFrameWhenCryptorNotReady to KeyProviderOptions.

[1.3.0] - 2024-04-08

* update to package:web by @jezell in #29.

[1.2.1] - 2024-02-05

* Downgrade some dependencies make more compatible.

[1.2.0] - 2024-02-05

* Make E2EE events to be consistent with native.
* E2EE imporve, and fix issue on Firefox.

[1.1.2] - 2023-09-14

* Add more frame cryptor api.

[1.1.2] - 2023-08-14

* Add async functions for get pc states.

[1.1.1] - 2023-06-29

* downgrade collection to ^1.17.1.

[1.1.0] - 2023-06-29

* Add FrameCryptor support.

[1.0.17] - 2023-06-14

* Fix facingMode for mobile.

[1.0.16] - 2023-04-10

* Add addStreams to RTCRtpSender.

[1.0.15] - 2023-02-10

* add bufferedamountlow
* Fix bug for firefox.

[1.0.14] - 2023-01-30

* Add support for getCapabilities/setCodecPreferences.

[1.0.13] - 2022-12-12

* export jsRtpReciver.

[1.0.12] - 2022-12-12

* fix: Convert iceconnectionstate to connectionstate for Firefox.

[1.0.11] - 2022-11-12

* Change MediaStream.clone to async.

[1.0.10] - 2022-11-02

* Update MediaRecorder interface.

[1.0.9] - 2022-10-10

* Use RTCPeerConnection::onConnectionStateChange.

--------------------------------------------
[1.0.8] - 2022-09-06

* Bump version for webrtc-interface.

[1.0.7] - 2022-08-04

* Bump version for webrtc-interface.

[1.0.6] - 2022-05-08

* Support null tracks in replaceTrack/setTrack.

[1.0.5] - 2022-03-31

* Added RTCDataChannel.id

[1.0.4] - 2022-02-07

* Add restartIce.
* Bump version for webrtc-interface.

[1.0.3] - 2021-12-28

* export media_stream_impl.dart to fix do not import impl files.

[1.0.2] - 2021-11-27

* Fix the type error of minified function in release mode.

[1.0.1] - 2021-11-25

* Bump interface version to 1.0.1
* Reduce code.

1.0.0

* Refactor using webrtc_interface.

0.2.3

* Fix bug for simulcast.

0.2.2

* Fix bug for unified-plan.

0.2.1

* Fix getStats.

0.2.0

* Implement basic functions.

0.1.0

* First working version.

0.0.1

* Initial version, created by Stagehand
