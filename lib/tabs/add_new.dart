import 'package:cards/Screens/add_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Screens/add_topic.dart';import 'package:cards/config/config.dart';

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
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            if (index > 0) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (index == 1) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => const AddCart(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutCubic;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(position: offsetAnimation, child: child);
                        },
                      ),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => const AddTopic(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutCubic;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(position: offsetAnimation, child: child);
                        },
                      ),
                    );
                  }
                },
                child: ListTile(
                  title: Text(items[index - 1]['name']),
                  leading: items[index - 1]['icon'],
                ).box.color(MyTheme().isDark ? Colors.black : Colors.grey.shade300).rounded.py1.py1.make().py4().px4(),
              );
            } else {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Add new...",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
            }
          })),
    );
  }
}
