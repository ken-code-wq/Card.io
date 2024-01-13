// ignore_for_file: unnecessary_const

import 'package:cards/classes/hive_adapter.dart';
import 'package:cards/custom/Widgets/card.dart';
import 'package:cards/custom/Widgets/empty_card.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Screens/add_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: const Text("Home Page")));
  }
}
