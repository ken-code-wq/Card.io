// ignore_for_file: non_constant_identifier_names

import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/constants/constants.dart';
import 'package:cards/custom/Widgets/subject_card.dart';
import 'package:cards/custom/Widgets/topic_card.dart';
import 'package:cards/gamification/vibration_tap.dart';
import 'package:cards/pages/subject.dart';
import 'package:cards/pages/topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../constants/config/config.dart';
import '../custom/Widgets/card.dart';
import '../custom/hero_dialog.dart';
import '../services/services.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({
    Key? key,
    required this.id,
  }) : super(key: key);
  final int id;

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> with SingleTickerProviderStateMixin {
  late TabController controller;
  bool upToDown = true;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Deck>('decks').listenable(),
      builder: (context, decks, child) {
        List<Topic> topics = Hive.box<Topic>('topics').values.toList();
        List<Flashcard> cards = Hive.box<Flashcard>('flashcards').values.toList();
        List<Subject> subjects = Hive.box<Subject>('subjects').values.toList();
        List<int> deck_topics = [];
        List<int> deck_subjects = [];
        List<int> deck_cards = [];
        Deck deck = decks.values.toList()[widget.id];
        try {
          deck_topics.addAll(deck.topic_ids as Iterable<int>);
          print(deck_topics);
          deck_subjects.addAll(deck.subject_ids as Iterable<int>);
          deck_cards.addAll(deck.card_ids as Iterable<int>);
        } catch (e) {
          print(e);
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            floatingActionButton: SpeedDial(
              backgroundColor: Color(boxColor[deck.color]),
              children: [
                SpeedDialChild(label: 'Add Cards', onTap: () => addCards(cards, deck_cards, topics, deck, context, widget.id), child: Icon(Icons.style_rounded)),
                SpeedDialChild(label: 'Add Topics', onTap: () => addTopics(cards, deck_cards, topics, deck, deck_topics, context, widget.id), child: Icon(Icons.topic)),
                SpeedDialChild(label: 'Add Subjects', onTap: () => addSubjects(cards, deck_cards, topics, deck, deck_topics, subjects, deck_subjects, context, widget.id), child: FaIcon(FontAwesomeIcons.book)),
              ],
              icon: Icons.add,
            ),
            body: CustomScrollView(
              slivers: [
                //AppBar
                SliverAppBar.large(
                  pinned: true,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: const [Icon(Icons.more_vert)],
                  backgroundColor: Color(boxColor[deck.color]),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      deck.name,
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    background: Hero(
                      tag: "Deck ${widget.id}",
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        color: Color(
                          boxColor[deck.color],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    color: Color(boxColor[deck.color]),
                    padding: EdgeInsets.only(top: 8, left: 15, right: 15),
                    margin: EdgeInsets.only(bottom: 30),
                    child: TabBar(
                      // controller: controller,
                      dividerColor: Color(boxColor[deck.color]),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                      indicatorColor: Colors.white,
                      indicatorWeight: 8,
                      unselectedLabelStyle: TextStyle(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(
                          text: 'Cards',
                        ),
                        Tab(
                          text: 'Topic',
                        ),
                        Tab(
                          text: 'Subjects',
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight * 0.65 - 30,
                    child: TabBarView(
                      // controller: controller,
                      children: [
                        if (deck_cards.isEmpty)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                addCards(cards, deck_cards, topics, deck, context, widget.id);
                              },
                              icon: Icon(Icons.add, color: Color(boxColor[deck.color])),
                              label: Text(
                                'Add card',
                                style: TextStyle(color: Color(boxColor[deck.color])),
                              ),
                            ),
                          )
                        else
                          Scaffold(
                            body: SizedBox(
                              height: context.screenHeight * 0.65,
                              width: context.screenWidth,
                              child: MasonryGridView.builder(
                                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                mainAxisSpacing: 14,
                                scrollDirection: Axis.vertical,
                                itemCount: deck.card_ids?.length ?? 0,
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
                                                    number: deck.card_ids![index],
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
                                            boxColor[deck.color],
                                          ).withOpacity(.45),
                                          borderRadius: BorderRadius.circular((context.screenHeight * 0.1 - 4) / 4),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Center(
                                            child: Text(
                                              "${Hive.box<Flashcard>('flashcards').get(deck.card_ids![index])?.question}",
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
                              ),
                            ),
                          ),
                        if (deck_topics.isEmpty)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                addTopics(cards, deck_cards, topics, deck, deck_topics, context, widget.id);
                              },
                              icon: Icon(Icons.add, color: Color(boxColor[deck.color])),
                              label: Text(
                                'Add Topic',
                                style: TextStyle(color: Color(boxColor[deck.color])),
                              ),
                            ),
                          )
                        else
                          Scaffold(
                            body: SizedBox(
                              height: context.screenHeight * 0.65,
                              width: context.screenWidth,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: List.generate(
                                    topics.length,
                                    (number) {
                                      int index = 0;
                                      if (upToDown) {
                                        index = topics.length - number - 1;
                                      } else {
                                        index = number;
                                      }
                                      int sId = topics.toList()[index].subject_id;
                                      return ZoomTapAnimation(
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
                                      ).py16().px8();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (deck_subjects.isEmpty)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                addSubjects(cards, deck_cards, topics, deck, deck_topics, subjects, deck_subjects, context, widget.id);
                              },
                              icon: Icon(Icons.add, color: Color(boxColor[deck.color])),
                              label: Text(
                                'Add Subject',
                                style: TextStyle(color: Color(boxColor[deck.color])),
                              ),
                            ),
                          )
                        else
                          Scaffold(
                            body: SizedBox(
                              height: context.screenHeight * 0.65,
                              width: context.screenWidth,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    subjects.length,
                                    (number) {
                                      int index = 0;
                                      if (upToDown) {
                                        index = subjects.length - number - 1;
                                      } else {
                                        index = number;
                                      }
                                      return ZoomTapAnimation(
                                        onLongTap: () {
                                          vibrate(amplitude: 20, duration: 30);
                                          VxBottomSheet.bottomSheetView(
                                            context,
                                            backgroundColor: !MyTheme().isDark ? Color(boxLightColor[subjects.toList()[index].color]) : Colors.grey.shade900,
                                            child: SizedBox(
                                              height: context.screenHeight * 0.35,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ZoomTapAnimation(
                                                    child: ListTile(
                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
                                                      tileColor: Color(boxColor[subjects.toList()[index].color]).withOpacity(.3),
                                                      leading: "🖋".text.headline2(context).make(),
                                                      title: "Edit".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                                      subtitle: const Text("Change name, color and Icon"),
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
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
                                                                          for (int id = 0; id < subjects.toList()[index].topic_ids.length; id++) {
                                                                            await TopicServices().editTopic(id: id, subject_id: 1000000000);
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
                                                      tileColor: Color(boxColor[subjects.toList()[index].color]).withOpacity(.3),
                                                      leading: "❌".text.headline2(context).make(),
                                                      title: "Delete".text.headline4(context).textStyle(GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w700)).make(),
                                                      subtitle: const Text("Delete topic but not all cards and topics in the subject"),
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  ZoomTapAnimation(
                                                    child: ListTile(
                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                                                      tileColor: Color(boxColor[subjects.toList()[index].color]).withOpacity(.3),
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
                                            MaterialPageRoute(
                                              builder: ((context) => SubjectPage(
                                                    id: index,
                                                  )),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: "Subject ${index}",
                                          child: SizedBox(
                                            child: SubjectCard(index: index, subjects: Hive.box<Subject>('subjects'), sId: 0),
                                          ).py4().px8(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future addCards(List<Flashcard> cards, List<int> deck_cards, List<Topic> topics, Deck deck, BuildContext context, int id) {
  return VxBottomSheet.bottomSheetView(
    context,
    // backgroundColor: !MyTheme().isDark ? Colors.white : Colors.grey.shade900,
    child: StatefulBuilder(builder: (context, setCState) {
      return Container(
        height: context.screenHeight * 0.8,
        width: context.screenWidth,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: !MyTheme().isDark ? Colors.white : Colors.grey.shade900, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                  itemCount: cards.length - deck_cards.length,
                  itemBuilder: (context, index) {
                    List<Flashcard> filt = [];
                    filt.addAll(cards);
                    filt.removeWhere((element) => deck_cards.contains(element.id));
                    print(filt);
                    return ZoomTapAnimation(
                      onTap: () {
                        vibrate(amplitude: 20, duration: 30);
                        setCState(() {
                          deck_cards.contains(index + 1) ? deck_cards.remove(index + 1) : deck_cards.add(index + 1);
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
                        trailing: deck_cards.contains(index + 1) ? const Icon(Icons.check) : const Column(),
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
                          await DeckServices().addCardNTopicNSubject(
                            id: id,
                            card_id: deck_cards,
                          );
                          if (deck_cards.isNotEmpty) {
                            for (int i = 0; i < deck_cards.length; i++) {
                              await CardServices().editCard(id: deck_cards[i] - 1, deck_id: id);
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

Future addTopics(List<Flashcard> cards, List<int> deck_cards, List<Topic> topics, Deck deck, List<int> deck_topics, BuildContext context, int id) {
  return VxBottomSheet.bottomSheetView(
    context,
    // backgroundColor: !MyTheme().isDark ? Colors.white : Colors.grey.shade900,
    child: StatefulBuilder(builder: (context, setCState) {
      return Container(
        height: context.screenHeight * 0.8,
        width: context.screenWidth,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: !MyTheme().isDark ? Colors.white : Colors.grey.shade900, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                child: "Add topics".text.semiBold.scale(2.5).make().px12(),
              ).centered(),
            ),
            Expanded(
              flex: 5,
              child: ListView.builder(
                  itemCount: topics.length - deck_topics.length,
                  itemBuilder: (context, index) {
                    List<Topic> filt = [];
                    filt.addAll(topics);
                    filt.removeWhere((element) => deck_topics.contains(element.id));
                    print(filt);
                    return ZoomTapAnimation(
                      onTap: () {
                        vibrate(amplitude: 20, duration: 30);
                        setCState(() {
                          deck_topics.contains(index + 1) ? deck_topics.remove(index + 1) : deck_topics.add(index + 1);
                        });
                      },
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          filt[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        selected: true,
                        subtitle: Text(
                          '${filt[index].card_ids.length} Cards',
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                        trailing: deck_topics.contains(index + 1) ? const Icon(Icons.check) : const Column(),
                        selectedTileColor: !MyTheme().isDark ? Color(boxLightColor[filt[index].color]) : Color(boxColor[filt[index].color]).withOpacity(.4),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: .0, top: 4, bottom: 4),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(boxColor[filt[index].color]),
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
                          await DeckServices().addCardNTopicNSubject(
                            id: id,
                            topic_id: deck_topics,
                          );
                          print(deck.topic_ids);
                          if (deck_topics.isNotEmpty) {
                            for (int i = 0; i < deck_topics.length; i++) {
                              await TopicServices().editTopic(id: deck_topics[i] - 1, deck_id: id);
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

Future addSubjects(List<Flashcard> cards, List<int> deck_cards, List<Topic> topics, Deck deck, List<int> deck_topics, List<Subject> subjects, List<int> deck_subjects, BuildContext context, int id) {
  return VxBottomSheet.bottomSheetView(
    context,
    // backgroundColor: !MyTheme().isDark ? Colors.white : Colors.grey.shade900,
    child: StatefulBuilder(builder: (context, setCState) {
      return Container(
        height: context.screenHeight * 0.8,
        width: context.screenWidth,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: !MyTheme().isDark ? Colors.white : Colors.grey.shade900, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                child: "Add subjects".text.semiBold.scale(2.5).make().px12(),
              ).centered(),
            ),
            Expanded(
              flex: 5,
              child: ListView.builder(
                  itemCount: subjects.length - deck_subjects.length,
                  itemBuilder: (context, index) {
                    return ZoomTapAnimation(
                      onTap: () {
                        vibrate(amplitude: 20, duration: 30);
                        setCState(() {
                          deck_subjects.contains(index + 1) ? deck_subjects.remove(index + 1) : deck_subjects.add(index + 1);
                        });
                      },
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          subjects[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        selected: true,
                        subtitle: Text(
                          '${subjects[index].card_ids.length} Cards \n${subjects[index].topic_ids.length} Topics',
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                        trailing: deck_subjects.contains(index + 1) ? const Icon(Icons.check) : const Column(),
                        selectedTileColor: !MyTheme().isDark ? Color(boxLightColor[subjects[index].color]) : Color(boxColor[subjects[index].color]).withOpacity(.4),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: .0, top: 4, bottom: 4),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(boxColor[subjects[index].color]),
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
                          await DeckServices().addCardNTopicNSubject(
                            id: id,
                            subject_id: deck_subjects,
                          );
                          print(deck.subject_ids);
                          if (deck_subjects.isNotEmpty) {
                            for (int i = 0; i < deck_subjects.length; i++) {
                              await SubjectServices().editSubject(id: deck_subjects[i] - 1, deck_id: id);
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
