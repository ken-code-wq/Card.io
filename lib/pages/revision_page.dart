import 'package:cards/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../classes/hive_adapter.dart';
import '../config/config.dart';
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

List easy = [];
List notYet = [];
List good = [];
List hard = [];
List again = [];
int current_index = 0;
List cards = [];

Color getC(int index) {
  if (easy.contains(index)) {
    return Colors.blue;
  } else if (again.contains(index)) {
    return Colors.red;
  } else if (good.contains(index)) {
    return Colors.green;
  } else if (hard.contains(index)) {
    return Colors.amber;
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
  void initState() {
    super.initState();

    hard.clear();
    easy.clear();
    again.clear();
    good.clear();
    notYet.addAll(widget.cards);
    current_index = 0;
    cards.addAll(widget.card_ids);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: List.generate(
                widget.cards.length,
                (index) => Expanded(
                  child: AnimatedContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    height: 10,
                    decoration: BoxDecoration(
                      color: getC(index),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    duration: Durations.short3,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
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
          Container(
            height: context.screenHeight * 0.1,
            width: context.screenWidth,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: !MyTheme().isDark ? Colors.grey.shade300 : Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: List.generate(
                4,
                (index) {
                  List difficulties = [
                    {
                      'name': 'Again',
                      'time': '< 2 min',
                      'color': Colors.red,
                      'colorShade': Colors.red.shade300,
                    },
                    {
                      'name': 'Hard',
                      'time': '2 hours',
                      'color': Colors.orange,
                      'colorShade': Colors.orange.shade300,
                    },
                    {
                      'name': 'Good',
                      'time': '14 days',
                      'color': Colors.green,
                      'colorShade': Colors.green.shade300,
                    },
                    {
                      'name': 'Easy',
                      'time': '25 days',
                      'color': Colors.blue,
                      'colorShade': Colors.blue.shade300,
                    },
                  ];
                  return Expanded(
                    child: ZoomTapAnimation(
                      onTap: () {
                        switch (index) {
                          case 0:
                            controller.swipeLeft();
                            setState(() {
                              again.add(current_index);
                            });
                          // current_index = current_index + 1;
                          case 1:
                            controller.swipeLeft();
                            setState(() {
                              hard.add(current_index);
                            });
                          // current_index = current_index + 1;
                          case 2:
                            controller.swipeRight();
                            setState(() {
                              good.add(current_index);
                            });
                          // current_index = current_index + 1;
                          case 3:
                            controller.swipeRight();
                            setState(() {
                              easy.add(current_index);
                            });
                          // current_index = current_index + 1;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: index == 3 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: !MyTheme().isDark ? difficulties[index]['colorShade'].withOpacity(.4) : difficulties[index]['color'].withOpacity(.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            difficulties[index]['name'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: difficulties[index]['color']),
                          ).py1(),
                          Text(
                            difficulties[index]['time'],
                            style: TextStyle(color: difficulties[index]['color']),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
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
    current_index = previousIndex;
    if (direction == CardSwiperDirection.right && widget.cards.isNotEmpty) {
      setState(() {
        good.add(previousIndex);
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     duration: const Duration(seconds: 1),
      //     elevation: 6,
      //     backgroundColor: Colors.grey[900],
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     content: const Text(
      //       "Understood 👍",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // );
      debugPrint(
        "The color is ${getC(previousIndex)}",
      );
      return true;
    } else if (direction == CardSwiperDirection.left && widget.cards.isNotEmpty) {
      setState(() {
        hard.add(previousIndex);
      });
      print(good);
      print(hard);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     duration: const Duration(seconds: 1),
      //     elevation: 6,
      //     backgroundColor: Colors.grey[900],
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     content: const Text(
      //       "Will show this more often 😉 Keep pushing",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // );
      debugPrint(
        "The color is ${getC(previousIndex)}",
      );
      return true;
    } else {
      return false;
    }
  }
}
