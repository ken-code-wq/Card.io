import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LineChartSample11 extends StatefulWidget {
  const LineChartSample11({super.key});

  @override
  State<LineChartSample11> createState() => _LineChartSample11State();
}

var baselineX = 0.0;
var baselineY = 0.0;
double zoom = 1;

List<FlSpot> points = [
  const FlSpot(0, 0),
];

class _LineChartSample11State extends State<LineChartSample11> {
  @override
  void initState() {
    super.initState();
    points = [const FlSpot(0, 0)];
    zoom = 1;
    baselineY = 0.0;
    baselineX = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  List added = [const FlSpot(0, 0)];
                  return StatefulBuilder(builder: (context, setSt) {
                    TextEditingController c1 = TextEditingController();
                    TextEditingController c2 = TextEditingController();
                    return AlertDialog(
                      icon: const Icon(Icons.add),
                      title: const Text("Add co-ordinates"),
                      content: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        height: context.screenHeight * 0.07,
                        width: context.screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: c1,
                                keyboardType: const TextInputType.numberWithOptions(),
                                decoration: const InputDecoration(hintText: "x"),
                                onChanged: (value) {
                                  if (c2.text != '') {
                                    // setState(() {
                                    //   points.insert(
                                    //     index,
                                    //     FlSpot(
                                    //       double.tryParse(c1.text) ?? 0,
                                    //       double.tryParse(c2.text) ?? 0,
                                    //     ),
                                    //   );
                                    // });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: c2,
                                keyboardType: const TextInputType.numberWithOptions(),
                                decoration: const InputDecoration(hintText: "y"),
                                onChanged: (value) {
                                  // if (c1.text != '') {
                                  //   setState(() {
                                  //     points.add(
                                  //       FlSpot(
                                  //         double.parse(c1.text),
                                  //         double.parse(c2.text),
                                  //       ),
                                  //     );
                                  //   });
                                  // }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     setSt(() {
                        //       added.add(const FlSpot(0, 0));
                        //     });
                        //   },
                        //   icon: const Icon(Icons.add),
                        //   label: const Text("One more point"),
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              points.add(FlSpot(double.parse(c1.text), double.parse(c2.text)));
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Done"),
                        ),
                      ],
                    );
                  });
                });
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: context.screenHeight * 0.6,
              width: context.screenWidth,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    baselineX = baselineX + details.primaryDelta!.toDouble() / 2;
                  });
                },
                onVerticalDragUpdate: (details) {
                  setState(() {
                    baselineY = baselineY - (details.primaryDelta!.toDouble()) / 2;
                  });
                },
                child: _Chart(baselineX, baselineY),
              ),
            ),
            Slider(
              min: 0.1,
              max: 4,
              value: zoom,
              onChanged: (val) {
                setState(() {
                  zoom = val;
                });
              },
            ),
            Expanded(
              child: Container(
                height: context.screenHeight * 0.3,
                width: context.screenWidth,
                color: Colors.grey.shade900,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      height: context.screenHeight * 0.07,
                      width: context.screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text("x: ${points[index].x.toString()}"),
                            // child: TextField(
                            //   controller: c1,
                            //   keyboardType: TextInputType.numberWithOptions(),
                            //   decoration: InputDecoration(hintText: "x"),
                            //   onChanged: (value) {
                            //     if (c2.text != '') {
                            //       setState(() {
                            //         points.insert(
                            //           index,
                            //           FlSpot(
                            //             double.tryParse(c1.text) ?? 0,
                            //             double.tryParse(c2.text) ?? 0,
                            //           ),
                            //         );
                            //       });
                            //     }
                            //   },
                            // ),
                          ),
                          SizedBox(
                            width: 50,

                            child: Text("y: ${points[index].y.toString()}"),
                            // child: TextField(
                            //   controller: c2,
                            //   keyboardType: TextInputType.numberWithOptions(),
                            //   decoration: InputDecoration(hintText: "y"),
                            //   onChanged: (value) {
                            //     if (c1.text != '') {
                            //       setState(() {
                            //         points.add(
                            //           FlSpot(
                            //             double.parse(c1.text),
                            //             double.parse(c2.text),
                            //           ),
                            //         );
                            //       });
                            //     }
                            //   },
                            // ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: points.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  final double baselineX;
  final double baselineY;

  const _Chart(this.baselineX, this.baselineY) : super();

  Widget getHorizontalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineX).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text((value - baselineX).toInt().toString(), style: style),
    );
  }

  Widget getVerticalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineY).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text((value - baselineY).toInt().toString(), style: style),
    );
  }

  FlLine getHorizontalVerticalLine(double value) {
    if ((value - baselineY).abs() <= 0.1) {
      return const FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return const FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  FlLine getVerticalVerticalLine(double value) {
    if ((value - baselineX).abs() <= 0.1) {
      return const FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return const FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(spots: List.generate(points.length, (index) => FlSpot(points[index].x + baselineX, points[index].y + baselineY)), isCurved: true, curveSmoothness: .6, barWidth: 3),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, getTitlesWidget: getHorizontalTitles, reservedSize: 32),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, getTitlesWidget: getHorizontalTitles, reservedSize: 32),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: getHorizontalVerticalLine,
          getDrawingVerticalLine: getVerticalVerticalLine,
        ),
        minY: -20 * zoom,
        maxY: 20 * zoom,
        baselineY: baselineY,
        minX: -20 * zoom,
        maxX: 20 * zoom,
        baselineX: baselineX,
      ),
      duration: Duration.zero,
    );
  }
}
