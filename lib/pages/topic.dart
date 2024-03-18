// ignore_for_file: must_be_immutable

import 'package:cards/config/config.dart';
import 'package:cards/custom/Widgets/card.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../classes/hive_adapter.dart';
import '../constants/constants.dart';
import '../custom/hero_dialog.dart';
import 'revision_page.dart';

class TopicPage extends StatefulWidget {
  int index;
  int color;

  TopicPage({
    Key? key,
    required this.index,
    required this.color,
  }) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  final ValueNotifier<double> _valueNotifier1 = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    List<Topic> topics = Hive.box<Topic>('topics').values.toList();
    List cardIds = topics[widget.index].card_ids;
    List days = [
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
    ];
    List<Flashcard> cards = List.generate(cardIds.length, (index) => Hive.box<Flashcard>('flashcards').values.toList()[index]);
    double progress = 20;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //AppBar
          SliverAppBar.large(
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: const [Icon(Icons.more_vert)],
            backgroundColor: Color(
              boxColor[widget.color],
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                topics[widget.index].name,
                style: GoogleFonts.aBeeZee(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Hero(
                tag: "Topic ${widget.index}",
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  color: Color(
                    boxColor[widget.color],
                  ),
                ),
              ),
            ),
          ),
          //Progress
          SliverToBoxAdapter(
            child: SizedBox(
              height: context.screenHeight * 0.51,
              width: context.screenWidth,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Progress",
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      Text(
                        "More stats",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(
                            boxColor[widget.color],
                          ),
                        ),
                      ),
                    ],
                  ).px12(),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: context.screenHeight * 0.25,
                    width: context.screenWidth,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier1,
                          progress: progress + 15,
                          maxProgress: 100,
                          corners: StrokeCap.round,
                          seekColor: Colors.transparent,
                          seekSize: 20,
                          foregroundColor: Color(
                            boxLightColor[widget.color],
                          ),
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 20,
                          backgroundStrokeWidth: 20,
                          animation: true,
                        ),
                        DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: progress,
                          maxProgress: 100,
                          corners: StrokeCap.round,
                          seekColor: Colors.transparent,
                          seekSize: 20,
                          foregroundColor: Color(
                            boxColor[widget.color],
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundStrokeWidth: 20,
                          backgroundStrokeWidth: 20,
                          animation: true,
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${value.toInt()}%',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 60),
                                      ),
                                      const Text(
                                        'Learnt',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                  dataTag(percentage: progress, severity: 3).py8(),
                  dataTag(percentage: 15, severity: 2),
                  dataTag(percentage: 65, severity: 1).py8(),
                ],
              ).px12(),
            ),
          ),
          //Space
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),

          //Topic Streak
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              width: context.screenWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Topic Streak",
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      const Text(
                        "Share",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ).px12(),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 70,
                    width: context.screenWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 65,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 7.5),
                                  height: 65,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(64 / 3),
                                    gradient: const LinearGradient(colors: [
                                      Colors.amber,
                                      Colors.orange,
                                      Colors.red,
                                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: MyTheme().isDark ? Colors.black : Colors.white,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(colors: [
                                      Colors.amber.withOpacity(.2),
                                      Colors.orange.withOpacity(.2),
                                      Colors.red.withOpacity(.2),
                                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                  ),
                                  child: Center(
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: List.generate(7, (index) {
                                          return SizedBox(
                                            child: Column(
                                              children: [
                                                Text(
                                                  days[index],
                                                  style: GoogleFonts.aBeeZee(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: !MyTheme().isDark ? Colors.black : Colors.white,
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  minRadius: 15,
                                                  backgroundColor: index <= DateTime.now().weekday ? Colors.orange : Colors.white,
                                                  child: const Icon(
                                                    Icons.check_circle_outline_rounded,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ).px4(),
                                          );
                                        })),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 7.5),
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40 / 3),
                            color: Color(boxLightColor[widget.color]),
                          ),
                          child: Center(
                            child: Text(
                              "${DateTime.now().difference(DateTime(2024, 2, 4)).inDays} days",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Space
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),
          //FlashCards
          SliverToBoxAdapter(
            child: SizedBox(
              height: context.screenHeight * 0.3,
              width: context.screenWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Flash cards",
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      Text(
                        "Take a quiz",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(
                            boxColor[widget.color],
                          ),
                        ),
                      ),
                    ],
                  ).px12(),
                  const SizedBox(height: 15),
                  SizedBox(
                      height: context.screenHeight * 0.21,
                      width: context.screenWidth,
                      child: MasonryGridView.builder(
                        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        mainAxisSpacing: 4,
                        scrollDirection: Axis.horizontal,
                        itemCount: topics[widget.index].card_ids.length,
                        crossAxisSpacing: 7,
                        itemBuilder: (context, index) {
                          return Hero(
                            tag: index,
                            child: ZoomTapAnimation(
                              onTap: () {
                                Navigator.push(context, HeroDialogRoute(builder: (BuildContext context) {
                                  return Center(
                                    child: Hero(
                                      tag: index,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: FlippingCard(
                                            number: cardIds[index],
                                            front: false,
                                          )),
                                    ),
                                  );
                                }));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 7),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                height: context.screenHeight * 0.1,
                                // width: context.screenWidth * 0.52,
                                decoration: BoxDecoration(
                                  color: Color(
                                    boxColor[widget.color],
                                  ).withOpacity(.45),
                                  borderRadius: BorderRadius.circular((context.screenHeight * 0.1 - 4) / 4),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      "${Hive.box<Flashcard>('flashcards').get(cardIds[index])?.question}",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                    ).centered(),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
          //Bottom Space
          SliverToBoxAdapter(
            child: SizedBox(
              height: context.screenHeight * 0.18,
            ),
          )
        ],
      ),
      bottomSheet: SizedBox(
        height: 70,
        width: context.screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
            const SizedBox(width: 20),
            FloatingActionButton.extended(
              backgroundColor: Color(boxColor[widget.color]).withOpacity(.5),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Revision(
                      cards: cards,
                      id: widget.index,
                      card_ids: cardIds,
                    );
                  }),
                );
              },
              label: const Text("Revise"),
              shape: const StadiumBorder(),
              elevation: 0,
              icon: const Icon(Icons.play_arrow_rounded),
            )
          ],
        ),
      ),
    );
  }

  Widget dataTag({required double percentage, required int severity}) {
    String name = '';
    switch (severity) {
      case 1:
        name = "Not learned";
      case 2:
        name = "To be revised";
      case 3:
        name = "Learned";
    }
    Color color = const Color(0xFF42A5F5);
    switch (severity) {
      case 3:
        color = Color(
          boxColor[widget.color],
        );
      case 2:
        color = Color(
          boxLightColor[widget.color],
        );
      case 1:
        color = const Color(0xffeeeeee);
    }
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: color,
        ).px12(),
        Text(
          name,
          style: GoogleFonts.aBeeZee(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          "$percentage %",
          style: GoogleFonts.aBeeZee(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ).px12()
      ],
    );
  }
}
