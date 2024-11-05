import 'dart:typed_data';
import 'dart:ui';

import 'package:appgym/Database/database_helper.dart';
import 'package:appgym/ImageCompressionHelper.dart';
import 'package:appgym/QRScanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
                            child: InkWell(
                              onTap: () => _showMemberDetail(member),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: member.isActive ==
                                                          'Aktif'
                                                      ? Colors.green.shade100
                                                      : Colors.red.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: member.isActive ==
                                                            'Aktif'
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                                child: Text(
                                                  member.isActive,
                                                  style: TextStyle(
                                                    color: member.isActive ==
                                                            'Aktif'
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
                                              style:
                                                  const TextStyle(fontSize: 12),
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
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
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
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixText: '+62 ',
                  hintText: 'Contoh: 8123456789',
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (value.startsWith('0')) {
                    _phoneController.text = value.substring(1);
                    _phoneController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _phoneController.text.length),
                    );
                  }
                },
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
    final ImageSource? source = await _showImageSourceDialog(context);

    if (source != null) {
      final pickedFile = await _picker.pickImage(
        source: source,
        preferredCameraDevice:
            CameraDevice.front, // Use front camera for profile photos
      );
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

//fungsi untuk memformat no tel menjadi 62
  String _formatPhoneNumber(String phone) {
    if (phone.startsWith('0')) {
      return '62${phone.substring(1)}';
    } else if (!phone.startsWith('62')) {
      return '62$phone';
    }
    return phone;
  }

  Future<void> _saveMember() async {
    final name = _nameController.text;
    var phoneNumber = _phoneController.text;
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
    phoneNumber = _formatPhoneNumber(phoneNumber);
    if (!RegExp(r'^62\d{9,}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Nomor telepon harus diawali 62 dan minimal 11 digit (termasuk 62)')),
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
    final qrKey = GlobalKey();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bungkus semua konten yang ingin disimpan dalam satu RepaintBoundary
            RepaintBoundary(
              key: qrKey,
              child: Container(
                color: Colors.white, // Pastikan background putih
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Info member dengan style yang lebih menarik
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.phoneNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // QR Code
                    QrImageView(
                      data: member.qrCode!,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                // Dapatkan render object menggunakan key
                final boundary = qrKey.currentContext?.findRenderObject()
                    as RenderRepaintBoundary?;
                if (boundary == null) {
                  throw Exception('Failed to find QR code boundary');
                }

                // Render ke image dengan pixel ratio yang lebih tinggi
                final image = await boundary.toImage(pixelRatio: 3.0);
                final byteData =
                    await image.toByteData(format: ImageByteFormat.png);

                if (byteData == null) {
                  throw Exception('Failed to generate image data');
                }

                final buffer = byteData.buffer.asUint8List();

                // Simpan dengan nama yang lebih deskriptif
                final timestamp = DateTime.now().millisecondsSinceEpoch;
                final result = await ImageGallerySaver.saveImage(
                  buffer,
                  name: 'Member_${member.name.replaceAll(' ', '_')}_$timestamp',
                  quality: 100,
                );

                if (result['isSuccess']) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('QR Code berhasil disimpan ke galeri'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  throw Exception('Failed to save image');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menyimpan QR Code: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Simpan QR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
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

// Tambahkan fungsi ini di dalam class _MemberPageState

  void _showMemberDetail(Member member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String trainerName = '';
        if (member.trainerId != null) {
          final trainer = _trainers.firstWhere(
            (trainer) => trainer['id'] == member.trainerId,
            orElse: () => {'name': 'Tidak ada'},
          );
          trainerName = trainer['name'];
        }

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
                        backgroundImage: member.photo != null
                            ? MemoryImage(member.photo!)
                            : null,
                        child: member.photo == null
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
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
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: member.isActive == 'Aktif'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              child: Text(
                                member.isActive,
                                style: TextStyle(
                                  color: member.isActive == 'Aktif'
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Member Details - Perhatikan perubahan pada nomor telepon
                  _buildDetailItem(
                    icon: Icons.phone,
                    title: 'Nomor Telepon',
                    value: member.phoneNumber,
                    isCopyable: true, // Menambahkan parameter isCopyable
                  ),
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    title: 'Tanggal Mulai',
                    value: member.startDate,
                  ),
                  _buildDetailItem(
                    icon: Icons.event,
                    title: 'Tanggal Berakhir',
                    value: member.endDate,
                  ),
                  _buildDetailItem(
                    icon: Icons.person,
                    title: 'Trainer',
                    value: trainerName.isEmpty ? 'Tidak ada' : trainerName,
                  ),
                  _buildDetailItem(
                    icon: Icons.military_tech,
                    title: 'Status TNI',
                    value: member.isTNI ? 'Ya' : 'Tidak',
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditMemberModal(member);
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
                          _showQRCode(member);
                        },
                        icon: const Icon(Icons.qr_code),
                        label: const Text('QR Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _confirmDeleteMember(member.id);
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

  // Helper widget untuk menampilkan detail item
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
    _phoneController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _isActiveController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
