import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:cards/constants/config/config.dart';
import 'package:cards/constants/constants.dart';

import '../../classes/hive_adapter.dart';

class TopicCard extends StatefulWidget {
  final int index;
  Box<Topic> topics;
  int sId;

  TopicCard({
    Key? key,
    required this.index,
    required this.topics,
    required this.sId,
  }) : super(key: key);

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  @override
  Widget build(BuildContext context) {
    var subjects = Hive.box<Subject>('subjects');
    int topicL = widget.topics.values.toList()[widget.index].card_ids.isEmpty ? 1 : widget.topics.values.toList()[widget.index].card_ids.length;
    return SizedBox(
      height: context.screenHeight * 0.25,
      width: context.screenWidth,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Hero(
            //   tag: "Topic $widget.index",
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Container(
            //       height: context.screenHeight * 0.14,
            //       width: 6,
            //       margin: const EdgeInsets.symmetric(
            //         horizontal: 5,
            //       ),
            //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(boxColor[widget.topics.values.toList()[widget.index].color])),
            //     ),
            //   ),
            // ),
            Container(
              height: context.screenHeight * 0.25,
              constraints: BoxConstraints(
                maxHeight: context.screenHeight * 0.27,
                minHeight: context.screenHeight * 0.25,
              ),
              width: context.screenWidth * 0.9,
              decoration: BoxDecoration(
                color: !MyTheme().isDark ? Color(boxLightColor[widget.topics.values.toList()[widget.index].color]).withOpacity(.5) : Color(boxColor[widget.topics.values.toList()[widget.index].color]).withOpacity(.4),
                borderRadius: BorderRadius.circular(context.screenHeight * 0.25 * 0.15),
                // border: Border.all(
                //   color: Color(boxColor[widget.topics.values.toList()[widget.index].color]),
                //   width: 2,
                //   style: BorderStyle.solid,
                // ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(levelsBoxes[widget.topics.values.toList()[widget.index].difficulty]['color']),
                                  radius: 7,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  "${levelsBoxes[widget.topics.values.toList()[widget.index].difficulty]['name']}",
                                  style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(border: Border.all(color: Color(boxColor[widget.topics.values.toList()[widget.index].color]), width: 2), color: Colors.transparent, borderRadius: BorderRadius.circular(14)),
                              child: Text(
                                widget.sId != 1000000000 ? subjects.values.toList()[widget.sId].name : '<Unknown Subject>',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: !MyTheme().isDark ? Color(boxColor[widget.topics.values.toList()[widget.index].color]) : Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.topics.values.toList()[widget.index].name,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.bold, color: !MyTheme().isDark ? Color(boxColor[widget.topics.values.toList()[widget.index].color]) : Colors.white),
                        ),
                        Hero(
                          tag: "Topic ${widget.index}",
                          child: FAProgressBar(
                            currentValue: widget.topics.values.toList()[widget.index].directions!['easy']!.length / topicL * 100,
                            backgroundColor: Colors.white.withOpacity(.2),
                            size: 10,
                            progressColor: Color(boxColor[widget.topics.values.toList()[widget.index].color]),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "${widget.topics.values.toList()[widget.index].card_ids.length} Cards".text.scale(1.051).make(),
                            "${widget.topics.values.toList()[widget.index].directions!['easy']!.length} /${widget.topics.values.toList()[widget.index].card_ids.length} cards learned".text.make(),
                          ],
                        ),
                      ],
                    ).px16(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
