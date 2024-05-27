// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:cards/constants/constants.dart';
import 'package:cards/services/services.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../classes/hive_adapter.dart';
import '../constants/config/config.dart';
import '../custom/Widgets/card.dart';
import '../gamification/vibration_tap.dart';

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

// // StreamController<List> cCon = StreamController<List>();
// Stream<List> cardsStream = cCon.stream;

class _RevisionState extends State<Revision> {
  List easy = [];
  List notYet = [];
  List good = [];
  List hard = [];
  List again = [];
  int current_index = 0;
  List cards = [];
  double progress = 0;

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

  int control = 0;
  int revised = 0;
  bool include = false;

  final ConfettiController confettiController = ConfettiController(duration: const Duration(seconds: 2, milliseconds: 500));
  bool isDone = false;
  bool revise = false;
  bool revAgain = false;
  List reRuns = [];
  final CardSwiperController controller = CardSwiperController();
  final CardSwiperController revController = CardSwiperController();
  @override
  void dispose() {
    controller.dispose();
    revController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    hard.clear();
    // cCon.add(widget.card_ids);
    easy.clear();
    again.clear();
    good.clear();
    notYet.addAll(widget.cards);
    current_index = 0;
    cards.clear();
    reRuns.clear();
    reRuns.add(100000);
    cards = List.generate(widget.card_ids.length, (index) => index);
    isDone = false;
    revise = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDone) {
          return true;
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Are you sure you want to quit this revision session ?"),
                  content: const Text("Your goals and milestones achived in this revision session will not be saved and your streak will not increase either. Do you want to quit the session ?"),
                  actions: [
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
                    ElevatedButton(
                        onPressed: () {
                          isDone = true;
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Yes")),
                  ],
                );
              });
          return false;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 15,
                  child: Stack(
                    children: [
                      FAProgressBar(
                        backgroundColor: Colors.transparent,
                        currentValue: (again.length.toDouble() + hard.length.toDouble() + good.length.toDouble() + easy.length.toDouble()) * 100 / widget.card_ids.length,
                        changeProgressColor: getC(current_index),
                        // onChanged: (val) {},
                        progressColor: Colors.red,
                      ),
                      FAProgressBar(
                        backgroundColor: Colors.transparent,
                        currentValue: (hard.length.toDouble() + good.length.toDouble() + easy.length.toDouble()) * 100 / (widget.card_ids.length),
                        changeProgressColor: getC(current_index),
                        // onChanged: (val) {},
                        progressColor: Colors.orange,
                      ),
                      FAProgressBar(
                        backgroundColor: Colors.transparent,
                        currentValue: (good.length.toDouble() + easy.length.toDouble()) * 100 / widget.card_ids.length,
                        changeProgressColor: getC(current_index),
                        // onChanged: (val) {},
                        progressColor: Colors.green,
                      ),
                      FAProgressBar(
                        backgroundColor: Colors.transparent,
                        currentValue: easy.length.toDouble() * 100 / widget.card_ids.length,
                        changeProgressColor: getC(current_index),
                        // onChanged: (val) {},
                        progressColor: Colors.blue,
                      ),
                    ],
                  ),
                ).px12(),
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
                    onEnd: () async {
                      isDone = true;
                      confettiController.play();
                      await TopicServices().editTopic(id: widget.id, directions: {'again': again, 'hard': hard, 'good': good, 'easy': easy});
                      // print(Hive.box<Topic>('topics').values.toList()[Hive.box<Flashcard>('flashcards').get(widget.card_ids[cards.last])!.topic_id].directions ?? 0);
                    },
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
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: !MyTheme().isDark ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [const BoxShadow(color: Colors.grey, spreadRadius: 1.0)],
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
                            onTap: () async {
                              vibrate(amplitude: 30, duration: 30);
                              switch (index) {
                                case 0:
                                  control = 0;
                                  include = true;
                                  controller.swipeLeft();
                                  Timer(const Duration(milliseconds: 300), () {
                                    include = false;
                                  });
                                case 1:
                                  control = 1;
                                  include = true;
                                  controller.swipeLeft();
                                  Timer(const Duration(milliseconds: 300), () {
                                    include = false;
                                  });
                                // current_index = current_index + 1;
                                case 2:
                                  control = 2;
                                  include = true;
                                  controller.swipeRight();
                                  Timer(const Duration(milliseconds: 300), () {
                                    include = false;
                                  });
                                // current_index = current_index + 1;
                                case 3:
                                  control = 3;
                                  include = true;
                                  print(include);
                                  controller.swipeRight();
                                  Timer(const Duration(milliseconds: 300), () {
                                    include = false;
                                  });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: index == 3 ? 8 : 0),
                              decoration: BoxDecoration(
                                  color: !MyTheme().isDark ? difficulties[index]['colorShade'].withOpacity(.4) : difficulties[index]['color'].withOpacity(.3),
                                  borderRadius: BorderRadius.circular(15),
                                  // boxShadow: [BoxShadow(color: difficulties[index]['color'], spreadRadius: 1)],
                                  border: Border.all(
                                    color: difficulties[index]['color'],
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    difficulties[index]['name'],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: difficulties[index]['color']),
                                  ).py1(),
                                  Text(
                                    difficulties[index]['time'],
                                    style: TextStyle(color: difficulties[index]['color']),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: context.screenHeight,
            width: context.screenWidth,
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              emissionFrequency: .2,
              numberOfParticles: 7,
              minBlastForce: 5,
              maxBlastForce: 10,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: .5 * pi,
              // strokeWidth: 5,
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
        if (include) {
          switch (control) {
            case 2:
              good.add(previousIndex);
              revised = revised + 1;
              progress = progress + 100 / (widget.card_ids.length + revised);
            case 3:
              easy.add(previousIndex);
              progress = progress + 100 / (widget.card_ids.length + revised);
          }
        } else {
          revised = revised + 1;
          progress = progress + 100 / (widget.card_ids.length + revised);
          good.add(previousIndex);
        }

        if (currentIndex == null || reRuns.last + 3 == currentIndex) {
          revise = true;
        }
      });

      print(progress);
      return true;
    } else if (direction == CardSwiperDirection.left && widget.cards.isNotEmpty) {
      setState(() {
        revised = revised + 1;
        progress = progress + 100 / (widget.card_ids.length + revised);
        if (include) {
          switch (control) {
            case 0:
              reRuns.add(previousIndex);
              again.add(previousIndex);
            case 1:
              cards.add(previousIndex);
              hard.add(previousIndex);
          }
        } else {
          hard.add(previousIndex);
        }
        if (currentIndex == null || reRuns.last + 3 == previousIndex) {
          revise = true;
        }
      });

      print(progress);
      return true;
    } else {
      return false;
    }
  }
}
