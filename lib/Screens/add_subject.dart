import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cards/config/config.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../constants/constants.dart';
import '../custom/Widgets/difficulty_selector.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

int col = 0;
int currentlySelectedPic = 0;

TextEditingController name = TextEditingController();

const List imagez = [
  'assets/ai.png',
  'assets/books_library_1.png',
  'assets/compass.png',
  'assets/english.png',
  'assets/home.png',
  'assets/math.png',
  'assets/more.png',
  'assets/search.png',
  'assets/worldwide.png',
  'assets/car-engine.png',
  'assets/chemistry.png',
  'assets/dollar.png',
  'assets/drugs.png',
  'assets/keyboard.png',
  'assets/law.png',
  'assets/palette.png',
  'assets/science.png',
  'assets/sports.png',
];

class _AddSubjectState extends State<AddSubject> {
  @override
  Widget build(BuildContext context) {
    var subjects = Hive.box<Subject>('subjects');
    return SizedBox(
      height: context.screenHeight * 0.95,
      child: StatefulBuilder(builder: (context, setDState) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (name.text.trim().isNotEmpty) {
                await SubjectServices().create(id: subjects.length + 1, name: name.text, color: col, font: 0, difficulty: difficulty_subject, more: {'asset': currentlySelectedPic});

                name.clear();
                currentlySelectedPic = 0;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.done),
          ),
          body: Container(
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
                        // "Name of the subject".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                        // const Divider().px20().px2(),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: name,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 4,
                          minLines: 1,
                          decoration: const InputDecoration(hintText: "Name of the subject", border: InputBorder.none),
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
                          type: BoxType.subject,
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
                          height: 40,
                        ),
                        "Select image".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                        // const Divider().px20().px2(),
                        SizedBox(
                          height: context.screenHeight * 0.35,
                          width: context.screenWidth,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    currentlySelectedPic = index;
                                  });
                                },
                                child: Container(
                                  // width: context.screenHeight * 0.15,
                                  margin: const EdgeInsets.only(left: 15),
                                  // padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(imagez[index], height: context.screenHeight * 0.08, width: context.screenHeight * 0.08),
                                      AnimatedContainer(
                                        width: context.screenHeight * 0.15,
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: currentlySelectedPic == index ? Colors.black45 : Colors.transparent,
                                            // image: DecorationImage(image: AssetImage(images[index])),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                                color: currentlySelectedPic == index
                                                    ? !MyTheme().isDark
                                                        ? Colors.black
                                                        : Colors.white
                                                    : Colors.transparent,
                                                width: 3)),
                                        duration: const Duration(milliseconds: 200),
                                        // child: Center(
                                        //   child: currentlySelectedPic == index
                                        //       ? const Icon(
                                        //           Icons.check_rounded,
                                        //           color: Colors.white,
                                        //           size: 50,
                                        //         )
                                        //       : const Row(),
                                        // ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: images.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        const SizedBox(
                          height: 100,
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
