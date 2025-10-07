import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../theme/app_palette.dart';
import '../widgets/stream_button.dart';
import 'assets.dart';

Future<void> showFeedbackDialog(
  BuildContext context, {
  required Call call,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _FeedbackRatingContent(call),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => hideFeedbackDialog(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void hideFeedbackDialog(BuildContext context) => context.pop();

class _FeedbackRatingContent extends StatefulWidget {
  const _FeedbackRatingContent(this.call);

  final Call call;

  @override
  State<_FeedbackRatingContent> createState() => __FeedbackRatingContentState();
}

class __FeedbackRatingContentState extends State<_FeedbackRatingContent> {
  int value = 0;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(streamVideoIconAsset, width: 250),
          const SizedBox(height: 16),
          Text(
            'We Value Your Feedback!',
            textAlign: TextAlign.center,
            style: StreamVideoTheme.of(context).textTheme.title1,
          ),
          const SizedBox(height: 4),
          Text(
            'Tell us about your video call experience',
            textAlign: TextAlign.center,
            style:
                StreamVideoTheme.of(
                  context,
                ).textTheme.footnote.apply(
                  color: AppColorPalette.secondaryText,
                ),
          ),
          const SizedBox(height: 32),
          RatingStars(
            value: value.toDouble(),
            onValueChanged: (v) {
              setState(() {
                value = max(min(v.round(), 5), 1);
              });
            },
            starBuilder: (index, color) =>
                Icon(Icons.star, size: 45, color: color),
            starSize: 45,
            starSpacing: 5,
            maxValueVisibility: false,
            valueLabelVisibility: false,
            animationDuration: const Duration(milliseconds: 1000),
            starColor: AppColorPalette.appGreen,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Tell us more about your experience',
              hintStyle: TextStyle(color: AppColorPalette.secondaryText),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
          ),
          const SizedBox(height: 32),
          StreamButton.active(
            label: 'Submit Feedback',
            icon: const Icon(Icons.feedback, color: Colors.white),
            onPressed: value > 0
                ? () async {
                    final result = await widget.call.collectUserFeedback(
                      rating: value,
                      reason: textController.text,
                    );

                    result.fold(
                      success: (_) {
                        hideFeedbackDialog(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thank you for your feedback!'),
                          ),
                        );
                      },
                      failure: (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to submit feedback: $error'),
                          ),
                        );
                      },
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
