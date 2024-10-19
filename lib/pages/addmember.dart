import 'dart:typed_data';

import 'package:appgym/Database/database_helper.dart';
import 'package:appgym/ImageCompressionHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Member {
  final int id;
  final Uint8List? photo;
  final String name;
  final String phoneNumber;
  final bool isPreRegis;
  final bool isTNI;
  final String startDate;
  final String endDate;
  final int? trainerId;
  final String isActive;
  final double price;

  Member({
    required this.id,
    required this.photo,
    required this.name,
    required this.phoneNumber,
    required this.isPreRegis,
    required this.isTNI,
    required this.startDate,
    required this.endDate,
    this.trainerId,
    required this.isActive,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo': photo,
      'name': name,
      'phone_number': phoneNumber,
      'is_pre_registration': isPreRegis ? 1 : 0,
      'is_tni': isTNI ? 1 : 0,
      'start_date': startDate,
      'end_date': endDate,
      'trainer_id': trainerId,
      'is_active': isActive,
      'price': price,
    };
  }

  static Member fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      photo: map['photo'],
      name: map['name'],
      phoneNumber: map['phone_number'],
      isPreRegis: map['is_pre_registration'] == 1,
      isTNI: map['is_tni'] == 1,
      startDate: map['start_date'],
      endDate: map['end_date'],
      trainerId: map['trainer_id'],
      isActive: map['is_active'],
      price: map['price'],
    );
  }
}

