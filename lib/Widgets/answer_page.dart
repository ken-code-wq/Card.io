import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerFace extends StatelessWidget {
  final int number;
  const AnswerFace({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
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
    return Card(
      elevation: 20,
      color: colS[number],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 550,
        width: 280,
        child: Center(
          child: Text(
            "Back page and answers $number",
            textAlign: TextAlign.center,
            style: GoogleFonts.aBeeZee(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: col[number],
            ),
          ),
        ),
      ),
    );
  }
}
