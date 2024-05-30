import 'package:cards/constants/constants.dart';
import 'package:cards/constants/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../classes/hive_adapter.dart';

class QuestionFace extends StatelessWidget {
  final int number;
  const QuestionFace({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    // final cards = Hive.box<Flashcard>('flashcards');
    // ignore: unused_local_variable
    Map swipeC = {
      SwipeD.neutral: Colors.black,
      SwipeD.left: Colors.red,
      SwipeD.right: Colors.green,
    };
    String none = "none";
    return Container(
      height: context.screenHeight * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: 280,
      decoration: BoxDecoration(
        color: MyTheme().isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(550 / 28),
        boxShadow: const [BoxShadow(color: Colors.grey, spreadRadius: 1.0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 10, right: 10),
                  height: 10,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Color(boxColor[Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').get(number)!.topic_id].color ?? 0]),
                    // color: Colors.brown,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').get(number)!.topic_id].name,
                    // 'Cool',
                    style: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 413 - 44.2,
              width: 280,
              child: Center(
                // child: Expanded(
                //   child: MarkdownBody(
                //     // key: const ValueKey<String>("zmarkdown-parse-body"),
                //     data: Hive.box<Flashcard>('flashcards').get(number)?.question ?? none,
                //     selectable: true,
                //   ),
                // ),
                child: Text(
                  Hive.box<Flashcard>('flashcards').get(number)?.question ?? none,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: MyTheme().isDark ? Colors.grey.shade700 : Colors.grey.shade200, blurRadius: 15),
                    ],
                  ),
                  maxLines: 7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
