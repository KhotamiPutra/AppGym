import 'package:flutter/material.dart';

class Datatrainer extends StatefulWidget {
  const Datatrainer({super.key});

  @override
  State<Datatrainer> createState() => _DatatrainerState();
}

class _DatatrainerState extends State<Datatrainer> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [],
        ),
      ),
    );
  }
}