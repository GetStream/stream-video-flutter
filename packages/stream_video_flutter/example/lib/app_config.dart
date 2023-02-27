import 'package:stream_video/stream_video.dart';

import 'env/env.dart';
import 'sample_user.dart';

final sampleUsers = <SampleUser>[
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId00,
      name: Env.sampleUserName00,
      role: Env.sampleUserRole00,
      imageUrl: Env.sampleUserImage00,
    ),
    Env.sampleUserVideoToken00,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId01,
      name: Env.sampleUserName01,
      role: Env.sampleUserRole01,
      imageUrl: Env.sampleUserImage01,
    ),
    Env.sampleUserVideoToken01,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId02,
      name: Env.sampleUserName02,
      role: Env.sampleUserRole02,
      imageUrl: Env.sampleUserImage02,
    ),
    Env.sampleUserVideoToken02,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId03,
      name: Env.sampleUserName03,
      role: Env.sampleUserRole03,
      imageUrl: Env.sampleUserImage03,
    ),
    Env.sampleUserVideoToken03,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId04,
      name: Env.sampleUserName04,
      role: Env.sampleUserRole04,
      imageUrl: Env.sampleUserImage04,
    ),
    Env.sampleUserVideoToken04,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId05,
      name: Env.sampleUserName05,
      role: Env.sampleUserRole05,
      imageUrl: Env.sampleUserImage05,
    ),
    Env.sampleUserVideoToken05,
  ),
];
