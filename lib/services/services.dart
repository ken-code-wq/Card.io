// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../classes/hive_adapter.dart';

final cards = Hive.box<Flashcard>('flashcards');
final subjects = Hive.box<Subject>('subjects');
final topics = Hive.box<Topic>('topics');
final decks = Hive.box<Deck>('decks');

final int cardLength = cards.length;
final int subjectsLength = subjects.length;
final int topicsLength = topics.length;
final int decksLength = decks.length;

class CardServices {
  Future createCard({
    required int id,
    required int topic_id,
    int? subject_id,
    required String question,
    required String answer,
    required int difficulty_user,
    required int usefullness,
    required List<int> fonts,
  }) async {
    await cards.put(
      cardLength,
      Flashcard(
        id: id,
        topic_id: topic_id,
        question: question,
        answer: answer,
        difficulty_user: difficulty_user,
        times_appeared: 0,
        times_correct: 0,
        usefullness: usefullness,
        rate_of_appearance: 0,
        times_spent: [],
        ratings: [],
        fonts: fonts,
      ),
    );
  }

  Future removeCard({
    required int id,
  }) async {
    await cards.delete(id);
  }

  Future editCard({
    required int id,
    int? topic_id,
    int? subject_id,
    int? deck_id,
    String? question,
    String? answer,
    List<double>? times_spent,
    List<int>? ratings,
    int? rate_of_appearance,
    double? adjusted_difficulty,
    int? times_correct,
    int? times_appeared,
    int? difficulty_user,
    int? usefullness,
    List<int>? fonts,
  }) async {
    final card = cards.get(id);
    await cards.put(
      cardLength,
      Flashcard(
        id: id,
        topic_id: topic_id ?? card!.topic_id,
        question: question ?? card!.question,
        answer: answer ?? card!.answer,
        difficulty_user: difficulty_user ?? card!.difficulty_user,
        times_appeared: times_appeared ?? card!.times_appeared,
        times_correct: times_correct ?? card!.times_correct,
        usefullness: usefullness ?? card!.usefullness,
        rate_of_appearance: rate_of_appearance ?? card!.rate_of_appearance,
        times_spent: times_spent ?? card!.times_spent,
        ratings: ratings ?? card!.ratings,
        fonts: fonts ?? card!.fonts,
        subject_id: subject_id ?? card!.subject_id,
        deck_id: deck_id ?? card!.deck_id,
        adjusted_difficulty: adjusted_difficulty ?? card!.adjusted_difficulty,
      ),
    );
  }
}

class SubjectServices {
  Future create({
    required int id,
    required String name,
    required int difficulty,
    required int color,
    required int font,
    required int subject_id,
    String? subtitle,
  }) async {
    await subjects.put(
      id,
      Subject(
        id: id,
        name: name,
        topic_ids: [],
        card_ids: [],
        difficulty: difficulty,
        times_appeared: 0,
        times_correct: 0,
        color: color,
        font: font,
      ),
    );
  }

  Future remove(int id) async {
    subjects.delete(id);
  }

  Future editSubject({
    required int id,
    String? name,
    List<int>? topic_ids,
    List<int>? card_ids,
    int? color,
    int? font,
    int? deck_id,
    String? subtitle,
    int? times_appeared,
    int? times_correct,
    int? difficulty,
    int? usefullness,
    int? fonts,
  }) async {
    final card = subjects.get(id);
    await subjects.put(
      cardLength,
      Subject(
          id: id,
          name: name ?? card!.name,
          difficulty: difficulty ?? card!.difficulty,
          times_appeared: times_appeared ?? card!.times_appeared,
          times_correct: times_correct ?? card!.times_correct,
          deck_id: deck_id ?? card!.deck_id,
          card_ids: card_ids ?? card!.card_ids,
          topic_ids: topic_ids ?? card!.topic_ids,
          color: color ?? card!.color,
          font: fonts ?? card!.font,
          subtitle: subtitle ?? card!.subtitle),
    );
  }
}
