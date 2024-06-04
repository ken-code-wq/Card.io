// ignore_for_file: unnecessary_const, empty_catches

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/constants/constants.dart';
import 'package:cards/services/services.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:animations/animations.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../constants/config/config.dart';
import '../custom/Widgets/blur.dart';
import '../custom/Widgets/topic_card.dart';
import '../gamification/vibration_tap.dart';
import '../pages/revision_page.dart';
import '../pages/topic.dart';
import 'library.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

//TODO: Credit card
//4704749001945214
//08/26
//Code: 417
//Ruth Glover Boulo
// A week way
List greetings = ['Good morning', 'Good afternoon', 'Good evening'];
List names = ['Levi', 'Annie', 'Mikasa', 'Eren', 'Hanje', 'Zeek', 'Pyxis'];
int dayTime = 0;
int val = 70;
double max = 0;
int t = 0;

List<String> formalities = [
  '🌅',
  '⛅',
  '🌒',
];

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    if (DateTime.now().hour < 12) {
      dayTime = 0;
    } else if (DateTime.now().hour < 17) {
      dayTime = 1;
    } else {
      dayTime = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Topic> topics = Hive.box<Topic>('topics').values.toList();
    List<Subject> subjects = Hive.box<Subject>('subjects').values.toList();
    for (int i = 0; i <= topics.length; i++) {
      try {
        if (topics[i].card_ids.isEmpty) {
          int cardL = 1;
          double maxT = topics[i].directions!['easy']!.length / cardL;
          if (maxT >= max) {
            t = i;
            max = maxT;
          }
        } else {
          double maxT = topics[i].directions!['easy']!.length / topics[i].card_ids.length;
          if (maxT >= max && maxT != 1) {
            t = i;
            max = maxT;
          }
        }
      } catch (e) {}
    }
    setState(() {
      val = (max * 100).ceil();
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const Drawer(
          shape: BeveledRectangleBorder(),
        ),
        body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              surfaceTintColor: Colors.transparent,
              actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
              centerTitle: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset('assets/streak-flame.png'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 25,
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return RadialGradient(
                          center: Alignment.topLeft,
                          radius: 1.0,
                          colors: <Color>[
                            Colors.amber.withOpacity(1),
                            Colors.orange.withOpacity(1),
                            Colors.red.withOpacity(1),
                          ],
                        ).createShader(bounds);
                      },
                      child: Text("102",
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          )).px4(),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: greeting(context),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: context.screenHeight * 0.08,
                width: context.screenWidth * 0.6,
                child: TabBar(
                  padding: EdgeInsets.zero,
                  // dividerColor: Color(boxColor[widget.color]),
                  labelStyle: GoogleFonts.aBeeZee(color: MyTheme().isDark ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  indicatorColor: MyTheme().isDark ? Colors.white : Colors.black,
                  indicatorWeight: 4,
                  unselectedLabelStyle: TextStyle(color: MyTheme().isDark ? Colors.white60 : Colors.grey.shade800, fontSize: 15, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(
                      text: 'Learn',
                    ),
                    Tab(
                      text: 'Explore',
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: SizedBox(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 30),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return ValueListenableBuilder(
                                  valueListenable: Hive.box<Topic>('topics').listenable(),
                                  builder: (context, topicss, child) {
                                    return dueTopic(context, topicss.values.toList()[index]);
                                  });
                            },
                            childCount: topics.length,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 60),
                        ),
                      ],
                    ),
                    CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([bestTopic(context), collumnRow(context, setState)]),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 60),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget revision(BuildContext context) {
  List<Topic> topics = Hive.box<Topic>('topics').values.toList();
  return Container(
    color: Colors.transparent,
    margin: const EdgeInsets.symmetric(vertical: 40),
    height: context.screenHeight * 0.32,
    width: context.screenWidth,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Revise these topics",
              style: rowStyle,
            ),
            ZoomTapAnimation(
              onTap: () {
                // setState(() {
                //   currentIndex = 1;
                // });
              },
              child: Container(
                height: 30,
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  "All",
                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, color: Colors.blue),
                ),
              ),
            ),
          ],
        ).px12(),
        const SizedBox(height: 15),
        SizedBox(
          height: context.screenHeight * 0.25,
          width: context.screenWidth,
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverList.builder(
                itemBuilder: (context, number) {
                  int index = 0;
                  if (upToDown) {
                    index = topics.length - number - 1;
                  } else {
                    index = number;
                  }
                  int sId = topics.toList()[index].subject_id;
                  return SizedBox(
                    width: context.screenWidth * 0.8,
                    child: ZoomTapAnimation(
                      onLongTap: () {
                        vibrate(amplitude: 20, duration: 30);
                        VxBottomSheet.bottomSheetView(
                          context,
                          backgroundColor: !MyTheme().isDark ? Color(boxLightColor[topics.toList()[index].color]) : Colors.grey.shade900,
                          child: SizedBox(
                            height: context.screenHeight * 0.35,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ZoomTapAnimation(
                                  child: ListTile(
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
                                    tileColor: Color(boxColor[topics.toList()[index].color]).withOpacity(.3),
                                    leading: "🖋".text.headline2(context).make(),
                                    title: "Edit".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                    subtitle: const Text("Change name, color and Subject"),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                ZoomTapAnimation(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            title: Text(
                                              "Are you sure you want to delete this topic ?",
                                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                            ),
                                            content: const Text("Deleting this topic does not delete the cards associated to this topic, unless you say so. \nWhat would you want to delete ?"),
                                            actions: [
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: Colors.grey[700],
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: Colors.red.shade300,
                                                      ),
                                                      onPressed: () async {
                                                        await TopicServices().remove(id: index);
                                                        // ignore: use_build_context_synchronously
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Topic only",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15.0),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: Colors.red.shade900,
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        //TODO
                                                      },
                                                      child: const Text(
                                                        "Everything",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: ListTile(
                                    tileColor: Color(boxColor[topics.toList()[index].color]).withOpacity(.3),
                                    leading: "❌".text.headline2(context).make(),
                                    title: "Delete".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                    subtitle: const Text("Delete topic but not all cards this topic"),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                ZoomTapAnimation(
                                  child: ListTile(
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                                    tileColor: Color(boxColor[topics.toList()[index].color]).withOpacity(.3),
                                    leading: "👓".text.headline2(context).make(),
                                    title: "More".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                  ),
                                ),
                              ],
                            ).px8(),
                          ),
                          minHeight: .35,
                          maxHeight: .7,
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return TopicPage(
                              index: index,
                              color: topics.toList()[index].color,
                            );
                          }),
                        );
                      },
                      child: TopicCard(index: index, topics: Hive.box<Topic>('topics'), sId: sId),
                      // child: topicMiniCard(index, false, true, context),
                    ),
                  ).px8();
                },
                itemCount: topics.length <= 3 ? topics.length : 4,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget greeting(BuildContext context) {
  return Container(
    height: context.screenHeight * 0.13,
    width: context.screenWidth,
    margin: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      // gradient: LinearGradient(colors: [Colors.deepPurpleAccent.withOpacity(.8), Colors.deepPurpleAccent.withOpacity(.6), Colors.deepPurpleAccent.withOpacity(.4)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              formalities[dayTime],
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
            ).px24(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 32,
                //   child: DefaultTextStyle(
                //     style: GoogleFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.w600, color: !MyTheme().isDark ? Colors.black : Colors.white),
                //     child: AnimatedTextKit(
                //       isRepeatingAnimation: false,
                //       animatedTexts: [
                //         RotateAnimatedText(greetings[dayTime], rotateOut: false, transitionHeight: 70, alignment: Alignment.bottomLeft),
                //       ],
                //       onTap: () {
                //         print("Tap Event");
                //       },
                //     ),
                //   ),
                // ),
                Text(
                  greetings[dayTime],
                  style: GoogleFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                Text(
                  names[DateTime.now().weekday - 1],
                  //package:google_fonts/google_fonts.dart 'Pearl',
                  style: GoogleFonts.aBeeZee(fontSize: 35, fontWeight: FontWeight.w700),
                )
              ],
            )
          ],
        ).py12(),
      ],
    ),
  );
}

