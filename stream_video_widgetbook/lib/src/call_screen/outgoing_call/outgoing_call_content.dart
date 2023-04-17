// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:stream_video_flutter/stream_video_flutter.dart';
//
// import '../../utils/stub_provider.dart';
//
// Widget defaultOutgoingCallContent(BuildContext context) {
//   return const DefaultOutgoingCallContent();
// }
//
// class DefaultOutgoingCallContent extends ConsumerWidget {
//   const DefaultOutgoingCallContent({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return StreamOutgoingCallContent(
//       call: ref.read(callProvider),
//       callState: ref.read(callStateProvider(true)),
//     );
//   }
// }
