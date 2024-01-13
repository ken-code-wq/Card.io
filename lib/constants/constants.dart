// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';


List<Map> levelsBoxes = [
  {'name': 'Easy', 'color': Colors.green.shade500.value},
  {'name': 'Okay', 'color': Colors.blue.shade500.value},
  {'name': 'Hard', 'color': Colors.orange.shade500.value},
  {'name': 'Tough', 'color': Colors.red.shade500.value},
];
List<int> boxColor = [
  Colors.amber.value,
  Colors.amberAccent.value,
  Colors.white.value,
  Colors.blue.value,
  Colors.blueAccent.value,
  Colors.blueGrey.value,
  Colors.brown.value,
  Colors.cyan.value,
  Colors.cyanAccent.value,
  Colors.deepOrange.value,
  Colors.deepOrangeAccent.value,
  Colors.deepPurple.value,
  Colors.deepPurpleAccent.value,
  Colors.green.value,
  Colors.grey.value,
  Colors.lightGreen.value,
  Colors.indigo.value,
  Colors.indigoAccent.value,
  Colors.lightBlue.value,
  Colors.lime.value,
  Colors.limeAccent.value,
  Colors.orange.value,
  Colors.pink.value,
  Colors.pinkAccent.value,
  Colors.purple.value,
  Colors.purpleAccent.value,
  Colors.red.value,
  Colors.teal.value,
  Colors.tealAccent.value,
  Colors.yellow.value,
];

int difficulty_card = 0;
int difficulty_topic = 0;
int difficulty_subject = 0;

enum BoxType {
  card,
  topic,
  subject,
}
