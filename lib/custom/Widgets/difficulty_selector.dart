import 'package:cards/constants/config/config.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/constants.dart';

class DifficultySelector extends StatefulWidget {
  final BoxType type;
  DifficultySelector({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<DifficultySelector> createState() => _DifficultySelectorState();
}

class _DifficultySelectorState extends State<DifficultySelector> {
  @override
  Widget build(BuildContext context) {
    int improvDif = 0;

    switch (widget.type) {
      case BoxType.card:
        improvDif = difficulty_card;
      case BoxType.subject:
        improvDif = difficulty_subject;
      case BoxType.topic:
        improvDif = difficulty_topic;
      default:
        improvDif = difficulty_card;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        levelsBoxes.length,
        (index) => ZoomTapAnimation(
          onTap: () {
            switch (widget.type) {
              case BoxType.card:
                difficulty_card = index;
              case BoxType.subject:
                difficulty_subject = index;
              case BoxType.topic:
                difficulty_topic = index;
              default:
                difficulty_card = index;
            }
            setState(() {});
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: context.screenHeight * 0.08 + (improvDif == index ? 20 : 0),
            width: context.screenWidth * 0.19 + (improvDif == index ? 20 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(levelsBoxes[index]['color']).withOpacity(.5),
              border: Border.fromBorderSide(
                BorderSide(
                  color: improvDif == index
                      ? MyTheme().isDark
                          ? Colors.white
                          : Colors.black
                      : Colors.transparent,
                  width: 2.1,
                ),
              ),
            ),
            child: "${levelsBoxes[index]['name']}".text.scale(1.1).fontWeight(FontWeight.w500).makeCentered(),
          ),
        ),
      ),
    ).box.height(context.screenHeight * 0.09).width(context.screenWidth).px4.make();
  }
}
