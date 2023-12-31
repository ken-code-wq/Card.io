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
        elevation: 20,
        borderOnForeground: true,
        color: Colors.redAccent.shade400,
        child: SizedBox(height: 550, width: 280, child: Center(child: Text("Front page and question ${widget.number}"))),
      ),
      back: Card(
        elevation: 20,
        color: Colors.deepPurpleAccent.shade700,
        child: SizedBox(height: 550, width: 280, child: Center(child: Text("Back page and answers ${widget.number}"))),
      ),
    );
  }
}
