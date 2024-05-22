import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyTheme with ChangeNotifier {
  bool _isDark = Hive.box('prefs').get('isDark', defaultValue: true) as bool;
  bool _isGranted = Hive.box('prefs').get('isGranted', defaultValue: false) as bool;

  bool _useSystemTheme = Hive.box('prefs').get('useSystemTheme', defaultValue: false) as bool;

  String accentColor = Hive.box('prefs').get('themeColor', defaultValue: 'Teal') as String;
  String canvasColor = Hive.box('prefs').get('canvasColor', defaultValue: 'Grey') as String;
  String cardColor = Hive.box('prefs').get('cardColor', defaultValue: 'Grey900') as String;

  int backGrad = Hive.box('prefs').get('backGrad', defaultValue: 2) as int;
  int cardGrad = Hive.box('prefs').get('cardGrad', defaultValue: 4) as int;
  int bottomGrad = Hive.box('prefs').get('bottomGrad', defaultValue: 3) as int;

  int colorHue = Hive.box('prefs').get('colorHue', defaultValue: 400) as int;
  List<Color?>? playGradientColor;

  List<List<Color>> get backOpt => _backOpt;
  List<List<Color>> get cardOpt => _cardOpt;
  bool get isDark => _isDark;
  bool get isGranted => _isGranted;

  final List<List<Color>> _backOpt = [
    [
      Colors.grey[850]!,
      Colors.grey[900]!,
      Colors.black,
    ],
    [
      Colors.grey[900]!,
      Colors.grey[900]!,
      Colors.black,
    ],
    [
      Colors.grey[900]!,
      Colors.black,
    ],
    [
      Colors.grey[900]!,
      Colors.black,
      Colors.black,
    ],
    [
      Colors.black,
      Colors.black,
    ]
  ];

  final List<List<Color>> _cardOpt = [
    [
      Colors.grey[850]!,
      Colors.grey[850]!,
      Colors.grey[900]!,
    ],
    [
      Colors.grey[850]!,
      Colors.grey[900]!,
      Colors.grey[900]!,
    ],
    [
      Colors.grey[850]!,
      Colors.grey[900]!,
      Colors.black,
    ],
    [
      Colors.grey[900]!,
      Colors.grey[900]!,
      Colors.black,
    ],
    [
      Colors.grey[900]!,
      Colors.black,
    ],
    [
      Colors.grey[900]!,
      Colors.black,
      Colors.black,
    ],
    [
      Colors.black,
      Colors.black,
    ]
  ];

  final List<List<Color>> _transOpt = [
    [
      Colors.grey[850]!.withOpacity(0.8),
      Colors.grey[900]!.withOpacity(0.9),
      Colors.black.withOpacity(1),
    ],
    [
      Colors.grey[900]!.withOpacity(0.8),
      Colors.grey[900]!.withOpacity(0.9),
      Colors.black.withOpacity(1),
    ],
    [
      Colors.grey[900]!.withOpacity(0.9),
      Colors.black.withOpacity(1),
    ],
    [
      Colors.grey[900]!.withOpacity(0.9),
      Colors.black.withOpacity(0.9),
      Colors.black.withOpacity(1),
    ],
    [
      Colors.black.withOpacity(0.9),
      Colors.black.withOpacity(1),
    ]
  ];

  void refresh() {
    final Box prefsBox = Hive.box('prefs');
    _isDark = prefsBox.get('isDark', defaultValue: true) as bool;
    _isGranted = prefsBox.get('isGranted', defaultValue: false) as bool;

    _useSystemTheme = prefsBox.get('useSystemTheme', defaultValue: false) as bool;

    accentColor = prefsBox.get('themeColor', defaultValue: 'Teal') as String;
    canvasColor = prefsBox.get('canvasColor', defaultValue: 'Grey') as String;
    cardColor = prefsBox.get('cardColor', defaultValue: 'Grey900') as String;

    backGrad = prefsBox.get('backGrad', defaultValue: 2) as int;
    cardGrad = prefsBox.get('cardGrad', defaultValue: 4) as int;
    bottomGrad = prefsBox.get('bottomGrad', defaultValue: 3) as int;

    colorHue = prefsBox.get('colorHue', defaultValue: 400) as int;
    notifyListeners();
  }

  void switchTheme({bool? useSystemTheme, bool? isDark, bool notify = true}) {
    if (isDark != null) {
      _isDark = isDark;
    }
    if (useSystemTheme != null) {
      _useSystemTheme = useSystemTheme;
    }
    Hive.box('prefs').put('isDark', _isDark);
    Hive.box('prefs').put('useSystemTheme', _useSystemTheme);
    if (notify) notifyListeners();
  }

  void switchGStatus({bool? isGranted, bool notify = true}) {
    if (isGranted != null) {
      _isGranted = isGranted;
    }
    Hive.box('prefs').put('isGranted', _isGranted);
    if (notify) notifyListeners();
  }

  void switchColor(String color, int hue, {bool notify = true}) {
    Hive.box('prefs').put('themeColor', color);
    accentColor = color;
    Hive.box('prefs').put('colorHue', hue);
    colorHue = hue;
    if (notify) notifyListeners();
  }

  ThemeMode currentTheme() {
    if (_useSystemTheme == true) {
      return ThemeMode.system;
    } else {
      return _isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  int currentHue() {
    return colorHue;
  }

  Color getColor(String color, int hue) {
    switch (color) {
      case 'Red':
        return Colors.redAccent[hue]!;
      case 'Teal':
        return Colors.tealAccent[hue]!;
      case 'Light Blue':
        return Colors.lightBlueAccent[hue]!;
      case 'Yellow':
        return Colors.yellowAccent[hue]!;
      case 'Orange':
        return Colors.orangeAccent[hue]!;
      case 'Blue':
        return Colors.blueAccent[hue]!;
      case 'Cyan':
        return Colors.cyanAccent[hue]!;
      case 'Lime':
        return Colors.limeAccent[hue]!;
      case 'Pink':
        return Colors.pinkAccent[hue]!;
      case 'Green':
        return Colors.greenAccent[hue]!;
      case 'Amber':
        return Colors.amberAccent[hue]!;
      case 'Indigo':
        return Colors.indigoAccent[hue]!;
      case 'Purple':
        return Colors.purpleAccent[hue]!;
      case 'Deep Orange':
        return Colors.deepOrangeAccent[hue]!;
      case 'Deep Purple':
        return Colors.deepPurpleAccent[hue]!;
      case 'Light Green':
        return Colors.lightGreenAccent[hue]!;
      case 'White':
        return Colors.white;

      default:
        return _isDark ? Colors.tealAccent[400]! : Colors.lightBlueAccent[400]!;
    }
  }

  Color getCanvasColor() {
    if (canvasColor == 'Black') return Colors.black;
    if (canvasColor == 'Grey') return Colors.grey[900]!;
    return Colors.grey[900]!;
  }

  void switchCanvasColor(String color, {bool notify = true}) {
    Hive.box('prefs').put('canvasColor', color);
    canvasColor = color;
    if (notify) notifyListeners();
  }

  Color getCardColor() {
    if (cardColor == 'Grey800') return Colors.grey[800]!;
    if (cardColor == 'Grey850') return Colors.grey[850]!;
    if (cardColor == 'Grey900') return Colors.grey[900]!;
    if (cardColor == 'Black') return Colors.black;
    return Colors.grey[850]!;
  }

  void switchCardColor(String color, {bool notify = true}) {
    Hive.box('prefs').put('cardColor', color);
    cardColor = color;
    if (notify) notifyListeners();
  }

  List<Color> getCardGradient() {
    return _cardOpt[cardGrad];
  }

  List<Color> getBackGradient() {
    return _backOpt[backGrad];
  }

  Color getPlayGradient() {
    return _backOpt[backGrad].last;
  }

  List<Color> getTransBackGradient() {
    return _transOpt[backGrad];
  }

  List<Color> getBottomGradient() {
    return _backOpt[bottomGrad];
  }

  Color currentColor() {
    switch (accentColor) {
      case 'Red':
        return Colors.redAccent[currentHue()]!;
      case 'Teal':
        return Colors.tealAccent[currentHue()]!;
      case 'Light Blue':
        return Colors.lightBlueAccent[currentHue()]!;
      case 'Yellow':
        return Colors.yellowAccent[currentHue()]!;
      case 'Orange':
        return Colors.orangeAccent[currentHue()]!;
      case 'Blue':
        return Colors.blueAccent[currentHue()]!;
      case 'Cyan':
        return Colors.cyanAccent[currentHue()]!;
      case 'Lime':
        return Colors.limeAccent[currentHue()]!;
      case 'Pink':
        return Colors.pinkAccent[currentHue()]!;
      case 'Green':
        return Colors.greenAccent[currentHue()]!;
      case 'Amber':
        return Colors.amberAccent[currentHue()]!;
      case 'Indigo':
        return Colors.indigoAccent[currentHue()]!;
      case 'Purple':
        return Colors.purpleAccent[currentHue()]!;
      case 'Deep Orange':
        return Colors.deepOrangeAccent[currentHue()]!;
      case 'Deep Purple':
        return Colors.deepPurpleAccent[currentHue()]!;
      case 'Light Green':
        return Colors.lightGreenAccent[currentHue()]!;
      case 'White':
        return Colors.white;

      default:
        return _isDark ? Colors.tealAccent[400]! : Colors.lightBlueAccent[400]!;
    }
  }

  void saveTheme(String themeName) {
    final userThemes = Hive.box('prefs').get('userThemes', defaultValue: {}) as Map;
    Hive.box('prefs').put(
      'userThemes',
      {
        ...userThemes,
        themeName: {
          'isDark': _isDark,
          'useSystemTheme': _useSystemTheme,
          'accentColor': accentColor,
          'canvasColor': canvasColor,
          'cardColor': cardColor,
          'backGrad': backGrad,
          'cardGrad': cardGrad,
          'bottomGrad': bottomGrad,
          'colorHue': colorHue,
        },
      },
    );
  }

  void deleteTheme(String themeName) {
    final userThemes = Hive.box('prefs').get('userThemes', defaultValue: {}) as Map;
    userThemes.remove(themeName);

    Hive.box('prefs').put('userThemes', {...userThemes});
  }

  Map getThemes() {
    return Hive.box('prefs').get('userThemes', defaultValue: {}) as Map;
  }

  void setInitialTheme(String themeName) {
    Hive.box('prefs').put('theme', themeName);
  }

  String getInitialTheme() {
    return Hive.box('prefs').get('theme') as String;
  }
}
