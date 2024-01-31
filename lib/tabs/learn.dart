import 'package:cards/classes/hive_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cards/custom/Widgets/card.dart';
import 'package:cards/custom/Widgets/empty_card.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../Screens/add_card.dart';
import '../constants/constants.dart';

class Learn extends StatefulWidget {
  const Learn({super.key});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> with AutomaticKeepAliveClientMixin {
  final CardSwiperController controller = CardSwiperController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: Hive.box<Flashcard>('flashcards').listenable(),
                builder: (context, cards, child) {
                  List cardL = List.generate(cards.length, (index) => index);
                  cardL.shuffle();
                  if (cards.isNotEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: CardSwiper(
                        isLoop: false,
                        controller: controller,
                        cardsCount: cards.isNotEmpty ? cards.length : 1,
                        // allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true),
                        scale: .8,
                        onSwipeDirectionChange: (initial, finalD) {
                          if (finalD.name == 'right') {
                            swipeDirection = SwipeD.right;
                          } else if (finalD.name == 'left') {
                            swipeDirection = SwipeD.left;
                          }
                        },
                        onSwipe: _onSwipe,
                        numberOfCardsDisplayed: cards.length >= 3
                            ? 3
                            : cards.length == 2
                                ? 2
                                : 1,
                        backCardOffset: const Offset(0, -60),
                        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                        cardBuilder: (
                          context,
                          index,
                          horizontalThresholdPercentage,
                          verticalThresholdPercentage,
                        ) =>
                            FlippingCard(number: cardL[index]),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: CardSwiper(
                        controller: controller,
                        cardsCount: 1,
                        // allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true),
                        scale: .8,
                        onSwipe: _onSwipe,
                        numberOfCardsDisplayed: 1,
                        backCardOffset: const Offset(40, 10),
                        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                        cardBuilder: (
                          context,
                          index,
                          horizontalThresholdPercentage,
                          verticalThresholdPercentage,
                        ) =>
                            const Empty(),
                      ),
                    );
                  }
                }),
          ],
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   controller.undo();
        // }),
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
