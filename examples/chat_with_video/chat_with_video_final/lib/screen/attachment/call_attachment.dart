import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallAttachment extends StatelessWidget {
  const CallAttachment({
    required this.message,
    required this.attachment,
  });

  /// The message that [attachment] is associated with.
  final Message message;

  /// The call attachment to display.
  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final chatTheme = StreamChatTheme.of(context);
    final colorTheme = chatTheme.colorTheme;
    final textTheme = chatTheme.textTheme;

    final callType = attachment.extraData["callType"] as String;
    final callId = attachment.extraData["callId"] as String;

    return Container(
      constraints: BoxConstraints(
        maxWidth: 256,
        minWidth: 256,
      ),
      decoration: BoxDecoration(
        color: colorTheme.accentInfo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Video Call",
                style: textTheme.bodyBold,
                maxLines: 1,
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: SizedBox(
                width: 110,
                height: 44,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.videocam_rounded,
                    color: Colors.black,
                  ),
                  label: Text(
                    "Join",
                    style: textTheme.bodyBold,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () async {
                    final call = StreamVideo.instance.makeCall(
                      type: callType,
                      id: callId,
                    );
                    await call.getOrCreateCall();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) {
                          return StreamCallContainer(call: call);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
