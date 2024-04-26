import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/constants/constants.dart';
import 'package:cards/gamification/vibration_tap.dart';
import 'package:cards/pages/topic.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:cards/services/services.dart';

import '../config/config.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key, required this.id});
  final int id;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Subject>('subjects').listenable(),
        builder: (context, subjects, child) {
          List<Topic> topics = Hive.box<Topic>('topics').values.toList();
          List<int> subject_topics = [];
          Subject subject = subjects.values.toList()[widget.id];
          subject_topics.addAll(subject.topic_ids);

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  pinned: true,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [const Icon(Icons.more_vert)],
                  backgroundColor: Color(
                    boxColor[subject.color],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: context.screenWidth * 0.5 - 36,
                          child: Text(
                            subject.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.aBeeZee(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Hero(
                            tag: "Subject Image ${widget.id}",
                            child: Image.asset(
                              images[subject.more?['asset'] ?? 0],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ).px4(),
                      ],
                    ),
                    background: Hero(
                      tag: "Subject ${widget.id}",
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        color: Color(
                          boxColor[subject.color],
                        ),
                      ),
                    ),
                  ),
                ),
                //Space
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
                //Topics
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Topics",
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      Text(
                        "More stats",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(
                            boxColor[subject.color],
                          ),
                        ),
                      ),
                    ],
                  ).px12(),
                ),
                //Space
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                //List
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: context.screenHeight * 0.15,
                    width: context.screenWidth,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ZoomTapAnimation(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return TopicPage(index: subject.topic_ids[index] - 1, color: topics[subject.topic_ids[index] - 1].color);
                              }),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                            margin: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: Color(boxColor[subject.color]).withOpacity(.4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: "Topic ${subject.topic_ids[index] - 1}",
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      topics[subject.topic_ids[index] - 1].name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    '${topics[subject.topic_ids[index] - 1].card_ids.length} Cards',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: subject.topic_ids.length,
                    ),
                  ),
                ),
                //Space
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
                //Add Topic
                SliverToBoxAdapter(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      VxBottomSheet.bottomSheetView(
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
                                    child: "Add topic".text.semiBold.scale(2.5).make().px12(),
                                  ).centered(),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: ListView.builder(
                                      itemCount: topics.length,
                                      itemBuilder: (context, index) {
                                        return ZoomTapAnimation(
                                          onTap: () {
                                            vibrate(amplitude: 20, duration: 30);
                                            setCState(() {
                                              subject_topics.contains(index + 1) ? subject_topics.remove(index + 1) : subject_topics.add(index + 1);
                                            });
                                          },
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            title: Text(
                                              topics[index].name,
                                              style: GoogleFonts.aBeeZee(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            selected: true,
                                            subtitle: Text('${topics[index].card_ids.length} Cards'),
                                            trailing: subject_topics.contains(index + 1) ? const Icon(Icons.check) : const Column(),
                                            selectedTileColor: !MyTheme().isDark ? Color(boxLightColor[topics[index].color]) : Color(boxColor[topics[index].color]).withOpacity(.4),
                                            leading: Padding(
                                              padding: const EdgeInsets.only(left: .0, top: 4, bottom: 4),
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Color(boxColor[topics[index].color]),
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
                                              await SubjectServices().editSubject(
                                                id: widget.id,
                                                topic_ids: subject_topics,
                                              );
                                              if (subject_topics.isNotEmpty) {
                                                for (int i = 0; i < subject_topics.length; i++) {
                                                  await TopicServices().editTopic(id: subject_topics[i] - 1, subject_id: widget.id);
                                                }
                                              }
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            label: const Text("Add"),
                                            elevation: .0,
                                            shape: const StadiumBorder(),
                                            backgroundColor: Color(boxColor[subject.color]).withOpacity(.4),
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
                    },
                    label: const Text("Add Topic"),
                    icon: const Icon(Icons.add),
                    elevation: .0,
                    shape: const StadiumBorder(),
                    backgroundColor: Color(boxColor[subject.color]).withOpacity(.4),
                  ).px16().px4(),
                ),
              ],
            ),
            // body: ListView.builder(
            //   itemBuilder: (context, index) {
            //     return Text(
            //       topics[subject.topic_ids[index] - 1].name,
            //     );
            //   },
            //   itemCount: subject.topic_ids.length,
            // ),
          );
        });
  }
}
