import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'env/env.dart';
import 'sample_user.dart';

final sampleUsers = <SampleUser>[
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId00,
      name: Env.sampleUserName00,
      role: Env.sampleUserRole00,
      image: Env.sampleUserImage00,
    ),
    Env.sampleUserVideoToken00,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId01,
      name: Env.sampleUserName01,
      role: Env.sampleUserRole01,
      image: Env.sampleUserImage01,
    ),
    Env.sampleUserVideoToken01,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId02,
      name: Env.sampleUserName02,
      role: Env.sampleUserRole02,
      image: Env.sampleUserImage02,
    ),
    Env.sampleUserVideoToken02,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId03,
      name: Env.sampleUserName03,
      role: Env.sampleUserRole03,
      image: Env.sampleUserImage03,
    ),
    Env.sampleUserVideoToken03,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId04,
      name: Env.sampleUserName04,
      role: Env.sampleUserRole04,
      image: Env.sampleUserImage04,
    ),
    Env.sampleUserVideoToken04,
  ),
  SampleUser(
    const UserInfo(
      id: Env.sampleUserId05,
      name: Env.sampleUserName05,
      role: Env.sampleUserRole05,
      image: Env.sampleUserImage05,
    ),
    Env.sampleUserVideoToken05,
  ),
];
