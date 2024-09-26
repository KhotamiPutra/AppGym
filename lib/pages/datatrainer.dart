import 'package:appgym/Database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Trainer {
  final int id;
  final String name;
  final String phoneNumber;
  final String? photo; // Path ke foto (jika ada)
  final double price;

  Trainer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.photo,
    required this.price,
  });

  Trainer copyWith({
    String? name,
    String? phoneNumber,
    String? photo,
    double? price,
  }) {
    return Trainer(
      id: id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      price: price ?? this.price,
    );
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
  final List<Trainer> _trainers = [];
  File? _image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: widget.paddingTop),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _trainers.length,
                  itemBuilder: (context, index) {
                    final trainer = _trainers[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 0.5),
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
                                    backgroundImage: trainer.photo != null
                                        ? FileImage(File(trainer.photo!))
                                        : null,
                                    child: trainer.photo == null
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
                                          _showEditTrainerModal(trainer);
                                          break;
                                        case 'Delete':
                                          _deleteTrainer(trainer.id);
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          value: 'Edit', child: Text('Edit')),
                                      const PopupMenuItem(
                                          value: 'Delete',
                                          child: Text('Delete')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(trainer.phoneNumber),
                                Text('Rp${trainer.price.toStringAsFixed(2)}'),
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
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () => _showAddTrainerModal(context),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showAddTrainerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _addTrainer() async {
    final name = nameController.text;
    final phoneNumber = phoneController.text;
    final price = double.tryParse(priceController.text) ?? 0.0;

    if (name.isEmpty || phoneNumber.isEmpty || price <= 0) {
      return; // Tampilkan pesan kesalahan jika perlu
    }

    final newTrainer = Trainer(
      id: _trainers.length +
          0, // Ganti dengan logika ID yang lebih baik jika perlu
      name: name,
      phoneNumber: phoneNumber,
      price: price,
      photo: _image?.path,
    );

    final dbHelper = DBHelper();

    // Memanggil insertTrainer dengan parameter yang benar
    await dbHelper.insertTrainer(
      newTrainer,
      name: newTrainer.name,
      phoneNumber: newTrainer.phoneNumber,
      photo: _image != null
          ? await _image!.readAsBytes()
          : null, // Mengonversi path menjadi Uint8List jika ada gambar
      price: newTrainer.price,
    );

    setState(() {
      _trainers.add(newTrainer);
      _image = null;
      nameController.clear();
      phoneController.clear();
      priceController.clear();
    });
  }

  Future<void> _deleteTrainer(int id) async {
  final dbHelper = DBHelper();
  
  // Panggil fungsi deleteTrainer untuk menghapus trainer berdasarkan ID
  await dbHelper.deleteTrainer(id);

  setState(() {
    // Hapus trainer dari daftar yang ditampilkan di UI
    _trainers.removeWhere((trainer) => trainer.id == id);
  });
}


  void _showEditTrainerModal(Trainer trainer) {
    nameController.text = trainer.name;
    phoneController.text = trainer.phoneNumber;
    priceController.text = trainer.price.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: _image == null && trainer.photo == null
                        ? Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.add_a_photo),
                          )
                        : Image.file(
                            _image ?? File(trainer.photo!),
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

  Future<void> _updateTrainer(Trainer trainer) async {
  final updatedName = nameController.text;
  final updatedPhoneNumber = phoneController.text;
  final updatedPrice = double.tryParse(priceController.text) ?? 0.0;

  if (updatedName.isEmpty || updatedPhoneNumber.isEmpty || updatedPrice <= 0) {
    return; // Tampilkan pesan kesalahan jika perlu
  }

  final updatedTrainer = Trainer(
    id: trainer.id, // Menggunakan ID yang sama
    name: updatedName,
    phoneNumber: updatedPhoneNumber,
    price: updatedPrice,
    photo: _image?.path ?? trainer.photo, // Jika ada foto baru, ambil dari _image
  );

  final dbHelper = DBHelper();

  await dbHelper.updateTrainer(
    id: updatedTrainer.id, // ID dari trainer yang diupdate
    name: updatedTrainer.name,
    phoneNumber: updatedTrainer.phoneNumber,
    photo: _image != null ? await _image!.readAsBytes() : null, // Ambil data foto jika ada
    price: updatedTrainer.price,
  );

  setState(() {
    final index = _trainers.indexWhere((t) => t.id == trainer.id);
    if (index != -1) {
      _trainers[index] = updatedTrainer; // Memperbarui data di UI
    }
    _image = null; // Mengosongkan gambar yang dipilih
    nameController.clear();
    phoneController.clear();
    priceController.clear();
  });
}
}
