// ignore_for_file: avoid_print

import 'package:cards/constants/constants.dart';
import 'package:cards/services/tester.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:markdown_editor_plus/src/toolbar.dart';

import '../classes/hive_adapter.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import '../services/services.dart';
import 'package:cards/constants/config/config.dart';
import 'add_topic.dart';
import '../services/definitions.dart';

class AddCart extends StatefulWidget {
  const AddCart({super.key});

  @override
  State<AddCart> createState() => _AddCartState();
}

final cards = Hive.box<Flashcard>('flashcards');
int topic = 0;

TextEditingController question = TextEditingController();
TextEditingController answer = TextEditingController();

late Toolbar _toolbar;

// {

// }
class _AddCartState extends State<AddCart> {
  @override
  void initState() {
    // TODO: implement initState
    _toolbar = Toolbar(
      controller: answer,
      // bringEditorToFocus: () {
      //   _focusNode.requestFocus();
      // },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
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
                      "Add Cards",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 30 - 5,
                        fontWeight: FontWeight.w600,
                        // color: !MyTheme().isDark ? Color(boxColor[topics.values.toList()[tE].color]) : Colors.white,
                      ),
                    ).px(20),
                    const SizedBox(
                      height: 20,
                    ),
                    "Select the topic"
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
                    topicPick(),
                    const SizedBox(
                      height: 15,
                    ),
                    "Front of the card"
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
                    // MarkdownField(),
                    // MarkdownToolbar(controller: controller, toolbar: toolbar),
                    TextFormField(
                      style: GoogleFonts.aBeeZee(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      controller: question,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(hintText: "Question...", border: InputBorder.none),
                      keyboardType: TextInputType.name,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ).animatedBox.animDuration(const Duration(milliseconds: 500)).easeIn.color(MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade200).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px20().px2(),
                    const SizedBox(
                      height: 40,
                    ),
                    "Back of the card"
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
                      height: 10,
                    ),
                    AnimatedContainer(
                      width: context.screenWidth,
                      duration: const Duration(microseconds: 900),
                      child: Column(
                        children: [
                          FutureBuilder(
                              future: definitions(query: question.text.trim()),
                              builder: (context, snapshot) {
                                // ignore: unnecessary_null_comparison
                                if (question.text == '' || question.text == null) {
                                  return const Row();
                                } else if (snapshot.hasData) {
                                  try {
                                    return SizedBox(
                                      width: context.screenWidth,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        child: Row(
                                          children: List.generate(snapshot.data!.length, (index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  answer.clear();
                                                  answer.text = snapshot.data![index]['definition'];
                                                });
                                              },
                                              child: Container(
                                                height: context.screenHeight * 0.15,
                                                width: context.screenWidth * 0.3,
                                                margin: const EdgeInsets.only(bottom: 15, left: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                                                  child: Text(snapshot.data![index]['definition']),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    return "No such word".text.makeCentered();
                                  }
                                } else if (snapshot.error != null) {
                                  return 'Error'.text.makeCentered();
                                } else {
                                  return const CircularProgressIndicator().centered();
                                }
                              }),
                          SizedBox(
                            width: context.screenWidth,
                            child: SplittedMarkdownFormField(
                              enableToolBar: false,
                              toolbarBackground: MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              emojiConvert: true,
                              onTap: () async {
                                try {
                                  List<Map> defs = [];
                                  List definitions = await getDefinition(term: question.text.trim());
                                  for (Map info in definitions) {
                                    List meanings = info["meanings"];
                                    for (Map partOfSpeech in meanings) {
                                      Map result = {'partOfSpeech': partOfSpeech['partOfSpeech']};
                                      List ds = partOfSpeech['definitions'];
                                      for (Map definition in ds) {
                                        Map add = {'definition': definition['definition']};
                                        result.addAll(add);
                                        defs.add({
                                          'partOfSpeech': partOfSpeech['partOfSpeech'],
                                          'definition': definition['definition'],
                                        });
                                      }
                                    }
                                  }
                                  print(defs);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              controller: answer,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(hintText: "Type answer", border: InputBorder.none),
                              // keyboardType: TextInputType.multiline,
                              minLines: 4,
                              maxLines: 15,
                            ).animatedBox.animDuration(const Duration(milliseconds: 200)).color(MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade200).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px20().px2(),
                          ),
                          // MarkdownToolbar(
                          //     controller: answer,
                          //     toolbar: const ToolbarOptions(
                          //       copy: true,
                          //       paste: true,
                          //       cut: true,
                          //       selectAll: true,
                          //     )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: context.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            heroTag: 'add',
                            elevation: 0,
                            onPressed: () {},
                            backgroundColor: Colors.black,
                            shape: const StadiumBorder(),
                            child: const Icon(Icons.add, color: Colors.white),
                          ).px(10),
                          FloatingActionButton.extended(
                            heroTag: 'add',
                            elevation: 0,
                            onPressed: () async {
                              if (answer.text.trim().isNotEmpty && question.text.trim().isNotEmpty) {
                                // await CardServices().createCard(
                                //   id: topics .length,
                                //   topic_id: topic,
                                //   question: question.text.trim(),
                                //   answer: answer.text.trim(),
                                //   difficulty_user: difficulty_card,
                                //   usefullness: 5,
                                //   fonts: [0, 0],
                                //   isImage: false,
                                // );
                                List<Flashcard> cds = [];
                                cds.addAll(Hive.box<Topic>('topics').values.toList()[topic].card_ids);
                                cds.add(
                                  Flashcard(
                                    id: Hive.box<Topic>('topics').values.toList()[topic].card_ids.length,
                                    topic_id: topic,
                                    question: question.text.trim(),
                                    answer: answer.text.trim(),
                                    difficulty_user: difficulty_card,
                                    times_appeared: 0,
                                    times_correct: 0,
                                    usefullness: 0,
                                    rate_of_appearance: 0,
                                    times_spent: [0],
                                    ratings: [0],
                                    fonts: [0],
                                    isImage: false,
                                    isAI: false,
                                  ),
                                );
                                TopicServices().editTopic(id: topic, card_ids: cds);
                                question.clear();
                                answer.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 4, milliseconds: 500),
                                    elevation: 15,
                                    backgroundColor: MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    content: const Text(
                                      "❗❗Fill in both question and answer❗❗",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                            },
                            backgroundColor: Colors.blue,
                            label: SizedBox(
                              width: context.screenWidth - 150,
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
                          ).px(8),
                        ],
                      ).py(15),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: context.screenWidth,
              child: MarkdownToolbar(
                showPreviewButton: true,
                // key: const ValueKey<String>("zmarkdowntoolbar"),
                controller: answer,
                emojiConvert: true,
                toolbarBackground: Colors.transparent,
                toolbar: _toolbar,
                onPreviewChanged: () {
                  setState(() {
                    preview = !preview;
                  });
                },
                onActionCompleted: () {
                  setState(() {});
                },
                showEmojiSelection: true,
              ).py(15),
            )
          ],
        ));
  }

  Widget topicPick() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Topic>('topics').listenable(),
        builder: (context, data, child) {
          List<Topic> topics = data.values.toList();
          return ZoomTapAnimation(
            onTap: () {
              VxBottomSheet.bottomSheetView(context, child: topicList(topics), maxHeight: .7, minHeight: .7);
            },
            child: topicMiniCard(topics[topic], false, true, context),
          );
        });
  }

