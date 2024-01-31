// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/adapters.dart';

part 'hive_adapter.g.dart';

@HiveType(typeId: 1)
class Flashcard {
  @HiveField(0)
  int id;

  @HiveField(1)
  int topic_id;

  @HiveField(2)
  int? subject_id;

  @HiveField(3)
  int? deck_id;

  @HiveField(4)
  String question;

  @HiveField(5)
  String answer;

  @HiveField(6)
  int difficulty_user;

  @HiveField(7)
  int times_appeared;

  @HiveField(8)
  int times_correct;

  @HiveField(9)
  int usefullness;

  @HiveField(10)
  int rate_of_appearance;

  @HiveField(11)
  List<double> times_spent;

  @HiveField(12)
  List<int> ratings;

  @HiveField(13)
  List<int> fonts;

  @HiveField(14)
  double? adjusted_difficulty;

  @HiveField(15)
  bool isImage;

  @HiveField(16)
  List? imageURLs;

  Flashcard({
    required this.id,
    required this.topic_id,
    this.subject_id,
    this.deck_id,
    required this.question,
    required this.answer,
    required this.difficulty_user,
    required this.times_appeared,
    required this.times_correct,
    required this.usefullness,
    required this.rate_of_appearance,
    required this.times_spent,
    required this.ratings,
    required this.fonts,
    this.adjusted_difficulty,
    required this.isImage,
    this.imageURLs,
  });

  // Flashcard({
  //   required this.name,
  //   required this.age,
  //   required this.friends,
  // });
}

@HiveType(typeId: 2)
class Subject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<int> topic_ids;

  @HiveField(3)
  List<int> card_ids;

  @HiveField(4)
  int difficulty;

  @HiveField(5)
  int times_appeared;

  @HiveField(6)
  int times_correct;

  @HiveField(7)
  int color;

  @HiveField(8)
  int font;

  @HiveField(9)
  int? deck_id;

  @HiveField(10)
  String? subtitle;

  Subject({
    required this.id,
    required this.name,
    required this.topic_ids,
    required this.card_ids,
    required this.difficulty,
    required this.times_appeared,
    required this.times_correct,
    required this.color,
    required this.font,
    this.deck_id,
    this.subtitle,
  });
}

@HiveType(typeId: 3)
class Topic {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<int> card_ids;

  @HiveField(3)
  int color;

  @HiveField(4)
  int font;

  @HiveField(5)
  int? deck_id;

  @HiveField(6)
  int difficulty;

  @HiveField(7)
  int? rate_of_appearance;

  @HiveField(8)
  String? subtitle;

  @HiveField(9)
  int? subject_id;

  @HiveField(10)
  Map<String, List>? directions;
  //For revisions, cards that were easy, hard, tough, etc. To feed the algorithm with enough info

  Topic({
    required this.id,
    required this.name,
    required this.card_ids,
    required this.color,
    required this.font,
    this.deck_id,
    required this.difficulty,
    this.rate_of_appearance,
    this.subtitle,
    this.subject_id,
    this.directions,
  });
}

@HiveType(typeId: 4)
class Deck {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<int>? card_ids;

  @HiveField(3)
  List<int>? subject_ids;

  @HiveField(4)
  List<int>? topic_ids;

  @HiveField(5)
  int color;

  @HiveField(6)
  int font;

  @HiveField(7)
  String? subtitle;

  @HiveField(8)
  Map? data;
  Deck({
    required this.id,
    required this.name,
    this.card_ids,
    this.subject_ids,
    this.topic_ids,
    required this.color,
    required this.font,
    this.subtitle,
    this.data,
  });
}
