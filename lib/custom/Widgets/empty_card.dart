import 'package:cards/Screens/add_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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

        // Navigator.pushNamed(context, '/addCard');
      },
      child: Card(
        elevation: 20,
        borderOnForeground: true,
        color: Colors.grey.shade900,
        child: SizedBox(
          height: 550,
          width: 280,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 550,
              width: 200,
              child: Center(
                child: Text(
                  "No cards available, add a new card",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.acme(fontSize: 40, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.grey.shade700, blurRadius: 15)]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
