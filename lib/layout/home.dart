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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(children: [
              Container(
                height: 100,
                width: 500,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 201, 7),
                ),
                child: Column(
                  children: [
                    Text(
                      "Omset Keselulahan",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "10.000.000",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 500,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 208, 0),
                ),
                child: Column(
                  children: [
                    Text(
                      "Omset Member Gym",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "10.000.000",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ],
      )),
    );
  }
}
