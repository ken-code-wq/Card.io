import 'package:cards/constants/constants.dart';
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
    final cards = Hive.box<Flashcard>('flashcards');
    String none = "none";
    return Card(
      elevation: 20,
      borderOnForeground: true,
      // color: Colors.grey.shade900,
      child: SizedBox(
        height: 550,
        width: 280,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 473,
                    width: 200,
                    child: Center(
                      child: Text(
                        "${Hive.box<Flashcard>('flashcards').values.toList()[number]?.question ?? none}",
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
            RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                height: 70,
                width: 550,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 10, right: 10),
                      height: 10,
                      width: 500,
                      decoration: BoxDecoration(
                        color: Color(boxColor[Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').values.toList()[number].topic_id].color]),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').values.toList()[number].topic_id].name,
                        style: GoogleFonts.abel(fontSize: 40, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
