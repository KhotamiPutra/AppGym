import 'package:appgym/pages/addmember.dart';
import 'package:appgym/pages/datatrainer.dart';
import 'package:appgym/pages/home.dart';
import 'package:appgym/pages/procuct.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  int _nav = 0;

  void _onItemTapped(int index) {
    setState(() {
      _nav = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    final myAppBar = AppBar(
      title: const Text('App Gym', style: TextStyle(color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 253, 62, 67),
    );
    final page = [
      Home(appBar: myAppBar, paddingTop: paddingTop),
      Addmember(),
      Datatrainer(),
      Product()
    ];

    // Ikon dan judul untuk navigasi bawah
    final iconList = <IconData>[
      Icons.home_outlined,
      Icons.group_add_outlined,
      Icons.fitness_center_outlined,
      Icons.trolley,
    ];

    return MaterialApp(
      theme: ThemeData(fontFamily: 'QuickSand'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: myAppBar,
        body: _nav == 0
            ? Home(appBar: myAppBar, paddingTop: paddingTop)
            : page[_nav],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Tambahkan aksi untuk tombol scan QR di sini
          },
          backgroundColor: const Color.fromARGB(255, 253, 62, 67),
          child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: _nav,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: _onItemTapped,
          activeColor: const Color.fromARGB(255, 253, 62, 67),
          inactiveColor: Colors.grey,
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              ListTile(
                leading: const Icon(Icons.backup_sharp),
                title: const Text('Backup Data'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
