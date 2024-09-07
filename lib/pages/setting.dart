import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Controllers for price inputs
  final TextEditingController _memberPriceController =
      TextEditingController(text: '50000');
  final TextEditingController _preRegisterPriceController =
      TextEditingController(text: '40000');
  final TextEditingController _tniDiscountPriceController =
      TextEditingController(text: '30000');
  final TextEditingController _visitorPriceController =
      TextEditingController(text: '10000');

  // Readonly flags for each input
  bool _isMemberPriceEditable = false;
  bool _isPreRegisterPriceEditable = false;
  bool _isTniDiscountPriceEditable = false;
  bool _isVisitorPriceEditable = false;

  // Toggle edit state for each input
  void _toggleEdit(String type) {
    setState(() {
      if (type == 'member') {
        _isMemberPriceEditable = !_isMemberPriceEditable;
      } else if (type == 'preRegister') {
        _isPreRegisterPriceEditable = !_isPreRegisterPriceEditable;
      } else if (type == 'tniDiscount') {
        _isTniDiscountPriceEditable = !_isTniDiscountPriceEditable;
      } else if (type == 'visitor') {
        _isVisitorPriceEditable = !_isVisitorPriceEditable;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove default leading icon
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white)),
            const Text(
              'Pengaturan',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 253, 62, 67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceField('Harga Member', _memberPriceController,
                _isMemberPriceEditable, 'member'),
            SizedBox(height: 10),
            _buildPriceField('Harga Pra-pendaftar', _preRegisterPriceController,
                _isPreRegisterPriceEditable, 'preRegister'),
            SizedBox(height: 10),
            _buildPriceField('Harga Diskon TNI', _tniDiscountPriceController,
                _isTniDiscountPriceEditable, 'tniDiscount'),
            SizedBox(height: 10),
            _buildPriceField('Harga Visitor', _visitorPriceController,
                _isVisitorPriceEditable, 'visitor'),
          ],
        ),
      ),
    );
  }

  // Function to build the price input with edit/save icons
  Widget _buildPriceField(String label, TextEditingController controller,
      bool isEditable, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: !isEditable,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Enter $label',
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(
                isEditable ? Icons.save : Icons.edit,
                color: isEditable ? Colors.green : Colors.blue,
              ),
              onPressed: () => _toggleEdit(type),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    _memberPriceController.dispose();
    _preRegisterPriceController.dispose();
    _tniDiscountPriceController.dispose();
    _visitorPriceController.dispose();
    super.dispose();
  }
}
