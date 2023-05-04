import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'attachment/call_attachment.dart';

class ChannelScreen extends StatelessWidget {
  const ChannelScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamChannelHeader(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.call_rounded,
              color: Colors.black,
            ),
            onPressed: () async => _startCall(context),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              messageBuilder: (context, details, messages, defaultMessage) {
                return defaultMessage.copyWith(
                    customAttachmentBuilders: _customAttachmentBuilders());
              },
            ),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }

  Map<String, AttachmentBuilder> _customAttachmentBuilders() {
    return {
      'custom': (context, message, attachments) {
        return WrapAttachmentWidget(
          attachmentWidget: CallAttachment(
            message: message,
            attachment: attachments.first,
          ),
          attachmentShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }
    };
  }

  /// Creates a new call and sends a message with its metadata to the chat.
  void _startCall(BuildContext context) async {
    final currentUser = StreamChat.of(context).currentUser;
    final channel = StreamChannel.of(context).channel;

    channel.sendMessage(
      Message(
        attachments: [
          Attachment(
            type: "custom",
            authorName: currentUser?.name ?? "",
            uploadState: UploadState.success(),
            extraData: {
              'callType': 'default',
              'callId': 'call${Random().nextInt(10000)}',
            },
          )
        ],
      ),
    );
  }
}
