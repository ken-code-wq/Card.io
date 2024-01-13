import 'package:cards/Screens/add_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Screens/add_topic.dart';

class AddNew extends StatefulWidget {
  const AddNew({super.key});

  @override
  State<AddNew> createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  @override
  Widget build(BuildContext context) {
    List<Map> items = [
      {'name': "Flashcards", 'icon': Icon(Icons.style_rounded)},
      {'name': "Topic", 'icon': Icon(Icons.topic)},
      {'name': "Subject", 'icon': FaIcon(FontAwesomeIcons.book)},
      {'name': "Deck", 'icon': Icon(Icons.library_books_rounded)}
    ];
    return Container(
      child: Expanded(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pop(context);
              if (index == 0) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => const AddCart(),
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
              } else if (index == 1) {
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
              }
            },
            child: ListTile(
              title: Text(items[index]['name']),
              leading: items[index]['icon'],
            ),
          );
        },
        itemCount: 4,
      )),
    );
  }
}
