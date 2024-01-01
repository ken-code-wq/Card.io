import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionFace extends StatelessWidget {
  final int number;
  const QuestionFace({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    List<Color> col = [
      Colors.amber,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.white,
    ];
    return Card(
      elevation: 20,
      borderOnForeground: true,
      color: Colors.grey.shade900,
      child: SizedBox(
        height: 550,
        width: 280,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 550,
                width: 200,
                child: Center(
                  child: Text(
                    "Front page and question $number",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pacifico(fontSize: 40, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.grey.shade700, blurRadius: 15)]),
                  ),
                ),
              ),
            ),
            RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                height: 60,
                width: 550,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      height: 10,
                      width: 500,
                      decoration: BoxDecoration(
                        color: col[number],
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    Text(
                      "MATHEMATICS",
                      style: GoogleFonts.abel(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
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
