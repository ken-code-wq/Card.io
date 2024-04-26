// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../classes/hive_adapter.dart';

// var cardss = Hive.box<Flashcard>('flashcards');
// var subjectss = Hive.box<Subject>('subjects');
// var topicss = Hive.box<Topic>('topics');
// var deckss = Hive.box<Deck>('decks');

// var int cardLength = cardss.length;
// var int subjectsLength = Hive.box<Subject>('subjects').length;
// var int topicsLength = Hive.box<Subject>('subjects').length;
// var int decksLength = Hive.box<Subject>('subjects').length;

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
    await Hive.box<Flashcard>('flashcards').put(
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
    await TopicServices().addCard(id: topic_id, card_id: id);
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
    var card = Hive.box<Flashcard>('flashcards').get(id);
    await Hive.box<Flashcard>('flashcards').put(
      Hive.box<Flashcard>('flashcards').values.length,
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
  Future create({
    required int id,
    required String name,
    required int difficulty,
    required int color,
    required int font,
    Map? more,
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
        more: more,
      ),
    );
  }

  Future remove(int id) async {
    await Hive.box<Subject>('subjects').deleteAt(id);
  }

  Future editSubject({
    required int id,
    String? name,
    List<int>? topic_ids,
    List<int>? card_ids,
    int? color,
    int? font,
    int? deck_id,
    Map? more,
    int? times_appeared,
    int? times_correct,
    int? difficulty,
    int? usefullness,
    int? fonts,
  }) async {
    Subject card = Hive.box<Subject>('subjects').values.toList()[id];
    await Hive.box<Subject>('subjects').putAt(
      id,
      Subject(
        id: id,
        name: name ?? card.name,
        difficulty: difficulty ?? card.difficulty,
        times_appeared: times_appeared ?? card.times_appeared,
        times_correct: times_correct ?? card.times_correct,
        deck_id: deck_id ?? card.deck_id,
        card_ids: card_ids ?? card.card_ids,
        topic_ids: topic_ids ?? card.topic_ids,
        color: color ?? card.color,
        font: fonts ?? card.font,
        more: more ?? card.more,
      ),
    );
  }

  Future addCardNTopic({
    required int id,
    int? card_id,
    int? topic_id,
  }) async {
    var subject = Hive.box<Subject>('subjects').getAt(id);
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
        more: subject.more,
      ),
    );
  }
}

class TopicServices {
  Future create({
    required int id,
    required String name,
    required int color,
    required int font,
    required int difficulty,
    required int subject_id,
  }) async {
    await SubjectServices().addCardNTopic(id: subject_id, topic_id: id);
    await Hive.box<Topic>('topics').add(
      Topic(
        id: id,
        name: name,
        card_ids: [],
        color: color,
        font: font,
        difficulty: difficulty,
        subject_id: subject_id,
      ),
    );
  }

  Future addCard({
    required int id,
    required int card_id,
  }) async {
    var topic = Hive.box<Topic>('topics').getAt(id);
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
        subject_id: topic.subject_id,
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
    Map? more,
    required int subject_id,
  }) async {
    Topic topic = Hive.box<Topic>('topics').values.toList()[id];
    await Hive.box<Topic>('topics').putAt(
      id,
      Topic(
        id: id,
        name: name ?? topic.name,
        card_ids: topic.card_ids,
        color: color ?? topic.color,
        font: font ?? topic.font,
        difficulty: difficulty ?? topic.difficulty,
        subject_id: subject_id,
      ),
    );
  }

  Future remove({required int id}) async {
    await Hive.box<Topic>('topics').deleteAt(id);
  }
}

class DeckServices {
  var decks = Hive.box<Deck>('decks');
  Future create({
    required int id,
    required String name,
    required int color,
    int? font,
    Map? more,
  }) async {
    decks.add(Deck(id: id, name: name, color: color, font: font ?? 0, more: more));
  }

  Future addCardNTopicNSubject({
    required int id,
    int? card_id,
    int? topic_id,
    int? subject_id,
  }) async {
    var deck = decks.getAt(id);
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
        more: deck.more,
      ),
    );
  }

  Future editDeck({
    required int id,
    String? name,
    int? color,
    int? font,
    Map? more,
    Map? data,
  }) async {
    var deck = decks.getAt(id);
    await Hive.box<Deck>('decks').putAt(
      id,
      Deck(
        id: id,
        name: name ?? deck!.name,
        color: color ?? deck!.color,
        font: font ?? deck!.font,
        more: more ?? deck!.more,
        data: data ?? deck!.data,
      ),
    );
  }

  Future remove({required int id}) async {
    await Hive.box<Deck>('decks').deleteAt(id);
  }
}
