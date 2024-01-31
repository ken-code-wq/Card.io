import 'package:cards/constants/constants.dart';
import 'package:cards/config/config.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../classes/hive_adapter.dart';

class QuestionFace extends StatelessWidget {
  final int number;
  const QuestionFace({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    // final cards = Hive.box<Flashcard>('flashcards');
    Map swipeC = {
      SwipeD.neutral: Colors.black,
      SwipeD.left: Colors.red,
      SwipeD.right: Colors.green,
    };
    String none = "none";
    return Stack(
      children: [
        Card(
          elevation: 20,
          color: MyTheme().isDark ? Colors.grey.shade800 : Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 550,
            width: 280,
          ),
        ),
        Card(
          elevation: 20,
          shadowColor: swipeC[swipeDirection],
          borderOnForeground: true,
          // color: Colors.grey.shade900,
          child: SizedBox(
            height: 550,
            width: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 60,
                  width: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8, left: 10, right: 10),
                        height: 10,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Color(boxColor[Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').get(number)!.topic_id].color]),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Text(
                          Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').get(number)!.topic_id].name,
                          style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 413,
                    width: 280,
                    child: Center(
                      child: Text(
                        "${Hive.box<Flashcard>('flashcards').get(number)?.question ?? none}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.grey.shade700, blurRadius: 15),
                          ],
                        ),
                        maxLines: 7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
