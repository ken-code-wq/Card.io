import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/tabs/add_new.dart';
import 'package:cards/tabs/home.dart';
import 'package:cards/tabs/discover.dart';
import 'package:cards/tabs/library.dart';
import 'package:cards/tabs/more.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cards/config/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'gamification/vibration_tap.dart';

// ...

void main() async {
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Hive.registerAdapter(FlashcardAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(TopicAdapter());
  Hive.registerAdapter(DeckAdapter());
  await Hive.openBox<Flashcard>('flashcards');
  await Hive.openBox<Topic>('topics');
  await Hive.openBox<Subject>('subjects');
  await Hive.openBox<Deck>('decks');
  await Hive.openBox('prefs');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('prefs').listenable(),
      builder: (context, dark, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: MyTheme().isDark
            ? ThemeData.dark(
                // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              )
            : ThemeData.light(
                // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int currentIndex = 0;
List pages = [
  const Home(),
  const Library(),
  const Learn(),
  const More(),
];
List icons = [Icons.home_rounded, Icons.book_rounded, Icons.search, Icons.more_horiz];
List tabNames = <String>[
  "Home",
  "Library",
  "Discover",
  "More",
];
List images = [
  'assets/home.png',
  'assets/books_library_1.png',
  'assets/compass.png',
  'assets/more.png',
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(systemNavigationBarColor: MyTheme().isDark ? Colors.black : Colors.white),
      child: ValueListenableBuilder(
        valueListenable: Hive.box('prefs').listenable(),
        builder: (context, isDark, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: pages[currentIndex],
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            // backgroundColor: MyTheme().isDark ? Colors.black : Colors.purple,
            shape: const CircleBorder(),
            onPressed: () {
              vibrate(amplitude: 20, duration: 30);
              showModalBottomSheet(
                  context: context,
                  constraints: BoxConstraints(maxHeight: context.screenHeight * 0.45),
                  builder: (context) {
                    return const AddNew();
                  });
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            backgroundColor: !MyTheme().isDark ? Colors.white : Colors.grey.shade900,
            height: context.screenHeight * 0.1,
            leftCornerRadius: 0,
            rightCornerRadius: 0,
            elevation: 5,
            notchMargin: -50,
            itemCount: 4,
            tabBuilder: ((index, isActive) {
              return Tab(
                icon: Image(
                  image: AssetImage(
                    images[index],
                  ),
                  height: isActive ? context.screenHeight * 0.07 : context.screenHeight * 0.03,
                ),
                // child: "${tabNames[index]}"
                //     .text
                //     .color(isActive
                //         ? Colors.white
                //         : MyTheme().isDark
                //             ? Colors.grey.shade600
                //             : Colors.black)
                //     .make(),
              );
            }),
            activeIndex: currentIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            onTap: (index) {
              vibrate(amplitude: 10, duration: 30);
              setState(() => currentIndex = index);
            },
          ),
        ),
      ),
    );
  }

  darkModeSwitch() {
    return ListTile(
      title: Text(
        "Dark theme",
        style: GoogleFonts.aBeeZee(fontSize: 18),
      ),
      leading: const Icon(Icons.dark_mode_rounded),
      trailing: Switch(
        onChanged: (val) {
          setState(() {
            Hive.box('prefs').put('isDark', val);
          });
        },
        value: MyTheme().isDark,
      ),
    ).box.color(MyTheme().isDark ? Colors.black : Colors.grey.shade300).rounded.py1.py1.make().py4().px4();
  }
}
