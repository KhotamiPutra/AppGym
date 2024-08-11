import 'package:appgym/layout/addmember.dart';
import 'package:appgym/layout/home.dart';
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

  final List<Widget> _page = [Home(), Addmember()];

  void _onItemTapped(int index) {
    setState(() {
      _nav = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _page[_nav],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              label: 'Beranda',
              activeIcon: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_add_outlined, color: Colors.white),
              label: 'Add Member',
              activeIcon: Icon(
                Icons.group_add,
                color: Colors.white,
              ),
            ),
          ],
          currentIndex: _nav,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
