import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../classes/hive_adapter.dart';

class AnswerFace extends StatelessWidget {
  final int number;
  const AnswerFace({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    final cards = Hive.box<Flashcard>('flashcards');
    List<Color> col = [
      Colors.amber,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.black,
    ];
    List<Color> colS = [
      Color.fromARGB(255, 116, 50, 0),
      const Color.fromARGB(255, 89, 0, 0),
      const Color.fromARGB(255, 0, 38, 3),
      const Color.fromARGB(255, 0, 27, 68),
      Colors.white,
    ];
    String none = "none";
    return Card(
      elevation: 20,
      color: colS[number % 4],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 550,
        width: 280,
        child: Center(
          child: Text(
            "${Hive.box<Flashcard>('flashcards').values.toList()[number]?.answer ?? none}",
            textAlign: TextAlign.center,
            style: GoogleFonts.acme(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: col[number % 4],
            ),
          ),
        ),
      ),
    );
  }
}
