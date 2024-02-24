// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

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
