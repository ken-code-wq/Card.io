// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<Map> levelsBoxes = [
  {'name': 'Easy', 'color': Colors.green.shade500.value},
  {'name': 'Okay', 'color': Colors.blue.shade500.value},
  {'name': 'Hard', 'color': Colors.orange.shade500.value},
  {'name': 'Tough', 'color': Colors.red.shade500.value},
];

const List images = [
  'assets/ai.png',
  'assets/books_library_1.png',
  'assets/compass.png',
  'assets/english.png',
  'assets/home.png',
  'assets/math.png',
  'assets/more.png',
  'assets/search.png',
  'assets/worldwide.png',
  'assets/car-engine.png',
  'assets/chemistry.png',
  'assets/dollar.png',
  'assets/drugs.png',
  'assets/keyboard.png',
  'assets/law.png',
  'assets/palette.png',
  'assets/science.png',
  'assets/sports.png',
];
List<int> boxColor = [
  Colors.deepPurple.value,
  Colors.red.value,
  Colors.orange.value,
  Colors.green.value,
  Colors.blue.value,
  Colors.brown.value,
  Colors.purpleAccent.value,
];
List<int> boxLightColor = [
  Colors.deepPurple.shade100.value,
  Colors.red.shade100.value,
  Colors.orange.shade100.value,
  Colors.green.shade100.value,
  Colors.blue.shade100.value,
  Colors.brown.shade100.value,
  Color.fromARGB(255, 244, 181, 255).value,
];

TextStyle rowStyle = GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 20);

int difficulty_card = 0;
int difficulty_topic = 0;
int difficulty_subject = 0;

SwipeD swipeDirection = SwipeD.neutral;

enum SwipeD {
  right,
  neutral,
  left,
}

enum BoxType {
  card,
  topic,
  subject,
}
