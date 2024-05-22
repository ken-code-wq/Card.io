import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../classes/hive_adapter.dart';
import '../constants/config/config.dart';
import '../constants/constants.dart';

class AddDeck extends StatefulWidget {
  const AddDeck({super.key});

  @override
  State<AddDeck> createState() => _AddDeckState();
}

TextEditingController name = TextEditingController();
int col = 0;

class _AddDeckState extends State<AddDeck> {
  @override
  Widget build(BuildContext context) {
    List<Deck> decks = Hive.box<Deck>('decks').values.toList();
    col = 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await DeckServices().create(id: decks.length, name: name.text, color: col);
          Navigator.pop(context);
        },
        label: Text("Create deck"),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Add Deck".text.semiBold.scale(2).make(),
      ),
      body: StatefulBuilder(builder: (context, setDState) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: name,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                minLines: 1,
                decoration: const InputDecoration(hintText: "Enter deck name", border: InputBorder.none),
                keyboardType: TextInputType.name,
              ).animatedBox.animDuration(const Duration(milliseconds: 500)).easeIn.color(MyTheme().isDark ? Colors.grey.shade800 : Colors.grey.shade300).padding(const EdgeInsets.symmetric(horizontal: 5, vertical: 7)).px20.rounded.make().px16(),
              const SizedBox(
                height: 40,
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
        );
      }),
    );
  }
}
