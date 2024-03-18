import 'package:cards/classes/hive_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cards/custom/Widgets/card.dart';
import 'package:cards/custom/Widgets/empty_card.dart';
import 'package:cards/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../Screens/add_card.dart';
import '../constants/constants.dart';

class Learn extends StatefulWidget {
  const Learn({super.key});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> with AutomaticKeepAliveClientMixin {
  final CardSwiperController controller = CardSwiperController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Discover")],
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   controller.undo();
        // }),
      ),
    );
  }

//   Future<bool> _onSwipe(
//     int previousIndex,
//     int? currentIndex,
//     CardSwiperDirection direction,
//   ) async {
//     debugPrint(
//       'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
//     );
//     if (direction == CardSwiperDirection.right && cards.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           duration: const Duration(seconds: 1),
//           elevation: 6,
//           backgroundColor: Colors.grey[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           behavior: SnackBarBehavior.floating,
//           content: const Text(
//             "Understood 👍",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//       return true;
//     } else if (direction == CardSwiperDirection.left && cards.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           duration: const Duration(seconds: 1),
//           elevation: 6,
//           backgroundColor: Colors.grey[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           behavior: SnackBarBehavior.floating,
//           content: const Text(
//             "Will show this more often 😉 Keep pushing",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//       return true;
//     } else if (direction == CardSwiperDirection.top && cards.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           duration: const Duration(seconds: 1),
//           elevation: 6,
//           backgroundColor: Colors.red[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           behavior: SnackBarBehavior.floating,
//           content: const Text(
//             "Deleted",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//       Future.delayed(const Duration(milliseconds: 210), () async {
//         await CardServices().removeCard(id: currentIndex ?? 0);
//       });
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
}
