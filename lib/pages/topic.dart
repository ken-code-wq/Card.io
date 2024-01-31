import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../classes/hive_adapter.dart';
import '../constants/constants.dart';
import 'revision_page.dart';

class TopicPage extends StatefulWidget {
  int index;
  int color;

  TopicPage({
    Key? key,
    required this.index,
    required this.color,
  }) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

List<Topic> topics = Hive.box<Topic>('topics').values.toList();

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.color);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          topics[widget.index].name,
          style: GoogleFonts.aBeeZee(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Hero(
          tag: widget.index,
          child: Container(height: MediaQuery.of(context).size.height * 0.2, width: MediaQuery.of(context).size.width, color: Color(boxColor[widget.color])),
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            List card_ids = topics[widget.index].card_ids;
            List<Flashcard> cards = List.generate(card_ids.length, (index) => Hive.box<Flashcard>('flashcards').values.toList()[index]);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Revision(
                cards: cards,
                id: widget.index,
                card_ids: card_ids,
              );
            }));
          },
          icon: const Icon(Icons.book),
          label: const Text(
            "Revise",
          ),
        ),
      ),
    );
  }
}
