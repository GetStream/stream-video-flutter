/// Centralized keys used as the `tag` of `Tracer.trace` calls when reporting
/// SFU / WebRTC events.
abstract class TraceTag {
  const TraceTag._();

  // Call lifecycle
  static const String callAccept = 'call.accept';
  static const String callReject = 'call.reject';
  static const String callJoinMigrate = 'callJoin.migrate';
  static const String pcReconnectionNeeded = 'pc.reconnectionNeeded';
  static const String sfuSocketDisconnected = 'sfuSocket.disconnected';
  static const String sfuSocketFailed = 'sfuSocket.failed';
  static const String sfuSocketGoAway = 'sfuSocket.goAway';
  static const String sfuSocketError = 'sfuSocket.error';
  static const String callReconnect = 'callReconnect';
  static const String callReconnectFailed = 'callReconnectFailed';
  static const String callReconnectSuccess = 'callReconnectSuccess';
  static const String awaitNetworkUnstable = 'awaitNetwork.unstable';

  // Device stats
  static const String deviceThermalState = 'device.thermalState';
  static const String deviceLowPowerMode = 'device.lowPowerMode';

  // Call session
  static const String networkChanged = 'network.changed';
  static const String joinRequest = 'joinRequest';
  static const String joinRequestTimeout = 'joinRequest.timeout';
  static const String fastReconnect = 'fastReconnect';
  static const String fastReconnectSuccess = 'fastReconnect.success';
  static const String fastReconnectFailure = 'fastReconnect.failure';
  static const String publisherConnectionCheckStalled =
      'publisherConnectionCheck.stalled';
  static const String callLeave = 'call.leaveReason';
  static const String trackPublished = 'trackPublished';
  static const String trackUnpublished = 'trackUnpublished';
  static const String changePublishQuality = 'changePublishQuality';
  static const String changePublishOptions = 'changePublishOptions';
  static const String goAway = 'goAway';
  static const String error = 'error';
  static const String callEnded = 'call.ended';
  static const String connectionQualityChanged = 'connectionQualityChanged';
  static const String inboundVideoState = 'inboundVideoState';

  // SFU signaling RPCs
  static const String sendAnswer = 'sendAnswer';
  static const String sendAnswerFailure = 'sendAnswer.failure';
  static const String iceTrickle = 'iceTrickle';
  static const String iceTrickleFailure = 'iceTrickle.failure';
  static const String iceRestart = 'iceRestart';
  static const String iceRestartFailure = 'iceRestart.failure';
  static const String setPublisher = 'setPublisher';
  static const String setPublisherFailure = 'setPublisher.failure';
  static const String updateMuteStates = 'updateMuteStates';
  static const String updateMuteStatesFailure = 'updateMuteStates.failure';
  static const String updateSubscriptions = 'updateSubscriptions';
  static const String updateSubscriptionsFailure =
      'updateSubscriptions.failure';
  static const String startNoiseCancellation = 'startNoiseCancellation';
  static const String startNoiseCancellationFailure =
      'startNoiseCancellation.failure';
  static const String stopNoiseCancellation = 'stopNoiseCancellation';
  static const String stopNoiseCancellationFailure =
      'stopNoiseCancellation.failure';

  // Peer connection events
  static const String negotiationNeeded = 'negotiationneeded';
  static const String iceConnectionStateChange = 'iceconnectionstatechange';
  static const String onIceCandidate = 'onicecandidate';
  static const String onTrack = 'ontrack';
  static const String iceGatheringStateChange = 'icegatheringstatechange';
  static const String signalingStateChange = 'signalingstatechange';
  static const String connectionStateChange = 'connectionstatechange';
  static const String dataChannel = 'datachannel';
  static const String getStats = 'getstats';
  static const String createOffer = 'createOffer';
  static const String createOfferSuccess = 'createOffer.success';
  static const String createOfferFailure = 'createOffer.failure';
  static const String createAnswer = 'createAnswer';
  static const String createAnswerSuccess = 'createAnswer.success';
  static const String createAnswerFailure = 'createAnswer.failure';
  static const String setRemoteDescription = 'setRemoteDescription';
  static const String setRemoteDescriptionSuccess =
      'setRemoteDescription.success';
  static const String setRemoteDescriptionError = 'setRemoteDescription.error';
  static const String setLocalDescription = 'setLocalDescription';
  static const String setLocalDescriptionSuccess =
      'setLocalDescription.success';
  static const String setLocalDescriptionError = 'setLocalDescription.error';
  static const String addIceCandidate = 'addIceCandidate';
  static const String addIceCandidateSuccess = 'addIceCandidate.success';
  static const String addIceCandidateError = 'addIceCandidate.error';

  // Peer connection factory
  static const String create = 'create';

  // Media devices
  static const String audioProcessingStateChanged =
      'audioProcessingStateChanged';
  static const String enumerateDevices =
      'navigator.mediaDevices.enumeratedevices';
  static const String pauseAudioPlayout =
      'navigator.mediaDevices.pauseAudioPlayout';
  static const String resumeAudioPlayout =
      'navigator.mediaDevices.resumeAudioPlayout';
  static const String regainAndroidAudioFocus =
      'navigator.mediaDevices.regainAndroidAudioFocus';

  // Media constraints
  static const String getDisplayMedia =
      'navigator.mediaDevices.getDisplayMedia';
  static const String getUserMedia = 'navigator.mediaDevices.getUserMedia';
}
