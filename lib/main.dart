import 'package:appgym/pages/addmember.dart';
import 'package:appgym/pages/datatrainer.dart';
import 'package:appgym/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_2/persistent_tab_view.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final int _nav = 0;

  List<Widget> _buildScreens() {
    final paddingTop = MediaQuery.of(context).padding.top;
    final myAppBar = AppBar(
      title: const Text('App Gym', style: TextStyle(color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 253, 62, 67),
    );
    return [
      Home(appBar: myAppBar, paddingTop: paddingTop),
      Addmember(
        appBar: myAppBar,
        paddingTop: paddingTop,
      ),
      Datatrainer(appBar: myAppBar, paddingTop: paddingTop),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: "Home",
        activeColorPrimary: const Color.fromARGB(255, 253, 62, 67),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.group_add_outlined),
        title: "Add Member",
        activeColorPrimary: const Color.fromARGB(255, 253, 62, 67),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.fitness_center_outlined),
        title: "Data Trainer",
        activeColorPrimary: const Color.fromARGB(255, 253, 62, 67),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'QuickSand'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Gym', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 253, 62, 67),
        ),
        body: PersistentTabView(
          context,
          controller: PersistentTabController(initialIndex: _nav),
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            colorBehindNavBar: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
          ),
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
