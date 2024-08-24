import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Home extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const Home({super.key, required this.appBar, required this.paddingTop});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    final heightBody =
        heightApp - widget.appBar.preferredSize.height - widget.paddingTop;

    // pie chart
    final double totalMembers = 100; // Total anggota
    final double activeMembers = 75; // Anggota aktif

    // Menghitung Persentase
    final double inactiveMembers = totalMembers - activeMembers;

    final Map<String, double> dataMap = {
      "Active": activeMembers,
      "Inactive": inactiveMembers,
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'QuickSand'),
      home: Scaffold(
        body: Container(
          height: heightBody, // Mengatur tinggi body
          child: ListView(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Mobile
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                            width: widthApp,
                            height: heightBody * 0.35,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 19, 47, 71),
                                borderRadius: BorderRadius.circular(15)),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.groups,
                                            size: constraints.maxWidth * 0.1,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Total Member : $totalMembers",
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxWidth * 0.03,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "Total Member Aktif : $activeMembers",
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxWidth * 0.03,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: constraints.maxWidth * 0.5,
                                        child: PieChart(
                                          dataMap: dataMap,
                                          chartType: ChartType.ring,
                                          colorList: [Colors.green, Colors.red],
                                          legendOptions: LegendOptions(
                                            legendPosition:
                                                LegendPosition.bottom,
                                            showLegends: false,
                                          ),
                                          chartValuesOptions:
                                              ChartValuesOptions(
                                            showChartValuesInPercentage: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                            ),
                      ],
                    ),
                  );
                } else {
                  // Desktop dan tablet
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Container(
                          width: widthApp,
                          height: heightBody * 0.4,
                          color: Colors.blue,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.green,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.red,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.amber,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.purple,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.green,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.red,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.amber,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.green,
                        ),
                        Container(
                          width: (widthApp - 30) / 2,
                          height: heightBody * 0.2,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                }
              })
              // Widget lainnya bisa ditambahkan di sini
            ],
          ),
        ),
      ),
    );
  }
}
