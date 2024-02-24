import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:cards/config/config.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../constants/constants.dart';
import '../custom/Widgets/difficulty_selector.dart';

class AddTopic extends StatefulWidget {
  const AddTopic({super.key});

  @override
  State<AddTopic> createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  int col = 0;
  int subject = 0;

  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var topics = Hive.box<Topic>('topics');
    var subjects = Hive.box<Subject>('subjects');
    return SizedBox(
      height: context.screenHeight * 0.7,
      child: StatefulBuilder(builder: (context, setDState) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (name.text.trim().isNotEmpty) {
                await TopicServices().create(id: topics.length + 1, name: name.text, color: col, font: 0, difficulty: difficulty_topic, subject_id: subject != 0 ? subject - 1 : null);

                name.clear();
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.done),
          ),
          body: Container(
            width: context.screenWidth,
            decoration: BoxDecoration(
              color: MyTheme().isDark ? const Color.fromARGB(255, 56, 56, 56) : Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                topLeft: Radius.circular(18),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: context.screenHeight * 0.058,
                  width: context.screenWidth,
                  child: Center(
                    child: Container(
                      height: 7,
                      width: context.screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            setState(() {
                              subject = value;
                            });
                          },
                          position: PopupMenuPosition.under,
                          constraints: BoxConstraints(
                            minWidth: context.screenWidth * 0.95,
                            maxWidth: context.screenWidth * 0.95,
                          ),
                          // color: Colors.transparent,
                          // elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(
                              subjects.length + 1,
                              (index) {
                                if (index > 0) {
                                  return PopupMenuItem(
                                    value: index,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        title: Text(
                                          subjects.values.toList()[index - 1].name,
                                        ),
                                        trailing: subject == index - 1 ? const Icon(Icons.check) : const Column(),
                                        tileColor: !MyTheme().isDark ? Color(boxLightColor[subjects.values.toList()[index - 1].color]) : Color(boxColor[subjects.values.toList()[index - 1].color]).withOpacity(.4),
                                        leading: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            images[subjects.values.toList()[index - 1].more?['asset'] ?? 0],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const PopupMenuItem(
                                    value: 0,
                                    child: ListTile(title: Text("No subject")),
                                  );
                                }
                              },
                            );
                          },
                          child: ListTile(
                            title: const Text("Select subject"),
                            subtitle: subject != 0 ? Text(subjects.values.toList()[subject - 1].name) : Text('No subject'),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            tileColor: subject != 0
                                ? !MyTheme().isDark
                                    ? Color(boxLightColor[subjects.values.toList()[subject - 1].color])
                                    : Color(boxColor[subjects.values.toList()[subject - 1].color]).withOpacity(.4)
                                : ThemeData().listTileTheme.tileColor,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: name,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 4,
                          minLines: 1,
                          decoration: const InputDecoration(hintText: "TName of topic", border: InputBorder.none),
                          keyboardType: TextInputType.name,
                        ).animatedBox.animDuration(const Duration(milliseconds: 500)).easeIn.color(MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade300).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px20().px2(),
                        const SizedBox(
                          height: 40,
                        ),
                        "Select difficulty".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
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
                        "Select color".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
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
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
