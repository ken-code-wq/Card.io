// ignore_for_file: must_be_immutable

import 'package:cards/constants/config/config.dart';
import 'package:cards/custom/Widgets/card.dart';
import 'package:cards/gamification/vibration_tap.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../classes/hive_adapter.dart';
import '../constants/constants.dart';
import '../custom/hero_dialog.dart';
import '../services/services.dart';
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
  final ValueNotifier<double> _valueNotifier2 = ValueNotifier(0);
  final ValueNotifier<double> _valueNotifier0 = ValueNotifier(0);
  final ValueNotifier<double> _valueNotifierA = ValueNotifier(0);
  final ValueNotifier<double> _valueNotifierH = ValueNotifier(0);
  final ValueNotifier<double> _valueNotifierG = ValueNotifier(0);
  final ValueNotifier<double> _valueNotifierE = ValueNotifier(0);
  final ValueNotifier<double> _valueNotifierNew = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Topic>('topics').listenable(),
        builder: (context, topicss, child) {
          List<Topic> topics = topicss.values.toList();
          Topic topic = topicss.values.toList()[widget.index];
          List<Flashcard> cards = Hive.box<Flashcard>('flashcards').values.toList();
          List cardIds = topics[widget.index].card_ids;
          List days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
          int again = 0;
          int hard = 0;
          int good = 0;
          int easy = 0;
          int not = 0;
          int topicLength = 1;

          topics[widget.index].card_ids.isNotEmpty ? topicLength = topics[widget.index].card_ids.length : topicLength = 1;
          try {
            again = topics[widget.index].directions!['again']!.length;
            hard = topics[widget.index].directions!['hard']!.length;
            good = topics[widget.index].directions!['good']!.length;
            easy = topics[widget.index].directions!['easy']!.length;
            not = topicLength - (again + hard + good + easy);
          } catch (e) {
            TopicServices().editTopic(id: widget.index, directions: {'again': [], 'hard': [], 'good': [], 'easy': []});
          }
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  //AppBar
                  SliverAppBar.large(
                    pinned: true,
                    floating: true,
                    snap: true,
                    iconTheme: const IconThemeData(color: Colors.white),
                    actions: const [Icon(Icons.more_vert), SizedBox(width: 8), Icon(Icons.edit), SizedBox(width: 8)],
                    backgroundColor: Color(boxColor[widget.color]),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        maxLines: 3,
                        overflow: TextOverflow.fade,
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
                  SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                      color: Color(boxColor[widget.color]),
                      padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
                      // margin: const EdgeInsets.only(bottom: 30),
                      child: TabBar(
                        padding: EdgeInsets.zero,
                        dividerColor: Color(boxColor[widget.color]),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                        indicatorColor: Colors.white,
                        indicatorWeight: 8,
                        unselectedLabelStyle: const TextStyle(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.bold),
                        tabs: const [
                          Tab(
                            text: 'Revision',
                            iconMargin: EdgeInsets.only(bottom: 0.0),
                            icon: Icon(Icons.person),
                          ),
                          Tab(
                            text: 'Stats',
                            iconMargin: EdgeInsets.only(bottom: 00.0),
                            icon: Icon(Icons.bar_chart_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: context.screenWidth,
                      height: context.screenHeight,
                      child: TabBarView(
                        children: [
                          Scaffold(
                            body: SizedBox(
                              height: context.screenHeight * 0.659,
                              width: context.screenWidth,
                              child: CustomScrollView(
                                slivers: [
                                  //Progress
                                  SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: context.screenHeight,
                                      width: context.screenWidth,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 28),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Progress",
                                                style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, fontSize: 25),
                                              ),
                                              Text(
                                                "All",
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
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ZoomTapAnimation(
                                                onTap: () {
                                                  print(topicLength);
                                                },
                                                child: Container(
                                                  width: context.screenWidth * 0.9 + 10,
                                                  height: context.screenHeight * 0.7 * 1 / 5,
                                                  decoration: BoxDecoration(
                                                    color: MyTheme().isDark ? Colors.grey.shade500.withOpacity(.4) : Colors.grey.withOpacity(.3),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: context.screenWidth * 0.2,
                                                        child: chart(not, topicLength, Colors.grey.shade800, _valueNotifierNew),
                                                      ).px8().py8(),
                                                      SizedBox(
                                                        width: context.screenWidth * 0.7 - 10,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Not reviewed",
                                                              style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 25),
                                                            ).px(4),
                                                            Text(
                                                              "Study these to gauge your knowledge concerning them",
                                                              maxLines: 2,
                                                              style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, fontSize: 16),
                                                            ).px(4),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              //Space
                                              SizedBox(height: context.screenWidth * 0.1 - 20),
                                              SizedBox(
                                                width: context.screenWidth,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ZoomTapAnimation(
                                                      onTap: () async {
                                                        //TODO
                                                        if (again > 0) {
                                                          List<Flashcard> cardIns = List.generate(again, (index) => Hive.box<Flashcard>('flashcards').values.toList()[topics[widget.index].directions!['again']![index]]);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) {
                                                              return Revision(
                                                                cards: cardIns,
                                                                id: widget.index,
                                                                card_ids: topics[widget.index].directions!['again']!,
                                                              );
                                                            }),
                                                          );
                                                        }
                                                      },
                                                      child: rev(topicLength: topicLength, direction: again, color: Colors.red, val: _valueNotifierA, topic: 'To study', des: 'You really need to study these'),
                                                    ),
                                                    ZoomTapAnimation(
                                                      onTap: () async {
                                                        //TODO
                                                        if (hard > 0) {
                                                          List<Flashcard> cardIns = List.generate(hard, (index) => Hive.box<Flashcard>('flashcards').values.toList()[topics[widget.index].directions!['hard']![index]]);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) {
                                                              return Revision(
                                                                cards: cardIns,
                                                                id: widget.index,
                                                                card_ids: topics[widget.index].directions!['hard']!,
                                                              );
                                                            }),
                                                          );
                                                        }
                                                      },
                                                      child: rev(topicLength: topicLength, direction: hard, color: Colors.orange, val: _valueNotifierH, topic: 'Mediocre', des: 'You made some progress here'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Space
                                              SizedBox(height: context.screenWidth * 0.1 - 20),
                                              SizedBox(
                                                width: context.screenWidth,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ZoomTapAnimation(
                                                      onTap: () async {
                                                        //TODO
                                                        if (easy > 0) {
                                                          List<Flashcard> cardIns = List.generate(easy, (index) => Hive.box<Flashcard>('flashcards').values.toList()[topics[widget.index].directions!['easy']![index]]);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) {
                                                              print(topics[widget.index].directions!['easy']!);
                                                              return Revision(
                                                                cards: cardIns,
                                                                id: widget.index,
                                                                card_ids: topics[widget.index].directions!['easy']!,
                                                              );
                                                            }),
                                                          );
                                                        }
                                                      },
                                                      child: rev(topicLength: topicLength, direction: easy, color: Colors.blue, val: _valueNotifierE, topic: 'Perfect', des: 'You nailed these flashcards'),
                                                    ),
                                                    ZoomTapAnimation(
                                                      onTap: () async {
                                                        //TODO
                                                        if (good > 0) {
                                                          List<Flashcard> cardIns = List.generate(good, (index) => Hive.box<Flashcard>('flashcards').values.toList()[topics[widget.index].directions!['good']![index]]);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) {
                                                              return Revision(
                                                                cards: cardIns,
                                                                id: widget.index,
                                                                card_ids: topics[widget.index].directions!['good']!,
                                                              );
                                                            }),
                                                          );
                                                        }
                                                      },
                                                      child: rev(topicLength: topicLength, direction: good, color: Colors.green, val: _valueNotifierG, topic: 'To revise', des: 'You need to read through thesee'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ).px(10),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //FlashCards
                                  SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: context.screenHeight * 0.3 + 30,
                                      width: context.screenWidth,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 28),
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
                            ),
                          ),
                          Scaffold(
                            body: SizedBox(
                              height: context.screenHeight * 0.65,
                              width: context.screenWidth,
                              child: CustomScrollView(
                                slivers: [
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
                                                  valueNotifier: _valueNotifier0,
                                                  progress: (again + hard + good + easy) / topicLength * 100 - 5 * (topics[widget.index].card_ids.length / topicLength),
                                                  maxProgress: 100,
                                                  corners: StrokeCap.round,
                                                  seekColor: Colors.transparent,
                                                  seekSize: 20,
                                                  foregroundColor: Colors.red,
                                                  backgroundColor: Colors.transparent,
                                                  foregroundStrokeWidth: 20,
                                                  backgroundStrokeWidth: 20,
                                                  animation: true,
                                                ),
                                                DashedCircularProgressBar.aspectRatio(
                                                  aspectRatio: 1, // width ÷ height
                                                  valueNotifier: _valueNotifier1,
                                                  progress: (hard + good + easy) / topicLength * 100,
                                                  maxProgress: 100,
                                                  corners: StrokeCap.round,
                                                  seekColor: Colors.transparent,
                                                  seekSize: 20,
                                                  foregroundColor: Colors.orange,
                                                  backgroundColor: Colors.transparent,
                                                  foregroundStrokeWidth: 20,
                                                  backgroundStrokeWidth: 20,
                                                  animation: true,
                                                ),
                                                DashedCircularProgressBar.aspectRatio(
                                                  aspectRatio: 1, // width ÷ height
                                                  valueNotifier: _valueNotifier2,
                                                  progress: (good + easy) / topicLength * 100,
                                                  maxProgress: 100,
                                                  corners: StrokeCap.round,
                                                  seekColor: Colors.transparent,
                                                  seekSize: 20,
                                                  foregroundColor: Colors.green,
                                                  backgroundColor: Colors.transparent,
                                                  foregroundStrokeWidth: 20,
                                                  backgroundStrokeWidth: 20,
                                                  animation: true,
                                                ),
                                                DashedCircularProgressBar.aspectRatio(
                                                  aspectRatio: 1, // width ÷ height
                                                  valueNotifier: _valueNotifier,
                                                  progress: (easy) / topicLength * 100,
                                                  maxProgress: 100,
                                                  corners: StrokeCap.round,
                                                  seekColor: Colors.transparent,
                                                  seekSize: 20,
                                                  foregroundColor: Colors.blue,
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
                                                                '${value.ceil().toInt()}%',
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
                                          dataTag(percentage: ((easy) / topicLength * 100).ceil().toDouble(), severity: 3).py8(),
                                          dataTag(percentage: ((again + hard + good) / topicLength * 100).floor().toDouble(), severity: 2),
                                          dataTag(percentage: ((topicLength - again - hard - good - easy) / topicLength * 100).ceil().toDouble(), severity: 1).py8(),
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

                                  //Space
                                  const SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      onPressed: () async {
                        await addCards(cards, topic.card_ids, topics, topic, context, widget.index);
                        cardIds = topics[widget.index].card_ids;
                      },
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton.extended(
                      backgroundColor: Color(boxColor[widget.color]).withOpacity(.5),
                      onPressed: () async {
                        List<Flashcard> cardIns = List.generate(cardIds.length, (index) => Hive.box<Flashcard>('flashcards').values.toList()[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Revision(
                              cards: cardIns,
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
            ),
          );
        });
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

  Widget chart(int easy, int topicLength, Color color, ValueNotifier<double> val) {
    return DashedCircularProgressBar.aspectRatio(
      aspectRatio: 1, // width ÷ height
      valueNotifier: val,
      progress: (easy) / topicLength * 100,
      maxProgress: 100,
      corners: StrokeCap.round,
      seekColor: Colors.transparent,
      seekSize: 5,
      foregroundColor: color,
      backgroundColor: MyTheme().isDark ? Colors.grey.shade400.withOpacity(.2) : Colors.white,
      foregroundStrokeWidth: 5,
      backgroundStrokeWidth: 5,
      animation: true,
      child: Center(
        child: ValueListenableBuilder(
            valueListenable: val,
            builder: (_, double value, __) {
              return Center(
                child: Text(
                  '${easy}',
                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              );
            }),
      ),
    );
  }

  Widget rev({required int topicLength, required int direction, required Color color, required ValueNotifier<double> val, required String topic, required String des}) {
    return Container(
      width: context.screenWidth * 0.45,
      height: context.screenHeight * 0.9 * 2 / 5,
      decoration: BoxDecoration(
        color: color.withOpacity(.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: context.screenWidth * 0.2,
            width: context.screenWidth * 0.2,
            child: chart(direction, topicLength, color, val),
          ).px(8).py(8),
          Text(
            topic,
            style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 25),
          ).px(8),
          Text(
            des,
            maxLines: 2,
            style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, fontSize: 16),
          ).px(8),
          ZoomTapAnimation(
            child: Container(
              margin: EdgeInsets.all(8),
              height: 60,
              width: context.screenWidth * 0.45,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                "Study",
                style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 30),
              ).px(4),
            ),
          ),
        ],
      ),
    );
  }
}

