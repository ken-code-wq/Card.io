import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../classes/hive_adapter.dart';
import '../services/services.dart';

class AddCart extends StatefulWidget {
  const AddCart({super.key});

  @override
  State<AddCart> createState() => _AddCartState();
}

final cards = Hive.box<Flashcard>('flashcards');

class _AddCartState extends State<AddCart> {
  @override
  Widget build(BuildContext context) {
    TextEditingController question = TextEditingController();
    TextEditingController answer = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            TextFormField(
              controller: question,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: "Type question"),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 60,
            ),
            TextFormField(
              controller: answer,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: "Type answer"),
              keyboardType: TextInputType.multiline,
              maxLines: 9,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (answer.text.trim().isNotEmpty && question.text.trim().isNotEmpty) {
            await CardServices().createCard(
              id: cards.length + 1,
              topic_id: 0,
              question: question.text.trim(),
              answer: answer.text.trim(),
              difficulty_user: 3,
              usefullness: 5,
              fonts: [0, 0],
              isImage: false,
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 3),
                elevation: 6,
                backgroundColor: Colors.grey[900],
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
        backgroundColor: Colors.green.shade900,
        child: const Icon(Icons.check),
      ),
    );
  }
}
