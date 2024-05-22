import 'dart:ui';
import 'package:flutter/material.dart';

class Blur extends StatelessWidget {
  final Widget onTop;
  final Widget? behind;
  final Alignment alignment;
  final double blur;
  const Blur({super.key, required this.onTop, this.behind, this.alignment = Alignment.center, this.blur = 2.5});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: alignment,
        children: [
          behind ?? SizedBox(),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur, tileMode: TileMode.repeated),
              child: onTop,
            ),
          ),
        ],
      ),
    );
  }
}
