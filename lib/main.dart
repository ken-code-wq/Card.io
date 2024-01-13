import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/tabs/add_new.dart';
import 'package:cards/tabs/home.dart';
import 'package:cards/tabs/learn.dart';
import 'package:cards/tabs/library.dart';
import 'package:cards/tabs/more.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FlashcardAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(TopicAdapter());
  Hive.registerAdapter(DeckAdapter());
  await Hive.openBox<Flashcard>('flashcards');
  await Hive.openBox<Topic>('topics');
  await Hive.openBox<Subject>('subjects');
  await Hive.openBox<Deck>('decks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// final c = List.generate(cardBox.length, (index) =>);

int currentIndex = 0;
List pages = [
  const Home(),
  const Library(),
  const Learn(),
  const More(),
];
List icons = [Icons.home_rounded, Icons.book_rounded, Icons.local_library_rounded, Icons.more_horiz];
List tabNames = <String>[
  "Home",
  "Library",
  "Learn",
  "More",
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              constraints: BoxConstraints(maxHeight: context.screenHeight * 0.35),
              builder: (context) {
                return const AddNew();
              });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        backgroundColor: Colors.black,
        height: context.screenHeight * 0.1,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        itemCount: 4,
        tabBuilder: ((index, isActive) {
          return Tab(
            child: "${tabNames[index]}".text.color(isActive ? Colors.white : Colors.grey.shade600).make(),
            icon: Icon(
              icons[index],
              color: isActive ? Colors.white : Colors.grey.shade600,
            ),
          );
        }),
        activeIndex: currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: (index) {
          setState(() => currentIndex = index);
          print(currentIndex);
        },
        //other params
      ),
      // bottomNavigationBar: GNav(
      //   selectedIndex: currentIndex != 2 ? currentIndex : 0,
      //   onTabChange: (value) {
      //     if (value != 2) {
      //       setState(() {
      //         currentIndex = value;
      //         print("This $value");
      //       });
      //     } else {
      //       showModalBottomSheet(
      //           context: context,
      //           builder: (context) {
      //             return pages[value];
      //           });
      //     }
      //     print("This! $value");
      //     print("This1 $currentIndex");
      //   },
      //   padding: EdgeInsets.symmetric(horizontal: 10),
      //   tabs: const [
      //     GButton(
      //       backgroundColor: Color.fromARGB(164, 122, 76, 250),
      //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      //       icon: Icons.home,
      //       text: "Home",
      //     ),
      //     GButton(
      //       backgroundColor: Color.fromARGB(164, 122, 76, 250),
      //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      //       icon: Icons.book_rounded,
      //       text: "Library",
      //     ),
      //     GButton(
      //       backgroundColor: Color.fromARGB(164, 122, 76, 250),
      //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      //       icon: Icons.local_library_rounded,
      //       text: "Learn",
      //     ),
      //     GButton(
      //       backgroundColor: Color.fromARGB(164, 122, 76, 250),
      //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      //       icon: Icons.more_horiz,
      //       text: "More",
      //     ),
      //   ],
      // ).box.width(context.screenWidth).height(context.screenHeight * 0.1).padding(EdgeInsets.symmetric(horizontal: 10)).make(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       PageRouteBuilder(
      //         opaque: false,
      //         pageBuilder: (_, __, ___) => const AddCart(),
      //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //           const begin = Offset(1.0, 0.0);
      //           const end = Offset.zero;
      //           const curve = Curves.easeInOutCubic;

      //           var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      //           var offsetAnimation = animation.drive(tween);

      //           return SlideTransition(position: offsetAnimation, child: child);
      //         },
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
