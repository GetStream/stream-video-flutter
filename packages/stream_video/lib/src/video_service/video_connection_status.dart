// import 'package:livekit_client/livekit_client.dart';

enum VideoConnectionStatus { disconnected, connecting, reconnecting, connected }

// extension ConnectionStateX on ConnectionState {
//   VideoConnectionStatus get mapped {
//     switch (this) {
//       case ConnectionState.disconnected:
//         {
//           return VideoConnectionStatus.disconnected;
//         }

//       case ConnectionState.connecting:
//         {
//           return VideoConnectionStatus.connecting;
//         }

//       case ConnectionState.reconnecting:
//         {
//           return VideoConnectionStatus.reconnecting;
//         }

//       case ConnectionState.connected:
//         {
//           return VideoConnectionStatus.connected;
//         }
//     }
//   }
// }
