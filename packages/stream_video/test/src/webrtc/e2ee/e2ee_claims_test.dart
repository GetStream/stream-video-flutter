import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/e2ee/e2ee_claims.dart';
import 'package:stream_video/stream_video.dart';

class _MockEncryptionManager extends Mock implements EncryptionManager {}

void main() {
  final cidA = StreamCallCid.from(
    id: 'call-a',
    type: StreamCallType.defaultType(),
  );
  final cidB = StreamCallCid.from(
    id: 'call-b',
    type: StreamCallType.defaultType(),
  );

  late E2eeClaims claims;
  late EncryptionManager manager;
  final owner = Object();
  final otherOwner = Object();

  setUp(() {
    claims = E2eeClaims();
    manager = _MockEncryptionManager();
  });

  test('an owner can claim a cid, and claim it again', () {
    claims.claim(cidA, owner, manager);

    expect(() => claims.claim(cidA, owner, manager), returnsNormally);
  });

  test('refuses another owner for a claimed cid', () {
    claims.claim(cidA, owner, manager);

    expect(
      () => claims.claim(cidA, otherOwner, _MockEncryptionManager()),
      throwsStateError,
    );
  });

  test('refuses a claimed manager under another cid', () {
    claims.claim(cidA, owner, manager);

    expect(() => claims.claim(cidB, otherOwner, manager), throwsStateError);
  });

  test('a release by someone else leaves the claim', () {
    claims
      ..claim(cidA, owner, manager)
      ..release(cidA, otherOwner);

    expect(
      () => claims.claim(cidA, otherOwner, _MockEncryptionManager()),
      throwsStateError,
    );
  });

  test('a release by the owner frees the cid and the manager', () {
    claims
      ..claim(cidA, owner, manager)
      ..release(cidA, owner);

    expect(
      () => claims
        ..claim(cidA, otherOwner, _MockEncryptionManager())
        ..claim(cidB, owner, manager),
      returnsNormally,
    );
  });

  test('reset drops every claim', () {
    claims
      ..claim(cidA, owner, manager)
      ..reset();

    expect(
      () => claims
        ..claim(cidA, otherOwner, _MockEncryptionManager())
        ..claim(cidB, owner, manager),
      returnsNormally,
    );
  });
}
