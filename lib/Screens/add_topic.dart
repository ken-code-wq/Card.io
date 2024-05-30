import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/constants/config/config.dart';
import 'package:cards/services/services.dart';

import '../constants/constants.dart';
import '../custom/Widgets/difficulty_selector.dart';

class AddTopic extends StatefulWidget {
  final Topic? topic;
  const AddTopic({
    Key? key,
    this.topic,
  }) : super(key: key);

  @override
  State<AddTopic> createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  int col = 0;
  int subject = 0;
  bool edit = false;

  TextEditingController name = TextEditingController();

  @override
  void initState() {
    if (widget.topic != null) {
      setState(() {
        name.text = widget.topic!.name;
        col = widget.topic!.color;
        subject = widget.topic!.subject_id + 1;
        difficulty_topic = widget.topic!.difficulty;
        edit = true;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var topics = Hive.box<Topic>('topics');
    return StatefulBuilder(builder: (context, setDState) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Add Topic",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 30 - 5,
                        fontWeight: FontWeight.w600,
                        // color: !MyTheme().isDark ? Color(boxColor[topics.values.toList()[tE].color]) : Colors.white,
                      ),
                    ).px(20),
                    const SizedBox(
                      height: 30,
                    ),
                    "Select Subject"
                        .text
                        .textStyle(
                          GoogleFonts.aBeeZee(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        .make()
                        .py4()
                        .px24(),
                    subjectPick(),
                    const SizedBox(
                      height: 15,
                    ),
                    "Topic name"
                        .text
                        .textStyle(
                          GoogleFonts.aBeeZee(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        .make()
                        .py4()
                        .px24(),
                    TextFormField(
                      controller: name,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(hintText: "Name of topic", border: InputBorder.none),
                      keyboardType: TextInputType.name,
                    ).animatedBox.animDuration(const Duration(milliseconds: 500)).easeIn.color(MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade200).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px20().px2(),
                    const SizedBox(
                      height: 40,
                    ),
                    "Select difficulty"
                        .text
                        .textStyle(
                          GoogleFonts.aBeeZee(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        .make()
                        .py4()
                        .px24(),
                    // const Divider().px20().px2(),
                    const SizedBox(
                      height: 15,
                    ),
                    DifficultySelector(
                      type: BoxType.topic,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    "Select color"
                        .text
                        .textStyle(
                          GoogleFonts.aBeeZee(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        .make()
                        .py4()
                        .px24(),
                    // const Divider().px20().px2(),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          boxColor.length,
                          (index) => ZoomTapAnimation(
                            onTap: () {
                              setDState(() {
                                col = index;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(
                                boxColor[index],
                              ),
                              radius: 20,
                              child: Center(
                                child: col == index
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : const Column(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                if (name.text.trim().isNotEmpty) {
                  if (!edit) {
                    await TopicServices().create(
                      id: topics.length + 1,
                      name: name.text,
                      color: col,
                      font: 0,
                      difficulty: difficulty_topic,
                      subject_id: subject != 0 ? subject - 1 : 1000000000,
                      directions: {'again': [], 'hard': [], 'good': [], 'easy': []},
                    );
                  } else {
                    await TopicServices().editTopic(
                      id: widget.topic!.id,
                      name: name.text,
                      color: col,
                      font: 0,
                      difficulty: difficulty_topic,
                      subject_id: subject != 0 ? subject - 1 : 1000000000,
                    );
                  }

                  name.clear();
                  Navigator.pop(context);
                }
              },
              elevation: 0,
              label: SizedBox(
                width: context.screenWidth,
                child: Center(
                  child: Text(
                    'Create',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              shape: const StadiumBorder(),
            ).px(10).py(10),
          ],
        ),
      );
    });
  }

  Widget subjectList(List<Subject> subjects) {
    return StatefulBuilder(builder: (context, state) {
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
                    "Subjects".text.align(TextAlign.left).semiBold.scale(2).make(),
                    ZoomTapAnimation(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ).px8().py(12).box.rounded.blue500.make()),
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
                            state(() {
                              subject = index + 1;
                            });
                          },
                          child: SubjectMiniCard(context, 2, subjects[index], false, index + 1 == subject))
                      .px(8)
                      .py(8);
                },
                itemCount: subjects.length,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget subjectPick() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Subject>('subjects').listenable(),
        builder: (context, data, child) {
          List<Subject> subjects = data.values.toList();
          return ZoomTapAnimation(
            onTap: () {
              VxBottomSheet.bottomSheetView(context, child: subjectList(subjects), maxHeight: .7, minHeight: .7);
            },
            child: subject != 0 && subject != 1000000001 ? SubjectMiniCard(context, subject, subjects[subject - 1], true, false) : SubjectMiniCard(context, 0, subjects[0], true, false),
          );
        }).px(8);
  }
}

// ignore: non_constant_identifier_names
Widget SubjectMiniCard(BuildContext context, int subject, Subject sbject, bool showC, bool sel) {
  return ListTile(
    selected: true,
    enabled: false,
    // isThreeLine: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    subtitle: Text(
      subject == 0 ? "No subject" : "${sbject.topic_ids.length} Topics | ${sbject.card_ids.length} Cards ",
      maxLines: 1,
      textAlign: TextAlign.justify,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.aBeeZee(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: subject == 0
            ? Colors.blue
            : !MyTheme().isDark
                ? Color(boxColor[sbject.color])
                : Colors.white,
      ),
    ),
    title: Text(
      subject == 0 ? 'Select a subject' : sbject.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.aBeeZee(
        fontSize: subject == 0 ? 25 : 35,
        fontWeight: FontWeight.w600,
        color: subject == 0
            ? Colors.blue
            : !MyTheme().isDark
                ? Color(boxColor[sbject.color])
                : Colors.white,
      ),
    ),
    tileColor: subject == 0
        ? Colors.blue.withOpacity(.2)
        : !showC
            ? !MyTheme().isDark
                ? Color(boxLightColor[sbject.color])
                : Color(boxColor[sbject.color]).withOpacity(.4)
            : Colors.transparent,
    leading: subject != 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              images[sbject.more?['asset'] ?? 0],
            ),
          )
        : null,
    trailing: !sel
        ? Icon(
            Icons.arrow_drop_down_rounded,
            color: subject == 0
                ? !MyTheme().isDark
                    ? Colors.blue
                    : Colors.white
                : !MyTheme().isDark
                    ? Color(boxColor[sbject.color])
                    : Colors.white,
            size: 50,
          )
        : Icon(
            Icons.check_rounded,
            color: Colors.white,
          ).px8().py(8).box.rounded.color(Color(boxColor[sbject.color])).make(),
  );
}
