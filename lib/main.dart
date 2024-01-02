import 'package:cards/Widgets/card.dart';
import 'package:cards/Widgets/empty_card.dart';
import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Screens/add_card.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FlashcardAdapter());
  await Hive.openBox<Flashcard>('flashcards');
  Hive.registerAdapter(SubjectAdapter());
  await Hive.openBox<Subject>('subjects');
  Hive.registerAdapter(TopicAdapter());
  await Hive.openBox<Topic>('topics');
  Hive.registerAdapter(DeckAdapter());
  await Hive.openBox<Deck>('decks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// final c = List.generate(cardBox.length, (index) =>);

class _MyHomePageState extends State<MyHomePage> {
  final CardSwiperController controller = CardSwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: Hive.box<Flashcard>('flashcards').listenable(),
                builder: (context, cards, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: CardSwiper(
                      controller: controller,
                      cardsCount: cards.isNotEmpty ? cards.length : 1,
                      // allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true),
                      scale: .8,
                      onSwipe: _onSwipe,
                      numberOfCardsDisplayed: cards.length >= 3
                          ? 3
                          : cards.length == 2
                              ? 2
                              : 1,
                      backCardOffset: const Offset(40, 10),
                      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                      cardBuilder: (
                        context,
                        index,
                        horizontalThresholdPercentage,
                        verticalThresholdPercentage,
                      ) =>
                          cards.isNotEmpty ? FlippingCard(number: index) : const Empty(),
                    ),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => const AddCart()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    if (direction == CardSwiperDirection.right && cards.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          elevation: 6,
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            "Understood 👍",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return true;
    } else if (direction == CardSwiperDirection.left && cards.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          elevation: 6,
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            "Will show this more often 😉 Keep pushing",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return true;
    } else if (direction == CardSwiperDirection.top && cards.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          elevation: 6,
          backgroundColor: Colors.red[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            "Deleted",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Future.delayed(Duration(milliseconds: 210), () async {
        await CardServices().removeCard(id: currentIndex ?? 0);
      });
      return true;
    } else {
      return false;
    }
  }
}
