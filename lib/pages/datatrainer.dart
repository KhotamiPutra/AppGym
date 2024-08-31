import 'package:flutter/material.dart';

class Datatrainer extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const Datatrainer({super.key, required this.appBar, required this.paddingTop});

  @override
  State<Datatrainer> createState() => _DatatrainerState();
}

class _DatatrainerState extends State<Datatrainer> {
  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    final heightBody = heightApp - widget.appBar.preferredSize.height - widget.paddingTop;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'QuickSand'),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: widget.paddingTop,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: Icon(Icons.person),
                                        radius: constraints.maxWidth * 0.05,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Khotami Putra",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: constraints.maxWidth * 0.03,
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          // Handle the selected option
                                          switch (value) {
                                            case 'Edit':
                                              // Handle edit action
                                              break;
                                            case 'Delete':
                                              // Handle delete action
                                              break;
                                            case 'View':
                                              // Handle view action
                                              break;
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'Edit',
                                            child: Text('Edit'),
                                          ),
                                          PopupMenuItem(
                                            value: 'Delete',
                                            child: Text('Delete'),
                                          ),
                                          PopupMenuItem(
                                            value: 'View',
                                            child: Text('View'),
                                          ),
                                        ],
                                        icon: Icon(Icons.more_vert),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Harga Trainer:",
                                      style: TextStyle(fontSize: constraints.maxWidth * 0.03),
                                    ),
                                    Text(
                                      "Rp. 250.000",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: constraints.maxWidth * 0.045,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                        },
                        child: Text(
                          "+ Trainer",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color.fromARGB(255, 253, 62, 67),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