Future addCards(List<Flashcard> cards, List<int> topic_cards, List<Topic> topics, Topic deck, BuildContext context, int id) {
  return VxBottomSheet.bottomSheetView(
    context,
    // backgroundColor: !MyTheme().isDark ? Colors.white : Colors.grey.shade900,
    child: StatefulBuilder(builder: (context, setCState) {
      return Container(
        height: context.screenHeight * 0.8,
        width: context.screenWidth,
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: !MyTheme().isDark ? Colors.white : Colors.grey.shade900, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: context.screenWidth * 0.9,
                height: 90,
                color: !MyTheme().isDark ? Colors.white : Colors.grey.shade900,
                alignment: Alignment.centerLeft,
                child: "Add cards".text.semiBold.scale(2.5).make().px12(),
              ).centered(),
            ),
            Expanded(
              flex: 5,
              child: ListView.builder(
                  itemCount: cards.length - topic_cards.length,
                  itemBuilder: (context, index) {
                    List<Flashcard> filt = [];
                    filt.addAll(cards);
                    filt.removeWhere((element) => topic_cards.contains(element.id));
                    print(filt);
                    return ZoomTapAnimation(
                      onTap: () {
                        vibrate(amplitude: 20, duration: 30);
                        setCState(() {
                          topic_cards.contains(index + 1) ? topic_cards.remove(index + 1) : topic_cards.add(index + 1);
                        });
                      },
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          filt[index].question,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        selected: true,
                        subtitle: Text(
                          'Topic: ${topics[filt[index].topic_id].name}',
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                        trailing: topic_cards.contains(filt[index].id) ? const Icon(Icons.check) : const Column(),
                        selectedTileColor: !MyTheme().isDark ? Color(boxLightColor[topics[filt[index].topic_id].color]) : Color(boxColor[topics[filt[index].topic_id].color]).withOpacity(.4),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: .0, top: 4, bottom: 4),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(boxColor[topics[filt[index].topic_id].color]),
                          ),
                        ),
                      ).px8().py8(),
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: !MyTheme().isDark ? Colors.white : Colors.grey.shade900,
                width: context.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FloatingActionButton.extended(
                        onPressed: () async {
                          if (topic_cards.isNotEmpty) {
                            for (int i = 0; i < topic_cards.length; i++) {
                              await TopicServices().addCard(
                                id: id,
                                card_id: topic_cards[i] - 1,
                              );
                              await CardServices().editCard(id: topic_cards[i] - 1, topic_id: id);
                            }
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        label: const Text("Add"),
                        elevation: .0,
                        shape: const StadiumBorder(),
                        backgroundColor: Color(boxColor[deck.color]).withOpacity(.4),
                      ).px20(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }),
    maxHeight: 1,
    minHeight: .8,
  );
}
