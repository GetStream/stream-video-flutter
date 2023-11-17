// 📦 Package imports:
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/utils/consts.dart';
import 'token_service.dart';

class UserChatRepository {
  const UserChatRepository({
    required this.chatClient,
    required this.tokenService,
  });

  final StreamChatClient chatClient;
  final TokenService tokenService;

  OwnUser? get currentUser => chatClient.state.currentUser;

  Future<OwnUser> connectUser(User user) {
    return chatClient.connectUserWithProvider(
      user,
      (userId) => tokenService
          .loadToken(userId: userId)
          .then((response) => response.token),
    );
  }

  Future<void> disconnectUser() => chatClient.disconnectUser();

  Future<Channel> createChannel(String channelId) async {
    final channel = chatClient.channel(kMessageChannelType, id: channelId);
    await channel.watch();
    return channel;
  }
}
