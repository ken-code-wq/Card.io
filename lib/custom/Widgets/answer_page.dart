import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../classes/hive_adapter.dart';
import 'package:cards/config/config.dart';

class AnswerFace extends StatelessWidget {
  final int number;
  const AnswerFace({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    final cards = Hive.box<Flashcard>('flashcards');
    String none = "none";
    return Stack(
      children: [
        Card(
          elevation: 20,
          color: MyTheme().isDark ? Colors.grey.shade900 : Colors.grey.shade300,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 550,
            width: 280,
          ),
        ),
        Card(
          elevation: 20,
          // color: Color(boxColor[Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').get(number)!.topic_id].color]).withOpacity(.5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            height: 550,
            width: 280,
            child: Center(
              child: AutoSizeText(
                Hive.box<Flashcard>('flashcards').get(number)!.answer ?? none,
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(boxColor[Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').get(number)!.topic_id].color]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
