
import 'package:flutter/material.dart';

class Datatrainer extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const Datatrainer({super.key, 
  required this.appBar, 
  required this.paddingTop
  });

  @override
  State<Datatrainer> createState() => _DatatrainerState();
}

class _DatatrainerState extends State<Datatrainer> {
  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    final heightBody =
        heightApp - widget.appBar.preferredSize.height - widget.paddingTop;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'QuickSand'),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){}, child: Text("+ Trainer",style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
              ),
              backgroundColor: const Color.fromARGB(255, 253, 62, 67)
              )
              ),
            ),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(children: [
                    CircleAvatar(child: Icon(Icons.person),),Text("Putra")
                    ],),
                    Divider(color: Colors.black,)
                  ],
                ),
              ),
            )
            
          ],
        )
      ),
    );
  }
}
