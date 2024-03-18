import 'package:cards/custom/Widgets/question_page.dart';
import 'package:cards/gamification/vibration_tap.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import 'answer_page.dart';

class FlippingCard extends StatefulWidget {
  final int number;
  final bool front;
  const FlippingCard({super.key, required this.number, this.front = true});

  @override
  State<FlippingCard> createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard> {
  FlipCardController cardController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    if (widget.front) {
      try {
        if (!cardController.state!.isFront) {
          cardController.toggleCard();
        }
      } catch (e) {
        print(e);
      }
    }

    return FlipCard(
      side: widget.front ? CardSide.FRONT : CardSide.BACK,
      controller: cardController,
      front: QuestionFace(
        number: widget.number,
      ),
      back: AnswerFace(number: widget.number),
    );
  }
}
