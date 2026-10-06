import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import '../call/fixtures/data.dart';

void main() {
  test('toCallMembers takes each member name and image from their user', () {
    final base = SampleCallData.createCallMetadata(
      members: const {
        'alice': CallMember(userId: 'alice', roles: ['host'], custom: {}),
        'bob': CallMember(userId: 'bob', roles: ['user'], custom: {}),
      },
    );
    final metadata = CallMetadata(
      cid: base.cid,
      details: base.details,
      settings: base.settings,
      session: base.session,
      members: base.members,
      users: const {
        'bob': CallUser(id: 'bob', name: 'Bob', roles: [], image: 'bob.png'),
        'alice': CallUser(
          id: 'alice',
          name: 'Alice',
          roles: [],
          image: 'alice.png',
        ),
      },
    );

    final members = metadata.toCallMembers();

    expect(
      members.map((m) => (m.userId, m.name, m.image)),
      [
        ('alice', 'Alice', 'alice.png'),
        ('bob', 'Bob', 'bob.png'),
      ],
    );
  });

  test('toCallMembers names a member without a user by their id', () {
    final metadata = SampleCallData.createCallMetadata(
      members: const {
        'carol': CallMember(userId: 'carol', roles: ['user'], custom: {}),
      },
    );

    final member = metadata.toCallMembers().single;

    expect(member.name, 'carol');
    expect(member.image, isNull);
  });
}
