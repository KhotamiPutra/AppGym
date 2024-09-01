import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Datatrainer extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const Datatrainer(
      {super.key, required this.appBar, required this.paddingTop});

  @override
  State<Datatrainer> createState() => _DatatrainerState();
}

class _DatatrainerState extends State<Datatrainer> {
  File? _image;

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

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
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
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
                            side: const BorderSide(
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
                                        child: const Icon(Icons.person),
                                        radius: constraints.maxWidth * 0.05,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Khotami Putra",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                constraints.maxWidth * 0.03,
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
                                          const PopupMenuItem(
                                            value: 'Edit',
                                            child: Text('Edit'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Delete',
                                            child: Text('Delete'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'View',
                                            child: Text('View'),
                                          ),
                                        ],
                                        icon: const Icon(Icons.more_vert),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Harga Trainer:",
                                      style: TextStyle(
                                          fontSize:
                                              constraints.maxWidth * 0.03),
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
                          // Show the modal for inputting trainer details
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true, // Allow full-screen scrolling
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom, // Adjust for the keyboard
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: _pickImage,
                                          child: _image == null
                                              ? Container(
                                                  height: 100,
                                                  width: 100,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                      Icons.add_a_photo),
                                                )
                                              : Image.file(
                                                  _image!,
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Nama'),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'No. Telepon'),
                                          keyboardType: TextInputType.phone,
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Harga'),
                                          keyboardType: TextInputType.number,
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle the save action here
                                          },
                                          child: const Text('Simpan'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          "+ Trainer",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 253, 62, 67),
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
