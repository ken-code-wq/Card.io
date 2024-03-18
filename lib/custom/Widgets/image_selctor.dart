import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({super.key});

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

int currentlySelectedPic = 0;

class _ImageSelectorState extends State<ImageSelector> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.09,
      width: context.screenWidth,
      child: ListView.builder(
        itemBuilder: (context, index) {
          const List images = [
            'assets/ai.png',
            'assets/books_library_1.png',
            'assets/compass.png',
            'assets/english.png',
            'assets/home.png',
            'assets/math.png',
            'assets/more.png',
            'assets/search.png',
            'assets/worldwide.png',
            'assets/car_engine.png',
            'assets/chemistry.png',
            'assets/dollar.png',
            'assets/drugs.png',
            'assets/keyboard.png',
            'assets/law.png',
            'assets/palette.png',
            'assets/science.png',
            'assets/sports.png',
          ];
          return InkWell(
            onTap: () {
              setState(() {
                currentlySelectedPic = index;
              });
            },
            child: Container(
              height: context.screenHeight * 0.09,
              width: context.screenHeight * 0.1,
              margin: const EdgeInsets.only(left: 15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(images[index], height: context.screenHeight * 0.08, width: context.screenHeight * 0.08),
                  Container(
                    decoration: BoxDecoration(
                      color: currentlySelectedPic == index ? Colors.black45 : Colors.transparent,
                      // image: DecorationImage(image: AssetImage(images[index])),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: currentlySelectedPic == index
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 50,
                            )
                          : const Row(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: 9,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
