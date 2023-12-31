import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FlippingCard extends StatefulWidget {
  final int number;
  const FlippingCard({super.key, required this.number});

  @override
  State<FlippingCard> createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: Card(
        child: Text("Front page and question ${widget.number}"),
      ),
      back: Card(
        child: Text("Back page and answers ${widget.number}"),
      ),
    );
  }
}
