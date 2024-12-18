import 'package:appgym/Database/database_helper.dart';
import 'package:appgym/pages/addmember.dart';
import 'package:appgym/pages/datatrainer.dart';
import 'package:appgym/pages/home.dart';
import 'package:appgym/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_2/persistent_tab_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final dbHelper = DBHelper();
    await dbHelper.initDB();
    await dbHelper.updateExpiredMemberships();
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cek platform sebelum menginisialisasi Workmanager
  if (!kIsWeb &&
      defaultTargetPlatform != TargetPlatform.windows &&
      defaultTargetPlatform != TargetPlatform.linux &&
      defaultTargetPlatform != TargetPlatform.macOS) {
    try {
      await Workmanager().initialize(callbackDispatcher,
          isInDebugMode: true // Set ke true untuk debugging
          );

      await Workmanager().registerPeriodicTask(
        "1",
        "checkMembershipStatus",
        frequency: const Duration(days: 1),
        initialDelay: const Duration(minutes: 1),
        constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresBatteryNotLow: true,
        ),
      );
    } catch (e) {
      debugPrint('Workmanager initialization failed: $e');
    }
  }

  // SQLite initialization untuk desktop platforms
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const AppWrapper());
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final int _nav = 0;

  // Define GlobalKey for Navigator
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  List<Widget> _buildScreens() {
    final paddingTop = MediaQuery.of(context).padding.top;
    final myAppBar = AppBar(
      title: const Text('App Gym', style: TextStyle(color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 253, 62, 67),
    );
    return [
      Home(appBar: myAppBar, paddingTop: paddingTop),
      MemberPage(
        appBar: myAppBar,
        paddingTop: paddingTop,
      ),
      TrainerPage(appBar: myAppBar, paddingTop: paddingTop),
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
      navigatorKey: _navigatorKey, // Set the navigatorKey here
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Gym', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 253, 62, 67),
          actions: [
            IconButton(
                onPressed: () {
                  // Use navigatorKey to perform navigation
                  _navigatorKey.currentState?.push(
                    MaterialPageRoute(
                        builder: (context) => const PriceSettingPage()),
                  );
                },
                icon: const Icon(Icons.settings))
          ],
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
      ),
    );
  }
}
