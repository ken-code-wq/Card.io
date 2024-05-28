import 'package:cards/Screens/add_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Screens/add_deck.dart';
import '../Screens/add_subject.dart';
import '../Screens/add_topic.dart';
import 'package:cards/constants/config/config.dart';

class AddNew extends StatefulWidget {
  const AddNew({super.key});

  @override
  State<AddNew> createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  @override
  Widget build(BuildContext context) {
    List<Map> items = [
      {'name': "Flashcards", 'icon': const Icon(Icons.style_rounded)},
      {'name': "Topic", 'icon': const Icon(Icons.topic)},
      {'name': "Subject", 'icon': const FaIcon(FontAwesomeIcons.book)},
      {'name': "Deck", 'icon': const Icon(Icons.library_books_rounded)}
    ];
    return Container(
      height: context.screenHeight * 0.45,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            if (index > 0) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (index == 1) {
                    VxBottomSheet.bottomSheetView(context, child: const AddCart(), maxHeight: .85, minHeight: .85, roundedFromTop: true);
                  } else if (index == 2) {
                    VxBottomSheet.bottomSheetView(context, child: const AddTopic(), maxHeight: 1, minHeight: .9, roundedFromTop: true);
                  } else if (index == 3) {
                    VxBottomSheet.bottomSheetView(context, child: const AddSubject(), maxHeight: 1, minHeight: .7, backgroundColor: Colors.transparent);
                  } else if (index == 4) {
                    VxBottomSheet.bottomSheetView(context, roundedFromTop: true, child: const AddDeck(), maxHeight: 1, minHeight: .6, backgroundColor: Colors.transparent);
                  }
                },
                child: ListTile(
                  title: Text(items[index - 1]['name']),
                  leading: items[index - 1]['icon'],
                ).box.color(MyTheme().isDark ? Colors.black : Colors.grey.shade300).rounded.py1.py1.make().py4().px4(),
              );
            } else {
              return const Row(
                children: [],
              );
            }
          })),
    );
  }
}
