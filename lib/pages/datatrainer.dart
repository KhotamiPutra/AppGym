import 'package:appgym/Database/database_helper.dart';
import 'package:appgym/ImageCompressionHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<Trainer> _filteredTrainers = [];

  void _filterTrainers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTrainers = List.from(_trainers);
      } else {
        _filteredTrainers = _trainers
            .where((trainer) =>
                trainer.name.toLowerCase().contains(query.toLowerCase()) ||
                trainer.phoneNumber.contains(query))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTrainers();
    _searchController.addListener(() {
      _filterTrainers(_searchController.text);
    });
  }

  Future<void> _loadTrainers() async {
    final trainersData = await _dbHelper.getAllTrainers();
    setState(() {
      _trainers.clear();
      _trainers.addAll(trainersData.map((data) => Trainer.fromMap(data)));
      _filteredTrainers = List.from(_trainers);
    });
  }

  Future<void> _refreshData() async {
    await _loadTrainers();
  }

  String _formatPhoneNumber(String phone) {
    if (phone.startsWith('0')) {
      return '62${phone.substring(1)}';
    } else if (!phone.startsWith('62')) {
      return '62$phone';
    }
    return phone;
  }

  Future<void> _saveTrainer() async {
    final name = _nameController.text;
    var phoneNumber = _phoneNumberController.text;
    final price = double.tryParse(_priceController.text);

    if (name.isEmpty || phoneNumber.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan data yang valid')),
      );
      return;
    }
    phoneNumber = _formatPhoneNumber(phoneNumber);
    if (!RegExp(r'^62\d{9,}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Nomor telepon harus diawali 62 dan minimal 11 digit (termasuk 62)')),
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

// Updated _pickImage function for TrainerPage
  Future<void> _pickImage() async {
    final ImageSource? source = await _showImageSourceDialog(context);

    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source);
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
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      hintText: 'Cari Trainer',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8)),
                ),
                const SizedBox(height: 16),
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: _filteredTrainers.length,
                    itemBuilder: (context, index) {
                      final trainer = _filteredTrainers[index];
                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Colors.black, width: 0.5),
                          ),
                          child: InkWell(
                            onTap: () => _showTrainerDetail(trainer),
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
                          ));
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
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixText: '+62 ',
                  hintText: 'Contoh: 8123456789',
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (value.startsWith('0')) {
                    _phoneNumberController.text = value.substring(1);
                    _phoneNumberController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: _phoneNumberController.text.length),
                    );
                  }
                },
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

  // Helper function to show image source selector
  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Gambar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Kamera'),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
                const Divider(),
                GestureDetector(
                  child: const ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Galeri'),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper function to show trainer detail
  void _showTrainerDetail(Trainer trainer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: scrollController,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Profile Section
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: trainer.photo != null
                            ? MemoryImage(trainer.photo!)
                            : null,
                        child: trainer.photo == null
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trainer.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Trainer Details
                  _buildDetailItem(
                    icon: Icons.phone,
                    title: 'Nomor Telepon',
                    value: trainer.phoneNumber,
                    isCopyable: true,
                  ),
                  _buildDetailItem(
                      icon: Icons.price_change,
                      title: 'Harga Trainer',
                      value: 'Rp ${trainer.price.toString()}'),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditTrainerModal(trainer);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _confirmDeleteTrainer(trainer.id);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Hapus'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    bool isCopyable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isCopyable)
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.blue),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: value));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nomor telepon berhasil disalin'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _priceController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