  Widget topicList(List<Topic> topics) {
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
                    "Topics".text.align(TextAlign.left).semiBold.scale(2).make(),
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
                        state(() {
                          topic = index;
                        });
                      },
                      child: topicMiniCard(topics[index], topic == index, false, context));
                },
                itemCount: topics.length,
              ),
            ),
          ],
        ),
      );
    });
  }

  topicSelxector() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Topic>('topics').listenable(),
        builder: (context, data, child) {
          if (data.isNotEmpty) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(data.length + 1, (index) {
                  if (index != data.length) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          topic = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: context.screenHeight * 0.08 + (topic == index ? 10 : 0),
                        width: context.screenWidth * 0.4 + (topic == index ? 10 : -40),
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: topic == index ? Color(boxColor[data.values.toList()[index].color]) : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: "${data.values.toList()[index].name}".text.ellipsis.scale(1.1).fontWeight(FontWeight.w500).makeCentered(),
                      ),
                    );
                  } else {
                    return FloatingActionButton(
                      heroTag: "Topic",
                      backgroundColor: MyTheme().isDark ? Colors.grey.shade900 : Colors.grey.shade400,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, __, ___) => const AddTopic(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOutCubic;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(position: offsetAnimation, child: child);
                            },
                          ),
                        );
                      },
                      child: const Icon(Icons.add),
                    );
                  }
                }),
              ),
            ).box.height(context.screenHeight * 0.11).width(context.screenWidth).px4.make();
          } else {
            return Center(
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => const AddTopic(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutCubic;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(position: offsetAnimation, child: child);
                      },
                    ),
                  );
                },
                label: "Add Topic".text.make().px64(),
                backgroundColor: MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                icon: const Icon(
                  Icons.add,
                  // color: Colors.green[500],
                ),
                heroTag: "Add",
              ),
            );
          }
        });
  }
}

Widget topicMiniCard(Topic topic, bool selected, bool out, BuildContext context) {
  // List<Topic> topics = Hive.box<Topic>('topics').values.toList();
  Color color = Color(boxColor[topic.color]);
  Color lightColor = Color(boxLightColor[topic.color]);
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 80,
    width: context.screenWidth,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      color: out
          ? MyTheme().isDark
              ? color.withOpacity(.2)
              : lightColor.withOpacity(.4)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(60 * 4 / 9),
      // border: selected
      //     ? Border.all(
      //         color: !MyTheme().isDark ? color : Colors.white,
      //         width: 2,
      //       )
      //     : const Border.symmetric(),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 20,
        ),
        CircleAvatar(
          backgroundColor: color,
          radius: 10,
        ),
        const SizedBox(
          width: 30,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // color: color,
              width: context.screenWidth - 160,
              child: Text(
                topic.name,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: GoogleFonts.aBeeZee(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: !MyTheme().isDark ? color : Colors.white,
                ),
              ),
            ),
            Text(
              "${topic.card_ids.length} Cards",
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: GoogleFonts.aBeeZee(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: !MyTheme().isDark ? color : Colors.white,
              ),
            ),
          ],
        ),
        out
            ? Icon(
                Icons.arrow_drop_down_rounded,
                color: color,
                size: 50,
              )
            : selected
                ? Icon(
                    Icons.check_rounded,
                    color: color,
                    size: 40,
                  )
                : const Text('')
      ],
    ),
  );
}
