import 'dart:typed_data';

import 'package:appgym/Database/database_helper.dart';
import 'package:appgym/ImageCompressionHelper.dart';
import 'package:appgym/QRScanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  final String? qrCode; // Tambahkan field QR code

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
    this.qrCode,
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
      'qr_code': qrCode,
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
      qrCode: map['qr_code'],
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
  final List<String> _statusOption = ['Aktif', 'Tidak Aktif'];
  final TextEditingController _searchController = TextEditingController();
  List<Member> _filteredMembers = [];

  void _filterMembers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMembers = List.from(_members);
      } else {
        _filteredMembers = _members
            .where((member) =>
                member.name.toLowerCase().contains(query.toLowerCase()) ||
                member.phoneNumber.contains(query))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _loadTrainers();
    _loadPrices();
    _searchController.addListener(() {
      _filterMembers(_searchController.text);
    });
    _checkAndUpdateStatus();
  }

  Future<void> _checkAndUpdateStatus() async {
    await _dbHelper.updateExpiredMemberships();
    await _loadMembers(); // Reload data setelah update
  }

  // Tambahkan fungsi untuk mengatur tanggal akhir otomatis
  void _setEndDate(String startDate) {
    try {
      final start = DateTime.parse(startDate);
      final end = start.add(const Duration(days: 30)); // Menambah 30 hari
      _endDateController.text = end.toIso8601String().split('T')[0];
    } catch (e) {
      print('Error setting end date: $e');
    }
  }

  // Tambahkan fungsi untuk mengecek status aktif berdasarkan tanggal
  String _checkActiveStatus(String endDateStr) {
    try {
      final endDate = DateTime.parse(endDateStr);
      final now = DateTime.now();

      // Ubah ke format tanggal saja (tanpa waktu)
      final endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);
      final todayOnly = DateTime(now.year, now.month, now.day);

      // Jika tanggal hari ini sama dengan atau setelah tanggal berakhir
      if (todayOnly.compareTo(endDateOnly) >= 0) {
        return 'Tidak Aktif';
      }
      return 'Aktif';
    } catch (e) {
      print('Error checking active status: $e');
      return 'Tidak Aktif';
    }
  }

  Future<void> _loadMembers() async {
    final memberData = await _dbHelper.getAllMembers();
    setState(() {
      _members.clear();
      _members.addAll(memberData.map((data) => Member.fromMap(data)));
      _filteredMembers = List.from(_members);
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
    final isExpired =
        (member) => _checkActiveStatus(member.endDate) == 'Tidak Aktif';

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
                      hintText: 'Cari Member...',
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
                      itemCount: _filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = _filteredMembers[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          color:
                              isExpired(member) ? Colors.white : Colors.white,
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: member.isActive == 'Aktif'
                                                  ? Colors.green.shade100
                                                  : Colors.red.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    member.isActive == 'Aktif'
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                            ),
                                            child: Text(
                                              member.isActive,
                                              style: TextStyle(
                                                color:
                                                    member.isActive == 'Aktif'
                                                        ? Colors.green.shade800
                                                        : Colors.red.shade800,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        switch (value) {
                                          case 'QR':
                                            _showQRCode(member);
                                            break;
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
                                            value: 'QR',
                                            child: Text('Show QR')),
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
                                        Text(
                                          "Tanggal: ${member.startDate} s/d ${member.endDate}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "TNI: ${member.isTNI ? 'Ya' : 'Tidak'}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
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
                  ),
                ),
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
            Positioned(
              right: 70, // Sesuaikan posisi
              bottom: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScanner()),
                  );
                },
                child: Icon(Icons.qr_code_scanner, color: Colors.white),
              ),
            )
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
                      _photoBytes != null ? MemoryImage(_photoBytes!) : null,
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
                      _setEndDate(_startDateController.text);
                      _isActiveController.text =
                          _checkActiveStatus(_endDateController.text);
                    });
                  }
                },
              ),
              TextField(
                controller: _endDateController,
                decoration:
                    const InputDecoration(labelText: 'Tanggal Berakhir'),
                // enabled: false,
              ),
              DropdownButtonFormField<String>(
                value: _isActiveController.text.isEmpty ||
                        !_statusOption.contains(_isActiveController.text)
                    ? _statusOption[0]
                    : _isActiveController.text,
                items: _statusOption.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _isActiveController.text = newValue ?? _statusOption[0];
                  });
                },
                decoration: const InputDecoration(labelText: 'Status'),
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
    final isActive = _checkActiveStatus(endDate);
    _isActiveController.text = isActive;
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
        trainerId: _selectedTrainerId,
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
        trainerId: _selectedTrainerId,
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

  void _showQRCode(Member member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(member.name),
            SizedBox(height: 16),
            QrImageView(
              data: member.qrCode!,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _isActiveController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
