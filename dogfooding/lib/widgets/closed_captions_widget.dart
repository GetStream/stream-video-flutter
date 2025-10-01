import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../theme/app_palette.dart';

class ClosedCaptionsWidget extends StatelessWidget {
  const ClosedCaptionsWidget({
    super.key,
    required this.call,
    this.maxCaptions = 2,
    this.height = 80,
  });

  final Call call;

  /// The maximum number of captions to show.
  final int? maxCaptions;

  /// The height of the captions widget.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: call.closedCaptions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var closedCaptions = snapshot.data != null
              ? snapshot.data!.reversed.toList()
              : <StreamClosedCaption>[];

          if (maxCaptions != null && closedCaptions.length > maxCaptions!) {
            closedCaptions = closedCaptions.sublist(0, maxCaptions);
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: !call.state.value.isCaptioning ? 0 : height,
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: ListView.separated(
              reverse: true,
              shrinkWrap: true,
              itemCount: closedCaptions.length,
              itemBuilder: (context, index) {
                final caption = closedCaptions[index];
                return Opacity(
                  opacity: closedCaptions.length >= 3 && index >= 2 ? 0.4 : 1,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${caption.user.name}: ',
                          style: const TextStyle(
                            color: AppColorPalette.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: caption.text.trim(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
