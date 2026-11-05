import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'clipboard_image_paste.dart';

/// The call's chat, as the body of a side panel.
///
/// Images pasted into the composer are added as attachments, subject to the
/// channel's upload permission and the app's attachment limits.
class ChatPanelBody extends StatefulWidget {
  /// Creates a chat body for [channel].
  const ChatPanelBody({super.key, required this.channel});

  /// The channel to show the messages of.
  final Channel channel;

  @override
  State<ChatPanelBody> createState() => _ChatPanelBodyState();
}

class _ChatPanelBodyState extends State<ChatPanelBody> {
  final _composerController = StreamMessageComposerController();
  final _composerFocusNode = FocusNode();

  @override
  void dispose() {
    _composerFocusNode.dispose();
    _composerController.dispose();
    super.dispose();
  }

  void _onImagesPasted(List<PastedImage> images) {
    if (!mounted || images.isEmpty) return;
    if (!widget.channel.canUploadFile) return;
    // Commands carry no attachments.
    if (_composerController.message.command != null) return;

    final appSettings = StreamChat.of(context).client.appSettings;
    final validator = StreamAttachmentValidator(
      fileUploadConfig: appSettings.fileUploadConfig,
      imageUploadConfig: appSettings.imageUploadConfig,
    );

    final total = _composerController.attachments.length + images.length;
    if (validator.validateCount(total) case final error?) {
      return _showAttachmentError(error);
    }

    StreamChatError? firstError;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    for (final (index, image) in images.indexed) {
      final attachment = Attachment(
        type: AttachmentType.image,
        file: AttachmentFile(
          bytes: image.bytes,
          size: image.bytes.length,
          name: _fileName(image, 'paste_${timestamp}_$index'),
        ),
      );

      if (validator.validate(attachment) case final error?) {
        firstError ??= error;
        continue;
      }
      _composerController.addAttachment(attachment);
    }

    if (firstError != null) _showAttachmentError(firstError);
  }

  // The name must end in an extension matching the MIME type: the
  // attachment's MIME type, and so its upload validation, is derived from it.
  static String _fileName(PastedImage image, String fallbackStem) {
    final mimeType = image.mimeType.toLowerCase();
    if (image.name.mediaType?.mimeType == mimeType) return image.name;

    final extension = extensionFromMime(mimeType) ?? mimeType.split('/').last;
    return '$fallbackStem.$extension';
  }

  void _showAttachmentError(StreamChatError error) {
    final translations = context.translations;
    final message = switch (error) {
      AttachmentBlockedError(:final fileExtension) =>
        translations.fileTypeNotSupportedError(fileExtension),
      AttachmentTooLargeError(:final maxSize) => translations.fileTooLargeError(
        maxSize / (1024 * 1024),
      ),
      AttachmentLimitReachedError(:final maxCount) =>
        translations.attachmentLimitExceedError(maxCount),
      _ => error.message,
    };
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: widget.channel,
      child: Column(
        children: <Widget>[
          const Expanded(child: StreamMessageListView()),
          ClipboardImagePaste(
            focusNode: _composerFocusNode,
            onImages: _onImagesPasted,
            child: StreamMessageComposer(
              messageComposerController: _composerController,
              focusNode: _composerFocusNode,
            ),
          ),
        ],
      ),
    );
  }
}
