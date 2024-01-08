// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardAdapter extends TypeAdapter<Flashcard> {
  @override
  final int typeId = 1;

  @override
  Flashcard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flashcard(
      id: fields[0] as int,
      topic_id: fields[1] as int,
      subject_id: fields[2] as int?,
      deck_id: fields[3] as int?,
      question: fields[4] as String,
      answer: fields[5] as String,
      difficulty_user: fields[6] as int,
      times_appeared: fields[7] as int,
      times_correct: fields[8] as int,
      usefullness: fields[9] as int,
      rate_of_appearance: fields[10] as int,
      times_spent: (fields[11] as List).cast<double>(),
      ratings: (fields[12] as List).cast<int>(),
      fonts: (fields[13] as List).cast<int>(),
      adjusted_difficulty: fields[14] as double?,
      isImage: fields[15] as bool,
      imageURLs: (fields[16] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Flashcard obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.topic_id)
      ..writeByte(2)
      ..write(obj.subject_id)
      ..writeByte(3)
      ..write(obj.deck_id)
      ..writeByte(4)
      ..write(obj.question)
      ..writeByte(5)
      ..write(obj.answer)
      ..writeByte(6)
      ..write(obj.difficulty_user)
      ..writeByte(7)
      ..write(obj.times_appeared)
      ..writeByte(8)
      ..write(obj.times_correct)
      ..writeByte(9)
      ..write(obj.usefullness)
      ..writeByte(10)
      ..write(obj.rate_of_appearance)
      ..writeByte(11)
      ..write(obj.times_spent)
      ..writeByte(12)
      ..write(obj.ratings)
      ..writeByte(13)
      ..write(obj.fonts)
      ..writeByte(14)
      ..write(obj.adjusted_difficulty)
      ..writeByte(15)
      ..write(obj.isImage)
      ..writeByte(16)
      ..write(obj.imageURLs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 2;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      id: fields[0] as int,
      name: fields[1] as String,
      topic_ids: (fields[2] as List).cast<int>(),
      card_ids: (fields[3] as List).cast<int>(),
      difficulty: fields[4] as int,
      times_appeared: fields[5] as int,
      times_correct: fields[6] as int,
      color: fields[7] as int,
      font: fields[8] as int,
      deck_id: fields[9] as int?,
      subtitle: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.topic_ids)
      ..writeByte(3)
      ..write(obj.card_ids)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.times_appeared)
      ..writeByte(6)
      ..write(obj.times_correct)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
      ..write(obj.font)
      ..writeByte(9)
      ..write(obj.deck_id)
      ..writeByte(10)
      ..write(obj.subtitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopicAdapter extends TypeAdapter<Topic> {
  @override
  final int typeId = 3;

  @override
  Topic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Topic(
      id: fields[0] as int,
      name: fields[1] as String,
      card_ids: (fields[2] as List).cast<int>(),
      color: fields[3] as int,
      font: fields[4] as int,
      deck_id: fields[5] as int?,
      difficulty: fields[6] as int,
      rate_of_appearance: fields[7] as int?,
      subtitle: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Topic obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.card_ids)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.font)
      ..writeByte(5)
      ..write(obj.deck_id)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.rate_of_appearance)
      ..writeByte(8)
      ..write(obj.subtitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final int typeId = 4;

  @override
  Deck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deck(
      id: fields[0] as int,
      name: fields[1] as String,
      card_ids: (fields[2] as List?)?.cast<int>(),
      subject_ids: (fields[3] as List?)?.cast<int>(),
      topic_ids: (fields[4] as List?)?.cast<int>(),
      color: fields[5] as int,
      font: fields[6] as int,
      subtitle: fields[7] as String?,
      data: (fields[8] as Map?)?.cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.card_ids)
      ..writeByte(3)
      ..write(obj.subject_ids)
      ..writeByte(4)
      ..write(obj.topic_ids)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.font)
      ..writeByte(7)
      ..write(obj.subtitle)
      ..writeByte(8)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
