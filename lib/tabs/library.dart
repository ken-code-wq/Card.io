import 'package:cards/Screens/add_subject.dart';
import 'package:cards/Screens/add_topic.dart';
import 'package:cards/config/config.dart';
import 'package:cards/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cards/classes/hive_adapter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

import '../pages/topic.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

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
                        // AnimatedContainer(
                        //   duration: const Duration(milliseconds: 100),
                        //   height: 50,
                        //   alignment: Alignment.center,
                        //   child: const Text('Cards'),
                        // ),
                        // Tab(
                        //   text: 'Topics',
                        //   // icon: Icon(Icons.topic),
                        // ),
                        // Tab(
                        //   text: 'Subjects',
                        //   // icon: FaIcon(FontAwesomeIcons.book),
                        // ),
                        // Tab(
                        //   text: 'Decks',
                        //   // icon: Icon(Icons.library_books_rounded),
                        // ),
                        // Tab(
                        //   text: 'Cards',
                        //   // icon: Icon(Icons.style_rounded),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(physics: const NeverScrollableScrollPhysics(), children: [
              topics(),
              subjects(),
              decks(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget topics() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Topic>('topics').listenable(),
        builder: (context, topics, child) {
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
                  (index) {
                    return InkWell(
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
                                tag: index,
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
                                                  "${topics.values.toList()[index].subject_id ?? '<Unknown Subject>'}",
                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ).px16(),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                "${topics.values.toList()[index].card_ids.length}".text.scale(3).textStyle(GoogleFonts.aBeeZee()).make(),
                                                const Text("Cards"),
                                              ],
                                            ),
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
                  (index) {
                    return Container(
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
                            // start: BorderSide(
                            //   color: Color(boxColor[subjects.values.toList()[index].color]),
                            //   width: 6,
                            //   style: BorderStyle.solid,
                            // ),
                            // end: BorderSide(
                            //   color: Color(boxColor[subjects.values.toList()[index].color]),
                            //   width: 6,
                            //   style: BorderStyle.solid,
                            // ),
                          )),
                      child: Column(
                        children: [
                          // Container(
                          //   height: 6,
                          //   width: context.screenWidth,
                          //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(boxColor[subjects.values.toList()[index].color])),
                          // ),
                          Expanded(
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          subjects.values.toList()[index].name,
                                          style: GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${levelsBoxes[subjects.values.toList()[index].difficulty]['name']}",
                                          style: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.w600, color: Color(levelsBoxes[subjects.values.toList()[index].difficulty]['color'])),
                                        ),
                                      ],
                                    ).px16(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Expanded(
                                      flex: 1,
                                      child: Image.asset(
                                        'assets/math.png',
                                        height: context.screenHeight * 0.2,
                                      ),
                                    ),
                                  ),
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

  Widget decks() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Deck>('decks').listenable(),
        builder: (context, decks, child) {
          if (decks.isEmpty) {
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
                  (index) {
                    return Container(
                      height: context.screenHeight * 0.25,
                      width: context.screenWidth,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: MyTheme().isDark ? Colors.black : Colors.grey.shade300,
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
                                    flex: 3,
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
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        "${decks.values.toList()[index].card_ids?.length ?? 0}".text.scale(3).textStyle(GoogleFonts.aBeeZee()).make(),
                                        const Text("Cards"),
                                      ],
                                    ),
                                  ),
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
