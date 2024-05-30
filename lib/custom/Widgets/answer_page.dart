import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards/constants/config/config.dart';
import 'package:cards/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../classes/hive_adapter.dart';
import 'package:flutter_markdown/src/widget.dart';

class AnswerFace extends StatelessWidget {
  final int number;
  const AnswerFace({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final cards = Hive.box<Flashcard>('flashcards');
    String none = "none";
    int col = 0;
    if (Hive.box<Flashcard>('flashcards').get(number)!.topic_id >= Hive.box<Topic>('topics').values.toList().length) {
    } else {
      col = Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').get(number)!.topic_id].color;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: context.screenHeight * 0.6,
      width: 280,
      decoration: BoxDecoration(
        color: !MyTheme().isDark ? Color(boxLightColor[col]) : Color(boxColor[col]),
        borderRadius: BorderRadius.circular(550 / 28),
        boxShadow: [BoxShadow(color: Color(boxColor[col]), spreadRadius: 1.0)],
      ),
      child: Center(
        child: MarkdownBody(
          // key: const ValueKey<String>("zmarkdown-parse-body"),
          data: Hive.box<Flashcard>('flashcards').get(number)?.answer ?? none,
          selectable: true,
        ),
        // child: AutoSizeText(
        //   Hive.box<Flashcard>('flashcards').get(number)!.answer ?? none,
        //   textAlign: TextAlign.center,
        //   style: GoogleFonts.aBeeZee(
        //     fontSize: 30,
        //     fontWeight: FontWeight.bold,
        //     color: Color(boxColor[col]),
        //   ),
        // ),
      ),
    );
  }
}
