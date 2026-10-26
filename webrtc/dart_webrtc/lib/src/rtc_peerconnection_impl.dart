import 'dart:async';
import 'dart:collection';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:dart_webrtc/dart_webrtc.dart';
import 'package:web/web.dart' as web;

import 'rtc_data_channel_impl.dart';
import 'rtc_dtmf_sender_impl.dart';
import 'rtc_rtp_receiver_impl.dart';
import 'rtc_rtp_sender_impl.dart';
import 'rtc_rtp_transceiver_impl.dart';

extension on web.RTCDataChannelInit {
  external set binaryType(String value);
}

/*
 *  PeerConnection
 */
class RTCPeerConnectionWeb extends RTCPeerConnection {
  RTCPeerConnectionWeb(this._peerConnectionId, this._jsPc) {
    final toDataChannel = (web.RTCDataChannelEvent dataChannelEvent) {
      onDataChannel?.call(RTCDataChannelWeb(dataChannelEvent.channel));
    };

    final onIceCandidateCb = (web.RTCPeerConnectionIceEvent iceEvent) {
      if (iceEvent.candidate != null) {
        onIceCandidate?.call(_iceFromJs(iceEvent.candidate!));
      }
    };

    _jsPc.addEventListener('datachannel', toDataChannel.toJS);

    _jsPc.addEventListener('icecandidate', onIceCandidateCb.toJS);

    var onIceConnectionStateChange = (JSAny _) {
      _iceConnectionState =
          iceConnectionStateForString(_jsPc.iceConnectionState);
      onIceConnectionState?.call(_iceConnectionState!);

      if (web.Device.isFirefox) {
        switch (_iceConnectionState!) {
          case RTCIceConnectionState.RTCIceConnectionStateNew:
            _connectionState = RTCPeerConnectionState.RTCPeerConnectionStateNew;
            break;
          case RTCIceConnectionState.RTCIceConnectionStateChecking:
            _connectionState =
                RTCPeerConnectionState.RTCPeerConnectionStateConnecting;
            break;
          case RTCIceConnectionState.RTCIceConnectionStateConnected:
            _connectionState =
                RTCPeerConnectionState.RTCPeerConnectionStateConnected;
            break;
          case RTCIceConnectionState.RTCIceConnectionStateFailed:
            _connectionState =
                RTCPeerConnectionState.RTCPeerConnectionStateFailed;
            break;
          case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
            _connectionState =
                RTCPeerConnectionState.RTCPeerConnectionStateDisconnected;
            break;
          case RTCIceConnectionState.RTCIceConnectionStateClosed:
            _connectionState =
                RTCPeerConnectionState.RTCPeerConnectionStateClosed;
            break;
          default:
            break;
        }
        onConnectionState?.call(_connectionState!);
      }
    };

    _jsPc.addEventListener(
        'iceconnectionstatechange', onIceConnectionStateChange.toJS);

    var onIceGatheringStateChange = (JSAny _) {
      _iceGatheringState = iceGatheringStateforString(_jsPc.iceGatheringState);
      onIceGatheringState?.call(_iceGatheringState!);
    };

    _jsPc.onicegatheringstatechange = onIceGatheringStateChange.toJS;

    var onSignalingStateChange = (JSAny _) {
      _signalingState = signalingStateForString(_jsPc.signalingState);
      onSignalingState?.call(_signalingState!);
    };

    _jsPc.addEventListener('signalingstatechange', onSignalingStateChange.toJS);

    if (!web.Device.isFirefox) {
      final onConnectionStateChange = (JSAny _) {
        _connectionState = peerConnectionStateForString(_jsPc.connectionState);
        onConnectionState?.call(_connectionState!);
      };
      _jsPc.addEventListener(
          'connectionstatechange', onConnectionStateChange.toJS);
    }

    var onNegotationNeeded = (JSAny _) {
      onRenegotiationNeeded?.call();
    };

    _jsPc.addEventListener('negotiationneeded', onNegotationNeeded.toJS);

    var onTrackEvent = (web.RTCTrackEvent trackEvent) {
      onTrack?.call(
        RTCTrackEvent(
            track: MediaStreamTrackWeb(trackEvent.track),
            receiver: RTCRtpReceiverWeb(trackEvent.receiver),
            transceiver:
                RTCRtpTransceiverWeb.fromJsObject(trackEvent.transceiver),
            streams: trackEvent.streams.toDart
                .map((dynamic stream) =>
                    MediaStreamWeb(stream, _peerConnectionId))
                .toList()),
      );
    };
    _jsPc.addEventListener('track', onTrackEvent.toJS);
  }

