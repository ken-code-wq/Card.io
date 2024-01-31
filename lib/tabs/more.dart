import 'package:cards/config/config.dart';
import 'package:cards/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('prefs').listenable(),
      builder: (context, dark, child) => SafeArea(
          child: Center(
        child: ListTile(
          title: Text(
            "Dark theme",
            style: GoogleFonts.aBeeZee(fontSize: 18),
          ),
          leading: Icon(Icons.dark_mode_rounded),
          trailing: Switch(
            onChanged: (val) {
              // Hive.box('prefs').put('isDark', val);
              MyTheme().switchTheme(isDark: val);
              MyTheme().refresh();
            },
            value: MyTheme().isDark,
          ),
        ).box.color(MyTheme().isDark ? Colors.black : Colors.grey.shade300).rounded.py1.py1.make().py4().px4(),
      )),
    );
  }
}
