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

    final cid = attachment.extraData["callCid"] as String;

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
                    final call = await _joinCall(context, cid);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) {
                          return StreamCallContent(
                            call: call,
                            onBackPressed: () => _finishCall(context, call),
                            onHangUp: () => _finishCall(context, call),
                          );
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

  /// Joins the call with the give cid.
  Future<Call> _joinCall(BuildContext context, String cid) async {
    final parts = cid.split(':');
    final type = parts[0];
    final id = parts[1];

    final call = await StreamVideo.instance.joinCall(type: type, id: id);
    await call.connect();
    return call;
  }

  Future<void> _finishCall(BuildContext context, Call call) async {
    await call.disconnect();

    Navigator.of(context).pop();
  }
}
