import 'package:cards/Screens/add_deck.dart';
import 'package:cards/Screens/add_subject.dart';
import 'package:cards/Screens/add_topic.dart';
import 'package:cards/config/config.dart';
import 'package:cards/constants/constants.dart';
import 'package:cards/pages/subject.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:cards/classes/hive_adapter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

import '../gamification/vibration_tap.dart';
import '../pages/topic.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

bool upToDown = false;

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('prefs').listenable(),
      builder: (context, dark, child) => SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: "Library".text.semiBold.scale(2).make(),
              actions: [
                ZoomTapAnimation(
                  onTap: () {
                    setState(() {
                      upToDown = !upToDown;
                    });
                  },
                  child: Icon(
                    Icons.swap_vert_rounded,
                    color: upToDown
                        ? MyTheme().isDark
                            ? Colors.white
                            : Colors.deepPurple
                        : Colors.grey.shade700,
                  ).px16(),
                )
              ],
              backgroundColor: Colors.transparent,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(context.screenHeight * 0.1),
                child: Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: TabBar(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      labelStyle: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: GoogleFonts.aBeeZee(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: [
                        AnimatedContainer(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                          duration: const Duration(milliseconds: 100),
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text('Topics'),
                        ),
                        AnimatedContainer(
                          margin: EdgeInsets.zero,
                          duration: const Duration(milliseconds: 100),
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text('Subjects', maxLines: 1),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text('Decks'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                topics(),
                subjects(),
                decks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topics() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Topic>('topics').listenable(),
        builder: (context, topics, child) {
          var subjects = Hive.box<Subject>('subjects');
          if (topics.isEmpty) {
            return Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  VxBottomSheet.bottomSheetView(context, child: const AddTopic(), maxHeight: 1, minHeight: .9, backgroundColor: Colors.transparent);

                  // Navigator.push(
                  //   context,
                  //   PageRouteBuilder(
                  //     opaque: false,
                  //     pageBuilder: (_, __, ___) => const AddTopic(),
                  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  //       const begin = Offset(1.0, 0.0);
                  //       const end = Offset.zero;
                  //       const curve = Curves.easeInOutCubic;

                  //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  //       var offsetAnimation = animation.drive(tween);

                  //       return SlideTransition(position: offsetAnimation, child: child);
                  //     },
                  //   ),
                  // );
                },
                label: "Add Topic".text.make().px64(),
                icon: const Icon(
                  Icons.add,
                  // color: Colors.green[500],
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(
                  topics.length,
                  (number) {
                    int index = 0;
                    if (upToDown) {
                      index = topics.values.length - number - 1;
                    } else {
                      index = number;
                    }
                    int sId = topics.values.toList()[index].subject_id ?? 1000000000;
                    return ZoomTapAnimation(
                      onLongTap: () {
                        print(index);
                        vibrate(amplitude: 20, duration: 30);
                        VxBottomSheet.bottomSheetView(
                          context,
                          backgroundColor: Color(boxLightColor[topics.values.toList()[index].color]),
                          child: SizedBox(
                            height: context.screenHeight * 0.45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ZoomTapAnimation(
                                  child: ListTile(
                                    leading: "🖋".text.headline2(context).make(),
                                    title: "Edit".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                    subtitle: const Text("Change name, color and Subject"),
                                  ),
                                ),
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
                                    leading: "❌".text.headline2(context).make(),
                                    title: "Delete".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                    subtitle: const Text("Delete topic but not all cards this topic"),
                                  ),
                                ),
                                ZoomTapAnimation(
                                  child: ListTile(
                                    leading: "👓".text.headline2(context).make(),
                                    title: "More".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          minHeight: .45,
                          maxHeight: .7,
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return TopicPage(
                              index: index,
                              color: topics.values.toList()[index].color,
                            );
                          }),
                        );
                      },
                      child: SizedBox(
                        height: context.screenHeight * 0.26,
                        width: context.screenWidth,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: "Topic $index",
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: context.screenHeight * 0.2,
                                    width: 6,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(boxColor[topics.values.toList()[index].color])),
                                  ),
                                ),
                              ),
                              Container(
                                height: context.screenHeight * 0.25,
                                width: context.screenWidth * 0.9,
                                decoration: BoxDecoration(
                                  color: !MyTheme().isDark ? Color(boxLightColor[topics.values.toList()[index].color]) : Color(boxColor[topics.values.toList()[index].color]).withOpacity(.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  topics.values.toList()[index].name,
                                                  style: GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  "${levelsBoxes[topics.values.toList()[index].difficulty]['name']}",
                                                  style: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.w600, color: Color(levelsBoxes[topics.values.toList()[index].difficulty]['color'])),
                                                ),
                                                Text(
                                                  sId != 1000000000 ? subjects.values.toList()[sId].name : '<Unknown Subject>',
                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ).px16(),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                "${topics.values.toList()[index].card_ids.length}".text.scale(3).textStyle(GoogleFonts.aBeeZee()).make(),
                                                "Cards".text.scale(1.5).fontWeight(FontWeight.w400).make(),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
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
                    ).py4().px8();
                  },
                ),
              ),
            );
          }
        });
  }

  Widget subjects() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Subject>('subjects').listenable(),
        builder: (context, subjects, child) {
          if (subjects.isEmpty) {
            return Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  VxBottomSheet.bottomSheetView(context, child: const AddSubject(), maxHeight: 1, minHeight: .9, backgroundColor: Colors.transparent);
                },
                label: "Add Subject".text.make().px64(),
                icon: const Icon(
                  Icons.add,
                  // color: Colors.green[500],
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  subjects.length,
                  (number) {
                    int index = 0;
                    if (upToDown) {
                      index = subjects.values.length - number - 1;
                    } else {
                      index = number;
                    }
                    return ZoomTapAnimation(
                      onLongTap: () {
                        print(index);
                        vibrate(amplitude: 20, duration: 30);
                        VxBottomSheet.bottomSheetView(
                          context,
                          backgroundColor: Color(boxLightColor[subjects.values.toList()[index].color]),
                          child: SizedBox(
                            height: context.screenHeight * 0.45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ZoomTapAnimation(
                                  child: ListTile(
                                    leading: "🖋".text.headline2(context).make(),
                                    title: "Edit".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                    subtitle: const Text("Change name, color and Icon"),
                                  ),
                                ),
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
                                              "Are you sure you want to delete this subject",
                                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                            ),
                                            content: const Text("Deleting this subject does not delete the topics and cards associated to this subject, unless you say so. \nWhat would you want to delete ?"),
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
                                                        for (int id = 0; id < subjects.values.toList()[index].topic_ids.length; id++) {
                                                          await TopicServices().editTopic(id: id, subject_id: null);
                                                        }
                                                        await SubjectServices().remove(index);
                                                        // ignore: use_build_context_synchronously
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Subject only",
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
                                    leading: "❌".text.headline2(context).make(),
                                    title: "Delete".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                    subtitle: const Text("Delete topic but not all cards and topics in the subject"),
                                  ),
                                ),
                                ZoomTapAnimation(
                                  child: ListTile(
                                    leading: "👓".text.headline2(context).make(),
                                    title: "More".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          minHeight: .45,
                          maxHeight: .7,
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => SubjectPage(
                                  id: index,
                                )),
                          ),
                        );
                      },
                      child: Hero(
                        tag: "Subject ${index}",
                        child: Container(
                          height: context.screenHeight * 0.25,
                          width: context.screenWidth,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: !MyTheme().isDark ? Color(boxLightColor[subjects.values.toList()[index].color]) : Color(boxColor[subjects.values.toList()[index].color]).withOpacity(.4),
                            borderRadius: BorderRadius.circular(10),
                            border: BorderDirectional(
                              bottom: BorderSide(
                                color: Color(boxColor[subjects.values.toList()[index].color]),
                                width: 6,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        subjects.values.toList()[index].name,
                                        style: GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        "${levelsBoxes[subjects.values.toList()[index].difficulty]['name']}",
                                        style: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.w600, color: Color(levelsBoxes[subjects.values.toList()[index].difficulty]['color'])),
                                      ),
                                    ),
                                  ],
                                ).px16(),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Image.asset(
                                    images[subjects.values.toList()[index].more?['asset'] ?? 0],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).py4().px8(),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        });
  }

  Widget decks() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Deck>('decks').listenable(),
        builder: (context, decks, child) {
          if (decks.isEmpty) {
            return Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  VxBottomSheet.bottomSheetView(context, roundedFromTop: true, child: const AddDeck(), maxHeight: 1, minHeight: .6, backgroundColor: Colors.transparent);
                },
                label: "Add Deck".text.make().px64(),
                icon: const Icon(
                  Icons.add,
                  // color: Colors.green[500],
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  decks.length,
                  (number) {
                    int index = 0;
                    if (upToDown) {
                      index = decks.values.length - number - 1;
                    } else {
                      index = number;
                    }
                    return Container(
                      height: context.screenHeight * 0.25,
                      width: context.screenWidth,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: MyTheme().isDark ? Colors.black : Color(boxLightColor[decks.values.toList()[index].color]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 6,
                            width: context.screenWidth,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(boxColor[decks.values.toList()[index].color])),
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          decks.values.toList()[index].name,
                                          style: GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ).px16(),
                                  ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Row(
                                  //     crossAxisAlignment: CrossAxisAlignment.end,
                                  //     children: [
                                  //       "${decks.values.toList()[index].card_ids?.length ?? 0}".text.scale(3).textStyle(GoogleFonts.aBeeZee()).make(),
                                  //       const Text("Cards"),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).py4().px8();
                  },
                ),
              ),
            );
          }
        });
  }
}
