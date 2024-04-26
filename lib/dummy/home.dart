import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'package:cards/dummy/dummy.dart';

class HomePhys extends StatefulWidget {
  const HomePhys({super.key});

  @override
  State<HomePhys> createState() => _HomePhysState();
}

class _HomePhysState extends State<HomePhys> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/exp.jpg',
            fit: BoxFit.fill,
            height: context.screenHeight * 0.85,
            width: context.screenWidth,
          ),
          Container(
            height: context.screenHeight,
            width: context.screenWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.black12,
                Colors.black54,
                Colors.black87,
                Colors.black,
                Colors.black,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.code,
                color: Colors.black,
                size: 80,
              ),
              const Text(
                "Team Suffix",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const Text(
                "Select the experiment of your choice",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              ZoomTapAnimation(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return Mechanics(
                        index: 0,
                      );
                    }));
                  },
                  child: const ListTile(title: Text("Mechanics"), subtitle: Text('Simple pendulum, Motion, Inclined plane, ...'))
                      .box
                      .color(Colors.grey.shade800.withOpacity(.65))
                      .rounded
                      .padding(const EdgeInsets.symmetric(horizontal: 4, vertical: 2))
                      .make()
                      .px12()),
              ZoomTapAnimation(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return Mechanics(
                        index: 1,
                      );
                    }));
                  },
                  child: const ListTile(title: Text("Optics"), subtitle: Text('Refraction of light(Concave and Convex), Reflection of light(Prism), ...'))
                      .box
                      .color(Colors.grey.shade800.withOpacity(.65))
                      .rounded
                      .padding(const EdgeInsets.symmetric(horizontal: 4, vertical: 2))
                      .make()
                      .px12()),
              ZoomTapAnimation(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return Mechanics(
                        index: 2,
                      );
                    }));
                  },
                  child: const ListTile(title: Text("Electricity"), subtitle: Text('Ohms law, Potentiometer, Metre bridge, ...'))
                      .box
                      .color(Colors.grey.shade800.withOpacity(.65))
                      .rounded
                      .padding(const EdgeInsets.symmetric(horizontal: 4, vertical: 2))
                      .make()
                      .px12()),
              ZoomTapAnimation(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return Mechanics(
                        index: 3,
                      );
                    }));
                  },
                  child: const ListTile(title: Text("Heat"), subtitle: Text('Measuring energy, Heat capacity, ...')).box.color(Colors.grey.shade800.withOpacity(.65)).rounded.padding(const EdgeInsets.symmetric(horizontal: 4, vertical: 2)).make().px12()),
              ZoomTapAnimation(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return Mechanics(
                        index: 4,
                      );
                    }));
                  },
                  child: const ListTile(title: Text("Waves"), subtitle: Text('Vibration in strings, Vibration in closed pipes, ...'))
                      .box
                      .color(Colors.grey.shade800.withOpacity(.65))
                      .rounded
                      .padding(const EdgeInsets.symmetric(horizontal: 4, vertical: 2))
                      .make()
                      .px12()),
            ],
          ),
        ],
      ),
    );
  }
}

class Mechanics extends StatelessWidget {
  int index;
  Mechanics({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List exps = [
      {
        'name': 'Mechanics',
        'exps': ['Simple pendulum', 'Motion', 'Inclined plane', 'Relative density', "Elastic property of solids"],
        'img': 'assets/pen.jpg',
      },
      {
        'name': 'Optics',
        'exps': ['Refraction of light(Concave and Convex)', 'Reflection of light(Prism)', 'Refraction of light(Prism)'],
        'img': 'assets/op.jpg',
      },
      {
        'name': 'Electricity',
        'exps': ['Ohms law', 'Potentiometer', 'Metre bridge'],
        'img': 'assets/electr.jpg',
      },
      {
        'name': 'Heat',
        'exps': ['Measuring energy', 'Heat capacity', 'Boiling point elevation'],
        'img': 'assets/heat.jpg',
      },
      {
        'name': 'Waves',
        'exps': ['Vibration in strings', 'Vibration in closed pipes'],
        'img': 'assets/wave.jpg',
      },
    ];
    List<Widget> adWid = List.generate(exps[index]['exps'].length, (i) {
      return ZoomTapAnimation(
          onTap: () {
            if (index == i && i == 0) {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return const LineChartSample11();
              }));
            }
          },
          child: ListTile(title: Text(exps[index]['exps'][i])).box.color(Colors.grey.shade800.withOpacity(.65)).rounded.padding(const EdgeInsets.symmetric(horizontal: 4, vertical: 2)).make().px12());
    });
    List<Widget> wid = [
      '${exps[index]['name']}'.text.semiBold.scale(2).make(),
      const Text(
        "Select the experiment of your choice",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
        textAlign: TextAlign.center,
      ).px12(),
    ];
    wid.addAll(adWid);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            exps[index]['img'],
            fit: BoxFit.fill,
            height: context.screenHeight * 0.6,
            width: context.screenWidth,
          ),
          Container(
            height: context.screenHeight,
            width: context.screenWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.black12,
                Colors.black12,
                Colors.black54,
                Colors.black87,
                Colors.black,
                Colors.black,
                Colors.black,
                Colors.black,
                Colors.black,
                Colors.black,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: wid,
          ),
        ],
      ),
    );
  }
}
// / ListView.builder(
//         itemBuilder: (context, index) {
//           List nams = [
//             "Simple pendulum",
//             "Motion",
//             "Inclined plane",
//             "Relative density",
//             "Elastic property of solids",
//           ];
//           return ListTile(
//             onTap: () {
//               if (index == 0) {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const LineChartSample11()));
//               }
//             },
//             title: Text(nams[index]),
//           );
//         },
//         itemCount: 5,
//       ),