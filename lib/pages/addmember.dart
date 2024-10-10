import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:appgym/Database/database_helper.dart';

class MemberPage extends StatefulWidget {
  final AppBar appBar;
  final double paddingTop;

  const MemberPage({super.key, required this.appBar, required this.paddingTop});
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final DBHelper _dbHelper = DBHelper();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int? _trainerId;
  String? _photoPath;
  bool _isPreRegistration = false;
  bool _isTNI = false;
  bool _isActive = true;
  int? _currentMemberId;
  List<Map<String, dynamic>> _trainers = [];
  List<Map<String, dynamic>> _members = [];

  @override
  void initState() {
    super.initState();
    _loadTrainers();
    _loadMembers();
  }

  Future<void> _loadTrainers() async {
    final trainers = await _dbHelper.getAllTrainers();
    setState(() {
      _trainers = trainers;
    });
  }

  Future<void> _loadMembers() async {
    final members = await _dbHelper.getAllMembers();
    setState(() {
      _members = members;
    });
  }

  Future<void> _showAddMemberModal({Map<String, dynamic>? member}) async {
    if (member != null) {
      _currentMemberId = member['id'];
      _nameController.text = member['name'];
      _phoneNumberController.text = member['phone_number'];
      _startDateController.text = member['start_date'];
      _endDateController.text = member['end_date'];
      _priceController.text = member['price'].toString();
      _trainerId = member['trainer_id'];
      _isPreRegistration = member['is_pre_registration'] == 1;
      _isTNI = member['is_tni'] == 1;
      _isActive = member['is_active'] == 'aktif';
      _photoPath = member['photo'];
    } else {
      _currentMemberId = null;
      _nameController.clear();
      _phoneNumberController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _priceController.clear();
      _trainerId = null;
      _isPreRegistration = false;
      _isTNI = false;
      _isActive = true;
      _photoPath = null;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPhotoPicker(),
            _buildTextField(_nameController, 'Nama'),
            _buildTextField(_phoneNumberController, 'No. Telpon'),
            _buildDatePicker(_startDateController, 'Tanggal Mulai'),
            _buildDatePicker(_endDateController, 'Tanggal Akhir'),
            _buildTextField(_priceController, 'Harga'),
            _buildTrainerDropdown(),
            _buildCheckbox(
                'Pra-Pendaftaran',
                _isPreRegistration,
                (value) =>
                    setState(() => _isPreRegistration = _isPreRegistration)),
            _buildCheckbox(
                'TNI', _isTNI, (value) => setState(() => _isTNI = _isTNI)),
            _buildCheckbox('Aktif', _isActive,
                (value) => setState(() => _isActive = _isActive)),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _photoPath = pickedFile.path;
          });
        }
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage:
            _photoPath != null ? FileImage(File(_photoPath!)) : null,
        child: _photoPath == null ? Icon(Icons.camera_alt) : null,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(labelText: label),
        onTap: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (selectedDate != null) {
            setState(() {
              controller.text = selectedDate.toIso8601String().substring(0, 10);
            });
          }
        },
      ),
    );
  }

  Widget _buildTrainerDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<int>(
        isExpanded: true,
        value: _trainerId,
        hint: Text('Pilih Trainer'),
        items: _trainers
            .map((trainer) => DropdownMenuItem<int>(
                  value: trainer['id'],
                  child: Text(trainer['name']),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _trainerId = value;
          });
        },
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveMember,
      child: Text(_currentMemberId != null ? 'Update' : 'Simpan'),
    );
  }

  Future<void> _saveMember() async {
    final name = _nameController.text;
    final phoneNumber = _phoneNumberController.text;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (_currentMemberId == null) {
      // Insert member
      await _dbHelper.insertMember(
        photo: _photoPath != null ? File(_photoPath!).readAsBytesSync() : null,
        name: name,
        phoneNumber: phoneNumber,
        startDate: startDate,
        endDate: endDate,
        trainerId: _trainerId!,
        isActive: _isActive ? 'aktif' : 'nonaktif',
        price: price,
        isPreRegistration: _isPreRegistration ? 1 : 0,
        isTni: _isTNI ? 1 : 0,
      );
    } else {
      // Update member
      await _dbHelper.updateMember(
        id: _currentMemberId!,
        photo: _photoPath != null ? File(_photoPath!).readAsBytesSync() : null,
        name: name,
        phoneNumber: phoneNumber,
        startDate: startDate,
        endDate: endDate,
        trainerId: _trainerId!,
        isActive: _isActive ? 'aktif' : 'nonaktif',
        price: price,
        isPreRegistration: _isPreRegistration ? 1 : 0,
        isTni: _isTNI ? 1 : 0,
      );
    }

    Navigator.of(context).pop();
    _loadMembers();
  }

  void _deleteMember(int memberId) {
    _dbHelper.deleteMember(memberId);
    _loadMembers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Member'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddMemberModal(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black, width: 0.5),
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
                          radius: 30,
                          backgroundImage: member['photo'] != null
                              ? MemoryImage(member['photo'])
                              : null,
                          child: member['photo'] == null
                              ? Icon(Icons.person)
                              : null,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            member['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'Edit':
                                _showAddMemberModal(member: member);
                                break;
                              case 'Delete':
                                _deleteMember(member['id']);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'Edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(member['phone_number']),
                      Text('Rp${member['price'].toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