class MemberPage extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;
  const MemberPage({super.key, required this.appBar, required this.paddingTop});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final List<Member> _members = [];
  final List<Map<String, dynamic>> _trainers = [];
  Map<String, dynamic>? _prices;
  int? _currentMemberId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _isActiveController = TextEditingController();
  bool _isPreRegis = false;
  bool _isTNI = false;
  int? _selectedTrainerId;
  Uint8List? _photoBytes;
  final ImagePicker _picker = ImagePicker();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _loadTrainers();
    _loadPrices();
  }

  Future<void> _loadMembers() async {
    final memberData = await _dbHelper.getAllMembers();
    setState(() {
      _members.clear();
      _members.addAll(memberData.map((data) => Member.fromMap(data)));
    });
  }

  Future<void> _loadTrainers() async {
    final trainerData = await _dbHelper.getAllTrainers();
    setState(() {
      _trainers.clear();
      _trainers.addAll(trainerData);
    });
  }

  Future<void> _loadPrices() async {
    final pricesData = await _dbHelper.getAllPrices();
    if (pricesData.isNotEmpty) {
      setState(() {
        _prices = pricesData.first;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadMembers();
    await _loadTrainers();
    await _loadPrices();
  }

  double _calculatePrice() {
    if (_prices == null) return 0.0;

    double basePrice = _isPreRegis
        ? (_prices!['pre_registration_price'] ?? 0.0)
        : (_prices!['member_price'] ?? 0.0);

    if (_isTNI) {
      double discount = _prices!['tni_discount'] ?? 0.0;
      basePrice -= discount;
    }

    if (_selectedTrainerId != null) {
      final selectedTrainer = _trainers.firstWhere(
        (trainer) => trainer['id'] == _selectedTrainerId,
        orElse: () => {'price': 0.0},
      );
      basePrice += (selectedTrainer['price'] ?? 0.0);
    }

    return basePrice;
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
                    itemCount: _members.length,
                    itemBuilder: (context, index) {
                      final member = _members[index];
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
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: member.photo != null
                                        ? MemoryImage(member.photo!)
                                        : null,
                                    child: member.photo == null
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      member.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      switch (value) {
                                        case 'Edit':
                                          _showEditMemberModal(member);
                                          break;
                                        case 'Delete':
                                          _confirmDeleteMember(member.id);
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
                              const Divider(color: Colors.black),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Status: ${member.isActive}"),
                                      Text(
                                          "Harga: Rp${member.price.toStringAsFixed(2)}"),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Pra-Pendaftar: ${member.isPreRegis ? 'Ya' : 'Tidak'}"),
                                      Text(
                                          "TNI: ${member.isTNI ? 'Ya' : 'Tidak'}"),
                                    ],
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
                onPressed: _showAddMemberModal,
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

  void _showAddMemberModal() {
    _currentMemberId = null;
    _nameController.clear();
    _phoneController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _isActiveController.clear();
    _isPreRegis = false;
    _isTNI = false;
    _selectedTrainerId = null;
    _photoBytes = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _buildMemberForm();
      },
    );
  }

  void _showEditMemberModal(Member member) {
    _currentMemberId = member.id;
    _nameController.text = member.name;
    _phoneController.text = member.phoneNumber;
    _startDateController.text = member.startDate;
    _endDateController.text = member.endDate;
    _isActiveController.text = member.isActive;
    _isPreRegis = member.isPreRegis;
    _isTNI = member.isTNI;
    _selectedTrainerId = member.trainerId;
    _photoBytes = member.photo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _buildMemberForm();
      },
    );
  }

  Widget _buildMemberForm() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      _photoBytes != null ? MemoryImage(_photoBytes!  ) : null,
                  child: _photoBytes == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Member'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isPreRegis,
                    onChanged: (value) {
                      setState(() {
                        _isPreRegis = value ?? false;
                      });
                    },
                  ),
                  const Text('Pra-Pendaftar'),
                  Checkbox(
                    value: _isTNI,
                    onChanged: (value) {
                      setState(() {
                        _isTNI = value ?? false;
                      });
                    },
                  ),
                  const Text('TNI'),
                ],
              ),
              DropdownButtonFormField<int>(
                value: _selectedTrainerId,
                items: [
                  const DropdownMenuItem<int>(
                    value: null, // Bisa gunakan 'null' untuk tidak ada pilihan
                    child: Text('Tidak ada'),
                  ),
                  ..._trainers.map((trainer) {
                    return DropdownMenuItem<int>(
                      value: trainer['id'],
                      child: Text(trainer['name']),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTrainerId = value;
                  });
                },
                decoration:
                    const InputDecoration(labelText: 'Trainer (Opsional)'),
              ),
              TextField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: 'Tanggal Mulai'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _startDateController.text =
                          pickedDate.toIso8601String().split('T')[0];
                    });
                  }
                },
              ),
              TextField(
                controller: _endDateController,
                decoration:
                    const InputDecoration(labelText: 'Tanggal Berakhir'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _endDateController.text =
                          pickedDate.toIso8601String().split('T')[0];
                    });
                  }
                },
              ),
              TextField(
                controller: _isActiveController,
                decoration: const InputDecoration(labelText: 'Status Aktif'),
              ),
              const SizedBox(height: 16),
              Text(
                'Total Harga: Rp${_calculatePrice().toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMember,
                child: Text(_currentMemberId == null ? 'Tambah' : 'Perbarui'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Kompres gambar
      final compressedBytes = await compressImage(pickedFile.path);
      if (compressedBytes != null) {
        setState(() {
          _photoBytes = compressedBytes; // Simpan langsung sebagai bytes
        });
      }
    }
  }

  Future<void> _saveMember() async {
    final name = _nameController.text;
    final phoneNumber = _phoneController.text;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final isActive = _isActiveController.text;
    final price = _calculatePrice();

    if (name.isEmpty ||
        phoneNumber.isEmpty ||
        startDate.isEmpty ||
        endDate.isEmpty ||
        isActive.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua field yang diperlukan')),
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
   

    if (_currentMemberId == null) {
      // Add new member
      await _dbHelper.insertMember(
        photo: _photoBytes,
        name: name,
        phoneNumber: phoneNumber,
        isPreRegistration: _isPreRegis ? 1 : 0,
        isTni: _isTNI ? 1 : 0,
        startDate: startDate,
        endDate: endDate,
        trainerId: _selectedTrainerId!,
        isActive: isActive,
        price: price,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member berhasil ditambahkan')),
      );
    } else {
      // Update existing member
      await _dbHelper.updateMember(
        id: _currentMemberId!,
        photo: _photoBytes,
        name: name,
        phoneNumber: phoneNumber,
        isPreRegistration: _isPreRegis ? 1 : 0,
        isTni: _isTNI ? 1 : 0,
        startDate: startDate,
        endDate: endDate,
        trainerId: _selectedTrainerId!,
        isActive: isActive,
        price: price,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member berhasil diperbarui')),
      );
    }

    await _loadMembers();
    Navigator.of(context).pop();
  }

  Future<void> _deleteMember(int memberId) async {
    await _dbHelper.deleteMember(memberId);
    await _loadMembers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member berhasil dihapus')),
    );
  }

  void _confirmDeleteMember(int memberId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus member ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                _deleteMember(memberId);
                Navigator.of(context).pop();
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
    _phoneController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _isActiveController.dispose();
    super.dispose();
  }
}
