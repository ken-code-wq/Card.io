import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cards/config/config.dart';

import '../constants/constants.dart';
import '../custom/Widgets/difficulty_selector.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

int col = 0;

TextEditingController name = TextEditingController();

class _AddSubjectState extends State<AddSubject> {
  @override
  Widget build(BuildContext context) {
    var subjects = Hive.box<Subject>('subjects');
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (name.text.trim().isNotEmpty) {
            await SubjectServices().create(id: subjects.length + 1, name: name.text, color: col, font: 0, difficulty: difficulty_subject);
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.done),
      ),
      body: Dismissible(
        key: const Key('AddSubject'),
        direction: DismissDirection.down,
        background: const ColoredBox(color: Colors.transparent),
        onDismissed: (d) {
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(top: context.screenHeight * 0.4),
          height: context.screenHeight * 0.9,
          width: context.screenWidth,
          decoration: BoxDecoration(
            color: MyTheme().isDark ? const Color.fromARGB(255, 56, 56, 56) : Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(163, 0, 0, 0),
                blurRadius: 205,
                spreadRadius: 2500,
              )
            ],
            borderRadius: BorderRadius.only(
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
                      "Name of the subject".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                      const Divider().px20().px2(),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: name,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        minLines: 1,
                        decoration: const InputDecoration(hintText: "Subject", border: InputBorder.none),
                        keyboardType: TextInputType.name,
                      ).animatedBox.animDuration(const Duration(milliseconds: 500)).easeIn.color(MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade300).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px20().px2(),
                      const SizedBox(
                        height: 40,
                      ),
                      "Select difficulty".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                      const Divider().px20().px2(),
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
                      const Divider().px20().px2(),
                      const SizedBox(
                        height: 15,
                      ),
                      PopupMenuButton(
                        child: ListTile(
                          title: const Text("Select your color"),
                          trailing: CircleAvatar(backgroundColor: Color(boxColor[col])),
                        ),
                        onSelected: (value) {
                          setState(() {
                            col = value;
                          });
                        },
                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        itemBuilder: (BuildContext bc) {
                          return List.generate(
                            boxColor.length,
                            (index) => PopupMenuItem(
                              value: index,
                              child: CircleAvatar(backgroundColor: Color(boxColor[index])),
                            ),
                          );
                        },
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
      ),
    );
  }
}
