import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const Home({super.key, required this.appBar, required this.paddingTop});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    final heightBody =
        heightApp - widget.appBar.preferredSize.height - widget.paddingTop;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Container(
        height: heightBody, // Mengatur tinggi body
        child: ListView(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: widthApp,
                        height: heightBody * 0.3,
                        color: Colors.blue,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.green,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.red,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.amber,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.purple,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.green,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.red,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.amber,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.green,
                      ),
                      SizedBox(height: heightBody * 0.02),
                      Container(
                        width: widthApp,
                        height: heightBody * 0.1,
                        color: Colors.red,
                      )
                    ],
                  ),
                );
              } else {
                // Desktop dan tablet
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Container(
                        width: widthApp,
                        height: heightBody * 0.4,
                        color: Colors.blue,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.green,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.red,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.amber,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.purple,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.green,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.red,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.amber,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.green,
                      ),
                      Container(
                        width: (widthApp - 30) / 2,
                        height: heightBody * 0.2,
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              }
            })
            // Widget lainnya bisa ditambahkan di sini
          ],
        ),
      ),
    );
  }
}
