import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Dummy model class for Trainer
class Trainer {
  final String name;
  final String phoneNumber;
  final double price;
  final File? image;

  Trainer({required this.name, required this.phoneNumber, required this.price, this.image});
}

// Dummy Database helper class for Trainer
class TrainerDatabaseHelper {
  Future<void> insertTrainer(Trainer trainer) async {
    // Implement your database insertion logic here
  }

  Future<List<Trainer>> getTrainers() async {
    // Implement your database retrieval logic here
    return []; // Return the list of trainers from database
  }
}

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
  final List<Trainer> _trainers = [];
  final TrainerDatabaseHelper _dbHelper = TrainerDatabaseHelper();

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

  // Function to add a new trainer
  Future<void> _addTrainer(String name, String phoneNumber, double price) async {
    final newTrainer = Trainer(
      name: name,
      phoneNumber: phoneNumber,
      price: price,
      image: _image,
    );

    await _dbHelper.insertTrainer(newTrainer);

    // Refresh the list of trainers
    setState(() {
      _trainers.add(newTrainer);
    });
  }

  // Function to open modal for adding a trainer
  void _showAddTrainerModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full-screen scrolling
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController phoneController = TextEditingController();
        final TextEditingController priceController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for the keyboard
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
                            child: const Icon(Icons.add_a_photo),
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
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'No. Telepon'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text;
                      final phoneNumber = phoneController.text;
                      final price = double.tryParse(priceController.text) ?? 0.0;

                      _addTrainer(name, phoneNumber, price);

                      Navigator.pop(context);
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
  }

  @override
  void initState() {
    super.initState();
    // Fetch existing trainers from database
    _dbHelper.getTrainers().then((trainers) {
      setState(() {
        _trainers.addAll(trainers);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: ListView.builder(
                    itemCount: _trainers.length,
                    itemBuilder: (context, index) {
                      final trainer = _trainers[index];
                      return Card(
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
                                      backgroundImage: trainer.image != null
                                          ? FileImage(trainer.image!)
                                          : null,
                                      child: trainer.image == null
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        trainer.name,
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
                                    "Rp. ${trainer.price.toStringAsFixed(0)}",
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
                      );
                    },
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
                      onPressed: _showAddTrainerModal,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 253, 62, 67),
                      ),
                      child: const Text(
                        "+ Trainer",
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
    );
  }
}
