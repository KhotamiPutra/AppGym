import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

// Dummy model class for Trainer
class Trainer {
  int? id;
  String name;
  String phoneNumber;
  double price;
  String? imagePath;

  Trainer({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.price,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Menyertakan id
      'name': name,
      'phoneNumber': phoneNumber,
      'price': price,
      'imagePath': imagePath,
    };
  }

  static Trainer fromMap(Map<String, dynamic> map) {
    return Trainer(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      price: map['price'],
      imagePath: map['imagePath'],
    );
  }
}

// Dummy Database helper class for Trainer
class DBhelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'trainer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE trainers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phoneNumber TEXT,
            price REAL,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTrainer(Trainer trainer) async {
    final db = await database;
    await db.insert(
      'trainers',
      trainer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTrainer(Trainer trainer) async {
    final db = await database;
    await db.update(
      'trainers',
      trainer.toMap(),
      where: 'id = ?',
      whereArgs: [trainer.id],
    );
  }

  Future<void> deleteTrainer(int? id) async {
    final db = await database;
    await db.delete(
      'trainers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Trainer>> getTrainers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('trainers');

    return List.generate(maps.length, (i) {
      return Trainer.fromMap(maps[i]);
    });
  }
}

class Datatrainer extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const Datatrainer({
    super.key,
    required this.appBar,
    required this.paddingTop,
  });

  @override
  State<Datatrainer> createState() => _DatatrainerState();
}

class _DatatrainerState extends State<Datatrainer> {
  @override
  void initState() {
    super.initState();
    _loadTrainers(); // Panggil fungsi untuk memuat data
  }

  Future<void> _loadTrainers() async {
    final trainers = await _dbHelper.getTrainers(); // Ambil data dari database
    setState(() {
      _trainers.addAll(trainers); // Tambahkan data yang diambil ke dalam daftar
    });
  }

  File? _image;
  final List<Trainer> _trainers = [];
  final DBhelper _dbHelper = DBhelper();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Fungsi untuk menampilkan modal tambah trainer
  void _showAddTrainerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'No. Telepon'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _addTrainer();
                      Navigator.pop(context);
                    },
                    child: const Text('Tambah'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk mengambil gambar
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Fungsi untuk menambah trainer baru
  Future<void> _addTrainer() async {
    try {
      final name = nameController.text;
      final phoneNumber = phoneController.text;
      final price = double.tryParse(priceController.text) ?? 0.0;

      if (name.isEmpty || phoneNumber.isEmpty || price <= 0) {
        // Tampilkan pesan kesalahan
        return;
      }

      final newTrainer = Trainer(
        name: name,
        phoneNumber: phoneNumber,
        price: price,
        imagePath: _image?.path,
      );

      await _dbHelper.insertTrainer(newTrainer);

      setState(() {
        _trainers.add(newTrainer);
        _image = null;
        nameController.clear();
        phoneController.clear();
        priceController.clear();
      });
    } catch (e) {
      // Tampilkan pesan kesalahan
      print('Error adding trainer: $e');
    }
  }

  // Fungsi untuk memperbarui trainer
  Future<void> _updateTrainer(Trainer trainer) async {
    final updatename = nameController.text;
    final phoneNumber = phoneController.text;
    final price = double.tryParse(priceController.text) ?? 0.0;

    trainer.name = updatename; // Memperbaiki nama
    trainer.phoneNumber = phoneNumber; // Memperbaiki nomor telepon
    trainer.price = price; // Memperbaiki harga
    trainer.imagePath = _image != null
        ? _image!.path
        : trainer.imagePath; // Menyimpan gambar baru jika ada

    await _dbHelper.updateTrainer(trainer);

    setState(() {
      _image = null; // Clear image after updating
      nameController.clear();
      phoneController.clear();
      priceController.clear();
    });
  }

  Future<void> _deleteTrainer(Trainer trainer) async {
    await _dbHelper.deleteTrainer(trainer.id); // Menggunakan id untuk menghapus
    setState(() {
      _trainers.remove(trainer); // Remove from the list
    });
  }

  // Fungsi untuk menampilkan modal edit trainer
  void _showEditTrainerModal(Trainer trainer, BuildContext context) {
    // Set data ke controller
    nameController.text = trainer.name;
    phoneController.text = trainer.phoneNumber;
    priceController.text = trainer.price.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: _image == null && trainer.imagePath == null
                        ? Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.add_a_photo),
                          )
                        : Image.file(
                            _image ?? File(trainer.imagePath!),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'No. Telepon'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateTrainer(trainer);
                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
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
                                      backgroundImage: trainer.imagePath != null
                                          ? FileImage(File(trainer.imagePath!))
                                          : null,
                                      child: trainer.imagePath == null
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        trainer.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: constraints.maxWidth * 0.03,
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        switch (value) {
                                          case 'Edit':
                                            _showEditTrainerModal(
                                                trainer, context);
                                            break;
                                          case 'Delete':
                                            _deleteTrainer(trainer);
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
                                      ],
                                      icon: const Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.black),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Harga Trainer:",
                                    style: TextStyle(
                                        fontSize: constraints.maxWidth * 0.03),
                                  ),
                                  Text(
                                    "Rp. ${trainer.price.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: constraints.maxWidth * 0.045,
                                    ),
                                  ),
                                ],
                              ),
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
                      onPressed: () => _showAddTrainerModal(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color.fromARGB(255, 253, 62, 67),
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
