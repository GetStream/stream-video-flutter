import 'package:meta/meta.dart';

/// How frames reach the E2EE worker in a browser.
@internal
enum EncodedTransformApi {
  /// The standard `RTCRtpScriptTransform`.
  script,

  /// Chrome's `createEncodedStreams`, which only works on a peer connection
  /// created with `encodedInsertableStreams: true`.
  insertableStreams,
}

/// The encoded-transform API this browser uses for end-to-end encryption, or
/// `null` where it has neither.
///
/// Chrome takes insertable streams even where it has `RTCRtpScriptTransform`,
/// whose support there is not reliable enough for encryption yet.
@internal
EncodedTransformApi? encodedTransformApiFor({
  required String userAgent,
  required bool hasScriptTransform,
  required bool hasInsertableStreams,
}) {
  if (userAgent.contains('Chrome') && hasInsertableStreams) {
    return EncodedTransformApi.insertableStreams;
  }
  if (hasScriptTransform) return EncodedTransformApi.script;
  return hasInsertableStreams ? EncodedTransformApi.insertableStreams : null;
}
