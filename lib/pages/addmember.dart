import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Member {
  final int id;
  final String? photo;
  final String name;
  final String phoneNumber;
  final int? isPreRegis;
  final int? isTNI;
  final String startDate;
  final String endDate;
  final int? trainerId;
  final String isActive;
  final int price;

  Member(
      {required this.id,
      required this.photo,
      required this.name,
      required this.phoneNumber,
      required this.isPreRegis,
      required this.isTNI,
      required this.startDate,
      required this.endDate,
      required this.trainerId,
      required this.isActive,
      required this.price});
}

class MemberPage extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;
  const MemberPage({super.key, required this.appBar, required this.paddingTop});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final List<Member> _member = [];
  int? _currentMemberId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _preController = TextEditingController();
  final TextEditingController _tniDiscController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _trainerIdController = TextEditingController();
  final TextEditingController _isActiveController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _photoPath;
  final ImagePicker _picker = ImagePicker();
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
                    child: ListView.builder(
                        itemCount: _member.length,
                        itemBuilder: (context, index) {
                          final member = _member[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.black, width: 0.5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: member.photo != null
                                            ? FileImage(File(member.photo!))
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
                                      )),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          switch (value) {
                                            case 'Edit':
                                              _ShowEditMemberModal(member);
                                              break;
                                            case 'Delete':
                                              _confirmDeleteMember(member.id);
                                              break;
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                              value: 'Edit',
                                              child: Text('Edut')),
                                          const PopupMenuItem(
                                              value: 'Delete',
                                              child: Text('Delete'))
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Status",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(member.isActive),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
              ],
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: _ShowAddMemberModal,
                child: const Text(
                  '+',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _ShowAddMemberModal() {
    _currentMemberId = null;
    _nameController.clear();
    _phoneController.clear();
    _preController.clear();
    _tniDiscController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _trainerIdController.clear();
    _isActiveController.clear();
    _priceController.clear();
    _photoPath = null;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _buildMemberForm();
        });
  }

  void _ShowEditMemberModal(Member member) {
    _currentMemberId = null;
    _nameController.clear();
    _phoneController.clear();
    _preController.clear();
    _tniDiscController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _trainerIdController.clear();
    _isActiveController.clear();
    _priceController.clear();
    _photoPath = null;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _buildMemberForm();
        });
  }

  Widget _buildMemberForm() {
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
                    backgroundImage: _photoPath != null
                        ? FileImage(File(_photoPath!))
                        : null,
                    child: _photoPath == null
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Member'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _saveMember,
                  child:
                      Text(_currentMemberId == null ? 'Tambah' : 'Perbarui')),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        _photoPath = PickedFile.path;
      });
    }
  }

 void _saveMember() {
  final name = _nameController.text;
  final phoneNumber = _phoneController.text;
  final preReg = int.tryParse(_preController.text); // Konversi ke int
  final tnidisc = int.tryParse(_tniDiscController.text); // Konversi ke int
  final startdate = _startDateController.text;
  final enddate = _endDateController.text;
  final trainerId = int.tryParse(_trainerIdController.text); // Konversi ke int
  final active = _isActiveController.text;
  final price = int.tryParse(_priceController.text); // Konversi ke int

  // Validasi untuk memastikan semua nilai sudah benar
  if (name.isEmpty ||
      phoneNumber.isEmpty ||
      preReg == null || // Pastikan preReg bukan null
      tnidisc == null || // Pastikan tnidisc bukan null
      startdate.isEmpty ||
      enddate.isEmpty ||
      trainerId == null || // Pastikan trainerId bukan null
      active.isEmpty ||
      price == null) { // Pastikan price bukan null
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukan Data yang valid')));
    return;
  }

  if (_currentMemberId == null) {
    final newMember = Member(
        id: _member.length,
        photo: _photoPath,
        name: name,
        phoneNumber: phoneNumber,
        isPreRegis: preReg,
        isTNI: tnidisc,
        startDate: startdate,
        endDate: enddate,
        trainerId: trainerId,
        isActive: active,
        price: price);
    setState(() {
      _member.add(newMember);
    });
  } else {
    // Update existing member
    final index =
        _member.indexWhere((member) => member.id == _currentMemberId);
    if (index != -1) {
      setState(() {
        _member[index] = Member(
            id: _currentMemberId!,
            photo: _photoPath,
            name: name,
            phoneNumber: phoneNumber,
            isPreRegis: preReg,
            isTNI: tnidisc,
            startDate: startdate,
            endDate: enddate,
            trainerId: trainerId,
            isActive: active,
            price: price);
      });
    }
  }
  Navigator.of(context).pop();
}


  void _deleteMember(int memberId) {
    setState(() {
      _member.removeWhere((member) => member.id == memberId);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Memver Berhasil dihapus')));
  }

  //konfirmasi hapus
  void _confirmDeleteMember(int memberId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: const Text('Apakah anda yakin ingin menghapus?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tidak')),
              TextButton(
                  onPressed: () {
                    _deleteMember(memberId);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ya'))
            ],
          );
        });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _preController.dispose();
    _tniDiscController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _trainerIdController.dispose();
    _isActiveController.dispose();
    _priceController.dispose();
    super.dispose(); // Pastikan untuk memanggil super.dispose()
  }
}
