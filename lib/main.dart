import 'dart:io';

import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/tabs/add_new.dart';
import 'package:cards/tabs/home.dart';
import 'package:cards/tabs/discover.dart';
import 'package:cards/tabs/library.dart';
import 'package:cards/tabs/more.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cards/constants/config/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'gamification/vibration_tap.dart';

// ...

const String newPath = '/storage/emulated/0/Cards.io';
void main() async {
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Hive.registerAdapter(FlashcardAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(TopicAdapter());
  Hive.registerAdapter(DeckAdapter());
  await Hive.openBox('prefs');

  await Permission.storage.request();
  await Permission.manageExternalStorage.request();
  Directory? directory;
  directory = await getDownloadsDirectory();
  // getting main path
  directory = Directory(newPath);
  // checking if directory exist or not
  if (!await directory.exists()) {
    // if directory not exists then asking for permission to create folder
    await requestPermission(Permission.manageExternalStorage);
    //creating folder
    try {
      await directory.create(recursive: true);
    } catch (e) {
      print(e);
    }
  }
  if (await directory.exists()) {
    try {
      await requestPermission(Permission.manageExternalStorage);

      // if directory exists then returning the complete path
      print(newPath);
    } catch (e) {
      rethrow;
    }
  }

  await Permission.storage.request();
  if (await Permission.storage.request().isGranted) {
    await Hive.openBox<Deck>('decks', path: newPath);
    await Hive.openBox<Subject>('subjects', path: newPath);
    await Hive.openBox<Topic>('topics', path: newPath);
    // await Hive.openBox<Flashcard>('flashcards', path: '/storage/emulated/0');

    if (Hive.box<Topic>('topics').isEmpty) {
      List<Flashcard> cards = [
        Flashcard(
          id: 0,
          topic_id: 0,
          question: 'Welcome to Cards.io ! \nTap the card to turn it over and see if you got the answer right',
          answer: 'Swipe right if you understand and left if you do not  understand.',
          difficulty_user: 0,
          times_appeared: 0,
          times_correct: 0,
          usefullness: 0,
          rate_of_appearance: 0,
          times_spent: [],
          ratings: [0],
          fonts: [],
          isImage: false,
          isAI: false,
        ),
        Flashcard(
          id: 1,
          topic_id: 0,
          question: 'To create a card you need a topic.',
          answer: 'Here is how the categorization goes \n Cards < Topic < Subject < Deck',
          difficulty_user: 0,
          times_appeared: 0,
          times_correct: 0,
          usefullness: 0,
          rate_of_appearance: 0,
          times_spent: [],
          ratings: [0],
          fonts: [],
          isImage: false,
          isAI: false,
        ),
        Flashcard(
          id: 2,
          topic_id: 0,
          question: 'Some motivational quotes to get you going',
          answer: '🥇 Believe you can and you are halfway there \n🥈 Learning is a lifelng journey',
          difficulty_user: 0,
          times_appeared: 0,
          times_correct: 0,
          usefullness: 0,
          rate_of_appearance: 0,
          times_spent: [],
          ratings: [0],
          fonts: [],
          isImage: false,
          isAI: false,
        ),
        Flashcard(
          id: 3,
          topic_id: 0,
          question: 'You are all set now 🙂',
          answer: 'Have fun 👋',
          difficulty_user: 0,
          times_appeared: 0,
          times_correct: 0,
          usefullness: 0,
          rate_of_appearance: 0,
          times_spent: [],
          ratings: [0],
          fonts: [],
          isImage: false,
          isAI: false,
        ),
      ];

      await Hive.box<Topic>('topics').add(
        Topic(
          id: 0,
          name: "Introductory Topic",
          card_ids: cards,
          difficulty: 0,
          color: 4,
          font: 0,
          directions: {'again': [], 'hard': [], 'good': [], 'easy': []},
        ),
      );
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('prefs').listenable(),
      builder: (context, dark, child) => MaterialApp(
        color: Colors.blue,
        title: 'Flutter Demo',
        theme: MyTheme().isDark
            ? ThemeData(
                colorScheme: ColorScheme.dark(primary: Colors.blue, secondary: Colors.blue.shade300),
                primaryColorDark: Colors.blue,
                primarySwatch: Colors.blue,
                brightness: Brightness.dark,
                // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              )
            : ThemeData(
                colorScheme: ColorScheme.light(primary: Colors.blue, secondary: Colors.blue.shade300),
                primaryColorDark: Colors.blue,
                primarySwatch: Colors.blue,
                brightness: Brightness.light,
                // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
        debugShowCheckedModeBanner: false,
        // home: HomePhys(),
        home: const MyHomePage(),
      ),
    );
  }
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    final result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
          builder: (context, isDark, child) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarIconBrightness: !MyTheme().isDark ? Brightness.dark : Brightness.light,
                systemNavigationBarIconBrightness: !MyTheme().isDark ? Brightness.dark : Brightness.light,
                systemNavigationBarColor: MyTheme().isDark ? Colors.black : Colors.white,
                systemNavigationBarDividerColor: Colors.transparent,
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: pages[currentIndex],
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  // backgroundColor: MyTheme().isDark ? Colors.black : Colors.purple,
                  shape: const CircleBorder(),
                  onPressed: () {
                    vibrate(amplitude: 20, duration: 30);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: context.screenHeight * 0.45,
                            child: const AlertDialog(
                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              title: Text('Add a new...'),
                              content: AddNew(),
                            ),
                          );
                        });
                    // showModalBottomSheet(
                    //     context: context,
                    //     constraints: BoxConstraints(maxHeight: context.screenHeight * 0.45),
                    //     builder: (context) {
                    //       return const AddNew();
                    //     });
                  },
                  child: const Icon(Icons.add),
                ),
                bottomNavigationBar: NavigationBar(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: !MyTheme().isDark ? Colors.white : Colors.black,
                  elevation: 8,
                  destinations: [
                    const NavigationDestination(icon: Icon(Icons.home), label: 'Home').px(2.5),
                    const NavigationDestination(icon: Icon(Icons.list), label: 'Library').px(2.5),
                    const NavigationDestination(icon: Icon(Icons.search), label: 'Search').px(2.5),
                    const NavigationDestination(icon: Icon(Icons.settings), label: 'Settings').px(2.5),
                  ],
                  // indicatorColor: Colors.deepPurple.shade400,
                  selectedIndex: currentIndex,
                  onDestinationSelected: (value) {
                    // Provider.of<ThemeModal>(context, listen: false).setCoin(generalBox.getAt(1));
                    setState(() {
                      currentIndex = value;
                    });
                  },
                ),
                // bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                //   backgroundColor: !MyTheme().isDark ? Colors.white : Colors.grey.shade900,
                //   height: context.screenHeight * 0.1,
                //   leftCornerRadius: 0,
                //   rightCornerRadius: 0,
                //   elevation: 5,
                //   notchMargin: -50,
                //   itemCount: 4,
                //   tabBuilder: ((index, isActive) {
                //     return Tab(
                //       icon: Image(
                //         image: AssetImage(
                //           images[index],
                //         ),
                //         height: isActive ? context.screenHeight * 0.07 : context.screenHeight * 0.03,
                //       ),
                //     );
                //   }),
                //   activeIndex: currentIndex,
                //   gapLocation: GapLocation.center,
                //   notchSmoothness: NotchSmoothness.verySmoothEdge,
                //   onTap: (index) {
                //     vibrate(amplitude: 10, duration: 30);
                //     setState(() => currentIndex = index);
                //   },
                // ),
              ),
            );
          }),
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
