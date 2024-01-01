import 'package:cards/Widgets/card.dart';
import 'package:cards/classes/hive_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  final CardSwiperController controller = CardSwiperController();

  final cards = [
    const FlippingCard(number: 0),
    const FlippingCard(number: 1),
    const FlippingCard(number: 2),
    const FlippingCard(number: 3),
    const FlippingCard(number: 4),
  ];

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
            Flexible(
              child: CardSwiper(
                controller: controller,
                cardsCount: cards.length,
                // allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true),
                scale: .8,
                onSwipe: _onSwipe,
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(40, 10),
                padding: const EdgeInsets.only(left: 40.0, top: 50),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    cards[index],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    if (direction == CardSwiperDirection.right) {
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
    } else if (direction == CardSwiperDirection.left) {
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
    } else {
      return false;
    }
  }
}
