import 'package:appgym/pages/layouts/Responsif_Home_HP.dart';
import 'package:appgym/pages/layouts/Responsif_Home_Tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                        TotalMemberHP(
                            widthApp: widthApp,
                            heightBody: heightBody,
                            totalMembers: totalMembers,
                            activeMembers: activeMembers,
                            dataMap: dataMap),
                        SizedBox(
                          height: heightBody * 0.02,
                        ),
                        // Total Omzet
                        TotalOmzetHP(heightBody: heightBody),
                        // Total Pengeluaran
                        TotalPengeluaranHP(heightBody: heightBody),
                        // Total Laba
                        TotalLabaHP(heightBody: heightBody)
                      ],
                    ),
                  );
                } else {
                  // Desktop dan tablet
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StaggeredGrid.count(
                      crossAxisCount: 4, // jumlah kolom dalam grid
                      crossAxisSpacing: 12, // jarak antara kolom
                      mainAxisSpacing: 12, // jarak antara baris
                      children: [
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 2,
                          child: TotalMemberTablet(
                              totalMembers: totalMembers,
                              activeMembers: activeMembers,
                              dataMap: dataMap),
                        ),
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 2,
                          child: TotalOmzetTablet(),
                        ),
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 2,
                          child: TotalPengeluaranTablet(),
                        ),
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 2,
                          child: TotalLabaTablet(),
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
