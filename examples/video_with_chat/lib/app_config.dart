import 'package:video_with_chat/sample_user.dart';

/// Stream Video API key.
const videoApiKey = 'us83cfwuhy8n';

/// Stream Chat API key.
const chatApiKey = 'tp8sef43xcpc';

final defaultUsers = <SampleUser>[
  const SampleUser(
    id: 'vasil',
    name: 'Vasil Valkanov',
    role: 'admin',
    image: 'https://payner.bg/images/uploads/Artist_images/VASIL_VALKANOV.jpg',
    videoToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tZ28tY2xpZW50LTAuMC4xIiwic3ViIjoidXNlci92YXNpbCIsImlhdCI6MTY3MDkyOTk4MSwidXNlcl9pZCI6InZhc2lsIn0.YlbxW8zCgTPDUe_rofCta2eKubF-Km5xqsJi_geDsv0',
    chatToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidmFzaWwifQ.7xb2ns3CWqX1XpYwJy89OHyARuIvouISpEoUTRwvZGg',
  ),
  const SampleUser(
    id: 'veselin',
    name: 'Veselin Marinov',
    role: 'admin',
    image:
        'https://payner.bg/images/uploads/Artist_images/Veselin_Marinov_2021-08-04.jpg',
    videoToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tZ28tY2xpZW50LTAuMC4xIiwic3ViIjoidXNlci92ZXNlbGluIiwiaWF0IjoxNjcwOTI5OTk4LCJ1c2VyX2lkIjoidmVzZWxpbiJ9.-scF4--7n3NGRE3wj5vfj7bJ4n5aWcYKdVg5uSqVNGc',
    chatToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidmVzZWxpbiJ9.8WJIIBHinLz80cSi_qy-xj45rT60nGdCBmarW7KEGeU',
  ),
  const SampleUser(
    id: 'valia',
    name: 'Valia',
    role: 'admin',
    image:
        'https://payner.bg/images/uploads/Artist_images/Valia_-_Site_April.jpg',
    videoToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tZ28tY2xpZW50LTAuMC4xIiwic3ViIjoidXNlci92YWxpYSIsImlhdCI6MTY3MDkzMDAxNywidXNlcl9pZCI6InZhbGlhIn0.SMz_Dggqf8ppxov3rjZtcs88v4FmKits0shVTfyObUQ',
    chatToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidmFsaWEifQ.MCm5GWwNeqOWdXnAReXt_9v7nIH7Xg6c94uBg1dxMOk',
  ),
  const SampleUser(
    id: 'damjan',
    name: 'Damjan Popov',
    role: 'admin',
    image: 'https://payner.bg/images/uploads/Artist_images/DAMYAN_POPOV.jpg',
    videoToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tZ28tY2xpZW50LTAuMC4xIiwic3ViIjoidXNlci9kYW1qYW4iLCJpYXQiOjE2NzA5MzAwMzMsInVzZXJfaWQiOiJkYW1qYW4ifQ.ECGyzMLH1ZQEaWiM7iyGsdh3bdubcJRXwGBLZlYJlXM',
    chatToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZGFtamFuIn0.BSeX6DPXC3YfVjHAf8gzl2hJ532DFmrJEhqT3pFLY3c',
  ),
  const SampleUser(
    id: 'jordan',
    name: 'Jordan',
    role: 'admin',
    image:
        'https://payner.bg/images/uploads/Artist_images/DJORDAN_-_SEPT_-_2022.jpg',
    videoToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tZ28tY2xpZW50LTAuMC4xIiwic3ViIjoidXNlci9qb3JkYW4iLCJpYXQiOjE2NzA5MzAwNTIsInVzZXJfaWQiOiJqb3JkYW4ifQ.reRIu94p1nJnR-487zC3ySEFeV1Er7hK3I-1b13mIyA',
    chatToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiam9yZGFuIn0.wwqn1Y2rwcDlO4-U3pmurIpK6CrIT0TQFvI4XovER88',
  ),
  const SampleUser(
    id: 'ina',
    name: 'Ina Garjadi',
    role: 'admin',
    image:
        'https://payner.bg/images/uploads/Artist_images/INA_GAYARDI_-_PAYNER_-_OCTOBER_-_2022.jpg',
    videoToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tZ28tY2xpZW50LTAuMC4xIiwic3ViIjoidXNlci9pbmEiLCJpYXQiOjE2NzA5MzAwNjQsInVzZXJfaWQiOiJpbmEifQ.FTVAMAWsKoO413lPIIzgbHsxrM-q-I5OO_bEYoeDfYo',
    chatToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaW5hIn0.3mTkk94zpzGbSHdkRXb_UHqboTq06WZ5zqDH8xtgyyg',
  ),
];
