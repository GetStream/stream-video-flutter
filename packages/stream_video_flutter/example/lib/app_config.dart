import 'package:stream_video/stream_video.dart';

import 'sample_user.dart';

final sampleUsers = <SampleUser>[
  SampleUser(
    const UserInfo(
      id: 'tommaso',
      role: 'admin',
      name: 'Tomasso',
      imageUrl:
          'https://getstream.io/static/712bb5c0bd5ed8d3fa6e5842f6cfbeed/c59de/tommaso.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.7siVclPhJmDVZ5SUbRXdNbgYWnO_AvtHbiKRPzvhObA',
  ),
  SampleUser(
    const UserInfo(
      id: 'thierry',
      role: 'admin',
      name: 'Thierry',
      imageUrl:
          'https://getstream.io/static/237f45f28690696ad8fff92726f45106/c59de/thierry.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGhpZXJyeSJ9.81Nhgjdnh7hnvpgqOXlGMRWkuUgCVbU-fp6gFtHymxA',
  ),
  SampleUser(
    const UserInfo(
      id: 'marcelo',
      role: 'admin',
      name: 'Marcelo',
      imageUrl:
          'https://getstream.io/static/aaf5fb17dcfd0a3dd885f62bd21b325a/802d2/marcelo-pires.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFyY2VsbyJ9.7eaqTfDEt7X_GfIyjakvAjpXpntEk4KDAtEFkB6ZcQc',
  ),
  SampleUser(
    const UserInfo(
      id: 'martin',
      role: 'admin',
      name: 'Martin',
      imageUrl:
          'https://getstream.io/static/2796a305dd07651fcceb4721a94f4505/802d2/martin-mitrevski.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFydGluIn0._oishDWVBDRRKt9VXY9RIR3Z7NunOeJkyE7mjApTux4',
  ),
  SampleUser(
    const UserInfo(
      id: 'filip',
      role: 'admin',
      name: 'Filip',
      imageUrl:
          'https://getstream.io/static/76cda49669be38b92306cfc93ca742f1/802d2/filip-babi%C4%87.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZmlsaXAifQ.NBYt9PdNrTnFFl5u2xVhZ93CCMSdM7uog-DNtb8DFAA',
  ),
  SampleUser(
    const UserInfo(
      id: 'kanat',
      role: 'admin',
      name: 'Kanat',
      imageUrl:
          'https://getstream.io/static/a4ba18b7dc1eedfa3ea4edbac74ce5e4/a3911/kanat-kiialbaev.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoia2FuYXQifQ.zNIgxFVA5tqai-lJhsrBj7XrFFVzQsNF46TVqaYB5Qs',
  ),
  SampleUser(
    const UserInfo(
      id: 'rafal',
      role: 'admin',
      name: 'Rafal',
      imageUrl:
          'https://getstream.io/static/0c1757caed4d61383ef5eb62c4d9b60f/a3911/rafał-adasiewicz.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFmYWwifQ.Gigvs8prmsZfKm0IHqv1NbfAgQUOl2hxlBt6N3CIES0',
  ),
  SampleUser(
    const UserInfo(
      id: 'jc',
      role: 'admin',
      name: 'Jc',
      imageUrl:
          'https://getstream.io/static/9c26c24d792debb76292f25ff8b30f20/a3911/jose-carlos-miñarro.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiamMifQ.HD_CKtM7aXj_iOeoFokKM2hR0MDAxV7ch6U6LISz39w',
  ),
  SampleUser(
    const UserInfo(
      id: 'sahil',
      role: 'admin',
      name: 'Sahil',
      imageUrl:
          'https://getstream.io/static/222908ea9f8c3f0adbd78d0580035080/a3911/sahil-kumar.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FoaWwifQ._8MmEOvq97drtzUbux3RvOaXBQF2X0wl7rRTvZv1vbQ',
  ),
  SampleUser(
    const UserInfo(
      id: 'dmitry',
      role: 'admin',
      name: 'Dmitry',
      imageUrl:
          'https://getstream.io/static/db3d452959916f64e9b4a480ee9c9bf9/a3911/dmitrii-bychkov.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZG1pdHJ5In0.IGaU_0q5ryWhzFxVC6La3ZMy1_5Q-LnvWijDF2Stjzg',
  ),
];
