import 'package:cards/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:velocity_x/velocity_x.dart';

import '../classes/hive_adapter.dart';
import '../custom/Widgets/card.dart';

class Revision extends StatefulWidget {
  List<Flashcard> cards;
  int id;
  List card_ids;
  Revision({
    Key? key,
    required this.cards,
    required this.card_ids,
    required this.id,
  }) : super(key: key);

  @override
  State<Revision> createState() => _RevisionState();
}

List understood = [];
List notYet = [];
List good = [];
List hard = [];
List tough = [];

Color getC(int index) {
  if (understood.contains(index)) {
    return Colors.blue;
  } else if (tough.contains(index)) {
    return Colors.red;
  } else if (good.contains(index)) {
    return Colors.green;
  } else if (hard.contains(index)) {
    return Colors.yellow;
  } else {
    return Colors.grey;
  }
}

class _RevisionState extends State<Revision> {
  final CardSwiperController controller = CardSwiperController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    hard.clear();
    understood.clear();
    tough.clear();
    good.clear();
    notYet.addAll(widget.cards);
    print(widget.card_ids);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: List.generate(
                widget.cards.length,
                (index) => Expanded(
                  child: AnimatedContainer(
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    height: 10,
                    decoration: BoxDecoration(
                      color: getC(index),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    duration: Durations.extralong4,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 150,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: CardSwiper(
              isLoop: false,
              controller: controller,
              cardsCount: widget.cards.isNotEmpty ? widget.cards.length : 1,
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
              numberOfCardsDisplayed: widget.cards.length >= 3
                  ? 3
                  : widget.cards.length == 2
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
                  FlippingCard(number: widget.card_ids[index]),
            ),
          ),
        ],
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
    if (direction == CardSwiperDirection.right && widget.cards.isNotEmpty) {
      setState(() {
        good.add(currentIndex);
      });
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
    } else if (direction == CardSwiperDirection.left && widget.cards.isNotEmpty) {
      setState(() {
        hard.add(currentIndex);
      });
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
    }
    // } else if (direction == CardSwiperDirection.top &&widget.cards.isNotEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       duration: const Duration(seconds: 1),
    //       elevation: 6,
    //       backgroundColor: Colors.red[900],
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       behavior: SnackBarBehavior.floating,
    //       content: const Text(
    //         "Deleted",
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   );
    //   Future.delayed(Duration(milliseconds: 210), () async {
    //     await CardServices().removeCard(id: currentIndex ?? 0);
    //   });
    //   return true;
    // }
    else {
      return false;
    }
  }
}
