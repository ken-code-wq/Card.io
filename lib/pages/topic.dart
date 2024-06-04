// ignore_for_file: must_be_immutable

import 'package:cards/constants/config/config.dart';
import 'package:cards/custom/Widgets/card.dart';
import 'package:cards/gamification/vibration_tap.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_markdown/src/widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../classes/hive_adapter.dart';
import '../constants/constants.dart';
import '../custom/hero_dialog.dart';
import '../main.dart';
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
          // List<Flashcard> cards = Hive.box<Flashcard>('flashcards').values.toList();
          // try {
          //   Hive.openBox<Flashcard>('${Hive.box<Topic>('topics').values.toList()[widget.index].name}-${widget.index}-1', path: newPath);
          //   for (int i = 0; i < Hive.box<Topic>('topics').values.toList()[widget.index].card_ids.length; i++) {
          //     Hive.box<Flashcard>('${Hive.box<Topic>('topics').values.toList()[widget.index].name}-${widget.index}-1').add(Hive.box<Flashcard>('flashcards').values.toList()[Hive.box<Topic>('topics').values.toList()[widget.index].card_ids[i]]);
          //     print(Hive.box<Flashcard>('flashcards').values.toList()[Hive.box<Topic>('topics').values.toList()[widget.index].card_ids[i]].question);
          //     print(Hive.box<Flashcard>('${Hive.box<Topic>('topics').values.toList()[widget.index].name}-${widget.index}-1').getAt(i)!.question);
          //     print("Look");
          //   }
          // } catch (e) {
          //   print("$e roor");
          // }
          List<Flashcard> newCards = Hive.box<Flashcard>('${topic.name}-${widget.index}').values.toList();
          print("quest ${newCards[0].question}");
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
            not = topics[widget.index].card_ids.length - (again + hard + good + easy);
          } catch (e) {
            TopicServices().editTopic(id: widget.index, directions: {'again': [], 'hard': [], 'good': [], 'easy': []});
          }
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
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
                                      height: context.screenHeight * 2.6 / 5 + context.screenWidth * 0.2 - 40 + context.screenHeight * 0.7 * 1 / 5 + 30,
                                      width: context.screenWidth,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 28),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Progress",
                                                style: rowStyle,
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
                                              SizedBox(
                                                width: context.screenWidth,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ZoomTapAnimation(
                                                      onTap: () async {
                                                        //TODO
                                                        if (again > 0) {
                                                          List<Flashcard> cardIns = List.generate(again, (index) => newCards[topics[widget.index].directions!['again']![index]]);

                                                          VxBottomSheet.bottomSheetView(context, child: bottomS('To study', cardIns, topics[widget.index].directions!['again']!, Colors.red, topic), maxHeight: .8, minHeight: .8, roundedFromTop: true);
                                                        }
                                                      },
                                                      child: rev(topicLength: topicLength, direction: again, color: Colors.red, val: _valueNotifierA, topic: 'To study', des: 'You really need to study these'),
                                                    ),
                                                    ZoomTapAnimation(
                                                      onTap: () async {
                                                        //TODO
                                                        if (hard > 0) {
                                                          List<Flashcard> cardIns = List.generate(hard, (index) => newCards[topics[widget.index].directions!['hard']![index]]);

                                                          VxBottomSheet.bottomSheetView(context, child: bottomS('Mediocre', cardIns, topics[widget.index].directions!['hard']!, Colors.orange, topic), maxHeight: .8, minHeight: .8, roundedFromTop: true);
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
                                                          List<Flashcard> cardIns = List.generate(easy, (index) => newCards[topics[widget.index].directions!['easy']![index]]);

                                                          VxBottomSheet.bottomSheetView(context, child: bottomS('Perfect', cardIns, topics[widget.index].directions!['easy']!, Colors.blue, topic), maxHeight: .8, minHeight: .8, roundedFromTop: true);
                                                        }
                                                      },
                                                      child: rev(topicLength: topicLength, direction: easy, color: Colors.blue, val: _valueNotifierE, topic: 'Perfect', des: 'You nailed these flashcards'),
                                                    ),
                                                    ZoomTapAnimation(
                                                      onTap: () async {
                                                        //TODO
                                                        if (good > 0) {
                                                          List<Flashcard> cardIns = List.generate(good, (index) => newCards[topics[widget.index].directions!['good']![index]]);

                                                          VxBottomSheet.bottomSheetView(context, child: bottomS('To revise', cardIns, topics[widget.index].directions!['good']!, Colors.green, topic), maxHeight: .8, minHeight: .8, roundedFromTop: true);
                                                        }
                                                      },
                                                      child: rev(topicLength: topicLength, direction: good, color: Colors.green, val: _valueNotifierG, topic: 'To revise', des: 'You need to read through thesee'),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              //Space
                                              SizedBox(height: context.screenWidth * 0.1 - 20),
                                              ZoomTapAnimation(
                                                onTap: () async {
                                                  List all = [];
                                                  all.addAll(topics[widget.index].card_ids);
                                                  all.remove(topics[widget.index].directions!['again']!);
                                                  all.remove(topics[widget.index].directions!['hard']!);
                                                  all.remove(topics[widget.index].directions!['good']!);
                                                  all.remove(topics[widget.index].directions!['easy']!);
                                                  // Hive.box<Flashcard>('flashcards').deleteAt(67)
                                                  //TODO
                                                  if (all.length > 0) {
                                                    try {
                                                      List<Flashcard> cardIns = List.generate(all.length, (index) => newCards[all[index]]);

                                                      VxBottomSheet.bottomSheetView(context, child: bottomS('To study', cardIns, all, Colors.grey.shade700, topic), maxHeight: .8, minHeight: .8, roundedFromTop: true);
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  }
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
                                            ],
                                          ).px(10),
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
                                      height: context.screenHeight * 0.4 + 30,
                                      width: context.screenWidth,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Progress",
                                                style: rowStyle,
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
                                            height: context.screenHeight * 0.2,
                                            width: context.screenWidth,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                DashedCircularProgressBar.aspectRatio(
                                                  aspectRatio: 1, // width ÷ height
                                                  valueNotifier: _valueNotifier,
                                                  progress: easy / topicLength * 360 - (15 * ((good + hard + again) == 0 ? 0 : 1)),
                                                  maxProgress: 360,
                                                  corners: StrokeCap.round,
                                                  seekColor: Colors.transparent,
                                                  seekSize: 20,
                                                  foregroundColor: easy != 0 ? Colors.blue : Colors.transparent,
                                                  backgroundColor: Colors.transparent,
                                                  foregroundStrokeWidth: 15,
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
                                                                // '${(easy / topicLength * 100).ceil().toInt()}%',
                                                                '${((easy + good) / topicLength * 100).ceil().toInt()} %',
                                                                style: GoogleFonts.aBeeZee(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 25,
                                                                  // color: !MyTheme().isDark ? Color(boxColor[topics.values.toList()[tE].color]) : Colors.white,
                                                                ),
                                                              ),
                                                              Text(
                                                                // '${(easy / topicLength * 100).ceil().toInt()}%',
                                                                'Learnt',
                                                                style: GoogleFonts.aBeeZee(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 20,
                                                                  // color: !MyTheme().isDark ? Color(boxColor[topics.values.toList()[tE].color]) : Colors.white,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                ),
                                                if (good != 0)
                                                  DashedCircularProgressBar.aspectRatio(
                                                    aspectRatio: 1, // width ÷ height
                                                    valueNotifier: _valueNotifier0,
                                                    startAngle: (easy) / topicLength * 360,
                                                    progress: good / topicLength * 360 - (15 * ((easy + hard + again) == 0 ? 0 : 1)),
                                                    maxProgress: 360,
                                                    corners: StrokeCap.round,
                                                    seekColor: Colors.transparent,
                                                    seekSize: 20,
                                                    foregroundColor: Colors.green,
                                                    backgroundColor: Colors.transparent,
                                                    foregroundStrokeWidth: 15,
                                                    backgroundStrokeWidth: 20,
                                                    animation: true,
                                                  ),
                                                if (hard != 0)
                                                  DashedCircularProgressBar.aspectRatio(
                                                    aspectRatio: 1, // width ÷ height
                                                    valueNotifier: _valueNotifier1,
                                                    startAngle: (easy + good) / topicLength * 360,
                                                    progress: hard / topicLength * 360 - (15 * ((good + easy + again) == 0 ? 0 : 1)),
                                                    maxProgress: 360,
                                                    corners: StrokeCap.round,
                                                    seekColor: Colors.transparent,
                                                    seekSize: 20,
                                                    foregroundColor: Colors.orange,
                                                    backgroundColor: Colors.transparent,
                                                    foregroundStrokeWidth: 15,
                                                    backgroundStrokeWidth: 20,
                                                    animation: true,
                                                  ),
                                                if (again != 0)
                                                  DashedCircularProgressBar.aspectRatio(
                                                    aspectRatio: 1, // width ÷ height
                                                    valueNotifier: _valueNotifier2,
                                                    startAngle: (easy + good + hard) / topicLength * 360,
                                                    progress: again / topicLength * 360 - (15 * ((good + hard + easy) == 0 ? 0 : 1)),
                                                    maxProgress: 360,
                                                    corners: StrokeCap.round,
                                                    seekColor: Colors.transparent,
                                                    seekSize: 20,
                                                    foregroundColor: Colors.red,
                                                    backgroundColor: Colors.transparent,
                                                    foregroundStrokeWidth: 15,
                                                    backgroundStrokeWidth: 20,
                                                    animation: true,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          dataTag(percentage: ((easy) / topicLength * 100).ceil().toDouble(), severity: 3).py8().px(20),
                                          dataTag(percentage: ((again + hard + good) / topicLength * 100).floor().toDouble(), severity: 2).px(20),
                                          dataTag(percentage: ((topicLength - again - hard - good - easy) / topicLength * 100).ceil().toDouble(), severity: 1).py8().px(20),
                                        ],
                                      ).px12(),
                                    ),
                                  ),

                                  //Space
                                  const SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: 20,
                                    ),
                                  ),

                                  SliverToBoxAdapter(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Flash cards",
                                          style: rowStyle,
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
                                  ),

                                  //Space
                                  const SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: 10,
                                    ),
                                  ),

                                  SliverGrid.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                                                        number: topic.card_ids[index],
                                                        front: false,
                                                      )),
                                                ),
                                              );
                                            }));
                                          },
                                          onLongTap: () {},
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                                            height: context.screenHeight * 0.13,
                                            constraints: BoxConstraints(maxHeight: context.screenHeight * 0.2),
                                            // width: context.screenWidth * 0.52,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                boxColor[widget.color],
                                              ).withOpacity(.45),
                                              borderRadius: BorderRadius.circular((context.screenHeight * 0.1 - 4) / 4),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${topic.card_ids[index]?.question}",
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                  Expanded(
                                                    child: ListView(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      children: [
                                                        MarkdownBody(
                                                          fitContent: false,
                                                          data: "${topic.card_ids[index]?.answer}",
                                                          selectable: false,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   "${Hive.box<Flashcard>('flashcards').get(topics[widget.index].card_ids[index])?.answer}",
                                                  //   overflow: TextOverflow.ellipsis,
                                                  //   textAlign: TextAlign.left,
                                                  //   style: GoogleFonts.aBeeZee(
                                                  //     fontSize: 15,
                                                  //     fontWeight: FontWeight.bold,
                                                  //   ),
                                                  //   maxLines: 5,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: topics[widget.index].card_ids.length,
                                  ),

                                  //Space
                                  const SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: 90,
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
                        // await addCards(newCards, topic.card_ids, topics, topic, context, widget.index);
                        // topics[widget.index].card_ids = topics[widget.index].card_ids;
                      },
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton.extended(
                      backgroundColor: Color(boxColor[widget.color]).withOpacity(.5),
                      onPressed: () async {
                        List<Flashcard> cardIns = newCards;
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Revision(
                              cards: cardIns,
                              id: widget.index,
                              card_ids: topics[widget.index].card_ids,
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

  Widget bottomS(String title, List<Flashcard> cardIns, List ids, Color color, Topic topic) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              width: context.screenWidth * 0.9,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title.text.align(TextAlign.left).semiBold.scale(2).make(),
                  ZoomTapAnimation(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                      ).px8().py(8).box.rounded.green500.make()),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ZoomTapAnimation(
                  onTap: () {
                    setState(() {});
                    // state(() {
                    //   topic = index;
                    // });
                  },
                  child: Hero(
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
                                  number: topic.card_ids[index],
                                  front: false,
                                ),
                              ),
                            ),
                          );
                        }));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: context.screenHeight * 0.1,
                        decoration: BoxDecoration(
                          color: color.withOpacity(.45),
                          // color: Color(
                          //   boxColor[widget.color],
                          // ).withOpacity(.45),
                          borderRadius: BorderRadius.circular((context.screenHeight * 0.1) / 3),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              "${topic.card_ids[index]?.question}",
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
                  ),
                );
              },
              itemCount: cardIns.length,
            ),
          ),
          SizedBox(
            width: context.screenWidth,
            child: FloatingActionButton.extended(
              heroTag: 'add',
              elevation: 0,
              onPressed: () async {},
              backgroundColor: color,
              label: SizedBox(
                width: context.screenWidth - 150,
                child: Center(
                  child: Text(
                    'Revise these cards',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              shape: const StadiumBorder(),
            ).px(8).py(15),
          )
        ],
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
      height: context.screenHeight * 0.9 * 1.3 / 5,
      decoration: BoxDecoration(
        color: color.withOpacity(.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: context.screenWidth * 0.2,
            width: context.screenWidth * 0.2,
            child: chart(direction, topicLength, color, val),
          ).px(8).py(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic,
                style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              Text(
                des,
                maxLines: 2,
                style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ).px(8).py8()
          // ZoomTapAnimation(
          //   child: Container(
          //     margin: EdgeInsets.all(8),
          //     height: 60,
          //     width: context.screenWidth * 0.45,
          //     decoration: BoxDecoration(
          //       color: color,
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //     alignment: Alignment.center,
          //     child: Text(
          //       "Study",
          //       style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 30),
          //     ).px(4),
          //   ),
          // ),
        ],
      ),
    );
  }
}