  final String _peerConnectionId;
  late final web.RTCPeerConnection _jsPc;
  final _localStreams = <String, MediaStream>{};
  final _configuration = <String, dynamic>{};

  RTCSignalingState? _signalingState;
  RTCIceGatheringState? _iceGatheringState;
  RTCIceConnectionState? _iceConnectionState;
  RTCPeerConnectionState? _connectionState;

  @override
  RTCSignalingState? get signalingState => _signalingState;

  @override
  Future<RTCSignalingState?> getSignalingState() async {
    _signalingState = signalingStateForString(_jsPc.signalingState);
    return signalingState;
  }

  @override
  RTCIceGatheringState? get iceGatheringState => _iceGatheringState;

  @override
  Future<RTCIceGatheringState?> getIceGatheringState() async {
    _iceGatheringState = iceGatheringStateforString(_jsPc.iceGatheringState);
    return _iceGatheringState;
  }

  @override
  RTCIceConnectionState? get iceConnectionState => _iceConnectionState;

  @override
  Future<RTCIceConnectionState?> getIceConnectionState() async {
    _iceConnectionState = iceConnectionStateForString(_jsPc.iceConnectionState);
    if (web.Device.isFirefox) {
      switch (_iceConnectionState!) {
        case RTCIceConnectionState.RTCIceConnectionStateNew:
          _connectionState = RTCPeerConnectionState.RTCPeerConnectionStateNew;
          break;
        case RTCIceConnectionState.RTCIceConnectionStateChecking:
          _connectionState =
              RTCPeerConnectionState.RTCPeerConnectionStateConnecting;
          break;
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
          _connectionState =
              RTCPeerConnectionState.RTCPeerConnectionStateConnected;
          break;
        case RTCIceConnectionState.RTCIceConnectionStateFailed:
          _connectionState =
              RTCPeerConnectionState.RTCPeerConnectionStateFailed;
          break;
        case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
          _connectionState =
              RTCPeerConnectionState.RTCPeerConnectionStateDisconnected;
          break;
        case RTCIceConnectionState.RTCIceConnectionStateClosed:
          _connectionState =
              RTCPeerConnectionState.RTCPeerConnectionStateClosed;
          break;
        default:
          break;
      }
    }
    return _iceConnectionState;
  }

  @override
  RTCPeerConnectionState? get connectionState => _connectionState;

  @override
  Future<RTCPeerConnectionState?> getConnectionState() async {
    /// platform is Firefox
    if (web.Device.isFirefox) {
      await getIceConnectionState();
    } else {
      _connectionState = peerConnectionStateForString(_jsPc.connectionState);
    }
    return _connectionState;
  }

  @override
  Future<void> dispose() {
    _jsPc.close();
    return Future.value();
  }

  @override
  Map<String, dynamic> get getConfiguration => _configuration;

  @override
  Future<void> setConfiguration(Map<String, dynamic> configuration) {
    _configuration.addAll(configuration);
    _jsPc.setConfiguration(configuration.jsify() as web.RTCConfiguration);
    return Future.value();
  }

  @override
  Future<RTCSessionDescription> createOffer(
      [Map<String, dynamic>? constraints]) async {
    final args = <String, dynamic>{};
    if (constraints != null) {
      for (var key in constraints.keys) {
        args[key] = constraints[key];
      }
    }
    final desc = await _jsPc.createOffer(args.jsify() as JSObject).toDart;

    return RTCSessionDescription(desc!.sdp, desc.type);
  }

  @override
  Future<RTCSessionDescription> createAnswer(
      [Map<String, dynamic>? constraints]) async {
    final args = <String, dynamic>{};
    if (constraints != null) {
      for (var key in constraints.keys) {
        args[key] = constraints[key];
      }
    }
    final desc = await _jsPc.createAnswer(args.jsify() as JSObject).toDart;
    return RTCSessionDescription(desc!.sdp, desc.type);
  }

