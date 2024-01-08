import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/constants.dart';
import '../custom/Widgets/difficulty_selector.dart';

class AddTopic extends StatefulWidget {
  const AddTopic({super.key});

  @override
  State<AddTopic> createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dismissible(
        key: const Key('AddTopic'),
        direction: DismissDirection.down,
        background: const ColoredBox(color: Colors.transparent),
        onDismissed: (d) {
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(top: context.screenHeight * 0.4),
          height: context.screenHeight * 0.9,
          width: context.screenWidth,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 56, 56, 56),
            boxShadow: [
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
                      "Name of the topic".text.scale(1.2).fontWeight(FontWeight.w500).make().py4().px24(),
                      const Divider().px20().px2(),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: name,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        minLines: 1,
                        decoration: const InputDecoration(hintText: "Question...", border: InputBorder.none),
                        keyboardType: TextInputType.name,
                      ).animatedBox.animDuration(const Duration(milliseconds: 500)).easeIn.color(Colors.grey.shade800).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px20().px2(),
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
                      const SizedBox(
                        height: 15,
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
