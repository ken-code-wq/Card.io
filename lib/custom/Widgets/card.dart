import 'package:cards/custom/Widgets/question_page.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import 'answer_page.dart';

class FlippingCard extends StatefulWidget {
  final int number;
  const FlippingCard({super.key, required this.number});

  @override
  State<FlippingCard> createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard> {
  FlipCardController cardController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    try {
      if (!cardController.state!.isFront) {
        cardController.toggleCardWithoutAnimation();
      }
    } catch (e) {
      print(e);
    }
    return FlipCard(
      controller: cardController,
      front: QuestionFace(
        number: widget.number,
      ),
      back: AnswerFace(number: widget.number),
    );
  }
}
