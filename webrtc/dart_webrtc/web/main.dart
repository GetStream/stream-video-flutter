import 'dart:async';
import 'dart:typed_data';

import 'package:dart_webrtc/dart_webrtc.dart';
import 'package:web/web.dart' as web;

/*
import 'test_media_devices.dart' as media_devices_tests;
import 'test_media_stream.dart' as media_stream_tests;
import 'test_media_stream_track.dart' as media_stream_track_tests;
import 'test_peerconnection.dart' as peerconnection_tests;
import 'test_video_element.dart' as video_elelment_tests;
*/
void main() {
  /*
  video_elelment_tests.testFunctions.forEach((Function func) => func());
  media_devices_tests.testFunctions.forEach((Function func) => func());
  media_stream_tests.testFunctions.forEach((Function func) => func());
  media_stream_track_tests.testFunctions.forEach((Function func) => func());
  peerconnection_tests.testFunctions.forEach((Function func) => func());
  */

  loopBackTest();
}

List<FrameCryptor> pc1FrameCryptors = [];
List<FrameCryptor> pc2FrameCryptors = [];

void loopBackTest() async {
  var local = web.document.querySelector('#local');
  var localVideo = RTCVideoElement();
  local!.append(localVideo.htmlElement);

  var remote = web.document.querySelector('#remote');
  var remotelVideo = RTCVideoElement();
  remote!.append(remotelVideo.htmlElement);

  var acaps = await getRtpSenderCapabilities('audio');
  print('sender audio capabilities: ${acaps.toMap()}');

  var vcaps = await getRtpSenderCapabilities('video');
  print('sender video capabilities: ${vcaps.toMap()}');

  var enableE2EE = true;

  var acapabilities = await getRtpReceiverCapabilities('audio');
  print('receiver audio capabilities: ${acapabilities.toMap()}');

  var vcapabilities = await getRtpReceiverCapabilities('video');
  print('receiver video capabilities: ${vcapabilities.toMap()}');

  var keyProviderOptions = KeyProviderOptions(
      sharedKey: false,
      ratchetWindowSize: 16,
      failureTolerance: -1,
      ratchetSalt: Uint8List.fromList('testSalt'.codeUnits),
      discardFrameWhenCryptorNotReady: true);
  var keyProviderForSender =
      await frameCryptorFactory.createDefaultKeyProvider(keyProviderOptions);

  var keyProviderForReceiver =
      await frameCryptorFactory.createDefaultKeyProvider(keyProviderOptions);

  await keyProviderForSender.setKey(
      participantId: 'sender',
      index: 0,
      key: Uint8List.fromList('testkey'.codeUnits));

  await keyProviderForReceiver.setKey(
      participantId: 'receiver',
      index: 0,
      key: Uint8List.fromList('testkey'.codeUnits));

  var pc2 =
      await createPeerConnection({'encodedInsertableStreams': enableE2EE});

  pc2.onTrack = (event) async {
    if (event.track.kind == 'video') {
      remotelVideo.srcObject = event.streams[0];
    }
    if (enableE2EE) {
      var fc = await frameCryptorFactory.createFrameCryptorForRtpReceiver(
          participantId: 'receiver',
          receiver: event.receiver!,
          algorithm: Algorithm.kAesGcm,
          keyProvider: keyProviderForReceiver);
      if (keyProviderOptions.discardFrameWhenCryptorNotReady) {
        Timer(Duration(seconds: 1), () {
          fc.setEnabled(true);
        });
      } else {
        await fc.setEnabled(true);
      }

      fc.onFrameCryptorStateChanged = (id, state) {
        print('receiver: frameCryptorStateChanged: $state');
      };

      await fc.setKeyIndex(0);
      if (event.track.kind == 'video') {
        await fc.updateCodec('vp8');
      }
      pc2FrameCryptors.add(fc);
    }
  };
  pc2.onConnectionState = (state) {
    print('connectionState $state');
  };

  pc2.onIceConnectionState = (state) {
    print('iceConnectionState $state');
  };

  var pc1 =
      await createPeerConnection({'encodedInsertableStreams': enableE2EE});

  pc1.onIceCandidate = (candidate) => pc2.addCandidate(candidate);
  pc2.onIceCandidate = (candidate) => pc1.addCandidate(candidate);

  var stream =
      await navigator.mediaDevices.getUserMedia({'audio': true, 'video': true});
  /*.getUserMedia(MediaStreamConstraints(audio: true, video: true))*/
  print('getDisplayMedia: stream.id => ${stream.id}');

  navigator.mediaDevices.ondevicechange = (event) async {
    var list = await navigator.mediaDevices.enumerateDevices();
    print('ondevicechange: ');
    list.where((element) => element.kind == 'audiooutput').forEach((e) {
      print('${e.runtimeType}: ${e.label}, type => ${e.kind}');
    });
  };
  /*
  var list = await navigator.mediaDevices.enumerateDevices();
  list.forEach((e) {
    print('${e.runtimeType}: ${e.label}, type => ${e.kind}');
  });
  var outputList = list.where((element) => element.kind == 'audiooutput');
  if (outputList.isNotEmpty) {
    var sinkId = outputList.last.deviceId;
    try {
      await navigator.mediaDevices
          .selectAudioOutput(AudioOutputOptions(deviceId: sinkId));
    } catch (e) {
      print('selectAudioOutput error: ${e.toString()}');
      await localVideo.setSinkId(sinkId);
    }
  }*/

  stream.getTracks().forEach((track) async {
    var sender = await pc1.addTrack(track, stream);
    if (enableE2EE) {
      var fc = await frameCryptorFactory.createFrameCryptorForRtpSender(
          participantId: 'sender',
          sender: sender,
          algorithm: Algorithm.kAesGcm,
          keyProvider: keyProviderForSender);
      await fc.setEnabled(true);
      await fc.setKeyIndex(0);
      if (track.kind == 'video') {
        await fc.updateCodec('vp8');
      }
      fc.onFrameCryptorStateChanged = (id, state) {
        print('sender: frameCryptorStateChanged: $state');
      };
      pc1FrameCryptors.add(fc);
    }
  });
/*
  var transceivers = await pc1.getTransceivers();
  transceivers.forEach((transceiver) {
    print('transceiver: ${transceiver.sender.track!.kind!}');
    if (transceiver.sender.track!.kind! == 'video') {
      transceiver.setCodecPreferences(vcapabilities.codecs!
          .takeWhile(
              (element) => element.mimeType.toLowerCase() == 'video/h264')
          .toList());
    } else if (transceiver.sender.track!.kind! == 'audio') {
      transceiver.setCodecPreferences(acapabilities.codecs!
          .takeWhile(
              (element) => element.mimeType.toLowerCase() == 'audio/pcmu')
          .toList());
    }
  });
*/
  await pc1.createDataChannel(
      'label', RTCDataChannelInit()..binaryType = 'binary');
  var offer = await pc1.createOffer();

  await pc2.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly));
  await pc2.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly));

  await pc1.setLocalDescription(offer);
  await pc2.setRemoteDescription(offer);
  var answer = await pc2.createAnswer({});
  await pc2.setLocalDescription(answer);
  await pc1.setRemoteDescription(answer);

  localVideo.muted = true;
  localVideo.srcObject = stream;

  var key2 =
      await keyProviderForSender.ratchetKey(index: 0, participantId: 'sender');
  print('ratchetKey key2: ${key2.toList()}');

  await keyProviderForSender.setKey(
      index: 1,
      participantId: 'sender',
      key: Uint8List.fromList('testkey3'.codeUnits));

  await keyProviderForReceiver.setKey(
      index: 1,
      participantId: 'receiver',
      key: Uint8List.fromList('testkey3'.codeUnits));

  [...pc1FrameCryptors, ...pc2FrameCryptors].forEach((element) async {
    await element.setKeyIndex(1);
  });

  await keyProviderForSender.setKey(
      index: 2,
      participantId: 'sender',
      key: Uint8List.fromList('testkey4'.codeUnits));

  await keyProviderForReceiver.setKey(
      index: 2,
      participantId: 'receiver',
      key: Uint8List.fromList('testkey4'.codeUnits));

  [...pc1FrameCryptors, ...pc2FrameCryptors].forEach((element) async {
    await element.setKeyIndex(2);
  });

  var key =
      await keyProviderForSender.ratchetKey(index: 2, participantId: 'sender');
  print('ratchetKey key: ${key.toList()}');

  var participantId = 'participantId_1';

  await keyProviderForSender.setKey(
      participantId: participantId, index: 0, key: key);

  final dataPacketCryptor =
      await dataPacketCryptorFactory.createDataPacketCryptor(
          algorithm: Algorithm.kAesGcm, keyProvider: keyProviderForSender);

  var data = Uint8List.fromList('Hello world!'.codeUnits);
  print('plain string: ${String.fromCharCodes(data)}');
  print('plain data: $data');
  var encryptedPacket = await dataPacketCryptor.encrypt(
      participantId: participantId, keyIndex: 0, data: data);
  print(
      'encrypted data: ${encryptedPacket.data}, keyIndex: ${encryptedPacket.keyIndex}, iv: ${encryptedPacket.iv}');
  var decryptedData = await dataPacketCryptor.decrypt(
      participantId: participantId, encryptedPacket: encryptedPacket);
  print('decrypted data: $decryptedData');
  print('decrypted string: ${String.fromCharCodes(decryptedData)}');

  await dataPacketCryptor.dispose();

  /*
  var key1 =
      await keyProviderForSender.ratchetKey(index: 0, participantId: 'sender');
  print('ratchetKey key1: ${key1.toList()}');

  [...pc1FrameCryptors, ...pc2FrameCryptors].forEach((element) async {
    await element.setKeyIndex(0);
  });*/

  /*
  await keyProvider.setKey(
      index: 0,
      participantId: 'sender',
      key: Uint8List.fromList('testkey2'.codeUnits));

  */
  /*
  Timer.periodic(Duration(seconds: 1), (timer) async {
    var senders = await pc1.getSenders();
    var receivers = await pc2.getReceivers();

    print('senders: ${senders.length}');
    print('receivers: ${receivers.length}');

    senders.forEach((sender) {
      sender.getStats().then((stats) {
        print(
            'sender stats: ${stats.map((e) => 'id: ${e.id}, type:  ${e.type}, timestamp: ${e.timestamp}, values: ${e.values.toString()} ')}');
      });
    });

    receivers.forEach((receiver) {
      receiver.getStats().then((stats) {
        print(
            'receiver stats: ${stats.map((e) => 'id: ${e.id}, type:  ${e.type}, timestamp: ${e.timestamp}, values: ${e.values.toString()} ')}');
      });
    });
  });
  */
}
