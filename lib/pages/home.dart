import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
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
                        // bagian atas
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
                                        width: constraints.maxWidth * 0.55,
                                        child: PieChart(
                                          dataMap: dataMap,
                                          chartType: ChartType.ring,
                                          colorList: [Colors.green, Colors.red],
                                          legendOptions: LegendOptions(
                                            legendPosition: LegendPosition.left,
                                            legendTextStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            showLegends: true,
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
                            )),
                        SizedBox(
                          height: heightBody * 0.02,
                        ),
                        // Total Omzet
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(top: heightBody * 0.02),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blueAccent, Colors.lightBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5), width: 2),
                          ),
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Omzet",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: constraints.maxWidth * 0.05,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Logic for additional action if needed
                                      },
                                      icon: Icon(Icons.info_outline,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(height: heightBody * 0.02),
                                Text(
                                  "Rp. 100.000.000",
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: heightBody * 0.02),
                                Divider(color: Colors.white.withOpacity(0.6)),
                                SizedBox(height: heightBody * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "More details:",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: constraints.maxWidth * 0.03,
                                      ),
                                    ),
                                    Text(
                                      "View",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: constraints.maxWidth * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                        // Total Pengeluaran
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(top: heightBody * 0.03),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purpleAccent, Colors.deepPurple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5), width: 2),
                          ),
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Pengeluaran",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: constraints.maxWidth * 0.035,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              AddExpenseModal(),
                                        );
                                      },
                                      child:
                                          Icon(Icons.add, color: Colors.white),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 67,
                                            27, 136), // Updated parameter
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(12),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: heightBody * 0.01),
                                Text(
                                  "Rp. 50.000.000",
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: heightBody * 0.01),
                                Divider(color: Colors.white.withOpacity(0.6)),
                                SizedBox(height: heightBody * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Details:",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: constraints.maxWidth * 0.03,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "See more",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: constraints.maxWidth * 0.03,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                        // Total Laba
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(top: heightBody * 0.03),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal, Colors.cyan],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5), width: 2),
                          ),
                          child: LayoutBuilder(builder: (context, Constraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Laba",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Constraints.maxWidth * 0.035,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Logic for additional action if needed
                                      },
                                      icon: Icon(Icons.info_outline,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(height: heightBody * 0.01),
                                Text(
                                  "Rp. 50.000.000",
                                  style: TextStyle(
                                    fontSize: Constraints.maxWidth * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: heightBody * 0.01),
                                Divider(color: Colors.white.withOpacity(0.6)),
                                SizedBox(height: heightBody * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "More details:",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: Constraints.maxWidth * 0.03,
                                      ),
                                    ),
                                    Text(
                                      "View",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: Constraints.maxWidth * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        )
                      ],
                    ),
                  );
                } else {
                  // Desktop dan tablet
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10, // Spacing between widgets horizontally
                        runSpacing: 10, // Spacing between rows
                        children: [
                          // Total Member
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.45, // Adjust width
                            height: MediaQuery.of(context).size.height *
                                0.45, // Adjust height
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 19, 47, 71),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.groups,
                                            size: constraints.maxWidth * 0.1,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: constraints.maxWidth * 0.02,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total Member : $totalMembers",
                                                style: TextStyle(
                                                    fontSize:
                                                        constraints.maxWidth *
                                                            0.03,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "Total Member Aktif : $activeMembers",
                                                style: TextStyle(
                                                    fontSize:
                                                        constraints.maxWidth *
                                                            0.03,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.02,
                                      ),
                                      SizedBox(
                                        width: constraints.maxWidth * 0.55,
                                        height: constraints.maxHeight * 0.5,
                                        child: PieChart(
                                          dataMap: dataMap,
                                          chartType: ChartType.ring,
                                          colorList: [Colors.green, Colors.red],
                                          legendOptions: LegendOptions(
                                            legendPosition:
                                                LegendPosition.right,
                                            showLegends: true,
                                            legendTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  constraints.maxWidth * 0.03,
                                            ),
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
                            ),
                          ),
                          // Total Omzet
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.45, // Adjust width
                            height: MediaQuery.of(context).size.height *
                                0.3, // Adjust height
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2),
                            ),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Omzet",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: constraints.maxWidth * 0.05,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Logic for additional action if needed
                                        },
                                        icon: Icon(Icons.info_outline,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.02),
                                  Text(
                                    "Rp. 100.000.000",
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.02),
                                  Divider(color: Colors.white.withOpacity(0.6)),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "More details:",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: constraints.maxWidth * 0.03,
                                        ),
                                      ),
                                      Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: constraints.maxWidth * 0.03,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                          // Total Pengeluaran
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.45, // Adjust width
                            height: MediaQuery.of(context).size.height *
                                0.25, // Adjust height
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purpleAccent,
                                  Colors.deepPurple
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2),
                            ),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Pengeluaran",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              constraints.maxWidth * 0.035,
                                          color: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                AddExpenseModal(),
                                          );
                                        },
                                        child: Icon(Icons.add,
                                            color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 67, 27, 136),
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.01),
                                  Text(
                                    "Rp. 50.000.000",
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.01),
                                  Divider(color: Colors.white.withOpacity(0.6)),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Details:",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: constraints.maxWidth * 0.03,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "See more",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize:
                                                constraints.maxWidth * 0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                          // Total Laba
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.45, // Adjust width
                            height: MediaQuery.of(context).size.height *
                                0.25, // Adjust height
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.teal, Colors.cyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2),
                            ),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Laba",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              constraints.maxWidth * 0.035,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Logic for additional action if needed
                                        },
                                        icon: Icon(Icons.info_outline,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.01),
                                  Text(
                                    "Rp. 50.000.000",
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.01),
                                  Divider(color: Colors.white.withOpacity(0.6)),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "More details:",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: constraints.maxWidth * 0.03,
                                        ),
                                      ),
                                      Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: constraints.maxWidth * 0.03,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ));
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

//modal untuk pengeluaran
class AddExpenseModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Tambah Pengeluaran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(
            decoration: InputDecoration(labelText: 'Nominal Pengeluaran'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(labelText: 'Keterangan'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add logic to handle saving the expense
              Navigator.pop(context);
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
