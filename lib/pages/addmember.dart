import 'package:flutter/material.dart';

class Addmember extends StatefulWidget {
  const Addmember({super.key});

  @override
  State<Addmember> createState() => _AddmemberState();
}

class _AddmemberState extends State<Addmember> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [],
        )
      ),
    );
  }
}