Widget tqopicStat(BuildContext context) {
  List<Topic> topics = Hive.box<Topic>('topics').values.toList();
  return ZoomTapAnimation(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return TopicPage(
            index: t,
            color: topics.toList()[t].color,
          );
        }),
      );
    },
    child: Container(
      width: context.screenWidth,
      height: context.screenHeight * 0.25,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 4, spreadRadius: .4),
        ],
        color: MyTheme().isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // AnimatedContainer(duration: Durations.long4,)
          FAProgressBar(
            currentValue: val.toDouble(),
            size: context.screenHeight * 0.25,
            progressColor: Color(boxColor[topics[t].color]).withOpacity(.8),
            borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), bottomLeft: const Radius.circular(20), topRight: Radius.circular(val != 100 ? 0 : 20), bottomRight: Radius.circular(val != 100 ? 0 : 20)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: context.screenWidth * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${val.toInt()}%',
                        style: GoogleFonts.aBeeZee(
                            fontSize: val < 100 ? 80 : 60,
                            color: val > 30
                                ? Colors.white
                                : !MyTheme().isDark
                                    ? Colors.black
                                    : Colors.white,
                            shadows: [BoxShadow(color: Color(boxColor[topics[t].color]), blurRadius: 20, spreadRadius: 0.4)])),
                    Text('Completed',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: val > 30
                                ? Colors.white
                                : !MyTheme().isDark
                                    ? Colors.black
                                    : Colors.white)),
                    Text('${topics[t].card_ids.length} Cards',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: val > 30
                                ? Colors.white
                                : !MyTheme().isDark
                                    ? Colors.black
                                    : Colors.white)),
                  ],
                ),
              ),
              Container(
                height: context.screenHeight * 0.12,
                width: context.screenWidth * 0.4,
                constraints: BoxConstraints(
                  maxHeight: context.screenHeight * 0.2,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(color: MyTheme().isDark ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(boxColor[topics[t].color]))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Topic: ",
                      style: TextStyle(color: !MyTheme().isDark ? Colors.black : Colors.white),
                    ),
                    Text(
                      topics[t].name,
                      style: GoogleFonts.aBeeZee(fontSize: 25, color: !MyTheme().isDark ? Colors.black : Colors.white, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget collumnRow(BuildContext context, void Function(void Function()) setState) {
  return SizedBox(
    height: context.screenHeight * 0.36,
    width: context.screenWidth,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ZoomTapAnimation(
          child: SizedBox(
            height: context.screenHeight * 0.36,
            width: context.screenWidth * 0.45,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: context.screenHeight * 0.36,
                  width: context.screenWidth * 0.45,
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
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  height: context.screenHeight * 0.36,
                  width: context.screenWidth * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: MyTheme().isDark ? Colors.black : Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  height: context.screenHeight * 0.36,
                  width: context.screenWidth * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64 / 3),
                    gradient: LinearGradient(colors: [
                      Colors.amber.withOpacity(.1),
                      Colors.orange.withOpacity(.1),
                      Colors.red.withOpacity(.1),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: context.screenHeight * 0.15,
                        child: Image.asset('assets/streak-flame.png'),
                      ),
                      SizedBox(
                        child: Column(
                          children: [
                            Text("102", style: GoogleFonts.aBeeZee(fontSize: 60, fontWeight: FontWeight.w900, color: Colors.orange)),
                            Text("Day Streak", style: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ZoomTapAnimation(
                child: Container(
                  width: context.screenWidth * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Blur(
                          blur: 20,
                          onTop: SizedBox(
                            width: context.screenWidth * 0.45,
                            height: context.screenHeight * 0.36,
                          ),
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return RadialGradient(
                            center: Alignment.topLeft,
                            radius: 1.0,
                            colors: <Color>[Colors.blueAccent.shade200, Colors.lightBlue.shade700],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: Text("Try AI generated quizzes",
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.aBeeZee(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )).py8().px12(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: context.screenWidth * 0.1 / 3),
            Expanded(
              child: ZoomTapAnimation(
                onTap: () {
                  vibrate(amplitude: 20, duration: 30);
                  setState(() {
                    // Hive.box('prefs').put('isDark', val);
                    MyTheme().switchTheme(isDark: !MyTheme().isDark);
                    MyTheme().refresh();
                  });
                },
                child: Container(
                  width: context.screenWidth * 0.45,
                  decoration: BoxDecoration(
                    color: MyTheme().isDark ? Colors.blue.shade600.withOpacity(.7) : Colors.blue.withOpacity(.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.dark_mode_rounded),
                          Switch(
                            inactiveThumbColor: Colors.blue.shade100,
                            inactiveTrackColor: Colors.black,
                            onChanged: (val) {
                              vibrate(amplitude: 20, duration: 30);
                              setState(() {
                                // Hive.box('prefs').put('isDark', val);
                                MyTheme().switchTheme(isDark: val);
                                MyTheme().refresh();
                              });
                            },
                            value: MyTheme().isDark,
                          )
                        ],
                      ).px12().py4(),
                      Text("Toggle dark mode", style: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.w600)).py8().px12(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget dueTopic(BuildContext context, Topic topic) {
  int topicL = topic.card_ids.isEmpty ? 1 : topic.card_ids.length;
  return Hero(
    tag: topic.id,
    child: Material(
      color: Colors.transparent,
      child: ZoomTapAnimation(
        onTap: () async {
          // for (int i = 0; i < topic.card_ids.length; i++) {
          //   try {
          //     await CardServices().editCard(id: topic.card_ids[i], topic_id: topic.id);
          //   } catch (e) {
          //     print(e);
          //   }
          // }
          List<Flashcard> cardIns = topic.card_ids;
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return Revision(
                cards: cardIns,
                id: topic.id,
                card_ids: topic.card_ids,
              );
            }),
          );
        },
        child: Container(
          width: context.screenWidth,
          height: 170,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: MyTheme().isDark ? Color(boxColor[topic.color]).withOpacity(.2) : Color(boxLightColor[topic.color]).withOpacity(.4),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${(topic.card_ids.length - topic.card_ids.length / 2).toInt()}',
                            style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 45, color: !MyTheme().isDark ? Color(boxColor[topic.color]) : Colors.white),
                          ),
                          Text(
                            '/${topic.card_ids.length}',
                            style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 20, color: !MyTheme().isDark ? Color(boxColor[topic.color]) : Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        'Cards due',
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 18, color: !MyTheme().isDark ? Color(boxColor[topic.color]) : Colors.white),
                      ),
                    ],
                  ).px8(),
                  SizedBox(
                    height: 90,
                    width: context.screenWidth - 40 - 16 - 110,
                    child: Text(
                      topic.name,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.aBeeZee(
                        fontSize: topic.name.length <= 10 ? 40 : 30,
                        fontWeight: FontWeight.w600,
                        color: !MyTheme().isDark ? Color(boxColor[topic.color]) : Colors.white,
                      ),
                    ),
                  ),
                ],
              ).px(15).py(4),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: topic.directions!['easy']!.isNotEmpty ? 2 : 0),
                    width: topic.directions!['easy']!.length / topicL * (context.screenWidth * 0.9 - 60),
                    height: 10,
                    child: FAProgressBar(
                      currentValue: 100,
                      backgroundColor: Colors.white.withOpacity(.2),
                      size: 10,
                      progressColor: Colors.blue,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: topic.directions!['good']!.isNotEmpty ? 2 : 0),
                    width: topic.directions!['good']!.length / topicL * (context.screenWidth * 0.9 - 60),
                    height: 10,
                    child: FAProgressBar(
                      currentValue: 100,
                      backgroundColor: Colors.white.withOpacity(.2),
                      size: 10,
                      progressColor: Colors.green,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: topic.directions!['hard']!.isNotEmpty ? 2 : 0),
                    width: topic.directions!['hard']!.length / topicL * (context.screenWidth * 0.9 - 60),
                    height: 10,
                    child: FAProgressBar(
                      currentValue: 100,
                      backgroundColor: Colors.white.withOpacity(.2),
                      size: 10,
                      progressColor: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    width: topic.directions!['again']!.length / topicL * (context.screenWidth * 0.9 - 60),
                    height: 10,
                    child: FAProgressBar(
                      currentValue: 100,
                      backgroundColor: Colors.white.withOpacity(.2),
                      size: 10,
                      progressColor: Colors.red,
                      // progressColor: Color(boxColor[topic.color]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: topicL - (topic.directions!['easy']!.length + topic.directions!['good']!.length + topic.directions!['hard']!.length + topic.directions!['again']!.length) != 0 ? 2 : 0),
                    width: (topicL - (topic.directions!['easy']!.length + topic.directions!['good']!.length + topic.directions!['hard']!.length + topic.directions!['again']!.length)) / topicL * (context.screenWidth * 0.9 - 60),
                    height: 10,
                    child: FAProgressBar(
                      currentValue: 100,
                      backgroundColor: Colors.white.withOpacity(.2),
                      size: 10,
                      progressColor: Colors.grey.shade400,
                    ),
                  ),
                ],
              ).px(20),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.blue,
                      ).px12(),
                      Text(
                        "${topic.directions?['easy']!.length}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.green,
                      ).px12(),
                      Text(
                        "${topic.directions?['good']!.length}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.red,
                      ).px12(),
                      Text(
                        "${topic.directions?['again']!.length}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.orange,
                      ).px12(),
                      Text(
                        "${topic.directions?['hard']!.length}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey.shade400,
                      ).px12(),
                      Text(
                        "${(topicL - (topic.directions!['easy']!.length + topic.directions!['good']!.length + topic.directions!['hard']!.length + topic.directions!['again']!.length))}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ).px(15),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget bestTopic(BuildContext context) {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  var subjects = Hive.box<Subject>('subjects');
  return ValueListenableBuilder(
      valueListenable: Hive.box<Topic>('topics').listenable(),
      builder: (context, topics, child) {
        int valE = 70;
        int maxE = 0;
        int tE = 0;

        for (int i = 0; i < topics.length; i++) {
          try {
            if (topics.values.toList()[i].card_ids.isEmpty) {
              int cardL = 1;
              int maxT = topics.values.toList()[i].directions!['easy']!.length;
              if (maxT >= maxE) {
                tE = topics.values.toList()[i].id;
                maxE = maxT;
                valE = (maxE / cardL * 100).ceil();
              }
            } else {
              int maxT = topics.values.toList()[i].directions!['easy']!.length;
              if (maxT >= maxE) {
                tE = topics.values.toList()[i].id;
                maxE = maxT;
                valE = (maxE / topics.values.toList()[i].card_ids.length * 100).ceil();
              }
            }

            print(topics.values.toList()[tE].name);
            print(maxE);
            print(tE);
            print(valE);
          } catch (e) {
            print(e);
          }
        }
        return ZoomTapAnimation(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return TopicPage(
                  index: tE,
                  color: topics.values.toList()[tE].color,
                );
              }),
            );
          },
          child: Container(
            width: context.screenWidth,
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: MyTheme().isDark ? Color(boxColor[topics.values.toList()[tE].color]).withOpacity(.2) : Color(boxLightColor[topics.values.toList()[tE].color]).withOpacity(.4),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: DashedCircularProgressBar.aspectRatio(
                    aspectRatio: 1, // width ÷ height
                    valueNotifier: _valueNotifier,
                    progress: valE.toDouble(),
                    maxProgress: 100,
                    corners: StrokeCap.round,
                    seekColor: Colors.transparent,
                    seekSize: 20,
                    foregroundColor: Color(boxColor[topics.values.toList()[tE].color]),
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
                                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600, fontSize: 35, color: !MyTheme().isDark ? Color(boxColor[topics.values.toList()[tE].color]) : Colors.white),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          topics.values.toList()[tE].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.aBeeZee(
                            fontSize: topics.values.toList()[tE].name.length <= 10 ? 40 : 30,
                            fontWeight: FontWeight.w600,
                            color: !MyTheme().isDark ? Color(boxColor[topics.values.toList()[tE].color]) : Colors.white,
                          ),
                        ),
                        Text(
                          "${topics.values.toList()[tE].directions!['easy']!.length}/${topics.values.toList()[tE].card_ids.length} cards learned",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: !MyTheme().isDark ? Color(boxColor[topics.values.toList()[tE].color]) : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ).py16(),
                ),
              ],
            ),
          ),
        );
      });
}