  @override
  Future<void> addStream(MediaStream stream) {
    var _native = stream as MediaStreamWeb;
    _localStreams.putIfAbsent(
        stream.id, () => MediaStreamWeb(_native.jsStream, _peerConnectionId));

    _jsPc.addStream(stream.jsStream);

    return Future.value();
  }

  @override
  Future<void> removeStream(MediaStream stream) async {
    var _native = stream as MediaStreamWeb;
    _localStreams.remove(stream.id);
    _jsPc.removeStream(_native.jsStream);
    return Future.value();
  }

  @override
  Future<void> setLocalDescription(RTCSessionDescription description) async {
    await _jsPc
        .setLocalDescription(web.RTCLocalSessionDescriptionInit(
          type: description.type!,
          sdp: description.sdp!,
        ))
        .toDart;
  }

  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await _jsPc
        .setRemoteDescription(web.RTCSessionDescriptionInit(
          type: description.type!,
          sdp: description.sdp!,
        ))
        .toDart;
  }

  @override
  Future<RTCSessionDescription?> getLocalDescription() async {
    if (null == _jsPc.localDescription) {
      return null;
    }
    return _sessionFromJs(_jsPc.localDescription);
  }

  @override
  Future<RTCSessionDescription?> getRemoteDescription() async {
    if (null == _jsPc.remoteDescription) {
      return null;
    }
    return _sessionFromJs(_jsPc.remoteDescription);
  }

  @override
  Future<void> addCandidate(RTCIceCandidate candidate) async {
    await _jsPc
        .addIceCandidate(web.RTCIceCandidateInit(
            candidate: candidate.candidate!,
            sdpMid: candidate.sdpMid!,
            sdpMLineIndex: candidate.sdpMLineIndex))
        .toDart;
  }

  @override
  Future<List<StatsReport>> getStats([MediaStreamTrack? track]) async {
    web.RTCStatsReport stats;
    if (track != null) {
      var jsTrack = (track as MediaStreamTrackWeb).jsTrack;
      stats = await _jsPc.getStats(jsTrack).toDart;
    } else {
      stats = await _jsPc.getStats().toDart;
    }

    var report = <StatsReport>[];
    stats.callMethodVarArgs('forEach'.toJS, [
      (JSObject value, JSAny key) {
        var map = value.dartify() as LinkedHashMap<Object?, Object?>;
        var stats = <String, dynamic>{};
        for (var entry in map.entries) {
          stats[entry.key.toString()] = entry.value;
        }
        report.add(StatsReport(
            value.getProperty<JSString>('id'.toJS).toDart,
            value.getProperty<JSString>('type'.toJS).toDart,
            value.getProperty<JSNumber>('timestamp'.toJS).toDartDouble,
            stats));
      }.toJS,
    ]);
    return report;
  }

  @override
  List<MediaStream> getLocalStreams() =>
      _jsPc.getLocalStreams().toDart.map((e) => _localStreams[e.id]!).toList();

  @override
  List<MediaStream> getRemoteStreams() => _jsPc
      .getRemoteStreams()
      .toDart
      .map((e) => MediaStreamWeb(e, _peerConnectionId))
      .toList();

  @override
  Future<RTCDataChannel> createDataChannel(
      String label, RTCDataChannelInit dataChannelDict) {
    var dcInit = web.RTCDataChannelInit(
      id: dataChannelDict.id,
      ordered: dataChannelDict.ordered,
      protocol: dataChannelDict.protocol,
      negotiated: dataChannelDict.negotiated,
    );

    if (dataChannelDict.binaryType == 'binary') {
      dcInit.binaryType = 'arraybuffer'; // Avoid Blob in data channel
    }

    if (dataChannelDict.maxRetransmits > 0) {
      dcInit.maxRetransmits = dataChannelDict.maxRetransmits;
    }

    if (dataChannelDict.maxRetransmitTime > 0) {
      dcInit.maxPacketLifeTime = dataChannelDict.maxRetransmitTime;
    }

    final jsDc = _jsPc.createDataChannel(
      label,
      dcInit,
    );

    return Future.value(RTCDataChannelWeb(jsDc));
  }

  @override
  Future<void> restartIce() {
    _jsPc.restartIce();
    return Future.value();
  }

  @override
  Future<void> close() async {
    _jsPc.close();
    return Future.value();
  }

  @override
  RTCDTMFSender createDtmfSender(MediaStreamTrack track) {
    var _native = track as MediaStreamTrackWeb;
    var jsDtmfSender = _jsPc.createDTMFSender(_native.jsTrack);
    return RTCDTMFSenderWeb(jsDtmfSender);
  }

  //
  // utility section
  //

  RTCIceCandidate _iceFromJs(web.RTCIceCandidate candidate) => RTCIceCandidate(
        candidate.candidate,
        candidate.sdpMid,
        candidate.sdpMLineIndex,
      );

  RTCSessionDescription _sessionFromJs(web.RTCSessionDescription? sd) =>
      RTCSessionDescription(sd?.sdp, sd?.type);

  @override
  Future<RTCRtpSender> addTrack(MediaStreamTrack track,
      [MediaStream? stream]) async {
    var jStream = (stream as MediaStreamWeb).jsStream;
    var jsTrack = (track as MediaStreamTrackWeb).jsTrack;
    var sender = _jsPc.addTrack(jsTrack, jStream);
    return RTCRtpSenderWeb.fromJsSender(sender);
  }

  @override
  Future<bool> removeTrack(RTCRtpSender sender) async {
    var nativeSender = sender as RTCRtpSenderWeb;
    // var nativeTrack = nativeSender.track as MediaStreamTrackWeb;
    _jsPc.removeTrack(nativeSender.jsRtpSender);
    return Future<bool>.value(true);
  }

  @override
  Future<List<RTCRtpSender>> getSenders() async {
    var senders = _jsPc.getSenders();
    var list = <RTCRtpSender>[];
    for (var e in senders.toDart) {
      list.add(RTCRtpSenderWeb.fromJsSender(e));
    }
    return list;
  }

  @override
  Future<List<RTCRtpReceiver>> getReceivers() async {
    var receivers = _jsPc.getReceivers();

    var list = <RTCRtpReceiver>[];
    for (var e in receivers.toDart) {
      list.add(RTCRtpReceiverWeb(e));
    }

    return list;
  }

  @override
  Future<List<RTCRtpTransceiver>> getTransceivers() async {
    var transceivers = _jsPc.getTransceivers();

    var list = <RTCRtpTransceiver>[];
    for (var e in transceivers.toDart) {
      list.add(RTCRtpTransceiverWeb.fromJsObject(e));
    }

    return list;
  }

  //'audio|video', { 'direction': 'recvonly|sendonly|sendrecv' }
  //
  // https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/addTransceiver
  //
  @override
  Future<RTCRtpTransceiver> addTransceiver({
    MediaStreamTrack? track,
    RTCRtpMediaType? kind,
    RTCRtpTransceiverInit? init,
  }) async {
    final jsTrack = track is MediaStreamTrackWeb ? track.jsTrack : null;
    final kindString = kind != null ? typeRTCRtpMediaTypetoString[kind] : null;
    final trackOrKind = jsTrack ?? kindString;
    assert(trackOrKind != null, 'track or kind must not be null');

    final transceiver = init != null
        ? _jsPc.addTransceiver(trackOrKind.jsify()!,
            init.toJsObject() as web.RTCRtpTransceiverInit)
        : _jsPc.addTransceiver(trackOrKind.jsify()!);

    return RTCRtpTransceiverWeb.fromJsObject(
      transceiver,
      peerConnectionId: _peerConnectionId,
    );
  }
}

extension _AddRemoveStream on web.RTCPeerConnection {
  external void addStream(web.MediaStream stream);

  external void removeStream(web.MediaStream stream);

  external JSArray<web.MediaStream> getLocalStreams();
  external JSArray<web.MediaStream> getRemoteStreams();

  external web.RTCDTMFSender createDTMFSender(web.MediaStreamTrack track);
}
