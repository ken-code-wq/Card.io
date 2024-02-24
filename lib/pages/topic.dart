import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';

import '../classes/hive_adapter.dart';
import '../constants/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    List<Topic> topics = Hive.box<Topic>('topics').values.toList();
    List cardIds = topics[widget.index].card_ids;
    List<Flashcard> cards = List.generate(cardIds.length, (index) => Hive.box<Flashcard>('flashcards').values.toList()[index]);
    double progress = 20;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //AppBar
          SliverAppBar.large(
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [const Icon(Icons.more_vert)],
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
              child: ColoredBox(
                color: Colors.transparent,
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
                      child: DashedCircularProgressBar.aspectRatio(
                        aspectRatio: 1, // width ÷ height
                        valueNotifier: _valueNotifier,
                        progress: progress,
                        maxProgress: 100,
                        corners: StrokeCap.round,
                        seekColor: Colors.white,
                        seekSize: 10,
                        foregroundColor: Color(
                          boxColor[widget.color],
                        ),
                        backgroundColor: const Color(0xffeeeeee),
                        foregroundStrokeWidth: 15,
                        backgroundStrokeWidth: 20,
                        animation: true,
                        child: Center(
                          child: ValueListenableBuilder(
                            valueListenable: _valueNotifier,
                            builder: (_, double value, __) => Text(
                              '${value.toInt()}%',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 60),
                            ),
                          ),
                        ),
                      ),
                    ),
                    dataTag(percentage: progress, severity: 3).py8(),
                    dataTag(percentage: 15, severity: 2),
                    dataTag(percentage: 65, severity: 1).py8(),
                  ],
                ),
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
              height: context.screenHeight * 0.32,
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
                    height: context.screenHeight * 0.25,
                    width: context.screenWidth,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: context.screenWidth * 0.42,
                          decoration: BoxDecoration(
                            color: Color(
                              boxColor[widget.color],
                            ).withOpacity(.45),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${Hive.box<Flashcard>('flashcards').get(cardIds[index])?.question}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 7,
                              ).centered(),
                              Text(
                                "${Hive.box<Flashcard>('flashcards').get(cardIds[index])?.answer}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 7,
                              ).centered(),
                            ],
                          ),
                        );
                      },
                      itemCount: topics[widget.index].card_ids.length,
                    ),
                  ),
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
