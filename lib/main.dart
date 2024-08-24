import 'package:appgym/pages/addmember.dart';
import 'package:appgym/pages/home.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.blue,
    );
    final _page = [Home(appBar: myAppBar, paddingTop: paddingTop), Addmember()];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: myAppBar,
        body: _nav == 0
            ? Home(appBar: myAppBar, paddingTop: paddingTop)
            : _page[_nav], // AddMember tidak memerlukan AppBar dan paddingTop
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.blueAccent),
              label: 'Beranda',
              activeIcon: Icon(
                Icons.home,
                color: Colors.blue,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_add_outlined, color: Colors.blueAccent),
              label: 'Add Member',
              activeIcon: Icon(
                Icons.group_add,
                color: Colors.blue,
              ),
            ),
          ],
          currentIndex: _nav,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blueAccent,
          onTap: _onItemTapped,
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
