import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class ClosedCaptionsWidget extends StatelessWidget {
  const ClosedCaptionsWidget({
    super.key,
    required this.call,
  });

  final Call call;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: call.closedCaptions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final closedCaptions = snapshot.data as List<StreamClosedCaption>;

          if (closedCaptions.isEmpty) {
            return const SizedBox.shrink();
          }

          return Positioned(
            bottom: 45,
            left: 20,
            right: 20,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: closedCaptions.map((caption) {
                  return Row(
                    children: [
                      Text(
                        "${caption.user.name}: ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          caption.text.trim(),
                          maxLines: 3,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
