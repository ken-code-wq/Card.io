import 'package:flutter/material.dart';

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
      Colors.white,
    ];
    return Card(
      elevation: 20,
      color: col[number],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 550,
        width: 280,
        child: Center(
          child: Text(
            "Back page and answers $number",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.grey.shade700, blurRadius: 15)]),
          ),
        ),
      ),
    );
  }
}
