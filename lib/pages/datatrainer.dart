import 'package:appgym/Database/database_helper.dart';
import 'package:appgym/ImageCompressionHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class Trainer {
  final int id;
  final String name;
  final String phoneNumber;
  final Uint8List? photo; // Ubah tipe data foto menjadi Uint8List?
  final double price;

  Trainer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.photo,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'photo': photo,
      'price': price,
    };
  }

  static Trainer fromMap(Map<String, dynamic> map) {
    return Trainer(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phone_number'],
      photo: map['photo'], // Ini sekarang akan menjadi Uint8List? atau null
      price: map['price'],
    );
  }
}

class TrainerPage extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const TrainerPage({Key? key, required this.appBar, required this.paddingTop})
      : super(key: key);

  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  final List<Trainer> _trainers = [];
  int? _currentTrainerId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Uint8List? _photoBytes; // Ubah _photoPath menjadi _photoBytes
  final ImagePicker _picker = ImagePicker();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadTrainers();
  }

  Future<void> _loadTrainers() async {
    final trainersData = await _dbHelper.getAllTrainers();
    setState(() {
      _trainers.clear();
      _trainers.addAll(trainersData.map((data) => Trainer.fromMap(data)));
    });
  }

  Future<void> _refreshData() async {
    await _loadTrainers();
  }

  Future<void> _saveTrainer() async {
    final name = _nameController.text;
    final phoneNumber = _phoneNumberController.text;
    final price = double.tryParse(_priceController.text);

    if (name.isEmpty || phoneNumber.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan data yang valid')),
      );
      return;
    }
    if (!RegExp(r'^\d{10,}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Nomor telepon harus berupa angka dan minimal 10 digit')),
      );
      return;
    }

    if (price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harga harus berupa angka positif')),
      );
      return;
    }
    if (_currentTrainerId == null) {
      // Tambah Trainer Baru
      await _dbHelper.insertTrainer(
        name: name,
        phoneNumber: phoneNumber,
        photo: _photoBytes,
        price: price,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trainer berhasil ditambahkan')),
      );
    } else {
      // Update Trainer
      await _dbHelper.updateTrainer(
        id: _currentTrainerId!,
        name: name,
        phoneNumber: phoneNumber,
        photo: _photoBytes,
        price: price,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trainer berhasil diperbarui')),
      );
    }

    await _loadTrainers(); // Muat ulang data dari database
    Navigator.of(context).pop(); // Tutup modal
  }

  Future<void> _deleteTrainer(int trainerId) async {
    await _dbHelper.deleteTrainer(trainerId);
    await _loadTrainers(); // Muat ulang data dari database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trainer berhasil dihapus')),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Kompres gambar
      final compressedBytes = await compressImage(pickedFile.path);
      if (compressedBytes != null) {
        setState(() {
          _photoBytes = compressedBytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: _trainers.length,
                    itemBuilder: (context, index) {
                      final trainer = _trainers[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(color: Colors.black, width: 0.5),
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
                                      radius: 24,
                                      backgroundImage: trainer.photo != null
                                          ? MemoryImage(trainer.photo!)
                                          : null,
                                      child: trainer.photo == null
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        trainer.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
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
                                            _confirmDeleteTrainer(trainer.id);
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
                              const Divider(color: Colors.black),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(trainer.phoneNumber),
                                  Text(
                                    'Rp${trainer.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
              ],
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _showAddTrainerModal,
                child: const Text(
                  '+',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTrainerModal() {
    _currentTrainerId = null;
    _nameController.clear();
    _phoneNumberController.clear();
    _priceController.clear();
    _photoBytes = null;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildTrainerForm();
      },
    );
  }

  void _showEditTrainerModal(Trainer trainer) {
    _currentTrainerId = trainer.id;
    _nameController.text = trainer.name;
    _phoneNumberController.text = trainer.phoneNumber;
    _priceController.text = trainer.price.toString();
    _photoBytes = trainer.photo;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildTrainerForm();
      },
    );
  }

  Widget _buildTrainerForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      _photoBytes != null ? MemoryImage(_photoBytes!) : null,
                  child: _photoBytes == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Trainer'),
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTrainer,
                child: Text(_currentTrainerId == null ? 'Tambah' : 'Perbarui'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTrainer(int trainerId) async {
    // Cek apakah trainer memiliki member
    bool hasMembers = await _dbHelper.trainerHasMember(trainerId);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(hasMembers
              ? 'Trainer ini masih memiliki member yang terkait. Jika dihapus, member tersebut tidak akan memiliki trainer. Apakah Anda yakin ingin melanjutkan?'
              : 'Apakah Anda yakin ingin menghapus trainer ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _deleteTrainer(trainerId);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trainer berhasil dihapus')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Gagal menghapus trainer. Silakan coba lagi.'),
                    ),
                  );
                }
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
