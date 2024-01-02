// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../classes/hive_adapter.dart';

final cardss = Hive.box<Flashcard>('flashcards');
final subjectss = Hive.box<Subject>('subjects');
final topicss = Hive.box<Topic>('topics');
final deckss = Hive.box<Deck>('decks');

final int cardLength = cardss.length;
final int subjectsLength = Hive.box<Subject>('subjects').length;
final int topicsLength = Hive.box<Subject>('subjects').length;
final int decksLength = Hive.box<Subject>('subjects').length;

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
    required bool isImage,
    List? imageURLs,
  }) async {
    await cardss.put(
      id,
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
          isImage: isImage,
          imageURLs: imageURLs),
    );
  }

  Future removeCard({
    required int id,
  }) async {
    await Hive.box<Flashcard>('flashcards').deleteAt(id);
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
    final card = cardss.get(id);
    await cardss.put(
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
        isImage: card!.isImage,
      ),
    );
  }
}

class SubjectServices {
  final subjects = Hive.box<Subject>('subjects');
  Future create({
    required int id,
    required String name,
    required int difficulty,
    required int color,
    required int font,
    required int subject_id,
    String? subtitle,
  }) async {
    await Hive.box<Subject>('subjects').put(
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
    Hive.box<Subject>('subjects').delete(id);
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
    final card = Hive.box<Subject>('subjects').get(id);
    await Hive.box<Subject>('subjects').put(
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

  Future addCardNTopic({
    required int id,
    int? card_id,
    int? topic_id,
  }) async {
    final subject = subjects.getAt(id);
    List<int> cards = [];
    List<int> topics = [];
    //Add from Hive
    if (subject!.card_ids.isNotEmpty) {
      cards.addAll(subject.card_ids);
    }
    if (subject.topic_ids.isNotEmpty) {
      topics.addAll(subject.topic_ids);
    }
    //Add to temp list
    if (card_id != null) {
      cards.add(card_id);
    }
    if (topic_id != null) {
      topics.add(topic_id);
    }
    await Hive.box<Subject>('subjects').putAt(
      id,
      Subject(
        id: id,
        name: subject.name,
        topic_ids: topics,
        card_ids: cards,
        difficulty: subject.difficulty,
        times_appeared: subject.times_appeared,
        times_correct: subject.times_correct,
        color: subject.color,
        font: subject.font,
        deck_id: subject.deck_id,
        subtitle: subject.subtitle,
      ),
    );
  }
}

class TopicServices {
  final topics = Hive.box<Topic>('topics');

  Future create({
    required int id,
    required String name,
    required int color,
    required int font,
    required int difficulty,
  }) async {
    await topics.add(
      Topic(
        id: id,
        name: name,
        card_ids: [],
        color: color,
        font: font,
        difficulty: difficulty,
      ),
    );
  }

  Future addCard({
    required int id,
    required int card_id,
  }) async {
    final topic = topics.getAt(id);
    List<int> card = [];
    if (topic!.card_ids.isNotEmpty) {
      card.addAll(topic.card_ids);
    }
    card.add(card_id);
    await Hive.box<Topic>('topics').putAt(
      id,
      Topic(
        id: id,
        name: topic.name,
        card_ids: card,
        color: topic.color,
        font: topic.font,
        difficulty: topic.difficulty,
      ),
    );
  }

  Future editTopic({
    required int id,
    String? name,
    int? color,
    int? font,
    int? deck_id,
    int? difficulty,
    int? rate_of_appearance,
    String? subtitle,
  }) async {
    final topic = topics.getAt(id);
    await Hive.box<Topic>('topics').putAt(
      id,
      Topic(
        id: id,
        name: name ?? topic!.name,
        card_ids: topic!.card_ids,
        color: color ?? topic.color,
        font: font ?? topic.font,
        difficulty: difficulty ?? topic.difficulty,
      ),
    );
  }

  Future remove({required int id}) async {
    await Hive.box<Topic>('topics').deleteAt(id);
  }
}

class DeckServices {
  final decks = Hive.box<Deck>('decks');
  Future create({
    required int id,
    required String name,
    required int color,
    required int font,
    String? subtitle,
  }) async {
    decks.add(Deck(id: id, name: name, color: color, font: font, subtitle: subtitle));
  }

  Future addCardNTopicNSubject({
    required int id,
    int? card_id,
    int? topic_id,
    int? subject_id,
  }) async {
    final deck = decks.getAt(id);
    List<int> cards = [];
    List<int> topics = [];
    List<int> subjects = [];

    //Add from Hive
    if (deck!.card_ids!.isNotEmpty) {
      cards.addAll(deck.card_ids as Iterable<int>);
    }
    if (deck.topic_ids!.isNotEmpty) {
      topics.addAll(deck.topic_ids as Iterable<int>);
    }
    if (deck.subject_ids!.isNotEmpty) {
      subjects.addAll(deck.subject_ids as Iterable<int>);
    }
    //Add to temp list
    if (card_id != null) {
      cards.add(card_id);
    }
    if (topic_id != null) {
      topics.add(topic_id);
    }
    if (subject_id != null) {
      topics.add(subject_id);
    }
    await Hive.box<Deck>('decks').putAt(
      id,
      Deck(
        id: id,
        name: deck.name,
        topic_ids: topics,
        card_ids: cards,
        subject_ids: subjects,
        data: deck.data,
        color: deck.color,
        font: deck.font,
        subtitle: deck.subtitle,
      ),
    );
  }

  Future editDeck({
    required int id,
    String? name,
    int? color,
    int? font,
    String? subtitle,
    Map? data,
  }) async {
    final deck = decks.getAt(id);
    await Hive.box<Deck>('decks').putAt(
      id,
      Deck(
        id: id,
        name: name ?? deck!.name,
        color: color ?? deck!.color,
        font: font ?? deck!.font,
        subtitle: subtitle ?? deck!.subtitle,
        data: data ?? deck!.data,
      ),
    );
  }

  Future remove({required int id}) async {
    await Hive.box<Deck>('decks').deleteAt(id);
  }
}
