import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

//Total Member Tablet
class TotalMemberTablet extends StatelessWidget {
  const TotalMemberTablet({
    super.key,
    required this.totalMembers,
    required this.activeMembers,
    required this.dataMap,
  });

  final double totalMembers;
  final double activeMembers;
  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45, 
      height: MediaQuery.of(context).size.height * 0.45, 
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 19, 47, 71),
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Member : $totalMembers",
                          style: TextStyle(
                              fontSize: constraints.maxWidth * 0.03,
                              color: Colors.white),
                        ),
                        Text(
                          "Total Member Aktif : $activeMembers",
                          style: TextStyle(
                              fontSize: constraints.maxWidth * 0.03,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  // height: constraints.maxHeight * 0.02,
                  width: constraints.maxWidth * 0.5,
                ),
                Expanded(
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    colorList: const [Colors.green, Colors.red],
                    legendOptions: LegendOptions(
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: constraints.maxWidth * 0.03,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//Total Omzet Tablet
class TotalOmzetTablet extends StatelessWidget {
  const TotalOmzetTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45, // Adjust width
      height: MediaQuery.of(context).size.height * 0.3, // Adjust height
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: constraints.maxHeight * 0.02),
            Text(
              "Rp. 100.000.000",
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.02),
            Divider(color: Colors.white.withOpacity(0.6)),
            SizedBox(height: constraints.maxHeight * 0.02),
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

//Total Pengeluaran Tablet
class TotalPengeluaranTablet extends StatelessWidget {
  const TotalPengeluaranTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45, // Adjust width
      height: MediaQuery.of(context).size.height * 0.25, // Adjust height
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purpleAccent, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                      builder: (context) => const AddExpenseModal(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 67, 27, 136),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Text(
              "Rp. 50.000.000",
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Divider(color: Colors.white.withOpacity(0.6)),
            SizedBox(height: constraints.maxHeight * 0.02),
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
  const AddExpenseModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Tambah Pengeluaran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const TextField(
            decoration: InputDecoration(labelText: 'Nominal Pengeluaran'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(labelText: 'Keterangan'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add logic to handle saving the expense
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class TotalLabaTablet extends StatelessWidget {
  const TotalLabaTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45, // Adjust width
      height: MediaQuery.of(context).size.height * 0.25, // Adjust height
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.teal, Colors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  "Total Laba",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: constraints.maxWidth * 0.035,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Logic for additional action if needed
                  },
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Text(
              "Rp. 50.000.000",
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Divider(color: Colors.white.withOpacity(0.6)),
            SizedBox(height: constraints.maxHeight * 0.02),
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
