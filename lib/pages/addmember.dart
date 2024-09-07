import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // Paket untuk format tanggal

class Addmember extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const Addmember({super.key, required this.appBar, required this.paddingTop});

  @override
  State<Addmember> createState() => _DatatrainerState();
}

class _DatatrainerState extends State<Addmember> {
  File? _image;
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');

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

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _endDate = _startDate?.add(Duration(days: 30));
        } else {
          _endDate = picked;
        }
      });
    }
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
                        SizedBox(height: heightApp * 0.02,),
                        TextField(
                          decoration: InputDecoration(
                           prefixIcon: Icon(Icons.search),
                           labelText: 'Cari Member',
                           border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                           )
                          ),
                        ),
                         SizedBox(height: heightApp * 0.02,),
                        Text(
                          "Data Member Aktif",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widthApp * 0.04),
                        ),
                        SizedBox(
                          height: heightApp * 0.03,
                        ),
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
                                        radius: constraints.maxWidth * 0.05,
                                        child: const Icon(Icons.person),
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
                                      "Status:",
                                      style: TextStyle(
                                          fontSize:
                                              constraints.maxWidth * 0.03),
                                    ),
                                    Text(
                                      "Aktif",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              constraints.maxWidth * 0.035,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Periode:",
                                      style: TextStyle(
                                          fontSize:
                                              constraints.maxWidth * 0.03),
                                    ),
                                    Text(
                                      "1 Januari - 1 Februari",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: constraints.maxWidth * 0.035,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: heightApp * 0.03,
                        ),
                        Text(
                          "Data Member Non Aktif",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widthApp * 0.04),
                        ),
                        SizedBox(
                          height: heightApp * 0.03,
                        ),
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
                                        radius: constraints.maxWidth * 0.05,
                                        child: const Icon(Icons.person),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Galih",
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
                                      "Status:",
                                      style: TextStyle(
                                          fontSize:
                                              constraints.maxWidth * 0.03),
                                    ),
                                    Text(
                                      "Non Aktif",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              constraints.maxWidth * 0.035,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Periode:",
                                      style: TextStyle(
                                          fontSize:
                                              constraints.maxWidth * 0.03),
                                    ),
                                    Text(
                                      "-",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: constraints.maxWidth * 0.035,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
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
                              // Modal data Member
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
                                        const TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Nama'),
                                        ),
                                        const TextField(
                                          decoration: InputDecoration(
                                              labelText: 'No. Telepon'),
                                          keyboardType: TextInputType.phone,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Pra-Pendaftar'),
                                                Checkbox(
                                                    value: false,
                                                    onChanged: null),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('TNI'),
                                                Checkbox(
                                                    value: false,
                                                    onChanged: null)
                                              ],
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _selectDate(context, true),
                                          child: AbsorbPointer(
                                            child: TextField(
                                              controller: TextEditingController(
                                                text: _startDate == null
                                                    ? 'Tanggal Mulai'
                                                    : _dateFormat
                                                        .format(_startDate!),
                                              ),
                                              decoration: InputDecoration(
                                                labelText: 'Tanggal Mulai',
                                                suffixIcon:
                                                    Icon(Icons.calendar_today),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _selectDate(context, false),
                                          child: AbsorbPointer(
                                            child: TextField(
                                              controller: TextEditingController(
                                                text: _endDate == null
                                                    ? 'Tanggal Akhir'
                                                    : _dateFormat
                                                        .format(_endDate!),
                                              ),
                                              decoration: InputDecoration(
                                                labelText: 'Tanggal Akhir',
                                                suffixIcon:
                                                    Icon(Icons.calendar_today),
                                              ),
                                            ),
                                          ),
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
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 253, 62, 67),
                        ),
                        child: const Text(
                          "+ Member",
                          style: TextStyle(color: Colors.white),
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
