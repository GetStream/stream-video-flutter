import 'package:flutter/material.dart';
import 'dart:math' as math;

class NoVideoWidget extends StatelessWidget {
  const NoVideoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (ctx, constraints) => Icon(
          Icons.videocam_off_outlined,
          // color: LKColors.lkBlue,
          size: math.min(constraints.maxHeight, constraints.maxWidth) * 0.3,
        ),
      ),
    );
  }
}
