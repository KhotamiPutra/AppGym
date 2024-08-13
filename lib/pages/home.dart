import 'package:appgym/pages/layouts/layouts_Home/for_financial_data.dart';
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    children: [
                      monthly_turnover(),
                      monthly_expenses(),
                      profit(),
                    ],
                  ),
                  Wrap(
                    children: [active_member()],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
