import 'package:appgym/Database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const Home({super.key, required this.appBar, required this.paddingTop});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DBHelper _dbHelper = DBHelper();
  Map<String, double> memberData = {};
  int totalMembers = 0;
  int activeMembers = 0;
  int inactiveMembers = 0;
  List<Map<String, dynamic>> nearExpiryMembers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final members = await _dbHelper.getAllMembers();
    final activeCount = members.where((m) => m['is_active'] == 'Aktif').length;
    final inactiveCount = members.length - activeCount;

    final expiryMembers = await _dbHelper.getMembersNearingExpiry();

    setState(() {
      totalMembers = members.length;
      activeMembers = activeCount;
      inactiveMembers = inactiveCount;
      nearExpiryMembers = expiryMembers;
      memberData = {
        "Aktif": activeCount.toDouble(),
        "Non-Aktif": inactiveCount.toDouble(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    // final widthApp = MediaQuery.of(context).size.width;
    // final heightApp = MediaQuery.of(context).size.height;
    // final heightBody =
    //     heightApp - widget.appBar.preferredSize.height - widget.paddingTop;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'QuickSand',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF64748B),
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Cards
                  Row(
                    children: [
                      _buildStatCard(
                        "Total Member",
                        totalMembers.toString(),
                        Icons.people,
                        Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        "Member Aktif",
                        activeMembers.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pie Chart Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1E3A8A), // Dark blue
                                Color(0xFF2563EB), // Medium blue
                              ])),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Statistik Member",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (memberData.isNotEmpty)
                            PieChart(
                              dataMap: memberData,
                              chartType: ChartType.ring,
                              colorList: const [
                                Color(0xFF22C55E),
                                Color(0xFFEF4444),
                              ],
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.right,
                                showLegends: true,
                                legendTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500
                                )
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Near Expiry Members
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Member Hampir Kadaluarsa",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${nearExpiryMembers.length} Member',
                                  style: TextStyle(
                                    color: Colors.orange.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (nearExpiryMembers.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Tidak ada member yang akan berakhir dalam 7 hari ke depan',
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: nearExpiryMembers.length,
                              itemBuilder: (context, index) {
                                final member = nearExpiryMembers[index];
                                final endDate =
                                    DateTime.parse(member['end_date']);
                                final daysLeft =
                                    endDate.difference(DateTime.now()).inDays;

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  color: Colors.orange.shade50,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.orange.shade100,
                                      child: Text(
                                        member['name'][0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.orange.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      member['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          'Berakhir: ${DateFormat('dd MMM yyyy').format(endDate)}',
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'No. Telp: ${member['phone_number']}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '$daysLeft hari lagi',
                                        style: TextStyle(
                                          color: Colors.orange.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
