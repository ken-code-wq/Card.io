import 'dart:async';

import 'package:dolphinsr_dart/dolphinsr_dart.dart';

void main() {
  final reviews = <Review>[];

  final dolphin = DolphinSR();

  dolphin.addMasters(<Master>[
    const Master(
      id: '1',
      fields: <String>['คน', 'person'],
      combinations: <Combination>[
        Combination(front: <int>[0], back: <int>[1]),
      ],
    ),
    const Master(
      id: '2',
      fields: <String>['คบ', 'To date'],
      combinations: <Combination>[
        Combination(front: <int>[0], back: <int>[1]),
      ],
    ),
    const Master(
      id: '3',
      fields: <String>['3', 'Three date'],
      combinations: <Combination>[
        Combination(front: <int>[0], back: <int>[1]),
      ],
    ),
    const Master(
      id: '4',
      fields: <String>['Chem', 'Hybrid'],
      combinations: <Combination>[
        Combination(front: <int>[0], back: <int>[1]),
      ],
    ),
  ]);
  dolphin.addReviews(reviews);

  var stats = dolphin.summary(); // => { due: 0, later: 0, learning: 4, overdue: 0 }

  printStats(stats);

  ///
  ///
  ///
  try {
    for (int i = 0; i < 20; i++) {
      List<Rating> ratings = [
        Rating.Again,
        Rating.Hard,
        Rating.Good,
        Rating.Easy,
      ];
      print("\n$i.\n");
      var card = dolphin.nextCard()!;
      printCard(card);
      var review = Review(master: card.master, combination: card.combination, ts: DateTime.now(), rating: ratings[i % 4]);

      dolphin.addReviews(<Review>[review]);

      stats = dolphin.summary(); // => { due: 0, later: 0, learning: 2, overdue: 0 }

      print(ratings[i % 4].name);
      print(dolphin.cardsLength());
      printStats(stats);
      printCard(card);
      print(dolphin.summary().due);
    }
  } catch (e) {
    print(e);
  }
  Timer(Duration(seconds: 5), () {
    final dolphina = DolphinSR();
    dolphina.addReviews(reviews);
    print(reviews);

    var statsa = dolphina.summary(); // => { due: 0, later: 0, learning: 4, overdue: 0 }

    printStats(statsa);
    statsa = dolphin.summary(); // => { due: 0, later: 0, learning: 4, overdue: 0 }

    printStats(statsa);
  });
}

void printCard(DRCard card) {
  print('${card.master}-${card.back}-${card.front}-${card.combination!.back}-${card.combination!.front} - ${card.lastReviewed} - ${card.dueDate}');
}

void printStats(stats) {
  print('${stats.due}-${stats.later}-${stats.learning}-${stats.overdue}');
}
