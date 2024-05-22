import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:cards/constants/config/config.dart';
import 'package:cards/constants/constants.dart';

import '../../classes/hive_adapter.dart';

class SubjectCard extends StatefulWidget {
  final int index;
  Box<Subject> subjects;
  int sId;

  SubjectCard({
    Key? key,
    required this.index,
    required this.subjects,
    required this.sId,
  }) : super(key: key);

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight * 0.2,
      width: context.screenWidth,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: !MyTheme().isDark ? Color(boxLightColor[widget.subjects.values.toList()[widget.index].color]) : Color(boxColor[widget.subjects.values.toList()[widget.index].color]).withOpacity(.2),
        borderRadius: BorderRadius.circular(context.screenHeight * 0.25 * 0.15),
        border: Border.all(
          color: Color(boxColor[widget.subjects.values.toList()[widget.index].color]),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Image.asset(
                images[widget.subjects.values.toList()[widget.index].more?['asset'] ?? 0],
                height: context.screenHeight * 0.15,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.subjects.values.toList()[widget.index].name,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(boxColor[widget.subjects.values.toList()[widget.index].color]),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(levelsBoxes[widget.subjects.values.toList()[widget.index].difficulty]['color']),
                        radius: 7,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        "${levelsBoxes[widget.subjects.values.toList()[widget.index].difficulty]['name']}",
                        style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ).px16(),
          ),
        ],
      ),
    );
  }
}
