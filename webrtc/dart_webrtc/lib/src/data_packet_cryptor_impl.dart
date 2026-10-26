import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

import 'e2ee.worker/e2ee.logger.dart';
import 'event.dart';
import 'frame_cryptor_impl.dart' show KeyProviderImpl, WorkerResponse;
import 'utils.dart';

class DataPacketCryptorImpl implements DataPacketCryptor {
  DataPacketCryptorImpl({
    required this.keyProvider,
    required this.algorithm,
  });

  final KeyProviderImpl keyProvider;
  final Algorithm algorithm;
  web.Worker get worker => keyProvider.worker;
  final String _dataCryptorId = randomString(24);
  EventsEmitter<WorkerResponse> get events => keyProvider.events;

  @override
  Future<EncryptedPacket> encrypt({
    required String participantId,
    required int keyIndex,
    required Uint8List data,
  }) async {
    var msgId = randomString(12);
    worker.postMessage(
      {
        'msgType': 'dataCryptorEncrypt',
        'msgId': msgId,
        'keyProviderId': keyProvider.id,
        'dataCryptorId': _dataCryptorId,
        'participantId': participantId,
        'keyIndex': keyIndex,
        'data': data,
        'algorithm': algorithm.name,
      }.jsify(),
    );

    var res = await events.waitFor<WorkerResponse>(
      filter: (event) {
        logger.fine('waiting for encrypt on msg: $msgId');
        return event.msgId == msgId;
      },
      duration: Duration(seconds: 5),
      onTimeout: () => throw Exception('waiting for encrypt on msg timed out'),
    );

    return EncryptedPacket(
      data: res.data['data'] as Uint8List,
      keyIndex: res.data['keyIndex'] as int,
      iv: res.data['iv'] as Uint8List,
    );
  }

  @override
  Future<Uint8List> decrypt({
    required String participantId,
    required EncryptedPacket encryptedPacket,
  }) async {
    var msgId = randomString(12);
    worker.postMessage(
      {
        'msgType': 'dataCryptorDecrypt',
        'msgId': msgId,
        'keyProviderId': keyProvider.id,
        'dataCryptorId': _dataCryptorId,
        'participantId': participantId,
        'keyIndex': encryptedPacket.keyIndex,
        'data': encryptedPacket.data,
        'iv': encryptedPacket.iv,
        'algorithm': algorithm.name,
      }.jsify(),
    );

    var res = await events.waitFor<WorkerResponse>(
      filter: (event) {
        logger.fine('waiting for decrypt on msg: $msgId');
        return event.msgId == msgId;
      },
      duration: Duration(seconds: 5),
      onTimeout: () => throw Exception('waiting for decrypt on msg timed out'),
    );

    return res.data['data'] as Uint8List;
  }

  @override
  Future<void> dispose() async {
    var msgId = randomString(12);
    worker.postMessage(
      {
        'msgType': 'dataCryptorDispose',
        'msgId': msgId,
        'dataCryptorId': _dataCryptorId
      }.jsify(),
    );

    await events.waitFor<WorkerResponse>(
      filter: (event) {
        logger.fine('waiting for dispose on msg: $msgId');
        return event.msgId == msgId;
      },
      duration: Duration(seconds: 5),
      onTimeout: () => throw Exception('waiting for dispose on msg timed out'),
    );
  }
}

class DataPacketCryptorFactoryImpl implements DataPacketCryptorFactory {
  DataPacketCryptorFactoryImpl._internal();

  static final DataPacketCryptorFactoryImpl instance =
      DataPacketCryptorFactoryImpl._internal();
  @override
  Future<DataPacketCryptor> createDataPacketCryptor(
      {required Algorithm algorithm, required KeyProvider keyProvider}) async {
    return Future.value(DataPacketCryptorImpl(
        algorithm: algorithm, keyProvider: keyProvider as KeyProviderImpl));
  }
}

DataPacketCryptorFactory get dataPacketCryptorFactory =>
    DataPacketCryptorFactoryImpl.instance;
