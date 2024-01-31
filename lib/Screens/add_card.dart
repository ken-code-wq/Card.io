import 'package:cards/constants/constants.dart';
import 'package:cards/services/tester.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

import '../classes/hive_adapter.dart';
import '../custom/Widgets/difficulty_selector.dart';
import '../services/services.dart';
import 'package:cards/config/config.dart';
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

class _AddCartState extends State<AddCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Dismissible(
        key: const Key('Addcard'),
        direction: DismissDirection.down,
        background: const ColoredBox(color: Colors.transparent),
        onDismissed: (d) {
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(top: context.screenHeight * 0.1),
          height: context.screenHeight * 0.9,
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
                      "Select the topic".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                      const Divider().px20().px2(),
                      topicSelector(),
                      const SizedBox(
                        height: 15,
                      ),
                      "Front of the card".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                      const Divider().px20().px2(),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: question,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        minLines: 1,
                        decoration: const InputDecoration(hintText: "Question...", border: InputBorder.none),
                        keyboardType: TextInputType.name,
                        onChanged: (val) {
                          setState(() {});
                        },
                      ).animatedBox.animDuration(const Duration(milliseconds: 500)).easeIn.color(MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade300).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px20().px2(),
                      const SizedBox(
                        height: 40,
                      ),
                      "Definition".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                      const Divider().px20().px2(),
                      const SizedBox(
                        height: 15,
                      ),
                      AnimatedContainer(
                        duration: const Duration(microseconds: 900),
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: definitions(query: question.text.trim()),
                                builder: (context, snapshot) {
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
                            TextFormField(
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
                                        //("done $result");
                                        //("done $add");
                                        //({'partOfSpeech': partOfSpeech['partOfSpeech'], 'definition': definition['definition']});
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
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 9,
                            ).animatedBox.animDuration(const Duration(milliseconds: 200)).color(MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade300).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px20().px2(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      "Select difficulty".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                      const Divider().px20().px2(),
                      const SizedBox(
                        height: 15,
                      ),
                      DifficultySelector(
                        type: BoxType.card,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        onPressed: () async {
          if (answer.text.trim().isNotEmpty && question.text.trim().isNotEmpty) {
            await CardServices().createCard(
              id: Hive.box<Flashcard>('flashcards').length + 1,
              topic_id: topic,
              question: question.text.trim(),
              answer: answer.text.trim(),
              difficulty_user: difficulty_card,
              usefullness: 5,
              fonts: [0, 0],
              isImage: false,
            );
            question.clear();
            answer.clear();
            Navigator.pop(context);
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
        backgroundColor: MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade500,
        child: Icon(
          Icons.check,
          color: Colors.green[500],
        ),
      ),
    );
  }

  topicSelector() {
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
