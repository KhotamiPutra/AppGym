import 'package:appgym/pages/layouts/layouts_Home/member_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Quicksand',
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        body: ListView(
          children: [
            // menampilkan informasi tentang keuangan
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15.0,
                runSpacing: 15.0,
                children: [
                  Wrap(
                    spacing: 15.0,
                    runSpacing: 15.0,
                    children: [Active_member(), Total_member(),Newmemberthismonth()],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
