import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pie_chart/pie_chart.dart';

class TotalMemberHP extends StatelessWidget {
  const TotalMemberHP({
    super.key,
    required this.widthApp,
    required this.heightBody,
    required this.totalMembers,
    required this.activeMembers,
    required this.dataMap,
  });

  final double widthApp;
  final double heightBody;
  final double totalMembers;
  final double activeMembers;
  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widthApp,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 19, 47, 71),
            borderRadius: BorderRadius.circular(15)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Keseluruhan Anggota",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Aktif : $activeMembers",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Non Aktif : ${totalMembers - activeMembers}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: heightBody * 0.05,
                  ),
                  PieChart(
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
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

//Total Omzet
class TotalOmzetHP extends StatelessWidget {
  const TotalOmzetHP({
    super.key,
    required this.heightBody,
  });

  final double heightBody;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  icon: Icon(Icons.info_outline, color: Colors.white),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}

//Total Pengeluaran
class TotalPengeluaranHP extends StatelessWidget {
  const TotalPengeluaranHP({
    super.key,
    required this.heightBody,
  });

  final double heightBody;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      builder: (context) => AddExpenseModal(),
                    );
                  },
                  child: Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 67, 27, 136), // Updated parameter
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

//Total Laba
class TotalLabaHP extends StatelessWidget {
  const TotalLabaHP({
    super.key,
    required this.heightBody,
  });

  final double heightBody;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: LayoutBuilder(builder: (context, Constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  icon: Icon(Icons.info_outline, color: Colors.white),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
