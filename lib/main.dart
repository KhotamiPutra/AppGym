import 'package:appgym/pages/addmember.dart';
import 'package:appgym/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    final myAppBar = AppBar(
      title: const Text('App Gym', style: TextStyle(color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 253, 62, 67),
    );
    final page = [Home(appBar: myAppBar, paddingTop: paddingTop), Addmember()];

    return MaterialApp(
      theme: ThemeData(fontFamily: 'QuickSand'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: myAppBar,
        body: _nav == 0
            ? Home(appBar: myAppBar, paddingTop: paddingTop)
            : page[_nav],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _nav,
          onTap: _onItemTapped,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              title: const Text('Beranda'),
              selectedColor: const Color.fromARGB(255, 253, 62, 67),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.group_add_outlined),
              title: const Text('Add Member'),
              selectedColor: const Color.fromARGB(255, 253, 62, 67),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
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
