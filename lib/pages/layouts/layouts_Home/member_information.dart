import 'package:flutter/material.dart';

class active_member extends StatelessWidget {
  const active_member({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups, color: Colors.white),
          Text("10", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
